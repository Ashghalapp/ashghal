// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:ashghal_app_frontend/core/services/app_services.dart';
import 'package:ashghal_app_frontend/core_api/users_state_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//Subscribes and no users there
// ?????????????????{auth: 481dbd40382f1648677d:d4ff53e32016a68de906a7040499c3590a6471d1fb631dbeeb9520318d24fde6, channel_data: {"user_id":"11","user_info":{"id":11,"name":"Mujahid Alhilaly"}}}??OK
// onSubscriptionSucceeded: presence-user.state.updated data: {presence: {count: 1, ids: [11], hash: {11: {id: 11.0, name: Mujahid Alhilaly}}}}
// ///////////////////My Idea Doesn't work/////////////////////////////
// channelName:presence-user.state.updated
// channelName:pusher:subscription_succeeded
// event:{presence: {count: 1, ids: [11], hash: {11: {id: 11.0, name: Mujahid Alhilaly}}}}

// Global onMemberAdded: presence-user.state.updated member: { userId: 12, userInfo: {"id":12.0,"name":"mujahid 2"} }
// Private OnMemeber Added { userId: 12, userInfo: {"id":12.0,"name":"mujahid 2"} }
// ///////////////////My Idea Doesn't work/////////////////////////////
// channelName:presence-user.state.updated
// channelName:pusher:member_added
// event:{"user_id":"12","user_info":{"id":12,"name":"mujahid 2"}}

//when subscribe an there are another users
// "user_info":{"id":12,"name":"mujahid 2"}}}??OK
// onSubscriptionSucceeded: presence-user.state.updated data: {presence: {count: 2, ids: [11, 12], hash: {11: {id: 11.0, name: Mujahid Alhilaly}, 12: {id: 12.0, name: mujahid 2}}}}
// ///////////////////My Idea Doesn't work/////////////////////////////
// channelName:presence-user.state.updated
// channelName:pusher:subscription_succeeded
// event:{presence: {count: 2, ids: [11, 12], hash: {11: {id: 11.0, name: Mujahid Alhilaly}, 12: {id: 12.0, name: mujahid 2}}}}

// onMemberRemoved: presence-user.state.updated member: { userId: 12, userInfo: {"id":12.0,"name":"mujahid 2"} }
// ///////////////////My Idea Doesn't work/////////////////////////////
// channelName:presence-user.state.updated
// channelName:pusher:member_removed
// event:{"user_id":"12"}

class UserStatusAvatar extends StatelessWidget {
  final int userId;
  final double radius;
  final Color activeColor;
  final Color unactiveColor;
  final Color borderColor;
  UserStatusAvatar({
    super.key,
    required this.userId,
    this.radius = 9,
    this.activeColor = Colors.blue,
    this.unactiveColor = Colors.grey,
    this.borderColor = Colors.white,
  });
  final UsersStateController _stateController = Get.find();

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: borderColor,
      child: Obx(
        () => CircleAvatar(
          radius: radius - 2,
          backgroundColor: _stateController.onlineUsersIds.contains(userId)
              ? activeColor
              : unactiveColor,
        ),
      ),
    );
  }
}
