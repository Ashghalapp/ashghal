import 'package:equatable/equatable.dart';

abstract class CommentAbstract extends Equatable{
  final int id;
  final String content;
  final String? imageUrl;
  /// basic user data it come with the shape: {'id':..., 'name':..., 'image_url':...}
  final Map<String, Object?> basicUserData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CommentAbstract({
    required this.id,
    required this.content,
    this.imageUrl,
    required this.basicUserData,
    required this.createdAt,
    required this.updatedAt,
  });
}