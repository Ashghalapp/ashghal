import 'package:ashghal_app_frontend/core/localization/app_localization.dart';

enum Gender { male, female }

/// enum to present the status of comment to control the comment widgets easily
enum CommentStatus { sending, faild, recieved }

/// نوع بيانات يحتوي على العمليات التي يمكن عملها على البوست
enum OperationsOnPostPopupMenuValues { save, report, copy }

/// نوع بيانات يحتوي على العمليات التي يمكن عملها على التعليق
enum OperationsOnCommentPopupMenuValues { edit, delete, report }

/// نوع بيانات يحتوي على العمليات التي يمكن عملها على البوست التي نشرها المستخدم
enum OperationsOnCurrentUserPostPopupMenuValues { edit, delete }

// class AppDataTypees{
//   static
// }
Map<String, List<String>> allowedExtensionsByType = {
  'image': ['jpeg', 'jpg', 'png', 'gif', 'bmp', 'svg'],
  'file': ['pdf', 'txt', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx'],
  'video': ['mp4', 'avi', 'mov', 'wmv', 'flv', 'mkv'],
  'audio': ['mp3', 'wav', 'ogg', 'aac'],
  'archive': ['zip', 'rar', 'tar', 'gz', '7z'],
};

String getFileType(String fileName) {
  String extension = fileName.split('.').last;
  String type = "file";
  for (var entry in allowedExtensionsByType.entries) {
    if (entry.value.contains(extension)) {
      type = entry.key;
      break;
    }
  }
  return type;
}

enum MultimediaTypes { image, video, audio, file, archive }

extension MultimediaTypesExtension on MultimediaTypes {
  String get value {
    switch (this) {
      case MultimediaTypes.image:
        return AppLocalization.image;
      case MultimediaTypes.video:
        return AppLocalization.video;
      case MultimediaTypes.audio:
        return AppLocalization.audio;
      case MultimediaTypes.file:
        return AppLocalization.file;
      case MultimediaTypes.archive:
        return AppLocalization.archive;
    }
  }
}
