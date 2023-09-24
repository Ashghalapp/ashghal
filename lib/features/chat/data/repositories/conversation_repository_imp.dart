import 'package:ashghal_app_frontend/core_api/api_response_model.dart';
import 'package:ashghal_app_frontend/core_api/errors/exceptions.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/core_api/network_info/network_info.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/receive_read_message_model.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/remote_conversation_model.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/remote_message_model.dart';
import 'package:ashghal_app_frontend/features/chat/data/repositories/message_repository_imp.dart';
import 'package:ashghal_app_frontend/features/chat/data/resources/local/conversation/conversation_local_source.dart';
import 'package:ashghal_app_frontend/features/chat/data/resources/local/message/message_local_source.dart';
import 'package:ashghal_app_frontend/features/chat/data/resources/remote/conversation_remote_source.dart';
import 'package:ashghal_app_frontend/features/chat/data/resources/remote/message_remote_source.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/conversation_last_message_and_count.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/conversation_repository.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/block_unblock_conversation_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/clear_chat_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/delete_conversation_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/start_conversation_request.dart';

import 'package:dartz/dartz.dart';

class ConversationRepositoryImp extends ConversationRepository {
  final ConversationRemoteSource _conversationRemoteSource =
      ConversationRemoteSourceImp();
  final MessageRemoteSource _messageRemoteSource = MessageRemoteSourceImp();
  late final ConversationLocalSource _conversationLocalSource;
  late final MessageLocalSource _messageLocalSource;
  // late final MultimediaLocalSource _multimediaLocalSource;
  final ChatDatabase db = ChatDatabase();
  final NetworkInfo networkInfo = NetworkInfoImpl();
  final MessageRepositoryImp _messageRepository = MessageRepositoryImp();
  ConversationRepositoryImp() {
    _conversationLocalSource = ConversationLocalSource(db);
    _messageLocalSource = MessageLocalSource(db);
  }

  @override
  Future<Either<Failure, List<LocalConversation>>> getAllConversations() async {
    try {
      List<LocalConversation> conversations =
          await _conversationLocalSource.getAllConversations();

      return Right(conversations);
    } catch (e) {
      print(
          ">>>>>>>>>>Exception:in ConversationRepositoryImp - function getAllConversations $e");
      return Left(NotSpecificFailure(message: e.toString()));
    }
  }

  @override
  Stream<List<LocalConversation>> watchAllConversations() async* {
    try {
      yield* _conversationLocalSource.watchAllConversations();
    } catch (e) {
      throw NotSpecificFailure(message: e.toString());
    }
  }

