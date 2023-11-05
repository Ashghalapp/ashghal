class BlockUnblockConversationRequest {
  final int conversationRemoteId;
  final bool block;

  BlockUnblockConversationRequest({
    required this.conversationRemoteId,
    required this.block,
  });

  Map<String, dynamic> toJson() {
    return {'conversation_id': conversationRemoteId};
  }
}
