enum Gender { male, female }

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
  String extension = fileName.split('.').first;
  String type = "file";
  for (var entry in allowedExtensionsByType.entries) {
    if (entry.value.contains(extension)) {
      type = entry.key;
      break;
    }
  }
  return type;
}
