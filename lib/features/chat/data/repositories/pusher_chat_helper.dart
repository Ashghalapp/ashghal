import 'dart:convert';

import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/services/app_services.dart';
import 'package:ashghal_app_frontend/core_api/api_constant.dart';
import 'package:ashghal_app_frontend/core_api/pusher_service.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/receive_read_message_model.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/remote_conversation_model.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/remote_message_model.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/inserting_message_controller.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

// enum ChatChannelTypes{
//   newMessage,
//   messageReceived,
//   messageRead,
// }
// Map<ChatChannelTypes,AppChannel> chatChannels ={
//     ChatChannelTypes.newMessage:AppChannel(channelName: "private-chat")
// }

class PusherChatHelper {
  List<String> subscribedChannels = [];
  static PusherChatHelper? _instance;
  PusherChatHelper._();
  factory PusherChatHelper() {
    _instance ??= PusherChatHelper._();
    return _instance!;
  }
  Future<void> connect() async {
    await AppServices.pusher.connect();
  }

// ReceivedReadMessageModel
  Future<void> subscribeToChatChannels({
    required int conversationRemoteId,
    required Function(RemoteMessageModel message) onNewMessage,
    // required void Function(RemoteConversationModel remoteConversation)
    //     onNewMessageUnknownConversation,
    required Function(ReceivedReadMessageModel receivedReadMessage)
        onMessageReceived,
    required Function(ReceivedReadMessageModel receivedReadMessage)
        onMessageRead,
    required void Function(TypingEventType eventType, int userId) onTypingEvent,
  }) async {
    String chatChannelName =
        '${ChannelsEventsNames.chatChannelName}$conversationRemoteId';

    //message sent event
    Channelhandler handler = Channelhandler(
      channel: AppChannel(
        channelName: chatChannelName,
        eventName: ChannelsEventsNames.messageSentEventName,
      ),
      onEvent: (PusherEvent event) async {
        print("Pusher event received: $event");
        dynamic data = json.decode(event.data);
        if (int.parse(data['broadcasted_by'].toString()) !=
            SharedPref.currentUserId) {
          RemoteMessageModel message =
              RemoteMessageModel.fromJson(data['message']);
          onNewMessage(message);
        }
      },
    );
    AppServices.pusher.addNewChannelHandler(handler);

    //message received event
    handler = Channelhandler(
      channel: AppChannel(
        channelName: chatChannelName,
        eventName: ChannelsEventsNames.messageReceivedEventName,
      ),
      onEvent: (PusherEvent event) async {
        print("Pusher event received: $event");
        dynamic data = json.decode(event.data);
        if (int.parse(data['broadcasted_by'].toString()) !=
            SharedPref.currentUserId) {
          ReceivedReadMessageModel receivedReadMessage =
              ReceivedReadMessageModel.fromJson(data['message']);
          print(receivedReadMessage.toString());
          onMessageReceived(receivedReadMessage);
        }
      },
    );

    AppServices.pusher.addNewChannelHandler(handler);

    //message read event
    handler = Channelhandler(
      channel: AppChannel(
        channelName: chatChannelName,
        eventName: ChannelsEventsNames.messageReadEventName,
      ),
      onEvent: (PusherEvent event) async {
        print("Pusher event received: $event");
        dynamic data = json.decode(event.data);
        if (int.parse(data['broadcasted_by'].toString()) !=
            SharedPref.currentUserId) {
          ReceivedReadMessageModel receivedReadMessage =
              ReceivedReadMessageModel.fromJson(data['message']);
          print(receivedReadMessage.toString());
          onMessageRead(receivedReadMessage);
        }
      },
    );

    AppServices.pusher.addNewChannelHandler(handler);

    //Typing event
    handler = Channelhandler(
      channel: AppChannel(
        channelName: chatChannelName,
        eventName: ChannelsEventsNames.typingEventName,
      ),
      onEvent: (PusherEvent event) async {
        print("Pusher event received: $event");
        dynamic data = json.decode(event.data);
        // if (int.parse(data['broadcasted_by'].toString()) !=
        //     SharedPref.currentUserId) {
        int userId = int.parse(data['user_id'].toString());
        print("user_id: $userId");
        bool isTyping = bool.parse(data['is_typing'].toString());
        print("isTyping: $isTyping");
        onTypingEvent(
          isTyping ? TypingEventType.start : TypingEventType.stop,
          userId,
        );
        // ReceivedReadMessageModel receivedReadMessage =
        //     ReceivedReadMessageModel.fromJson(data['message']);
        // print(receivedReadMessage.toString());
        // onMessageRead(receivedReadMessage);
        // }
      },
    );

    AppServices.pusher.addNewChannelHandler(handler);
    // await AppServices.pusher.subscribeToChannel(chanelName);
    // subscribedChannels.add(chanelName);

    await AppServices.pusher.subscribeToChannel(chatChannelName);
    if (!subscribedChannels.contains(chatChannelName)) {
      subscribedChannels.add(chatChannelName);
    }
  }

