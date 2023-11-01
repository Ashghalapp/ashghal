import '../../domain/entities/comment.dart';

class CommentModel extends Comment {
  const CommentModel({
    required super.id,
    required super.content,
    super.imageUrl,
    required super.parentPostId,
    required super.basicUserData,
    required super.repliesCount,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: int.parse(json['id'].toString()),
      content: json['content'].toString(),
      imageUrl: json['image_url'],
      parentPostId: int.parse(json['parent_post_id'].toString()),
      basicUserData: json['user'],
      repliesCount: int.parse(json['replies_count'].toString()),
      createdAt: DateTime.parse(json['updated_at'].toString()),
      updatedAt: DateTime.parse(json['created_at'].toString()),
    );
  }

  static List<CommentModel> fromJsonList(List<Map<String, dynamic>> json) {
    return json.map((reply) => CommentModel.fromJson(reply)).toList();
  }

  static copyWith(Comment comment){
    return CommentModel(
      id: comment.id,
      content: comment.content,
      parentPostId: comment.parentPostId,
      basicUserData: comment.basicUserData,
      repliesCount: comment.repliesCount,
      createdAt: comment.createdAt,
      updatedAt: comment.updatedAt,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'content': content,
      'image_url': imageUrl,
      'parent_post_id': parentPostId,
      'user': basicUserData,
      'replies_count': repliesCount,
      'updated_at': createdAt.toString(),
      'created_at': updatedAt.toString(),
    };
  }
}
