import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int id;
  final String title;
  final String content;
  final DateTime expireDate;
  final bool allowComment;
  final bool isComplete;
  final int userId;
  final int categoryId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String imageUrl;
  final String userName;
  Post({
    required this.id,
    required this.title,
    required this.userName,
    required this.content,
    DateTime? expireDate,
    DateTime? createdAt,
    this.allowComment = true,
    this.isComplete = false,
    required this.userId,
    required this.categoryId,
    required this.imageUrl,
    DateTime? updatedAt,
  })  : expireDate = expireDate ??
            DateTime.now().add(const Duration(
                days: 30)), // Default value, one month from now,;
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        expireDate,
        allowComment,
        isComplete,
        userId,
        categoryId,
        createdAt,
        updatedAt,
      ];
}
