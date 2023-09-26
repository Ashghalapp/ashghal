import 'comment_abstract.dart';

class Reply extends CommentAbstract {
  final int parentCommentId;

  const Reply({
    required super.id,
    required this.parentCommentId,
    required super.content,
    super.imageUrl,
    required super.userId,
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
        userId,
        createdAt,
        updatedAt,
      ];
}
