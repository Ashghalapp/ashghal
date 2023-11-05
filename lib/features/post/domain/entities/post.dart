import 'package:ashghal_app_frontend/features/post/data/models/multimedia_model.dart';
import 'package:equatable/equatable.dart';

import '../../../../app_library/public_entities/address.dart';

class Post extends Equatable {
  final int id;
  final String title;
  final String content;
  final DateTime expireDate;
  final bool allowComment;
  final bool isComplete;
  final bool isMarked;
  /// basic user data it come with the shape: {'id':..., 'name':..., 'image_url':...}
  final Map<String, Object?> basicUserData;
  int commentsCount;
  final Address? address;
  final List<MultimediaModel>? multimedia;
  // final int categoryId;
  final Map<String, Object?> categoryData;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.expireDate,
    required this.allowComment,
    required this.isComplete,
    required this.isMarked,
    required this.basicUserData,
    required this.commentsCount,
    this.address,
    this.multimedia,
    // required this.categoryId,
    required this.categoryData,
    required this.createdAt,
    required this.updatedAt,
  });
  // : expireDate = expireDate ??
  //           DateTime.now().add(const Duration(
  //               days: 30)), // Default value, one month from now,;
  //       createdAt = createdAt ?? DateTime.now(),
  //       updatedAt = updatedAt ?? DateTime.now();

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        expireDate,
        allowComment,
        isComplete,
        basicUserData,
        commentsCount,
        address,
        multimedia,
        // categoryId,
        categoryData,
        createdAt,
        updatedAt,
      ];
}
