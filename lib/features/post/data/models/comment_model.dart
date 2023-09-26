import '../../domain/entities/comment.dart';

class CommentModel extends Comment {
  const CommentModel({
    required super.id,
    required super.parentPostId,
    required super.content,
    super.imageUrl,
    required super.userId,
    required super.updatedAt,
    required super.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: int.parse(json['id'].toString()),
      parentPostId: int.parse(json['parent_post_id'].toString()),
      content: json['content'].toString(),
      imageUrl: json['image_url'],
      userId: int.parse(json['user_id'].toString()),
      updatedAt: DateTime.parse(json['created_at'].toString()),
      createdAt: DateTime.parse(json['updated_at'].toString()),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'parent_post_id': parentPostId,
      'content': content,
      'image_path': imageUrl,
      'user_id': userId,
      'updated_at': createdAt,
      'created_at': updatedAt,
    };
  }
}
