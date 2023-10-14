class UpdateCommentOrReplyRequest {
  final int id;
  final String content;
  final String? imagePath;

  UpdateCommentOrReplyRequest({
    required this.id,
    required this.content,
    this.imagePath,
  });

  /// Map ارجاع البيانات على شكل
  Map<String, Object?> toJson() {
    return {
      'comment_id': id,
      'content': content,
      if (imagePath != null) 'image': imagePath,
    };
  }
}
