import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/message_and_multimedia.dart';

class MessageAndMultimediaModel extends MessageAndMultimedia {
  const MessageAndMultimediaModel({
    required super.message,
    super.multimedia,
  });

  MessageAndMultimediaModel copyWith(
      {LocalMessage? message, LocalMultimedia? multimedia}) {
    return MessageAndMultimediaModel(
      message: message ?? this.message,
      multimedia: multimedia ?? this.multimedia,
    );
  }
}
