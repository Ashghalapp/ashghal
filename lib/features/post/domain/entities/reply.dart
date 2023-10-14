import 'comment_abstract.dart';

class Reply extends CommentAbstract {
  final int parentCommentId;
  final int replyToCommentId;

  const Reply({
    required super.id,
    required this.parentCommentId,
    required super.content,
    super.imageUrl,
    required super.basicUserData,
    required this.replyToCommentId,
    required super.updatedAt,
    required super.createdAt,
    
  });
    // : createdAt = createdAt ?? DateTime.now(),
        // updatedAt = updatedAt ?? DateTime.now();

  @override
  List<Object?> get props => [
        id,
        parentCommentId,
        content,
        imageUrl,
        basicUserData,
        replyToCommentId,
        createdAt,
        updatedAt,
      ];
}
