class GetUserRepliesOnCommentRequest {
  final int userId;
  final int commentId;

  GetUserRepliesOnCommentRequest({required this.userId, required this.commentId});

  Map<String, Object> toJson() {
    return {
      'user_id': userId,
      'comment_id': commentId,
    };
  }
}
