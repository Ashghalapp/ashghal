import 'comment_abstract.dart';

class Comment extends CommentAbstract {
  final int parentPostId;
  final int repliesCount;

  const Comment({
    required super.id,
    required this.parentPostId,
    required super.content,
    super.imageUrl,
    required this.repliesCount,
    required super.basicUserData,
    required super.createdAt,
    required super.updatedAt,
  });
    // : createdAt = createdAt ?? DateTime.now(),
        // updatedAt = updatedAt ?? DateTime.now();

  @override
  List<Object?> get props => [
        id,
        parentPostId,
        content,
        imageUrl,
        basicUserData,
        repliesCount,
        createdAt,
        updatedAt,
      ];
}
