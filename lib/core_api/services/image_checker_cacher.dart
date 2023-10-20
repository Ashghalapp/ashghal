import 'package:ashghal_app_frontend/core_api/dio_service.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImageCheckerAndCacher {
  DioService dio = DioService();

  Future<bool> filterValidImages(String url) async {
    return await dio.head(url);
  }

  Future<String?> loadImage(String imageUrl) async {
    try {
      if (!(await filterValidImages(imageUrl))) return null;
      DefaultCacheManager cacheManager = DefaultCacheManager();
      FileInfo? fileInfo = await cacheManager.getFileFromCache(imageUrl);
      if (fileInfo == null) {
        // Image is not cached, download and store it locally.
        await cacheManager.downloadFile(imageUrl, force: true);
        fileInfo = await cacheManager.getFileFromCache(imageUrl);
      }
      return fileInfo?.file.path;
    } catch (e) {
      print("::::::::: Error: $e");
      // AppUtil.showMessage(AppLocalization.thereIsSomethingError, Colors.green);
    }
    return null;
  }
}
