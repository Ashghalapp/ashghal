import 'package:ashghal_app_frontend/core_api/errors/exceptions.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/core_api/network_info/network_info.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/receive_read_confirmation_models.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/receive_read_message_model.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/remote_message_model.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/remote_multimedia_model.dart';
import 'package:ashghal_app_frontend/features/chat/data/resources/local/conversation/conversation_local_source.dart';
import 'package:ashghal_app_frontend/features/chat/data/resources/local/message/message_local_source.dart';
import 'package:ashghal_app_frontend/features/chat/data/resources/local/multimedia/multimedia_local_source.dart';
import 'package:ashghal_app_frontend/features/chat/data/resources/remote/message_remote_source.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/message_repository.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/clear_chat_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/delete_messages_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/receive_read_confirmation_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/send_message_request.dart';
import 'package:dartz/dartz.dart';

class MessageRepositoryImp extends MessageRepository {
  final MessageRemoteSource _messageRemoteSource = MessageRemoteSourceImp();
  late final ConversationLocalSource _conversationLocalSource;
  late final MessageLocalSource _messageLocalSource;
  late final MultimediaLocalSource _multimediaLocalSource;
  // final ConversationRepositoryImp _conversationRepository =
  //     ConversationRepositoryImp();
  final ChatDatabase db = ChatDatabase();
  final NetworkInfo networkInfo = NetworkInfoImpl();
  MessageRepositoryImp() {
    _conversationLocalSource = ConversationLocalSource(db);
    _messageLocalSource = MessageLocalSource(db);
    _multimediaLocalSource = MultimediaLocalSource(db);
  }

  @override
  Stream<List<LocalMessage>> watchConversationMessages(
      int conversationId) async* {
    try {
      yield* _messageLocalSource.watchConversationMessages(conversationId);
    } catch (e) {
      print("Error: " + e.toString());
      throw NotSpecificFailure(message: e.toString());
    }
  }

  @override
  Stream<List<LocalMultimedia>> watchConversationMessagesMultimedia(
      int conversationId) async* {
    try {
      yield* _multimediaLocalSource
          .watchConversationMessagesMultimedia(conversationId);
    } catch (e) {
      print("Error: " + e.toString());
      throw NotSpecificFailure(message: e.toString());
    }
  }

