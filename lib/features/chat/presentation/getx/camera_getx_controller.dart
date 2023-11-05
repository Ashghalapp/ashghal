// import 'package:ashghal/model/multimedea_model.dart';

import 'package:ashghal_app_frontend/core/services/app_services.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/sending_image_view_page.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/sending_video_view_page.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';

class CameraGetxController extends GetxController {
  late CameraController cameraController;
  late Future<void> cameraValue;
  RxBool isFlashOn = false.obs;
  RxBool isCameraFront = true.obs;
  RxBool isRecording = false.obs;
  // RxList<String> paths = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameraController =
        CameraController(AppServices.cameras[0], ResolutionPreset.max);
    try {
      cameraValue = cameraController.initialize();
    } catch (e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    }
  }

  void toggleFlash() {
    isFlashOn.value = !isFlashOn.value;

    isFlashOn.value
        ? cameraController.setFlashMode(FlashMode.torch)
        : cameraController.setFlashMode(FlashMode.off);
  }

  void toggleCameraFront() {
    isCameraFront.value = !isCameraFront.value;

    int cameraPos = isCameraFront.value ? 0 : 1;
    cameraController = CameraController(
      AppServices.cameras[cameraPos],
      ResolutionPreset.high,
    );
    cameraValue = cameraController.initialize();
  }

  void takePhoto() async {
    XFile file = await cameraController.takePicture();
    if (isFlashOn.value) toggleFlash();
    Get.off<List<String>>(() => SendingImageViewPage(paths: [file.path]));
  }

  Future<void> startVideoRecording() async {
    await cameraController.startVideoRecording();
    isRecording.value = true;
  }

  Future<void> stopVideoRecording() async {
    XFile videoPath = await cameraController.stopVideoRecording();
    isRecording.value = false;
    Get.off<String>(() => SendingVideoViewPage(path: videoPath.path));
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }
}
