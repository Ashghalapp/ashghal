import 'dart:io';
import 'dart:typed_data';

import 'package:ashghal_app_frontend/app_library/app_data_types.dart';
import 'package:ashghal_app_frontend/config/app_images.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/message_and_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/components.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ReplyMessageWidget extends StatelessWidget {
  bool get isReplyMine => message.message.senderId == SharedPref.currentUserId;
  final bool? isMine;
  final MessageAndMultimedia message;
  final VoidCallback? onCancelReply;
  final String userName;

  const ReplyMessageWidget({
    super.key,
    required this.message,
    this.isMine,
    this.onCancelReply,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Container(
          decoration: BoxDecoration(
            color: isMine != null && isMine!
                ? Colors.black38
                : Get.isPlatformDarkMode
                    ? Colors.white12
                    : Colors.white60,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                ),
                width: 4,
              ),
              Expanded(child: buildReplyMessage()),
            ],
          ),
        ),
      );

  Widget buildReplyMessage() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        maxLines: 1,
                        isReplyMine ? AppLocalization.you.tr : userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )),
                const SizedBox(height: 3),
                Expanded(
                  child: Row(
                    children: [
                      if (message.multimedia == null)
                        Expanded(
                          child: Text(
                            maxLines: 1,
                            message.message.body ?? "",
                            overflow: TextOverflow.ellipsis,
                            style: _getBodyTextStyle(),
                          ),
                        ),
                      if (message.multimedia != null)
                        _buildMultimediaReplyBody(
                          message.multimedia!,
                          message.message.body,
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        message.multimedia != null &&
                message.multimedia!.type !=
                    MultimediaTypes.audio.value.toLowerCase()
            ? _builImageAvatar()
            : onCancelReply != null
                ? Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 2.0, top: 2),
                      child: _buildCancelIcon(),
                    ),
                  )
                : const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildCancelIcon() {
    return PressableCircularContianerWidget(
      onPress: onCancelReply != null ? onCancelReply! : () {},
      childPadding: const EdgeInsets.all(3),
      child: GestureDetector(
        onTap: onCancelReply,
        child: const Icon(
          Icons.close,
          size: 16,
          color: Colors.white70,
          // color: Colors.lightBlue,
        ),
      ),
    );
  }

  Widget _buildMultimediaReplyBody(LocalMultimedia multimedia, String? body) {
    if (multimedia.type == MultimediaTypes.image.value.toLowerCase()) {
      return _buildMultimediaIconAndText(
        Icons.image,
        body ?? AppLocalization.imageMessage.tr,
      );
    } else if (multimedia.type == MultimediaTypes.audio.value.toLowerCase()) {
      return _buildMultimediaIconAndText(
        Icons.mic,
        body ?? AppLocalization.voiceMessage.tr,
      );
    } else if (multimedia.type == MultimediaTypes.video.value.toLowerCase()) {
      return _buildMultimediaIconAndText(
        Icons.videocam_sharp,
        body ?? AppLocalization.videoMessage.tr,
      );
    } else if (multimedia.type == MultimediaTypes.archive.value.toLowerCase()) {
      return _buildMultimediaIconAndText(
        Icons.file_present_sharp,
        body ?? AppLocalization.archiveMessage.tr,
      );
    }
    return _buildMultimediaIconAndText(
      Icons.file_present_sharp,
      body ?? AppLocalization.fileMessage.tr,
    );
  }

  Widget _buildMultimediaIconAndText(IconData icon, String text) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
          ),
          const SizedBox(width: 2),
          Expanded(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: _getBodyTextStyle(),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _getBodyTextStyle() {
    return TextStyle(
        color: isMine != null && isMine! && !Get.isPlatformDarkMode
            ? Colors.white70
            : null);
  }

  Widget _builImageAvatar() {
    return Stack(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
            child: message.multimedia!.type ==
                        MultimediaTypes.file.value.toLowerCase() ||
                    message.multimedia!.type ==
                        MultimediaTypes.archive.value.toLowerCase()
                ? _getAssetsImage(AppImages.documentPlaceholder)
                : message.multimedia!.path == null
                    ? _getAssetsImage(AppImages.imagePlaceholder)
                    : getImageVideoPhoto(),
          ),
        ),
        if (onCancelReply != null)
          Positioned(
            right: 2,
            top: 2,
            child: _buildCancelIcon(),
          ),
      ],
    );
  }

  Image _getAssetsImage(String path) {
    return Image.asset(
      path,
      fit: BoxFit.cover,
    );
  }

  FutureBuilder<bool> getImageVideoPhoto() {
    return FutureBuilder<bool>(
      future: File(message.multimedia!.path!).exists(),
      builder: (_, snapShot) {
        if (snapShot.hasData && snapShot.data != null && snapShot.data!) {
          if (message.multimedia!.type ==
              MultimediaTypes.image.value.toLowerCase()) {
            return Image.file(
              File(message.multimedia!.path!),
              fit: BoxFit.cover,
            );
          } else {
            return _getVideoThumnial();
          }
        }
        return _getAssetsImage(AppImages.imagePlaceholder);
      },
    );
  }

  FutureBuilder<Uint8List?> _getVideoThumnial() {
    return FutureBuilder<Uint8List?>(
      future: getMemoryThumnial(message.multimedia!.path!),
      builder: (_, innerShot) {
        if (innerShot.hasData && innerShot.data != null) {
          return Image.memory(
            innerShot.data!,
            fit: BoxFit.cover,
          );
        }
        return _getAssetsImage(AppImages.imagePlaceholder);
      },
    );
  }

  Future<Uint8List?> getMemoryThumnial(String path) async {
    return await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.JPEG,
    );
  }
}
