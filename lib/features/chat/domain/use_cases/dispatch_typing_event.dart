import 'package:ashghal_app_frontend/features/chat/domain/repositories/message_repository.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/dispatch_typing_event_request.dart';

class DispatchTypingEventUseCase {
  final MessageRepository repository;
  DispatchTypingEventUseCase({
    required this.repository,
  });

  Future<void> call(DispatchTypingEventRequest request) async {
    return await repository.dispatchTypingEvent(request);
  }
}