  Future<void> subscribeToUserChannels({
    required void Function(RemoteConversationModel remoteConversation)
        onNewMessageUnknownConversation,
  }) async {
    String userChannelName =
        '${ChannelsEventsNames.userChannelName}${SharedPref.currentUserId}';

    //message sent on unknown conversation
    Channelhandler handler = Channelhandler(
      channel: AppChannel(
        channelName: userChannelName,
        eventName: ChannelsEventsNames.newMessageUnknownConversationEvent,
      ),
      onEvent: (PusherEvent event) async {
        print("Pusher event received: $event");
        dynamic data = json.decode(event.data);
        RemoteConversationModel conversation = RemoteConversationModel.fromJson(
          data['conversation'],
        );
        onNewMessageUnknownConversation(conversation);
      },
    );
    AppServices.pusher.addNewChannelHandler(handler);
    await AppServices.pusher.subscribeToChannel(userChannelName);
    print("Subscribe to user channel ok");
    if (!subscribedChannels.contains(userChannelName)) {
      subscribedChannels.add(userChannelName);
    }
  }

  Future<void> dispatchTypingEvent(
      int conversationId, TypingEventType eventType) async {
    print("dispatchTypingEvent$conversationId");
    String channelName =
        "${ChannelsEventsNames.chatChannelName}$conversationId";
    if (subscribedChannels.contains(channelName)) {
      Map<String, Object?> data = {
        'user_id': SharedPref.currentUserId,
        'is_typing': eventType == TypingEventType.start ? true : false,
      };
      await AppServices.pusher.triggerEvent(
        channelName: channelName,
        eventName: ChannelsEventsNames.typingEventName,
        eventData: data,
      );
    }
  }

// // ReceivedReadMessageModel
//   Future<void> subscribeOnlineChannel(
//       // {
//       // required int conversationRemoteId,
//       // required Function(RemoteMessageModel message) onNewMessage,
//       // required Function(ReceivedReadMessageModel receivedReadMessage)
//       // onMessageReceived,
//       // required Function(ReceivedReadMessageModel receivedReadMessage)
//       // onMessageRead,
//       // }
//       ) async {
//     String chanelName = 'presence-user.state.updated';

//     //message sent event
//     Channelhandler handler = Channelhandler(
//       channel: AppChannel(
//         channelName: chanelName,
//         eventName: 'user.state.updated.event',
//       ),
//       onEvent: (PusherEvent event) async {
//         print("Pusher user state updated event received: $event");
//         // dynamic data = json.decode(event.data);
//       },
//     );
//     AppServices.pusher.addNewChannelHandler(handler);

//     await AppServices.pusher.subscribeToChannel(chanelName);
//     if (!subscribedChannels.contains(chanelName)) {
//       subscribedChannels.add(chanelName);
//     }
//     // await AppServices.pusher.triggerEvent(PusherEvent(
//     //     channelName: chanelName,
//     //     eventName: "user.state.updated.event",
//     //     data: {"user_id": 15}));
//   }

  Future<void> unsubscribeFromChannels() async {
    for (var channelName in subscribedChannels) {
      await AppServices.pusher.unsubscribeFromChannel(channelName);
      print("unsubscribed from channel $channelName");
    }
    subscribedChannels.clear();
  }

  Future<void> unsubscribeFromConversationChannel(
      int conversationRemoteId) async {
    String chatChannelName =
        '${ChannelsEventsNames.chatChannelName}$conversationRemoteId';
    if (subscribedChannels.contains(chatChannelName)) {
      await AppServices.pusher.unsubscribeFromChannel(chatChannelName);
      subscribedChannels.remove(chatChannelName);
      print("Unsubscribe from chat $conversationRemoteId channel finished");
    }
  }
}
