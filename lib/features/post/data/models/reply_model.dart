import '../../domain/entities/reply.dart';

class ReplyModel extends Reply {
  const ReplyModel({
    required super.id,
    required super.parentCommentId,
    required super.content,
    super.imageUrl,
    required super.userId,
    required super.updatedAt,
    required super.createdAt,
  });

  factory ReplyModel.fromJson(Map<String, dynamic> json) {
    return ReplyModel(
      id: int.parse(json['id'].toString()),
      parentCommentId: int.parse(json['parent_comment_id'].toString()),
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
      'parent_post_id': parentCommentId,
      'content': content,
      'image_path': imageUrl,
      'user_id': userId,
      'updated_at': createdAt,
      'created_at': updatedAt,
    };
  }
}
