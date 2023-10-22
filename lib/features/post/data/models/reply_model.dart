import '../../domain/entities/reply.dart';

class ReplyModel extends Reply {
  const ReplyModel({
    required super.id,
    required super.parentCommentId,
    required super.content,
    super.imageUrl,
    required super.basicUserData,
    required super.replyToCommentId,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ReplyModel.fromJson(Map<String, dynamic> json) {
    return ReplyModel(
      id: int.parse(json['id'].toString()),
      content: json['content'].toString(),
      imageUrl: json['image_url'],
      parentCommentId: int.parse(json['parent_comment_id'].toString()),
      basicUserData: json['user'],
      replyToCommentId: json['reply_to_comment_id'],
      createdAt: DateTime.parse(json['updated_at'].toString()),
      updatedAt: DateTime.parse(json['created_at'].toString()),
    );
  }

  static List<ReplyModel> fromJsonList(List<Map<String, dynamic>> json){
    return json.map((reply) => ReplyModel.fromJson(reply)).toList();
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'content': content,
      'image_url': imageUrl,
      'parent_post_id': parentCommentId,
      'user': basicUserData,
      'reply_to_comment_id': replyToCommentId,
      'created_at': updatedAt.toString(),
      'updated_at': createdAt.toString(),
    };
  }
}
