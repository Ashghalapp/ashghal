import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/inserting_message_controller.dart';

class SendButtonWidget extends StatelessWidget {
  final InsertingMessageController insertingMessageController;

  const SendButtonWidget({
    super.key,
    required this.insertingMessageController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
        right: 2,
        left: 2,
      ),
      child: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.blue,
        child: GetX<InsertingMessageController>(
          builder: (controller) {
            return IconButton(
              icon: Icon(
                controller.sendButtonEnabled.value ? Icons.send : Icons.mic,
                color: Colors.white,
              ),
              onPressed: insertingMessageController.sendMessage,
            );
          },
        ),
      ),
    );
  }
}
