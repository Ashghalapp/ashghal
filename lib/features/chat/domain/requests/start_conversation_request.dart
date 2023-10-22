import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:moor_flutter/moor_flutter.dart';

class StartConversationRequest {
  final int userId;
  final String userName;
  final String? userEmail;
  final String? userPhone;
  final String? userImageUrl;

  StartConversationRequest({
    required this.userId,
    this.userName = "Unknown Name",
    this.userEmail,
    this.userPhone,
    this.userImageUrl,
  });

  Map<String, dynamic> toJson() => {
        "user_id": userId,
      };

  ConversationsCompanion toLocal() {
    return ConversationsCompanion(
      userId: Value(userId),
      userName: Value(userName),
      userEmail: Value(userEmail),
      userPhone: Value(userPhone),
      userImageUrl: Value(userImageUrl),
    );
  }
}
