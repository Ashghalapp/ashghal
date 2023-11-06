import '../../../../app_library/public_entities/address.dart';
import '../../domain/entities/post.dart';
import 'multimedia_model.dart';

class PostModel extends Post {
  PostModel({
    required super.id,
    required super.title,
    required super.content,
    required super.expireDate,
    required super.allowComment,
    required super.isComplete,
    required super.isMarked,
    required super.basicUserData,
    required super.commentsCount,
    super.address,
    super.multimedia,
    // required super.categoryId,
    required super.categoryData,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: int.parse(json['id'].toString()),
      title: json['title'],
      content: json['content'],
      expireDate: DateTime.parse(json['expire_date']),
      allowComment: json['allow_comment'],
      isComplete: json['is_complete'],
      isMarked: json['is_marked'],
      basicUserData: json['user'],
      commentsCount: int.parse(json['comments_count'].toString()),
      // categoryId: int.parse(json['category_id'].toString()),
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
      multimedia: json['multimedia'] != null? MultimediaModel.fromJsonList(json['multimedia']): null,
      categoryData: json['category'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  static List<PostModel> fromJsonList(List<Map<String, dynamic>> json){
    return json.map((post) => PostModel.fromJson(post)).toList();
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'expire_date': expireDate.toString(),
      'allow_comment': allowComment,
      'is_complete': isComplete,
      'is_marked' : isMarked,
      'user': basicUserData,
      'comments_count': commentsCount,
      // 'category_id': categoryId,
      'category': categoryData,
      'address': address?.toJson(),
      'multimedia': multimedia?.map((e) => e.toJson()).toList(),
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
    };
  }
}
