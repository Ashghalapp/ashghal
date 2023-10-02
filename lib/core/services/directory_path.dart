import 'dart:io';

import 'package:path_provider/path_provider.dart';

class DirectoryPath {
  _getPath(String type) async {
    final Directory? tempDir = await getExternalStorageDirectory();
    final filePath = Directory("${tempDir!.path}/AshghalApp/media/$type");
    if (await filePath.exists()) {
      return filePath.path;
    } else {
      await filePath.create(recursive: true);
      return filePath.path;
    }
  }

  getFilesPath() async {
    return await _getPath("files");
  }

  getImagesPath() async {
    return await _getPath("images");
  }
}
