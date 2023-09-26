import 'package:equatable/equatable.dart';

abstract class CommentAbstract extends Equatable{
  final int id;
  final String content;
  final String? imageUrl;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CommentAbstract({
    required this.id,
    required this.content,
    this.imageUrl,
    required this.userId,
    required this.updatedAt,
    required this.createdAt,
  });
}