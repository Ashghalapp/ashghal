import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

abstract class VideoControllerService {
  Future<VideoPlayerController> getControllerForVideo(String url);
}

class CachedVideoControllerService extends VideoControllerService {
  final BaseCacheManager _cacheManager;

  CachedVideoControllerService(this._cacheManager);

  @override
  Future<VideoPlayerController> getControllerForVideo(String url) async {
    // if (await File(url).exists()) {
    //   print('[VideoControllerService]: Loading video from local device');
    //   return VideoPlayerController.file(File(url));
    // }
    final fileInfo = await _cacheManager.getFileFromCache(url);

    if (fileInfo == null) {
      print('[VideoControllerService]: No video in cache');
      try {
        _cacheManager.downloadFile(url, force: true);
        print('[VideoControllerService]: Saving video to cache');
      } catch (e) {
        print('Exception on saving to cache: ${e.toString()}');
      }

      return VideoPlayerController.networkUrl(Uri.parse(url));
    } else {
      print('[VideoControllerService]: Loading video from cache');
      return VideoPlayerController.file(fileInfo.file);
    }
  }
}
