class ConfirmGotConversationDataRequest {
  final int conversationRemoteId;

  ConfirmGotConversationDataRequest({required this.conversationRemoteId});

  Map<String, dynamic> toJson() {
    return {'conversation_id': conversationRemoteId};
  }
}
