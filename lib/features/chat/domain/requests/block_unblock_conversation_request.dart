class BlockUnblockConversationRequest {
  final int conversationId;
  final bool block;

  BlockUnblockConversationRequest({
    required this.conversationId,
    required this.block,
  });

  Map<String, dynamic> toJson() {
    return {'conversation_id': conversationId};
  }
}
