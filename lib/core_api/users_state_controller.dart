import 'dart:async';

import 'package:ashghal_app_frontend/app_live_cycle_controller.dart';
import 'package:ashghal_app_frontend/core/helper/app_print_class.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/services/app_services.dart';
import 'package:ashghal_app_frontend/core_api/api_constant.dart';
import 'package:ashghal_app_frontend/core_api/network_info/network_info.dart';
import 'package:ashghal_app_frontend/core_api/pusher_service.dart';
import 'package:get/get.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class UsersStateController extends GetxController {
  RxList<int> onlineUsersIds = <int>[].obs;
  bool isSubscribed = false;
  AppLifeCycleController lifeCycleController = Get.find();
  final StreamController<List<int>> _onlineUsersController =
      StreamController<List<int>>.broadcast();
  Stream<List<int>> get onlineUsersStream => _onlineUsersController.stream;

  @override
  void onInit() {
    onlineUsersIds.listen((onlineIds) {
      _onlineUsersController.add(onlineIds);
    });
    super.onInit();
    _checkUserFirstEnter();
    lifeCycleController.isAppResumed.listen((value) async {
      if (!isSubscribed && value) {
        await subscribeToOnlineUsersChannel();
      } else if (isSubscribed && !value) {
        await unsubscribeFromOnlineUsersChannel();
      }
      AppPrint.printInfo(
          "Listener on UsersStateController got isAppResumed:$value");
    });
    AppServices.networkInfo.onStatusChanged.listen((isConnected) async {
      if (isConnected) {
        // if(!isSubscribed){
        // if(!isSubscribed){
        await subscribeToOnlineUsersChannel();
        // }
        // }
      } else {
        await unsubscribeFromOnlineUsersChannel();
      }
    });
  }

  void addMember(int memberId) {
    if (!onlineUsersIds.contains(memberId) &&
        memberId != SharedPref.currentUserId) {
      onlineUsersIds.add(memberId);
    }
  }

  Future<void> subscribeToOnlineUsersChannel() async {
    if (!await NetworkInfoImpl().isConnected &&
        SharedPref.currentUserId != null) {
      return;
    }
    // await AppServices.pusher.initializePusher();
    // AppServices.pusher.subscribeToChannel(channelName)
    //message read event
    Channelhandler handler = Channelhandler(
      channel: AppChannel(
        channelName: ChannelsEventsNames.userStateUpdatedChannel,
        eventName: ChannelsEventsNames.userStateUpdatedEvent,
      ),
      onEvent: (PusherEvent event) async {
        print("Pusher event received: $event");
        // dynamic data = json.decode(event.data);
        // print(data);
        // if (int.parse(data['broadcasted_by'].toString()) !=
        //     SharedPref.currentUserId) {
        //   ReceivedReadMessageModel receivedReadMessage =
        //       ReceivedReadMessageModel.fromJson(data['message']);
        //   print(receivedReadMessage.toString());
        //   // onMessageRead(receivedReadMessage);
        // }
      },
      onSubscriptionSucceeded: (membersIds) {
        for (var memberId in membersIds) {
          addMember(memberId);
        }
        isSubscribed = true;
        print(SharedPref.currentUserId);
        print(
            "<><><><>><><><><> My onSubscriptionSucceeded works ${onlineUsersIds.length} -- ${onlineUsersIds}");
      },
      onMemeberAdded: (memberId) {
        addMember(memberId);
        print(
            "<><><><>><><><><> My onMemeberAdded works ${onlineUsersIds.length} -- ${onlineUsersIds}");
      },
      onMemeberRemoved: (memberId) {
        onlineUsersIds.remove(memberId);
        print(
            "<><><><>><><><><> My onMemeberRemoved works ${onlineUsersIds.length} -- ${onlineUsersIds}");
      },
    );

    AppServices.pusher.addNewChannelHandler(handler);

    await AppServices.pusher
        .subscribeToChannel(ChannelsEventsNames.userStateUpdatedChannel);
    // await AppServices.pusher.connect();
  }

  Future<void> unsubscribeFromOnlineUsersChannel() async {
    await AppServices.pusher
        .unsubscribeFromChannel(ChannelsEventsNames.userStateUpdatedChannel);
    isSubscribed = false;
  }

  @override
  void onClose() {
    unsubscribeFromOnlineUsersChannel();
    super.onClose();
  }

  void _checkUserFirstEnter() async {
    if (SharedPref.isUserFirstOpen != null && SharedPref.isUserFirstOpen!) {
      SharedPref.setUserFirstOpenAfterLogin(false);
      await subscribeToOnlineUsersChannel();
    }
  }
}
