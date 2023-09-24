class DeleteConversationRequest {
  final int conversationLocalId;

  DeleteConversationRequest({required this.conversationLocalId});

  Map<String, dynamic> toJson() {
    return {'conversation_id': conversationLocalId};
  }
}
