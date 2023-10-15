import 'package:ashghal_app_frontend/features/chat/presentation/getx/inserting_message_controller.dart';

class DispatchTypingEventRequest {
  final int conversationId;
  final TypingEventType eventType;

  DispatchTypingEventRequest({
    required this.conversationId,
    required this.eventType,
  });
}