  @override
  Stream<List<ConversationlastMessageAndCount>>
      watchConversationsLastMessageAndCount() async* {
    try {
      yield* _messageLocalSource.watchLastMessageAndCountInEachConversation();
    } catch (e) {
      throw NotSpecificFailure(message: e.toString());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteConversation(
      DeleteConversationRequest request) async {
    try {
      await _messageRepository.clearChat(
          ClearChatRequest(conversationLocalId: request.conversationLocalId));
      bool deleted = await _conversationLocalSource
          .deleteConversationByLocalId(request.conversationLocalId);

      return Right(deleted);
    } catch (e) {
      print(
          ">>>>>>>>>>Exception:in ConversationRepositoryImp function deleteConversation $e");
      return Left(NotSpecificFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LocalConversation>> startConversationWith(
      StartConversationRequest request) async {
    // bool createdLocal = false;
    try {
      LocalConversation? localConversation =
          await _conversationLocalSource.getConversationWith(request.userId);
      // print(
      //   localConversation == null
      //       ? "1111111111111111111"
      //       : localConversation.toString(),
      // );
      if (localConversation == null) {
        // createdLocal = true;
        localConversation =
            await _conversationLocalSource.startConversation(request.toLocal());
        // print("after ${localConversation.localId}");
        if (await networkInfo.isConnected) {
          _startAConversationRemotelyAndUpdateTheLocal(localConversation);
        }
      }
      return Right(localConversation);
    } catch (e) {
      // print(">>>>>>>>>>Exception: $e");
      return Left(NotSpecificFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> blockUnblockConversation(
      BlockUnblockConversationRequest request) async {
    try {
      if (await networkInfo.isConnected) {
        ApiResponseModel response;
        if (request.block) {
          response = await _conversationRemoteSource
              .blockConversation(request.toJson());
        } else {
          response = await _conversationRemoteSource
              .unblockConversation(request.toJson());
        }
        await _conversationLocalSource.blockUnblockConversation(
          request.conversationId,
          request.block,
        );
        return Right(response.status);
      }

      return const Right(false);
    } catch (e) {
      // print(">>>>>>>>>>Exception: $e");
      return Left(NotSpecificFailure(message: e.toString()));
    }
  }

  // Future<void>
  //     _listenToMessagesGotReceiveResponseOnThemAndNotConfirmedYet() async {
  //   _messageLocalSource
  //       .watchReceivedAndNotConfirmedYet()
  //       .listen((messsages) async {
  //     if (await networkInfo.isConnected) {
  //       List<int> ids = [];
  //       for (var message in messsages) {
  //         ids.add(message.remoteId!);
  //       }
  //       if (ids.isNotEmpty) {
  //         RecieveReadGotConfirmationModel response =
  //             await _messageRemoteSource.confirmGettenReceiveResponse(ids);
  //         await _messageLocalSource
  //             .updateConfirmGotReceiveToTrue(response.success);
  //       }
  //     }
  //   });
  // }
  // Future<void>
  //     _listenToMessagesGotReadResponseOnThemAndNotConfirmedYet() async {
  //   _messageLocalSource.watchReadAndNotConfirmedYet().listen((messsages) async {
  //     if (await networkInfo.isConnected) {
  //       List<int> ids = [];
  //       for (var message in messsages) {
  //         ids.add(message.remoteId!);
  //       }
  //       if (ids.isNotEmpty) {
  //         RecieveReadGotConfirmationModel response =
  //             await _messageRemoteSource.confirmGettenReadResponse(ids);
  //         await _messageLocalSource
  //             .updateConfirmGotReadToTrue(response.success);
  //       }
  //     }
  //   });
  // }

  @override
  Future<void> synchronizeConversations() async {
    print("Syncronizing start before connection checked");
    if (await networkInfo.isConnected) {
      try {
        print("Syncronizing start with connection");
        print("before Call Start Local Conversation Remotely");
        // start coversations created locally on remote
        await _startLocalConversationsRemotely();
        print("after Call Start Local Conversation Remotely");
        // send unsent messages
        await _sendUnSentMessages();

        //Conferm yany messages that is marked as received locally or read locally
        await _messageRepository.confermReceivedLocallyMessagesRemotely();
        await _messageRepository.confermReadLocallyMessagesRemotely();

        //  get conversations updates from remote surce
        List<RemoteConversationModel> remoteConversations =
            await _conversationRemoteSource.getUserConversationsUpdates();

        // update local conversations according to updates comes from remote
        for (RemoteConversationModel remoteConversation
            in remoteConversations) {
          int conversationLocalId =
              await _insertOrUpdateLocalConversationFromRemote(
                  remoteConversation);
          print("After conversation Updates");

          //Save new messages into local db
          for (RemoteMessageModel message
              in remoteConversation.newMessages.cast<RemoteMessageModel>()) {
            await _messageRepository.insertNewMessageFromRemote(
                message, conversationLocalId);
          }
          _conversationLocalSource
              .refreshConversationUpdatedAt(conversationLocalId);

          //Here we mark received messages as received, and ensure to the remote source
          //that we got the receive confirmation, So it will not be sent again
          if (remoteConversation.receivedMessages.isNotEmpty) {
            await _messageRepository.markMessagesAsReceived(
              remoteConversation.receivedMessages
                  .cast<ReceivedReadMessageModel>(),
            );
          }

          //Here we mark read messages as read, and ensure to the remote source
          //that we got the receive confirmation, So it will not be sent again
          if (remoteConversation.readMessages.isNotEmpty) {
            await _messageRepository.markMessagesAsRead(
              remoteConversation.readMessages.cast<ReceivedReadMessageModel>(),
            );
          }
          //check if you received new messsaages to confirm that you recieved the new messages
          if (remoteConversation.newMessages.isNotEmpty) {
            await _messageRepository.confermReceivedLocallyMessagesRemotely();
          }
        }
        // _listenToReceivedLocallyMessages();

        // _listenToReadLocallyMessages();
      } on AppException catch (e) {
        print(
            "MyException in ConversationRepositoryImp in initializeConversations: ${e.failure.toString()}");
      } catch (e) {
        print(
            "Error in ConversationRepositoryImp in initializeConversations: ${e.toString()}");
      }
    }
  }

  Future<void> _startLocalConversationsRemotely() async {
    List<LocalConversation> localConversations =
        await _conversationLocalSource.getLocalConversations();
    for (var localConversation in localConversations) {
      await _startAConversationRemotelyAndUpdateTheLocal(localConversation);
    }
  }

  Future<void> _startAConversationRemotelyAndUpdateTheLocal(
      LocalConversation local) async {
    RemoteConversationModel remote =
        await _conversationRemoteSource.startConversation(
      StartConversationRequest(userId: local.userId).toJson(),
    );
    await _conversationLocalSource.updateConversation(
      remote.toLocalConversationWithId(local.localId),
    );
  }

  Future<void> _sendUnSentMessages() async {
    List<LocalMessage> localMessages =
        await _messageLocalSource.getUnSentMessages();
    for (var localMessage in localMessages) {
      await _messageRepository.sendLocalMessageToRemote(
        localMessage,
        localMessage.conversationId,
      );
    }
  }

  /// Inserts or updates a local conversation based on a remote conversation model.
  ///
  /// This function takes a [RemoteConversationModel] as input and attempts to
  /// insert or update the corresponding local conversation in the local database.
  ///
  /// If a local conversation with the participant's ID does not exist, a new
  /// conversation is started using the provided [remote] data, and its local ID
  /// is returned.
  ///
  /// If a local conversation with the participant's ID already exists, it is
  /// updated with the latest data from the [remote] model.
  ///
  /// Parameters:
  ///   - [remote]: The remote conversation model to insert or update.
  ///
  /// Returns:
  ///   - A [Future] that resolves to an [int] representing the local ID of the
  ///     conversation.
  ///
  /// Example Usage:
  /// ```dart
  /// final remoteConversation = RemoteConversationModel(/* ... */);
  /// final localConversationId =
  ///     await _insertOrUpdateLocalConversationFromRemote(remoteConversation);
  /// ```
  ///
  /// Note: This function assumes that you have a `_conversationLocalSource` with
  /// methods like `getConversationWith`, `startConversation`, and `updateConversation`
  /// for managing local conversations.
  Future<int> _insertOrUpdateLocalConversationFromRemote(
      RemoteConversationModel remote) async {
    LocalConversation? local =
        await _conversationLocalSource.getConversationWithRemoteId(remote.id);
    if (local == null) {
      // print("Coversatio Not Exists");
      return (await _conversationLocalSource
              .startConversation(remote.toLocalConversation()))
          .localId;
    } else {
      await _conversationLocalSource.updateConversation(
        remote.toLocalConversationWithId(local.localId),
      );
    }
    return local.localId;
  }

  // Future<void> _listenToReceivedLocallyMessages() async {
  //   _messageLocalSource
  //       .watchReceivedLocallyMessages()
  //       .listen((messsages) async {
  //     if (await networkInfo.isConnected) {
  //       messsages.removeWhere((element) => element.receivedLocally == false);
  //       //first we get a list of readConfirmation model(contains id, and at) from
  //       //the local messages so we can use them to construct the ReceiveReadConfirmationRequest
  //       List<ReceivedReadMessageModel> recReadMeaages =
  //           _getIdsAndAtFromLocalMessages(messsages, true);

  //       if (recReadMeaages.isNotEmpty) {
  //         ReceivedReadConfimationResponseModel response =
  //             await _messageRemoteSource.confirmMessagesReceieve(
  //           ReceiveReadConfirmationRequest(
  //               receivedReadMessages: recReadMeaages),
  //         );

  //         await _messageLocalSource
  //             .updateReceivedLocallyToFalse(response.success);
  //       }
  //     }
  //   });
  // }

  // Future<void> _listenToReadLocallyMessages() async {
  //   _messageLocalSource.watchReadLocallyMessages().listen((messsages) async {
  //     if (await networkInfo.isConnected) {
  //       print(
  //           "================================_listenToReadLocallyMessages================================");
  //       messsages.removeWhere((element) => element.readLocally == false);

  //       List<ReceivedReadMessageModel> recReadMeaages =
  //           _getIdsAndAtFromLocalMessages(messsages, false);
  //       print("======= Length =${recReadMeaages.length}");
  //       if (recReadMeaages.isNotEmpty) {
  //         // print("======= Length =${recReadMeaages.length}");
  //         // print("======= data[0] =${recReadMeaages[0].toString()}");
  //         // print("======= data[1] =${recReadMeaages[1].toString()}");
  //         // print("======= data[2] =${recReadMeaages[2].toString()}");
  //         ReceivedReadConfimationResponseModel response =
  //             await _messageRemoteSource.confirmMessagesRead(
  //           ReceiveReadConfirmationRequest(
  //               receivedReadMessages: recReadMeaages),
  //         );
  //         await _messageLocalSource.updateReadLocallyToFalse(response.success);
  //       }
  //     }
  //   });
  // }
}
