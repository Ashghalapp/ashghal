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
  final Function(int count, int total)? onSendProgress;
  SendMessageRequest._({
    required this.conversationId,
    this.body,
    this.filePath,
    this.onSendProgress,
  });

  factory SendMessageRequest.withBody({
    required int conversationId,
    required String body,
  }) =>
      SendMessageRequest._(
        conversationId: conversationId,
        body: body,
      );

  factory SendMessageRequest.withMultimedia(
          {required int conversationId,
          required String filePath,
          required Function(int count, int total)? onSendProgress}) =>
      SendMessageRequest._(
        conversationId: conversationId,
        filePath: filePath,
        onSendProgress: onSendProgress,
      );

  factory SendMessageRequest.withBodyAndMultimedia(
          {required int conversationId,
          required String body,
          required String filePath,
          required Function(int count, int total)? onSendProgress}) =>
      SendMessageRequest._(
        conversationId: conversationId,
        body: body,
        filePath: filePath,
        onSendProgress: onSendProgress,
      );

  Map<String, dynamic> toJson() {
    return {
      'conversation_id': conversationId,
      if (body != null) 'body': body,
      if (filePath != null)
        'multimedia': FormData.fromMap({
          'file': MultipartFile.fromFile(
            filePath!,
            filename: filePath!.split('/').last,
          )
        })
    };
  }

  MessagesCompanion toLocal() {
    return MessagesCompanion(
      conversationId: Value(conversationId),
      body: Value.ofNullable(body),
      senderId: Value(SharedPref.currentUserId!),
    );
  }

  MultimediaCompanion toLocalMultimedia(int messageId) {
    return MultimediaCompanion(
      type: Value(getFileType(filePath!)),
      path: Value(filePath),
      fileName: Value(filePath!.split('/').last),
      messageId: Value(messageId),
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
