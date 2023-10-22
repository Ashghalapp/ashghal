import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:equatable/equatable.dart';

class ConversationlastMessageAndCount extends Equatable {
  final LocalMessage lastMessage;
  final int newMessagesCount;
  const ConversationlastMessageAndCount({
    required this.lastMessage,
    required this.newMessagesCount,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        lastMessage,
        newMessagesCount,
      ];
}
