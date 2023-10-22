import 'package:ashghal_app_frontend/features/chat/data/models/receive_read_message_model.dart';

class ReceiveReadConfirmationRequest {
  final List<ReceivedReadMessageModel> receivedReadMessages;

  ReceiveReadConfirmationRequest({required this.receivedReadMessages});

  Map<String, dynamic> toJson() {
    return {
      'confirm_messages': receivedReadMessages.map((e) => e.toJson()).toList()
    };
  }
}
