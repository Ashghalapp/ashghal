import 'dart:io';

import 'package:ashghal_app_frontend/app_library/app_data_types.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:dio/dio.dart';
import 'package:moor_flutter/moor_flutter.dart';

class SendMessageRequest {
  final int conversationId;
  final String? body;
  final String? filePath;
  final CancelToken? cancelToken;
  final Function(int count, int total)? onSendProgress;
  SendMessageRequest._({
    required this.conversationId,
    this.body,
    this.filePath,
    this.onSendProgress,
    this.cancelToken,
  });

  factory SendMessageRequest.withBody({
    required int conversationId,
    required String body,
  }) =>
      SendMessageRequest._(
        conversationId: conversationId,
        body: body,
      );

  factory SendMessageRequest.withMultimedia({
    required int conversationId,
    required String filePath,
    required Function(int count, int total)? onSendProgress,
    required CancelToken? cancelToken,
  }) =>
      SendMessageRequest._(
        conversationId: conversationId,
        filePath: filePath,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );

  factory SendMessageRequest.withBodyAndMultimedia({
    required int conversationId,
    required String body,
    required String filePath,
    required Function(int count, int total)? onSendProgress,
    required CancelToken? cancelToken,
  }) =>
      SendMessageRequest._(
        conversationId: conversationId,
        body: body,
        filePath: filePath,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );

  dynamic toJson() async {
    if (filePath != null) {
      return FormData.fromMap({
        'conversation_id': conversationId,
        if (body != null && body!.trim() != "") 'body': body,
        'file': await MultipartFile.fromFile(
          filePath!,
          // filename: filePath!.split('/').last,
        ),
      }, ListFormat.multiCompatible);

      ///data/user/0/com.example.ashghal_app_frontend/cache/01340b7f-c8c8-4b71-a5ca-c31888a7b242/IMG_20230622_025742.jpg
    }
    return {
      'conversation_id': conversationId,
      if (body != null && body!.trim() != "") 'body': body,
    };
  }

  MessagesCompanion toLocal() {
    return MessagesCompanion(
      conversationId: Value(conversationId),
      body: Value(body),
      senderId: Value(SharedPref.currentUserId!),
    );
  }

  MultimediaCompanion toLocalMultimediaOnInsert(int messageId) {
    return MultimediaCompanion(
      messageId: Value(messageId),
      type: Value(getFileType(filePath!)),
      path: Value(filePath),
      fileName: Value(filePath!.split('/').last),
    );
  }

  SendMessageRequest copyWith({
    int? conversationId,
    String? body,
    String? filePath,
  }) {
    return SendMessageRequest._(
      conversationId: conversationId ?? this.conversationId,
      body: body ?? this.body,
      filePath: filePath ?? this.filePath,
    );
  }
}
