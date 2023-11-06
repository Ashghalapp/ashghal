import 'package:ashghal_app_frontend/core_api/dio_service.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImageCheckerAndCacher {
  DioService dio = DioService();

  Future<bool> filterValidImages(String url) async {
    return await dio.head(url);
  }

  Future<String?> loadImage(String imageUrl) async {
    try {
      DefaultCacheManager cacheManager = DefaultCacheManager();
      FileInfo? fileInfo = await cacheManager.getFileFromCache(imageUrl);
      if (fileInfo == null) {
        //check image validation
        if (!(await filterValidImages(imageUrl))) return null;
        // Image is not cached, download and store it locally.
        await cacheManager.downloadFile(imageUrl, force: true);
        fileInfo = await cacheManager.getFileFromCache(imageUrl);
        // Image.network(src)
      }
      return fileInfo?.file.path;
    } catch (e) {
      print("::::::::: Error: $e");
      // AppUtil.showMessage(AppLocalization.thereIsSomethingError, Colors.green);
    }
    return null;
  }
}
