import 'package:any_link_preview/any_link_preview.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/message_and_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/messages/components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LinksPreviewWidget extends StatelessWidget {
  const LinksPreviewWidget({
    super.key,
    required this.isMine,
    required this.message,
  });

  final bool isMine;
  final MessageAndMultimediaModel message;

  String? get link => AppUtil.getURLInText(message.message.body!);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
      child: Row(
        children: [
          Expanded(
            child: AnyLinkPreview(
              // previewHeight: 170,
              link: link!,
              displayDirection: UIDirection.uiDirectionVertical,
              showMultimedia: true,
              bodyMaxLines: 6,
              bodyTextOverflow: TextOverflow.ellipsis,
              titleStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              bodyStyle: const TextStyle(color: Colors.black, fontSize: 12),
              errorBody: 'Show my custom error body',
              errorTitle: 'Show my custom error title',
              errorWidget: const SizedBox.shrink(),
              cache: const Duration(days: 7),
              backgroundColor: isMine
                  ? Colors.black38
                  : Get.isPlatformDarkMode
                      ? Colors.white38
                      : Colors.white60,
              removeElevation: false,
              boxShadow: const [BoxShadow(blurRadius: 1, color: Colors.grey)],
              onTap: () async {
                await launchURL(link!);
              },
            ),
          ),
        ],
      ),
    );
  }
}
