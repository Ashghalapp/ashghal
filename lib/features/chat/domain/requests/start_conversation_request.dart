import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:moor_flutter/moor_flutter.dart';

class StartConversationRequest {
  final int userId;
  final String userName;

  StartConversationRequest({
    required this.userId,
    this.userName = "Unknown Name",
  });

  Map<String, dynamic> toJson() => {
        "user_id": userId,
      };

  ConversationsCompanion toLocal() {
    return ConversationsCompanion(
      userName: Value(userName),
      userId: Value(userId),
    );
  }
}
