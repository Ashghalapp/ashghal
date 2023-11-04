import 'package:ashghal_app_frontend/core/helper/app_print_class.dart';
import 'package:ashghal_app_frontend/core_api/errors/error_strings.dart';
import 'package:ashghal_app_frontend/core_api/errors/exceptions.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/core_api/network_info/network_info.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/message_and_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/receive_read_confirmation_models.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/receive_read_message_model.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/remote_message_model.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/remote_multimedia_model.dart';
import 'package:ashghal_app_frontend/features/chat/data/repositories/pusher_chat_helper.dart';
import 'package:ashghal_app_frontend/features/chat/data/resources/local/conversation/conversation_local_source.dart';
import 'package:ashghal_app_frontend/features/chat/data/resources/local/message/message_local_source.dart';
import 'package:ashghal_app_frontend/features/chat/data/resources/local/multimedia/multimedia_local_source.dart';
import 'package:ashghal_app_frontend/features/chat/data/resources/remote/message_remote_source.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/message_repository.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/clear_chat_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/delete_messages_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/dispatch_typing_event_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/download_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/receive_read_confirmation_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/send_message_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/upload_request.dart';
import 'package:dartz/dartz.dart';

class MessageRepositoryImp extends MessageRepository {
  final MessageRemoteSource _messageRemoteSource = MessageRemoteSourceImp();
  late final ConversationLocalSource _conversationLocalSource;
  late final MessageLocalSource _messageLocalSource;
  // late final MultimediaLocalSource _multimediaLocalSource;
  // final ConversationRepositoryImp _conversationRepository =
  //     ConversationRepositoryImp();
  // final ChatDatabase db = ChatDatabase();
  final NetworkInfo networkInfo = NetworkInfoImpl();
  final PusherChatHelper _pusherChatHelper = PusherChatHelper();
  MessageRepositoryImp() {
    _conversationLocalSource = ConversationLocalSource();
    _messageLocalSource = MessageLocalSource();
    // _multimediaLocalSource = MultimediaLocalSource(db);
  }

