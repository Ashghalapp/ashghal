import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:equatable/equatable.dart';

class MessageAndMultimedia extends Equatable {
  final LocalMessage message;
  final LocalMultimedia? multimedia;
  const MessageAndMultimedia({
    required this.message,
    this.multimedia,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        message,
        multimedia,
      ];
}
