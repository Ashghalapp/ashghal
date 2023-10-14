class GetUserCommentsOnPostRequest {
  final int userId;
  final int postId;

  GetUserCommentsOnPostRequest({required this.postId, required this.userId});

  Map<String, Object> toJson() {
    return {
      'user_id': userId,
      'post_id': postId,
    };
  }
}
