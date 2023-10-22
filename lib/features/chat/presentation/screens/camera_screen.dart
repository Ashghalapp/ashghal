import 'package:ashghal_app_frontend/features/chat/presentation/getx/camera_getx_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/multimedia_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/unused/camera_appbar.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class CameraScreen extends StatefulWidget {

//   const CameraScreen({
//     super.key,
//   });

//   @override
//   State<CameraScreen> createState() => _CameraScreenState();
// }

class CameraScreen extends StatelessWidget {
  CameraScreen({super.key});
  final CameraGetxController _controller = Get.put(CameraGetxController());
  final MultimediaController _multimediaController =
      Get.put(MultimediaController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                FutureBuilder(
                  future: _controller.cameraValue,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return SizedBox(
                        width: double.infinity,
                        child: CameraPreview(_controller.cameraController),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _multimediaController.pickImagesFromGallery();
                          },
                          child: const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.black38,
                            child: Icon(
                              Icons.photo,
                              size: 30,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (!_controller.isRecording.value)
                              _controller.takePhoto();
                          },
                          onLongPress: () async {
                            await _controller.startVideoRecording();
                          },
                          onLongPressUp: () async {
                            await _controller.stopVideoRecording();
                          },
                          child: Obx(() => cameraIcon()),
                        ),
                        GestureDetector(
                          onTap: _controller.toggleCameraFront,
                          child: const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.black38,
                            child: Icon(
                              Icons.flip_camera_ios,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10, bottom: 8),
            child: Text(
              'Hold for video, tap for photo',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      systemOverlayStyle: Get.theme.appBarTheme.systemOverlayStyle,
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(Icons.clear),
      ),
      actions: [
        IconButton(
          onPressed: _controller.toggleFlash,
          icon: Obx(
            () => Icon(
              _controller.isFlashOn.value ? Icons.flash_on : Icons.flash_off,
            ),
          ),
        ),
      ],
    );
  }

  Icon cameraIcon() {
    return _controller.isRecording.value
        ? const Icon(
            Icons.radio_button_on,
            color: Colors.red,
            size: 80,
          )
        : const Icon(
            Icons.panorama_fish_eye,
            size: 80,
            color: Colors.white,
          );
  }
}
