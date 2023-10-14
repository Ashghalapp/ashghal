import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final int id;
  final String content;
  final String? imagePath;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Comment({
    required this.id,
    required this.content,
    this.imagePath,
    required this.userId,
    DateTime? updatedAt,
    DateTime? createdAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  @override
  List<Object?> get props => [
        id,
        content,
        imagePath,
        userId,
        createdAt,
        updatedAt,
      ];
}
