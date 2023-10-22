class DeleteConversationRequest {
  final int conversationRemoteId;

  DeleteConversationRequest({required this.conversationRemoteId});

  Map<String, dynamic> toJson() {
    return {'conversation_id': conversationRemoteId};
  }
}
