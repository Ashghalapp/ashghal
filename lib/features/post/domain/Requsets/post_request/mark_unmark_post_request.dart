class MarkUnmarkPostRequest {
  final int postId;

  MarkUnmarkPostRequest({required this.postId});

  Map<String, Object> toJson() {
    return {
      'post_id': postId,
    };
  }
}
