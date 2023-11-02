import 'dart:io';

import 'package:ashghal_app_frontend/app_library/app_data_types.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:dio/dio.dart';
import 'package:moor_flutter/moor_flutter.dart';

class DownloadRequest {
  final String url;
  final String savePath;
  final int multimediaLocalId;
  final int messageLocalId;
  final CancelToken? cancelToken;
  final Function(int count, int total)? onReceiveProgress;
  DownloadRequest({
    required this.url,
    required this.savePath,
    required this.multimediaLocalId,
    required this.messageLocalId,
    this.onReceiveProgress,
    this.cancelToken,
  });

  MultimediaCompanion toLocalOnDownload() {
    return MultimediaCompanion(
      path: Value(savePath),
      updatedAt: Value(DateTime.now()),
    );
  }
}
