// import 'dart:io';

// import 'package:ashghal_app_frontend/core/services/video_controller_service.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:get/get.dart';
// import 'package:video_player/video_player.dart';

// class VideoController extends GetxController {
//   // Observables to track the video state
//   final _isVideoPlaying = false.obs;
//   // final isUploading = false.obs;
//   RxBool isLoading = false.obs;

//   // Track the ID of the current video being played
//   final _currentId = 999999.obs;

//   // Observables to track the start and end time for video duration calculation
//   // final start = DateTime.now().obs;
//   // final end = DateTime.now().obs;

//   // String to store the formatted total video duration
//   // String _total = "";
//   // String get total => _total;

//   // Variables to store the completed percentage and current/total duration
//   // double completedPercentage = 0.0;
//   // int currentDuration = 0;
//   // int totalDuration = 0;

//   final CachedVideoControllerService _videoControllerService =
//       CachedVideoControllerService(DefaultCacheManager());

//   // Getter to check if a video is currently playing
//   bool get isVideoPlaying => _isVideoPlaying.value;

//   // Video player controller
//   VideoPlayerController _videoPlayerController =
//       VideoPlayerController.file(File("No-File"));

//   VideoPlayerController get videoPlayerController => _videoPlayerController;
//   // Getter for the current video ID
//   int get currentId => _currentId.value;

//   @override
//   void onInit() {
//     super.onInit();
//   }

//   @override
//   void onClose() {
//     // Dispose of the video player controller when closing the controller
//     _videoPlayerController.dispose();
//     super.onClose();
//   }

//   // Handle the play/pause button click for a video
//   // Future<void> onPressedPlayButton(int id, String path) async {
//   //   _currentId.value = id;
//   //   if (isVideoPlaying) {
//   //     // await _pauseVideo();
//   //   } else {
//   //     await _playVideo(path);
//   //   }
//   // }

//   Future<void> initializeVideoPlayer(
//       {required int id, String? path, String? url, bool isMine = false}) async {
//     // try {} catch (e) {}
//     _currentId.value = id;
//     isLoading.value = true;

//     if (_videoPlayerController.value.isInitialized) {
//       await _videoPlayerController.dispose();
//     }
//     if (path != null && await File(path).exists()) {
//       print("File Video");
//       _videoPlayerController = VideoPlayerController.file(File(path));
//     } else if (url != null && !isMine) {
//       print("Url Video");
//       _videoPlayerController =
//           await _videoControllerService.getControllerForVideo(url!);
//     } else {
//       throw Exception("Failed to play/download the video");
//     }
//     print("before initializing");
//     await _videoPlayerController.initialize().then((_) {}, onError: (error) {
//       print(
//           "****************************************************////////////////////****************");
//       print('Error: ${_videoPlayerController.value.errorDescription}');
//       print('Error: ${error.toString()}');
//     });
//     isLoading.value = false;
//     // isInitialized.value = true;
//     // videoPlayerController.pause();
//   }

//   // Calculate the duration of the video playback
//   // void calcDuration() {
//   //   final a = end.value.difference(start.value).inSeconds;
//   //   _total = Duration(seconds: a).toString().split('.').first.padLeft(8, "0");
//   // }

//   // Pause the video playback
//   // Future<void> _pauseVideo() async {
//   //   _isVideoPlaying.value = false;
//   //   await _videoPlayerController.pause();
//   // }

//   // Play a video
//   // Future<void> _playVideo(String path) async {
//   //   _isVideoPlaying.value = true;
//   //   await _videoPlayerController.initialize();
//   //   await _videoPlayerController.play();
//   // }

//   // Start the video upload process
//   void startUpload() {
//     // Implement video upload logic here
//     // Set isUploading.value to true during the upload process
//   }

//   // Stop the video upload process
//   void stopUpload() {
//     // Implement logic to stop the video upload if needed
//     // Set isUploading.value to false after upload is complete or canceled
//   }
// }