  @override
  Future<Either<Failure, List<LocalMessage>>> getCoversationMessages(
      int conversationId) async {
    try {
      return Right(
          await _messageLocalSource.getConversationMessages(conversationId));
    } on AppException catch (e) {
      return Left(e.failure as ServerFailure);
    } catch (e) {
      return Left(NotSpecificFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MessageAndMultimediaModel>>>
      getStarredMessages() async {
    try {
      return Right(await _messageLocalSource.getStarredMessages());
    } on AppException catch (e) {
      return Left(e.failure as ServerFailure);
    } catch (e) {
      return Left(NotSpecificFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MessageAndMultimediaModel>>>
      getConversationMessagesWithMultimedia(int conversationLocalId) async {
    try {
      return Right(await _messageLocalSource
          .getConversationMessagesWithMultimedia(conversationLocalId));
    } on AppException catch (e) {
      return Left(e.failure as ServerFailure);
    } catch (e) {
      return Left(NotSpecificFailure(message: e.toString()));
    }
  }

  @override
  Stream<List<LocalMessage>> watchConversationMessages(
      int conversationId) async* {
    try {
      yield* _messageLocalSource.watchConversationMessages(conversationId);
    } catch (e) {
      throw NotSpecificFailure(message: e.toString());
    }
  }

  @override
  Stream<List<MessageAndMultimediaModel>> watchConversationMessagesMultimedia(
      int conversationId) async* {
    try {
      yield* _messageLocalSource
          .watchConversationMessagesAndMultimedia(conversationId);
    } catch (e) {
      print("Error: " + e.toString());
      throw NotSpecificFailure(message: e.toString());
    }
  }

  @override
  Future<Either<Failure, List<LocalMessage>>> searchInMessages(
      String searchText) async {
    try {
      List<LocalMessage> matchedes =
          await _messageLocalSource.search(searchText);
      return right(matchedes);
    } catch (e) {
      AppPrint.printError(
          "Error in MessageRepositoryImp in searchInMessages: ${e.toString()}");
      return Left(NotSpecificFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleStarMessage(
      int messageLocalId, bool starMessage, int conversationLocalId) async {
    try {
      bool ok = (await _messageLocalSource.toggleStarMessage(
            messageLocalId,
            starMessage,
            conversationLocalId,
          )) >
          0;
      return right(ok);
    } catch (e) {
      print(
          "**********Error in MessageRepositoryImp in toggleStarMessage: ${e.toString()}");
      return Left(NotSpecificFailure(message: e.toString()));
    }
  }

  @override
  Future<void> dispatchTypingEvent(DispatchTypingEventRequest request) async {
    try {
      // int remoteId
      await _pusherChatHelper.dispatchTypingEvent(
        request.conversationId,
        request.eventType,
      );
    } catch (e) {
      AppPrint.printError(
          "**********Error in MessageRepositoryImp in dispatchTypingEvent: ${e.toString()}");
    }
  }

  @override
  Future<Either<Failure, bool>> uploadMultimedia(UploadRequest request) async {
    try {
      if (await networkInfo.isConnected) {
        LocalMessage? localMessage = await _messageLocalSource
            .getMessageByLocalId(request.messageLocalId);
        if (localMessage != null) {
          int? conversationRemoteId = await _conversationLocalSource
              .getRemoteIdByLocalId(localMessage.conversationId);

          if (conversationRemoteId != null) {
            LocalMultimedia? localMultimedia = await _messageLocalSource
                .getMessageMultimedia(localMessage.localId);
            if (localMultimedia == null) {
              return const Left(
                  ServerFailure(message: "Sending failed, unknown error"));
            }

            //Construct the request according to the message content
            SendMessageRequest sendRequest =
                SendMessageRequest.withBodyAndMultimedia(
              conversationId: conversationRemoteId,
              replyTo: localMessage.replyTo,
              body: localMessage.body ?? "",
              filePath: localMultimedia.path!,
              onSendProgress: request.onSendProgress,
              cancelToken: request.cancelToken,
            );
            // print(request.toJson());

            request.cancelToken!.whenCancel.then((value) async {
              int count = await _messageLocalSource
                  .cancelUploadDownloadMultimedia(localMultimedia.localId);
              AppPrint.printError(
                  "Uploading multimedia ${localMultimedia.localId} Canceled, number of updates $count");
            });
            //Send the message to the remote db
            RemoteMessageModel remoteMessage =
                await _messageRemoteSource.uploadMultimedia(sendRequest);

            // AppPrint.printInfo(
            //     "sending the message to the remote db completes${remoteMessage.toString()}");
            //update local message according to the changes you got
            await _messageLocalSource.updateMessageWithLocalId(
              conversationLocalId: localMessage.conversationId,
              localMessage: remoteMessage.toLocalMessageOnSend(),
              messageLocalId: localMessage.localId,
              multimediaLocalId: remoteMessage.multimedia == null
                  ? null
                  : localMultimedia.localId,
              multimediaConverterCallBack: (messageLocalId) {
                return Future.value(
                  (remoteMessage.multimedia! as RemoteMultimediaModel)
                      .toLocalMultimediaOnSend(),
                );
              },
            );

            // await _messageLocalSource.updateMessageWithLocalId(
            //     remoteMessage.toLocalMessageOnSend(), localMessage.localId,localMessage.conversationId);

            //if the message contians multimedia update the local multimedia record
            // if (remoteMessage.multimedia != null) {
            //   await _multimediaLocalSource.updateMultimedia(
            //     (remoteMessage.multimedia! as RemoteMultimediaModel)
            //         .toLocalMultimediaOnSend(),
            //     localMultimedia.localId,
            //   );
            // }
          }
        } else {
          return const Left(
              ServerFailure(message: "Sending failed, unknown error"));
        }
      } else {
        return Left(ServerFailure(message: ErrorString.OFFLINE_ERROR));
      }

      return const Right(true);
    } on AppException catch (e) {
      return Left(e.failure as ServerFailure);
    } catch (e) {
      return Left(NotSpecificFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> downloadMultimedia(
      DownloadRequest request) async {
    try {
      if (await networkInfo.isConnected) {
        request.cancelToken!.whenCancel.then((value) async {
          int count = await _messageLocalSource
              .cancelUploadDownloadMultimedia(request.multimediaLocalId);
          AppPrint.printError(
              "Downloading multimedia ${request.multimediaLocalId} Canceled, number of updates $count");
        });
        bool isDownloaded =
            await _messageRemoteSource.downloadMultimedia(request);
        if (isDownloaded) {
          await _messageLocalSource.updateMessageMultimedia(
            request.messageLocalId,
            request.toLocalOnDownload(),
            request.multimediaLocalId,
          );
        } else {
          return const Left(ServerFailure(message: "Downloading Failed..."));
        }
      } else {
        return Left(ServerFailure(message: ErrorString.OFFLINE_ERROR));
      }

      return const Right(true);
    } on AppException catch (e) {
      return Left(e.failure as ServerFailure);
    } catch (e) {
      return Left(NotSpecificFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LocalMessage>> sendMessage(
      SendMessageRequest request) async {
    try {
      LocalMessage message = await _messageLocalSource.insertMessage(
        message: request.toLocal(),
        conversationLocalId: request.conversationId,
        multimediaConverterCallBack: request.filePath == null
            ? null
            : (messageLocalId) async {
                return await request.toLocalMultimediaOnInsert(messageLocalId);
              },
      );
      AppPrint.printInfo("local message inserted");
      AppPrint.printData(message.toString());
      await _conversationLocalSource
          .refreshConversationUpdatedAt(request.conversationId);

      if (request.filePath == null && await networkInfo.isConnected) {
        await sendLocalMessageToRemote(message, request.replyTo);
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
      print("clear called");
      await _messageLocalSource
          .deleteAllMessagesInConversation(request.conversationLocalId);
      return const Right(true);
    } on AppException catch (e) {
      return Left(e.failure as ServerFailure);
    } catch (e) {
      return Left(NotSpecificFailure(message: e.toString()));
    }
  }

  @override
  Future<void> sendLocalMessageToRemote(LocalMessage localMessage,
      [int? replyTo]) async {
    try {
      // print("sendLocalMessageToRemote ----------");
      //get the conversation remote id the message belongs to
      int? conversationRemoteId = await _conversationLocalSource
          .getRemoteIdByLocalId(localMessage.conversationId);

      if (conversationRemoteId != null) {
        LocalMultimedia? localMultimedia = await _messageLocalSource
            .getMessageMultimedia(localMessage.localId);
        // print(localMultimedia.toString());
        // print("--------here-------" + localMultimedia.toString());

        //Construct the request according to the message content
        SendMessageRequest request = _buildSendMessageRequestObject(
            localMessage, localMultimedia, conversationRemoteId);
        // print(request.toJson());

        //Send the message to the remote db
        RemoteMessageModel remoteMessage =
            await _messageRemoteSource.sendMessage(request);

        //update local message according to the changes you got
        await _messageLocalSource.updateMessageWithLocalId(
          conversationLocalId: localMessage.conversationId,
          localMessage: remoteMessage.toLocalMessageOnSend(),
          messageLocalId: localMessage.localId,
          multimediaLocalId:
              remoteMessage.multimedia == null || localMultimedia == null
                  ? null
                  : localMultimedia.localId,
          multimediaConverterCallBack: (messageLocalId) {
            return Future.value(
              (remoteMessage.multimedia! as RemoteMultimediaModel)
                  .toLocalMultimediaOnSend(),
            );
          },
        );

        //update local message according to the changes you got
        // await _messageLocalSource.updateMessageWithLocalId(
        //     remoteMessage.toLocalMessageOnSend(),
        //     localMessage.localId,
        //     localMessage.conversationId);

        //if the message contians multimedia update the local multimedia record
        // if (remoteMessage.multimedia != null && localMultimedia != null) {
        //   await _multimediaLocalSource.updateMultimedia(
        //     (remoteMessage.multimedia! as RemoteMultimediaModel)
        //         .toLocalMultimediaOnSend(),
        //     localMultimedia.localId,
        //   );
        // }
      }
    } on AppException catch (e) {
      print(
          "**********MyException in MessageRepositoryImp in sendLocalMessageToRemote: ${e.failure.toString()}");
    } catch (e) {
      print(
          "**********Error in MessageRepositoryImp in sendLocalMessageToRemote: ${e.toString()}");
    }
  }

  @override
  Future<void> conversationMessagesRead(int conversationId) async {
    try {
      await _messageLocalSource
          .markConversationMessagesAsReadLocally(conversationId);
      if (await networkInfo.isConnected) {
        await confermReadLocallyMessagesRemotely();
      }
    } catch (e) {
      print("Error: " + e.toString());
    }
  }

  
  @override
  Future<void> confirmMessageRead(LocalMessage message) async {
    try {
      await _messageLocalSource
          .markMessageAsReadLocally(message.localId,message.conversationId);
      if (await networkInfo.isConnected && message.remoteId!=null) {
        ReceivedReadMessageModel r =ReceivedReadMessageModel(id: message.remoteId!, at: DateTime.now());
        await _confirmReadMessagesRemotely([r]);
      }
    } catch (e) {
      print("Error: " + e.toString());
    }
  }

  @override
  Future<void> insertNewMessageFromRemote(
      RemoteMessageModel message, int conversationLocalId) async {
    try {
      //make sure that the message doesn't exists, maybe you received it before but
      //the receiving confimation didn't success, so the api sent it to you again as a new message
      int? messageLocalId =
          (await _messageLocalSource.getMessageByRemoteId(message.id))?.localId;
      messageLocalId ??= (await _messageLocalSource.insertMessage(
        message: message.toLocalMessageOnReceived(conversationLocalId),
        conversationLocalId: conversationLocalId,
        multimediaConverterCallBack: message.multimedia == null
            ? null
            : (int messageLocalId) async {
                return Future.value(
                  (message.multimedia! as RemoteMultimediaModel)
                      .toLocalMultimediaOnReceive(messageLocalId),
                );
              },
      ))
          .localId;
      // if (messageLocalId == null) {
      //   messageLocalId = await _messageLocalSource.insertMessage(
      //     message.toLocalMessageOnReceived(conversationLocalId),
      //     conversationLocalId
      //   );
      //   if (message.multimedia != null) {
      //     //check if the message has a multimedia to be added
      //     await _multimediaLocalSource.insertMultimedia(
      //       (message.multimedia! as RemoteMultimediaModel)
      //           .toLocalMultimediaOnReceive(messageLocalId),
      //     );
      //   }
      // }
      await _conversationLocalSource
          .refreshConversationUpdatedAt(conversationLocalId);

      //If the message already exists, or its added now, in both cases we need to confirm thier receipt
      // await confirmReceivedMessagesRemotelyAndUpdateLocallay([
      //   ReceivedReadMessageModel(id: message.id, at: DateTime.now()),
      // ]);
      // return messageLocalId;
    } on AppException catch (e) {
      print(
          "**********MyException in MessageRepositoryImp in insertNewMessageFromRemote: ${e.failure.toString()}");
      // return null;
    } catch (e) {
      print(
          "**********Error in MessageRepositoryImp in insertNewMessageFromRemote: ${e.toString()}");
    }
  }

  @override
  Future<void> confirmReceivedLocallyMessagesRemotely() async {
    try {
      // Get received locally messages
      List<LocalMessage> messages =
          await _messageLocalSource.getReceivedLocallyMessages();
      // Extract a liat of ReceivedReadMessageModel from the messages, to use in the request
      List<ReceivedReadMessageModel> recReadMeaages =
          _getIdsAndAtFromLocalMessages(messages, true);
      await confirmReceivedMessagesRemotelyAndUpdateLocallay(recReadMeaages);
    } on AppException catch (e) {
      print(
          "**********MyException in MessageRepositoryImp in confirmReceivedLocallyMessagesRemotely: ${e.failure.toString()}");
    } catch (e) {
      print(
          "**********Error in MessageRepositoryImp in confirmReceivedLocallyMessagesRemotely: ${e.toString()}");
    }
  }

  @override
  Future<void> confermReadLocallyMessagesRemotely() async {
    try {
      List<LocalMessage> messages =
          await _messageLocalSource.getReadLocallyMessages();
      List<ReceivedReadMessageModel> recReadMeaages =
          _getIdsAndAtFromLocalMessages(messages, true);
      await _confirmReadMessagesRemotely(recReadMeaages);
    } on AppException catch (e) {
      print(
          "**********MyException in MessageRepositoryImp in confermReadLocallyMessagesRemotely: ${e.failure.toString()}");
    } catch (e) {
      print(
          "**********Error in MessageRepositoryImp in confermReadLocallyMessagesRemotely: ${e.toString()}");
    }
  }

  @override
  Future<void> markMessagesAsReceived(
      List<ReceivedReadMessageModel> remote) async {
    try {
      for (var element in remote) {
        await _messageLocalSource.updateMessagesReceivedAt(element);
      }
      List<int> ids = remote.map<int>((e) => e.id).toList();
      await _gettenRecieveResponse(ids);
    } on AppException catch (e) {
      print(
          "**********MyException in MessageRepositoryImp in markMessagesAsReceived: ${e.failure.toString()}");
    } catch (e) {
      print(
          "**********Error in MessageRepositoryImp in markMessagesAsReceived: ${e.toString()}");
    }
  }

  @override
  Future<void> markMessagesAsRead(List<ReceivedReadMessageModel> remote) async {
    try {
      for (var element in remote) {
        await _messageLocalSource.updateMessagesReadAt(element);
      }
      List<int> ids = remote.map<int>((e) => e.id).toList();
      await _gettenReadResponse(ids);
    } on AppException catch (e) {
      print(
          "**********MyException in MessageRepositoryImp in markMessagesAsRead: ${e.failure.toString()}");
    } catch (e) {
      print(
          "**********Error in MessageRepositoryImp in markMessagesAsRead: ${e.toString()}");
    }
  }

  /// Builds a [SendMessageRequest] object based on message content and multimedia (if present).
  ///
  /// This method constructs a [SendMessageRequest] object that encapsulates information
  /// needed to send a message, including the conversation ID, message body, and multimedia content.
  ///
  /// - [localMessage]: The local message object containing message details.
  /// - [localMultimedia]: The multimedia content associated with the message (can be null).
  /// - [conversationRemoteId]: The remote ID of the conversation to which the message belongs.
  ///
  /// Returns a [SendMessageRequest] object representing the message to be sent.
  ///
  /// Example usage:
  /// ```dart
  /// final messageSource = MessageLocalSource(chatDatabase);
  /// final localMessage = LocalMessage(
  ///   // Populate localMessage properties...
  /// );
  /// final conversationRemoteId = 123; // Replace with the actual conversation ID.
  /// final request = messageSource._buildSendMessageRequestObject(
  ///   localMessage, localMultimedia, conversationRemoteId,
  /// );
  ///
  /// print("Sending Message Request: $request");
  /// ```
  SendMessageRequest _buildSendMessageRequestObject(LocalMessage localMessage,
      LocalMultimedia? localMultimedia, int conversationRemoteId) {
    late SendMessageRequest request;
    if (localMultimedia != null) {
      if (localMessage.body != null && localMessage.body != "") {
        request = SendMessageRequest.withBodyAndMultimedia(
          conversationId: conversationRemoteId,
          replyTo: localMessage.replyTo,
          body: localMessage.body!,
          filePath: localMultimedia.path!,
          onSendProgress: null,
          cancelToken: null,
        );
      } else {
        request = SendMessageRequest.withMultimedia(
          conversationId: conversationRemoteId,
          replyTo: localMessage.replyTo,
          filePath: localMultimedia.path!,
          onSendProgress: null,
          cancelToken: null,
        );
      }
    } else {
      request = SendMessageRequest.withBody(
        conversationId: conversationRemoteId,
        replyTo: localMessage.replyTo,
        body: localMessage.body!,
      );
    }
    // print(request.toString());
    return request;
  }

  /// Confirms received messages remotely and updates their received locally flag.
  ///
  /// This method takes a list of [ReceivedReadMessageModel] objects, confirms their reception
  /// remotely, and then updates their received locally flag in the local data source.
  ///
  /// Use this method to confirm the receipt of messages and update their flag accordingly.
  ///
  /// Example usage:
  /// ```dart
  /// final receivedMessages = // List of ReceivedReadMessageModel objects
  ///
  /// await _confermReceivedMessagesRemotely(receivedMessages);
  /// ```
  ///
  /// - [recReadMessages]: A list of [ReceivedReadMessageModel] objects representing received messages.
  Future<void> confirmReceivedMessagesRemotelyAndUpdateLocallay(
      List<ReceivedReadMessageModel> recReadMeaages) async {
    if (recReadMeaages.isNotEmpty) {
      ReceivedReadConfimationResponseModel response =
          await _messageRemoteSource.confirmMessagesReceieve(
        ReceiveReadConfirmationRequest(receivedReadMessages: recReadMeaages),
      );

      await _messageLocalSource.updateReceivedLocallyToFalse(response.success);
    }
  }

  /// Confirms raed messages remotely and updates their read locally flag.
  ///
  /// This method takes a list of [ReceivedReadMessageModel] objects, confirms their read
  /// remotely, and then updates their read locally flag in the local data source.
  ///
  /// Use this method to confirm the read of messages and update their flag accordingly.
  ///
  /// Example usage:
  /// ```dart
  /// final receivedMessages = // List of ReceivedReadMessageModel objects
  ///
  /// await _confirmReadMessagesRemotely(receivedMessages);
  /// ```
  ///
  /// - [recReadMessages]: A list of [ReceivedReadMessageModel] objects representing received messages.
  Future<void> _confirmReadMessagesRemotely(
      List<ReceivedReadMessageModel> recReadMeaages) async {
    if (recReadMeaages.isNotEmpty) {
      ReceivedReadConfimationResponseModel response =
          await _messageRemoteSource.confirmMessagesRead(
        ReceiveReadConfirmationRequest(receivedReadMessages: recReadMeaages),
      );

      await _messageLocalSource.updateReadLocallyToFalse(response.success);
    }
  }

  /// Converts a list of local messages into a list of ReceivedReadMessageModel objects.
  ///
  /// This helper method takes a list of local messages and extracts their IDs
  /// and either received timestamps or read timestamps based on the `withReceivedAt`
  /// parameter. It then creates and returns a list of ReceivedReadMessageModel objects
  /// containing this information.
  ///
  /// - [messages]: A list of [LocalMessage] objects.
  /// - [withReceivedAt]: Set to `true` to include received timestamps, `false` to include read timestamps.
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

  /// Notifies the remote server of the reception confirmation response for a list of message IDs.
  ///
  /// This method takes a list of message IDs and sends a reception confirmation response
  /// to the remote server to acknowledge the successful reception of these messages.
  ///
  /// Use this method to inform the remote server about the received messages.
  ///
  /// Example usage:
  /// ```dart
  /// final messageIds = // List of message IDs
  ///
  /// await _gettenRecieveResponse(messageIds);
  /// ```
  ///
  /// - [ids]: A list of message IDs for which the reception confirmation response is sent.
  ///
  /// Note: This method is typically used internally within the repository.
  _gettenRecieveResponse(List<int> ids) async {
    if (ids.isNotEmpty) {
      await _messageRemoteSource.confirmGettenReceiveResponse(ids);
    }
  }

  /// Notifies the remote server of the read confirmation response for a list of message IDs.
  ///
  /// This method takes a list of message IDs and sends a read confirmation response
  /// to the remote server to acknowledge the successful reading of these messages.
  ///
  /// Use this method to inform the remote server about the read messages.
  ///
  /// Example usage:
  /// ```dart
  /// final repository = MessageRepository();
  /// final messageIds = // List of message IDs
  ///
  /// await repository._gettenReadResponse(messageIds);
  /// ```
  ///
  /// - [ids]: A list of message IDs for which the read confirmation response is sent.
  ///
  /// Note: This method is typically used internally within the repository.
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
