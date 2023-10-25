import 'dart:convert';

import 'package:ashghal_app_frontend/core/helper/app_print_class.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/services/app_services.dart';
import 'package:ashghal_app_frontend/core_api/api_response_model.dart';
import 'package:ashghal_app_frontend/core_api/errors/error_strings.dart';
import 'package:ashghal_app_frontend/core_api/errors/exceptions.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/core_api/network_info/network_info.dart';
import 'package:ashghal_app_frontend/core_api/pusher_service.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/receive_read_message_model.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/remote_conversation_model.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/remote_message_model.dart';
import 'package:ashghal_app_frontend/features/chat/data/repositories/message_repository_imp.dart';
import 'package:ashghal_app_frontend/features/chat/data/repositories/pusher_chat_helper.dart';
import 'package:ashghal_app_frontend/features/chat/data/resources/local/conversation/conversation_local_source.dart';
import 'package:ashghal_app_frontend/features/chat/data/resources/local/message/message_local_source.dart';
import 'package:ashghal_app_frontend/features/chat/data/resources/local/multimedia/multimedia_local_source.dart';
import 'package:ashghal_app_frontend/features/chat/data/resources/remote/conversation_remote_source.dart';
import 'package:ashghal_app_frontend/features/chat/data/resources/remote/message_remote_source.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/conversation_last_message_and_count.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/matched_conversation_and_messages.dart';
import 'package:ashghal_app_frontend/features/chat/domain/repositories/conversation_repository.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/block_unblock_conversation_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/clear_chat_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/confirm_got_conversation_data_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/delete_conversation_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/start_conversation_request.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/inserting_message_controller.dart';

