import 'comment_abstract.dart';

class Comment extends CommentAbstract {
  final int parentPostId;

  const Comment({
    required super.id,
    required this.parentPostId,
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
        parentPostId,
        content,
        imageUrl,
        userId,
        createdAt,
        updatedAt,
      ];
}
