import 'dart:convert';

import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/services/app_services.dart';
import 'package:ashghal_app_frontend/core_api/pusher_service.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/receive_read_message_model.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/remote_message_model.dart';
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
  PusherChatHelper();
  Future<void> connect() async {
    await AppServices.pusher.connect();
  }

// ReceivedReadMessageModel
  Future<void> subscribeToChatChannels({
    required int conversationRemoteId,
    required Function(RemoteMessageModel message) onNewMessage,
    required Function(ReceivedReadMessageModel receivedReadMessage)
        onMessageReceived,
    required Function(ReceivedReadMessageModel receivedReadMessage)
        onMessageRead,
  }) async {
    String chanelName = 'private-chat.$conversationRemoteId';

    //message sent event
    Channelhandler handler = Channelhandler(
      channel: AppChannel(
        channelName: chanelName,
        eventName: 'message.sent',
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
        channelName: chanelName,
        eventName: 'message.received',
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
        channelName: chanelName,
        eventName: 'message.read',
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
    // await AppServices.pusher.subscribeToChannel(chanelName);
    // subscribedChannels.add(chanelName);

    await AppServices.pusher.subscribeToChannel(chanelName);
    if (!subscribedChannels.contains(chanelName)) {
      subscribedChannels.add(chanelName);
    }
  }

  Future<void> unsubscribeFromChannels() async {
    for (var channelName in subscribedChannels) {
      await AppServices.pusher.unsubscribeFromChannel(channelName);
    }
  }
}