import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class ConversationRepositoryImp extends ConversationRepository {
  final ConversationRemoteSource _conversationRemoteSource =
      ConversationRemoteSourceImp();
  final MessageRemoteSource _messageRemoteSource = MessageRemoteSourceImp();
  late final ConversationLocalSource _conversationLocalSource;
  late final MessageLocalSource _messageLocalSource;
  late final MultimediaLocalSource _multimediaLocalSource;
  // late final MultimediaLocalSource _multimediaLocalSource;
  final ChatDatabase db = ChatDatabase();
  final NetworkInfo networkInfo = NetworkInfoImpl();
  final MessageRepositoryImp _messageRepository = MessageRepositoryImp();
  final PusherChatHelper _pusherChatHelper = PusherChatHelper();
  // List<LocalConversation> _remoteConversations = [];
  ConversationRepositoryImp() {
    _conversationLocalSource = ConversationLocalSource(db);
    _messageLocalSource = MessageLocalSource(db);
    _multimediaLocalSource = MultimediaLocalSource(db);
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
  Future<Either<Failure, bool>> deleteConversations(
      List<int> conversationsLocalIds) async {
    try {
      for (var conversationLocalId in conversationsLocalIds) {
        int? conversationRemoteId = await _conversationLocalSource
            .getRemoteIdByLocalId(conversationLocalId);
        await _deleteConversationRemotelyAndlocally(
          conversationLocalId: conversationLocalId,
          conversationRemoteId: conversationRemoteId,
        );
      }
      // bool deleted = false;

      // if (await networkInfo.isConnected) {}
      // if (!deleted) {
      //   deleted = (await _conversationLocalSource
      //           .deleteConversationLocally(conversationsLocalId)) >
      //       0;
      // }
      return const Right(true);
    } catch (e) {
      return Left(NotSpecificFailure(message: e.toString()));
    }
  }

  Future<bool> _deleteConversationRemotelyAndlocally(
      {required int conversationLocalId, int? conversationRemoteId}) async {
    // try {
    bool deleted = false;
    if (conversationRemoteId != null && await networkInfo.isConnected) {
      DeleteConversationRequest request =
          DeleteConversationRequest(conversationRemoteId: conversationRemoteId);
      bool ok =
          (await _conversationRemoteSource.deleteConversation(request.toJson()))
              .status;
      if (ok) {
        deleted = await _conversationLocalSource
            .deleteConversationByLocalId(conversationLocalId);
      }
    }
    if (!deleted) {
      deleted = (await _conversationLocalSource
              .deleteConversationLocally(conversationLocalId)) >
          0;
    }
    if (deleted && conversationRemoteId != null) {
      print("Unsubscribe from chat $conversationRemoteId channel started");
      await _pusherChatHelper
          .unsubscribeFromConversationChannel(conversationRemoteId);
    }

    return deleted;
    // } catch (e) {
    //   print(
    //       "**********Error in ConversationRepositoryImp in _deleteConversationRemotely: ${e.toString()}");
    //   return false;
    // }
  }

  // Future<void> _deleteConversation

  Future<void> cofirmGotConversationData(int conversationRemoteId) async {
    if (await networkInfo.isConnected) {
      await _conversationRemoteSource.confirmGotConversationData(
        ConfirmGotConversationDataRequest(
          conversationRemoteId: conversationRemoteId,
        ).toJson(),
      );
    }
  }

  @override
  Future<Either<Failure, LocalConversation>> startConversationWith(
      StartConversationRequest request) async {
    try {
      LocalConversation? conversation = await _conversationLocalSource
          .getConversationWithUser(request.userId);
      if (conversation != null) {
        AppPrint.printInfo("Conversation already exists in the local db");
        return right(conversation);
      }
      conversation =
          await _conversationLocalSource.startConversation(request.toLocal());
      // LocalConversation conversation =
      //     await _conversationLocalSource.startConversation(request.toLocal());

      // If the device is connected to the network, start the conversation remotely
      if (await networkInfo.isConnected && conversation != null) {
        AppPrint.printData(
            "conversation creadted locally: ${conversation.toString()}");
        await _startAConversationRemotelyAndUpdateTheLocal(request);
        conversation = await _conversationLocalSource
            .getConversationWithUser(request.userId);
        AppPrint.printData(
            "conversation creadted remotely: ${conversation.toString()}");
      }

      if (conversation == null) {
        AppPrint.printError(
            "error in ConversationRepositoryImp in startConversationWith: Fail to create conversation locally");
        return Left(
            NotSpecificFailure(message: AppLocalization.startChatingFailer.tr));
      }

      return Right(conversation);
    } catch (e) {
      AppPrint.printError(
          "error in ConversationRepositoryImp in startConversationWith:${e.toString()}");
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

        if (!response.status) {
          return Left(NotSpecificFailure(message: response.message));
        } else {
          await _conversationLocalSource.blockUnblockConversation(
            request.conversationRemoteId,
            request.block,
          );
        }
        return const Right(true);
      } else {
        return Left(NotSpecificFailure(message: ErrorString.OFFLINE_ERROR));
      }
    } catch (e) {
      return Left(NotSpecificFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavoriteConversation(
      int conversationLocalId, bool addToFavorite) async {
    try {
      bool ok = (await _conversationLocalSource.toggleFavoriteConversation(
              conversationLocalId, addToFavorite)) >
          0;
      return right(ok);
    } catch (e) {
      print(
          "**********Error in ConversationRepositoryImp in toggleFavoriteConversation: ${e.toString()}");
      return Left(NotSpecificFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleArchiveConversation(
      int conversationLocalId, bool addToArchive) async {
    try {
      bool ok = (await _conversationLocalSource.toggleArchiveConversation(
              conversationLocalId, addToArchive)) >
          0;
      return right(ok);
    } catch (e) {
      print(
          "**********Error in ConversationRepositoryImp in toggleFavoriteConversation: ${e.toString()}");
      return Left(NotSpecificFailure(message: e.toString()));
    }
  }

  @override
  Future<void> subscribeToChatChannels(
      void Function(TypingEventType eventType, int userId)
          onTypingEvent) async {
    try {
      if (await networkInfo.isConnected) {
        await _pusherChatHelper.subscribeToUserChannels(
          onNewMessageUnknownConversation: (remoteConversation) async {
            int? conversationLocalId =
                await _insertLocalConversationFromRemoteIfNotExists(
              remoteConversation,
            );
            if (conversationLocalId != null) {
              for (var remoteMessage in remoteConversation.newMessages
                  .cast<RemoteMessageModel>()) {
                await _messageRepository.insertNewMessageFromRemote(
                  remoteMessage,
                  conversationLocalId,
                );
              }
              LocalConversation? conversation = await _conversationLocalSource
                  .getConversationByLocalId(conversationLocalId);
              if (conversation != null) {
                await _subscribTtoConversationChannel(
                    conversation, onTypingEvent);
              }
            }
          },
        );

        List<LocalConversation> conversations =
            await _conversationLocalSource.getRemoteConversations();

        for (var conversation in conversations) {
          await _subscribTtoConversationChannel(conversation, onTypingEvent);

          // await _pusherChatHelper.subscribeToChatChannels(
          //   conversationRemoteId: conversation.remoteId!,
          //   onNewMessage: (message) async {
          //     await _messageRepository.insertNewMessageFromRemote(
          //       message,
          //       conversation.localId,
          //     );
          //   },
          //   onMessageReceived: (receivedReadMessage) async {
          //     // print("onMessageReceived///////////////////////");
          //     print(receivedReadMessage.toString());
          //     await _messageRepository
          //         .markMessagesAsReceived([receivedReadMessage]);
          //   },
          //   onMessageRead: (receivedReadMessage) async {
          //     print("onMessageRead///////////////////////");
          //     // print(receivedReadMessage.toString());
          //     await _messageRepository
          //         .markMessagesAsRead([receivedReadMessage]);
          //   },
          //   onTypingEvent: onTypingEvent,
          // );
          print("*********Subscrib to chat channls ok*********");
        }

        // Future.delayed(
        //   const Duration(seconds: 3),
        //   () async {
        //     print("************Search starts************");
        //     List<MatchedConversationsAndMessages> matchedes =
        //         await _conversationLocalSource
        //             .searchConversationsAndMessages("how");
        //     for (var match in matchedes) {
        //       print(
        //           "Conversation: ${match.conversation.localId} - messages: ${match.messages.length}");
        //     }
        //     print("************Search Ends************");
        //   },
        // );
      }
    } on AppException catch (e) {
      print(
          "**********MyException in ConversationRepositoryImp in subscribeToChatChannels: ${e.failure.toString()}");
    } catch (e) {
      print(
          "**********Error in ConversationRepositoryImp in subscribeToChatChannels: ${e.toString()}");
    }
  }

  Future<void> _subscribTtoConversationChannel(
      LocalConversation conversation,
      void Function(TypingEventType eventType, int userId)
          onTypingEvent) async {
    await _pusherChatHelper.subscribeToChatChannels(
      conversationRemoteId: conversation.remoteId!,
      onNewMessage: (message) async {
        await _messageRepository.insertNewMessageFromRemote(
          message,
          conversation.localId,
        );
      },
      onMessageReceived: (receivedReadMessage) async {
        // print("onMessageReceived///////////////////////");
        print(receivedReadMessage.toString());
        await _messageRepository.markMessagesAsReceived([receivedReadMessage]);
      },
      onMessageRead: (receivedReadMessage) async {
        print("onMessageRead///////////////////////");
        // print(receivedReadMessage.toString());
        await _messageRepository.markMessagesAsRead([receivedReadMessage]);
      },
      onTypingEvent: onTypingEvent,
    );
  }

  @override
  Future<Either<Failure, List<LocalConversation>>> searchInConversations(
      String searchText) async {
    try {
      List<LocalConversation> matchedes =
          await _conversationLocalSource.search(searchText);
      return right(matchedes);
    } catch (e) {
      AppPrint.printError(
          "Error in ConversationRepositoryImp in searchInConversations: ${e.toString()}");
      return Left(NotSpecificFailure(message: e.toString()));
    }
  }

  @override
  Future<void> unsubscribeFromChatChannels() async {
    await _pusherChatHelper.unsubscribeFromChannels();
  }

  @override
  Future<void> synchronizeConversations() async {
    // print("Syncronizing start before connection checked");
    if (await networkInfo.isConnected) {
      try {
        // print("Syncronizing start with connection");
        // print("before Call Start Local Conversation Remotely");

        // start coversations created locally remotely
        await _startLocalConversationsRemotely();

        List<LocalConversation> deletedConversations =
            await _conversationLocalSource.getDeletedLocallyConversations();
        for (var conversation in deletedConversations) {
          if (conversation.remoteId != null) {
            await _deleteConversationRemotelyAndlocally(
              conversationLocalId: conversation.localId,
              conversationRemoteId: conversation.remoteId,
            );
          }
        }
        // print("after Call Start Local Conversation Remotely");

        //Conferm any messages that is marked as received locally or read locally
        await _messageRepository.confirmReceivedLocallyMessagesRemotely();
        await _messageRepository.confermReadLocallyMessagesRemotely();

        // send unsent messages
        await _sendUnSentMessages();
        print("here0");
        //  get conversations updates from remote surce
        List<RemoteConversationModel> remoteConversations =
            await _conversationRemoteSource.getUserConversationsUpdates();
        print("here0");

        // update local conversations according to updates comes from remote
        for (RemoteConversationModel remoteConversation
            in remoteConversations) {
          int? conversationLocalId =
              await _insertLocalConversationFromRemoteIfNotExists(
                  remoteConversation);
          // print("After conversation Updates");
          if (conversationLocalId == null) {
            continue;
          }
          print("here1");

          //Save new messages into local db
          for (RemoteMessageModel message
              in remoteConversation.newMessages.cast<RemoteMessageModel>()) {
            await _messageRepository.insertNewMessageFromRemote(
              message,
              conversationLocalId,
            );
          }
          print("here2");

          //refresh the conversation as the last updated conversation
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
        }
        // await subscribeToChatChannels((type, userid) {
        //   print("Every thing works ok");
        //   print("type: ${type == TypingEventType.start ? 'start' : 'stop'}");
        //   print("userid: $userid");
        // });
      } on AppException catch (e) {
        AppPrint.printError(
            "MyException in ConversationRepositoryImp in initializeConversations: ${e.failure.toString()}");
      } catch (e) {
        AppPrint.printError(
            "Error in ConversationRepositoryImp in initializeConversations: ${e.toString()}");
      }
    }
  }

  /// Starts a conversation remotely and updates the local conversation data accordingly.
  ///
  /// This private method is used internally by [startConversationWith] and [_startLocalConversationsRemotely] to initiate a conversation
  /// remotely and synchronize the local data with the remote data.
  ///
  /// - [request]: A [StartConversationRequest] object specifying the user to start a conversation with.
  Future<void> _startAConversationRemotelyAndUpdateTheLocal(
      StartConversationRequest request) async {
    RemoteConversationModel remote =
        await _conversationRemoteSource.startConversation(
      request.toJson(),
    );
    await _conversationLocalSource.updateConversationWithUserId(
      remote.toLocalConversation(),
      remote.secondUser.id,
    );
  }

  /// Starts local conversations remotely and updates them in the local database.
  ///
  /// This method fetches a list of the created local conversations and starts each conversation
  /// remotely by sending a request to a remote server. After starting each conversation
  /// remotely, it updates the local database with the newly created conversation.
  ///
  /// Example usage:
  /// ```dart
  /// final source = ConversationLocalSource(database);
  /// await source._startLocalConversationsRemotely();
  /// ```
  Future<void> _startLocalConversationsRemotely() async {
    List<LocalConversation> localConversations =
        await _conversationLocalSource.getLocalConversations();
    for (var localConversation in localConversations) {
      try {
        await _startAConversationRemotelyAndUpdateTheLocal(
          StartConversationRequest(
            userId: localConversation.userId,
          ),
        );
      } catch (e) {
        // if one conversation fails to be created remotely, its ok continue creating the others
        continue;
      }
    }
  }

  /// Sends unsent messages to the remote server.
  ///
  /// Retrieves a list of unsent messages using [_messageLocalSource.getUnSentMessages()]
  /// and attempts to send them to the remote server using [_messageRepository.sendLocalMessageToRemote()].
  ///
  /// Example usage:
  /// ```dart
  /// await _sendUnSentMessages();
  /// ```
  Future<void> _sendUnSentMessages() async {
    List<LocalMessage> localMessages =
        await _messageLocalSource.getUnSentMessages();
    for (var localMessage in localMessages) {
      //exclude multimedia messages from being sent
      //becuase they have to be sent exciplicitly by pressing upload
      if (localMessage.senderId == SharedPref.currentUserId &&
          await _multimediaLocalSource
                  .getMessageMultimedia(localMessage.localId) !=
              null) {
        continue;
        // LocalMultimedia? multimedia = await _multimediaLocalSource
        //     .getMessageMultimedia(localMessage.localId);
      }
      await _messageRepository.sendLocalMessageToRemote(localMessage);
    }
  }

  /// Inserts a local conversation from a remote source if it doesn't already exist locally.
  ///
  /// This method checks if a local conversation with the same remote ID and user ID
  /// already exists. If not, it inserts the conversation as a new local conversation based
  /// on the provided [remote] data by converting it to a local conversation.
  ///
  /// Returns the local ID of the inserted conversation if it was inserted or if it already
  /// exists locally, and `null` if there was an error during insertion.
  ///
  /// - [remote]: A [RemoteConversationModel] representing the conversation data from the remote source.
  ///
  Future<int?> _insertLocalConversationFromRemoteIfNotExists(
      RemoteConversationModel remote) async {
    LocalConversation? local = await _conversationLocalSource
        .getConversationWith(remote.id, remote.secondUser.id);
    if (local == null) {
      // print("Coversation Not Exists");
      try {
        int? c = await _conversationLocalSource
            .insertConversation(remote.toLocalConversation());
        await cofirmGotConversationData(remote.id);
        return c;
      } catch (e) {
        return null;
      }
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
}
