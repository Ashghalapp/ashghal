import 'package:dio/dio.dart';

import '../../../../../app_library/public_entities/address.dart';

/// كلاس اساسي يحتوي على الخصائص المشتركة في طلبات الاضافة والتعديل للبوست
abstract class _AddUpdatePostRequestAbstract {
  final String? title;
  final String? content;

  /// the expiredate value is month after current timestamp by default
  final DateTime? expireDate;
  final int? categoryId;

  /// the allowComment value is true by default
  final bool? allowComment;

  /// the isComplete value is false by default
  final bool? isComplete;
  final Address? address;
  final List<String>? multimediaPaths;

  _AddUpdatePostRequestAbstract({
    this.title,
    this.content,
    this.categoryId,
    this.allowComment,
    this.expireDate,
    this.isComplete,
    this.address,
    this.multimediaPaths,
  });

  /// Map ارجاع البيانات على شكل 
  Map<String, Object?> getDataAsMap() {
    return {
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (categoryId != null) 'category_id': categoryId,
      if (allowComment != null) 'allow_comment': allowComment,
      if (expireDate != null) 'expire_date': expireDate.toString(),
      if (isComplete != null) 'is_complete': isComplete,
      if (address != null) 'address': address?.toJson(),
    };
  }
}

/// request that use to add new post
class AddPostRequest extends _AddUpdatePostRequestAbstract {
  AddPostRequest({
    required super.title,
    required super.content,
    required super.categoryId,
    super.expireDate,
    super.allowComment,
    super.isComplete,
    super.address,
    super.multimediaPaths,
  });

  /// return data as FormData object to send multimedia
  Future<FormData> toJson() async {
    List<MultipartFile> multimedia = [];
    if (multimediaPaths != null) {
      print(":::::::::The paths of multimedia are: $multimediaPaths");
      for (var path in multimediaPaths ?? []) {
        multimedia.add(await MultipartFile.fromFile(path));
      }
    }
    return FormData.fromMap({
      ...(super.getDataAsMap()),
      if (multimedia.isNotEmpty) 'multimedia': multimedia,
    }, ListFormat.multiCompatible);
  }
}

/// request that use to update post
class UpdatePostRequest extends _AddUpdatePostRequestAbstract {
  final int postId;
  UpdatePostRequest({
    required this.postId,
    super.title,
    super.content,
    super.categoryId,
    super.expireDate,
    super.allowComment,
    super.isComplete,
    super.address,
    super.multimediaPaths,
  });

  /// return data as FormData object to send multimedia
  Future<FormData> toJson() async {
    List<MultipartFile> multimedia = [];
    if (multimediaPaths != null) {
      print(":::::::::The paths of multimedia are: $multimediaPaths");
      for (var path in multimediaPaths ?? []) {
        multimedia.add(await MultipartFile.fromFile(path));
      }
    }

    return FormData.fromMap({
      'post_id': postId,
      ...(super.getDataAsMap()),
      if (multimedia.isNotEmpty) 'multimedia': multimedia,
    }, ListFormat.multiCompatible);
  }
}
