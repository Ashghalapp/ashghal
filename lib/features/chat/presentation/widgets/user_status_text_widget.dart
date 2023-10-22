import 'package:ashghal_app_frontend/core_api/users_state_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserStatusTextWidget extends StatelessWidget {
  final int userId;
  final double radius;
  final Color onlineColor;
  final Color offlineColor;
  final double fontSize;
  UserStatusTextWidget({
    super.key,
    required this.userId,
    this.radius = 9,
    this.onlineColor = Colors.blue,
    this.offlineColor = Colors.grey,
    this.fontSize = 15,
  });
  final UsersStateController _stateController = Get.find();
  final ChatController _chatController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Text(
          _chatController.typingUsers.contains(userId)
              ? "Typing Now..."
              : _stateController.onlineUsersIds.contains(userId)
                  ? "Online"
                  : "Offline",
          style: TextStyle(
            color: _stateController.onlineUsersIds.contains(userId)
                ? onlineColor
                : offlineColor,
            fontSize: fontSize,
          ),
        ));
  }
}
