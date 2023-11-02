import 'package:ashghal_app_frontend/features/chat/presentation/getx/multimedia_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttachmentOptionInfo {
  final IconData icon;
  final AttachmentOption option;
  final Color color;
  AttachmentOptionInfo({
    required this.color,
    required this.icon,
    required this.option,
  });
}

final List<AttachmentOptionInfo> attachmentOptionsInfo = [
  AttachmentOptionInfo(
    color: Colors.pink,
    icon: Icons.photo_camera,
    option: AttachmentOption.camera,
  ),
  AttachmentOptionInfo(
    color: Colors.purple,
    icon: Icons.photo,
    option: AttachmentOption.gallery,
  ),
  AttachmentOptionInfo(
      color: Colors.blue, icon: Icons.videocam, option: AttachmentOption.video),
  AttachmentOptionInfo(
    color: Colors.indigo,
    icon: Icons.insert_drive_file,
    option: AttachmentOption.file,
  ),
];

Future<void> showAttachmentBottomSheet(
  MultimediaController multimediaController,
) async {
  await Get.bottomSheet(
    Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.2,
          ),
          itemCount: attachmentOptionsInfo.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                multimediaController.handleAttachmentOption(
                  attachmentOptionsInfo[index].option,
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: attachmentOptionsInfo[index].color,
                    ),
                    child: Center(
                      child: Icon(
                        attachmentOptionsInfo[index].icon,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    attachmentOptionsInfo[index].option.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        //   ),
        // );
      ],
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    backgroundColor: Colors.white,
  );
}