  @override
  Future<Either<Failure, LocalMessage>> sendMessage(
      SendMessageRequest request) async {
    try {
      LocalMessage message = await _messageLocalSource
          .insertMessageAndGetInstance(request.toLocal());
      if (request.filePath != null) {
        await _multimediaLocalSource
            .insertMultimedia(request.toLocalMultimedia(message.localId));
      }
      await _conversationLocalSource
          .refreshConversationUpdatedAt(request.conversationId);
      if (await networkInfo.isConnected) {
        await sendLocalMessageToRemote(message, message.conversationId);
      }

      return Right(message);
    } on AppException catch (e) {
      return Left(e.failure as ServerFailure);
    } catch (e) {
      return Left(NotSpecificFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteMessages(
      DeleteMessagesRequest request) async {
    try {
      await _messageLocalSource.deleteMessages(request.messagesIds);

      return const Right(true);
    } on AppException catch (e) {
      return Left(e.failure as ServerFailure);
    } catch (e) {
      return Left(NotSpecificFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> clearChat(ClearChatRequest request) async {
    try {
      await _messageLocalSource
          .deleteAllMessagesInConversation(request.conversationLocalId);
      await _messageLocalSource
          .deleteAllMessagesInConversation(request.conversationLocalId);
      return const Right(true);
    } on AppException catch (e) {
      return Left(e.failure as ServerFailure);
    } catch (e) {
      return Left(NotSpecificFailure(message: e.toString()));
    }
  }

  SendMessageRequest _getSendMessageRequest(
    LocalMultimedia? localMultimedia,
    LocalMessage localMessage,
    int conversationRemoteId,
  ) {
    late SendMessageRequest request;
    if (localMultimedia != null) {
      if (localMessage.body != null && localMessage.body != "") {
        request = SendMessageRequest.withBodyAndMultimedia(
          conversationId: conversationRemoteId,
          body: localMessage.body ?? "",
          filePath: localMultimedia.path ?? "",
          onSendProgress: null,
        );
      } else {
        request = SendMessageRequest.withMultimedia(
          conversationId: conversationRemoteId,
          filePath: localMultimedia.path ?? "",
          onSendProgress: null,
        );
      }
    } else {
      request = SendMessageRequest.withBody(
        conversationId: conversationRemoteId,
        body: localMessage.body ?? "",
      );
    }
    return request;
  }

  Future<void> sendLocalMessageToRemote(
      LocalMessage localMessage, int conversationLocalId) async {
    int? conversationRemoteId = await _conversationLocalSource
        .getRemoteIdByLocalId(conversationLocalId);
    if (conversationRemoteId != null) {
      //get the conversation remote id the message belongs to
      LocalMultimedia? localMultimedia = await _multimediaLocalSource
          .getMessageMultimedia(localMessage.localId);
      // print("--------here-------" + localMultimedia.toString());

      //Construct the request according to the message content
      SendMessageRequest request = _getSendMessageRequest(
        localMultimedia,
        localMessage,
        conversationRemoteId,
      );
      //Send the message to the remote db
      RemoteMessageModel remoteMessage =
          await _messageRemoteSource.sendMessage(request);

      //update local message according to the changes you got
      await _messageLocalSource.updateMessage(
        remoteMessage.toLocalMessageOnSend(
          localMessage.localId,
          localMessage.conversationId,
        ),
      );

      //if the message contians multimedia update the local multimedia record
      if (remoteMessage.multimedia != null) {
        await _multimediaLocalSource.updateMultimedia(
          (remoteMessage.multimedia! as RemoteMultimediaModel)
              .toLocalMultimediaOnSend(
            localMessage.localId,
            localMessage.conversationId,
          ),
        );
      }
    }
  }

  @override
  Future<void> conversationMessagesRead(int conversationId) async {
    try {
      await _messageLocalSource
          .markConversationMessagesAsReadLocally(conversationId);
    } catch (e) {
      print("Error: " + e.toString());
    }
  }

  Future<int?> insertNewMessageFromRemote(
      RemoteMessageModel message, int onversationLocalId) async {
    //make sure that the message doesn't exists, maybe you received it before but
    //the receiving confimation didn't success, so the api sent it to you again as a new message
    int? messageLocalId =
        (await _messageLocalSource.getMessageByRemoteId(message.id))?.localId;
    if (messageLocalId == null) {
      messageLocalId = await _messageLocalSource.insertMessage(
        message.toLocalMessageOnReceived(onversationLocalId),
      );
      if (message.multimedia != null) {
        await _multimediaLocalSource.insertMultimedia(
          (message.multimedia! as RemoteMultimediaModel)
              .toLocalMultimediaOnReceive(messageLocalId),
        );
      }
    }

    return messageLocalId;
  }

  Future<void> confermReceivedLocallyMessagesRemotely() async {
    List<LocalMessage> messages =
        await _messageLocalSource.getReceivedLocallyMessages();
    List<ReceivedReadMessageModel> recReadMeaages =
        _getIdsAndAtFromLocalMessages(messages, true);
    if (recReadMeaages.isNotEmpty) {
      ReceivedReadConfimationResponseModel response =
          await _messageRemoteSource.confirmMessagesReceieve(
        ReceiveReadConfirmationRequest(receivedReadMessages: recReadMeaages),
      );

      await _messageLocalSource.updateReceivedLocallyToFalse(response.success);
    }
  }

  Future<void> confermReadLocallyMessagesRemotely() async {
    List<LocalMessage> messages =
        await _messageLocalSource.getReadLocallyMessages();
    List<ReceivedReadMessageModel> recReadMeaages =
        _getIdsAndAtFromLocalMessages(messages, true);
    if (recReadMeaages.isNotEmpty) {
      ReceivedReadConfimationResponseModel response =
          await _messageRemoteSource.confirmMessagesRead(
        ReceiveReadConfirmationRequest(receivedReadMessages: recReadMeaages),
      );

      await _messageLocalSource.updateReadLocallyToFalse(response.success);
    }
  }

  List<ReceivedReadMessageModel> _getIdsAndAtFromLocalMessages(
      List<LocalMessage> messages, bool withReceivedAt) {
    List<ReceivedReadMessageModel> recReadMeaages = [];
    for (var message in messages) {
      recReadMeaages.add(
        ReceivedReadMessageModel(
          id: message.remoteId!,
          at: withReceivedAt ? message.recievedAt! : message.readAt!,
        ),
      );
    }
    return recReadMeaages;
  }

  Future<void> markMessagesAsReceived(
      List<ReceivedReadMessageModel> remote) async {
    for (var element in remote) {
      await _messageLocalSource.updateMessagesReceivedAt(element);
    }
    List<int> ids = remote.map<int>((e) => e.id).toList();
    await _gettenRecieveResponse(ids);
  }

  _gettenRecieveResponse(List<int> ids) async {
    if (ids.isNotEmpty) {
      await _messageRemoteSource.confirmGettenReceiveResponse(ids);
    }
  }

  Future<void> markMessagesAsRead(List<ReceivedReadMessageModel> remote) async {
    for (var element in remote) {
      await _messageLocalSource.updateMessagesReadAt(element);
    }
    List<int> ids = remote.map<int>((e) => e.id).toList();
    await _gettenReadResponse(ids);
  }

  _gettenReadResponse(List<int> ids) async {
    if (ids.isNotEmpty) {
      await _messageRemoteSource.confirmGettenReadResponse(ids);
    }
  }

  // @override
  // Future<Either<Failure, List<LocalMessage>>> sendSomeMessages(
  //     SendSomeMessageRequest request) async {
  //   // throw UnimplementedError();
  //   try {
  //     List<LocalMessage> messages = [];
  //     for (var messageRequest in request.messages) {
  //       int id = await _messageLocalSource.getUniqueRandomNumber();
  //       messages.add(await _messageLocalSource
  //           .insertMessage(messageRequest.toLocal()));
  //     }

  //     return Right(messages);
  //   } catch (e) {
  //     return Left(NotSpecificFailure(e.toString()));
  //   } finally {
  //     if (await networkInfo.isConnected) {
  //       try {
  //         List<RemoteMessageModel> remoteMessages =
  //             await _messageRemoteSource.sendSomeMessages(request);
  //         for (var remoteMessage in remoteMessages) {
  //           await _messageLocalSource
  //               .updateMessage(remoteMessage.toLocalMessage());
  //         }
  //       } on MyException catch (e) {
  //         return Left(e.failure as ServerFailure);
  //       } catch (e) {
  //         return Left(NotSpecificFailure(e.toString()));
  //       }
  //     }
  //   }
  // }

  // @override
  // Future<Either<Failure, RecieveReadConfirmation>> confirmMessagesReceive(
  //     ReceiveReadConfirmationRequest request) {
  //   throw UnimplementedError();
  // }

  // @override
  // Future<Either<Failure, RecieveReadConfirmation>> confirmMessagesRead(
  //     ReceiveReadConfirmationRequest request) {
  //   // TODO: implement confirmMessagesRead
  //   throw UnimplementedError();
  // }

  // @override
  // Future<Either<Failure, RecieveReadGotConfirmation>>
  //     confirmGettenReceiveResponse(List<String> messagesIds) {
  //   // TODO: implement confirmGettenReceiveResponse
  //   throw UnimplementedError();
  // }

  // @override
  // Future<Either<Failure, RecieveReadGotConfirmation>> confirmGettenReadResponse(
  //     List<String> messagesIds) {
  //   // TODO: implement confirmGettenReadResponse
  //   throw UnimplementedError();
  // }
}
