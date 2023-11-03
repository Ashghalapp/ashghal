import 'dart:async';

import 'package:ashghal_app_frontend/config/app_images.dart';
import 'package:ashghal_app_frontend/config/app_patterns.dart';
import 'package:ashghal_app_frontend/config/chat_theme.dart';
import 'package:ashghal_app_frontend/core/helper/app_print_class.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/upload_download_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/style2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

enum MessageStatus {
  notSent,
  sent,
  received,
  read,
}

class IconBorder extends StatelessWidget {
  const IconBorder({
    Key? key,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      splashColor: ChatColors.secondary,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            width: 2,
            color: Theme.of(context).cardColor,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: icon,
        ),
      ),
    );
  }
}

class PressableIconBackground extends StatelessWidget {
  const PressableIconBackground({
    Key? key,
    this.icon,
    this.child,
    required this.onTap,
    this.borderRadius = 6,
    this.padding = 6,
  }) : super(key: key);
  final double borderRadius;
  final IconData? icon;
  final Widget? child;
  final VoidCallback onTap;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color:
          Get.isPlatformDarkMode ? Colors.white12 : Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: ChatColors.secondary,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: icon != null
              ? Icon(
                  icon,
                  size: 24,
                )
              : child,
        ),
      ),
    );
  }
}

class MessageStatusIcon extends StatelessWidget {
  final LocalMessage message;
  const MessageStatusIcon({super.key, required this.message});

  MessageStatus get messageStatus {
    if (message.sentAt != null) {
      if (message.recievedAt != null) {
        if (message.readAt != null) {
          return MessageStatus.read;
        }
        return MessageStatus.received;
      }
      return MessageStatus.sent;
    }
    return MessageStatus.notSent;
  }

  @override
  Widget build(BuildContext context) {
    return messageStatus == MessageStatus.read
        ? const Icon(
            FontAwesomeIcons.checkDouble,
            color: Colors.blue,
            size: 16,
          )
        : messageStatus == MessageStatus.received
            ? const Icon(
                FontAwesomeIcons.checkDouble,
                size: 16,
              )
            : messageStatus == MessageStatus.sent
                ? const Icon(
                    FontAwesomeIcons.check,
                    size: 16,
                  )
                : const Icon(
                    Icons.access_time,
                    size: 18,
                  );
  }
}

class MessageCtreatedAtTextWidget extends StatelessWidget {
  final DateTime date;
  const MessageCtreatedAtTextWidget({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Text(AppUtil.getHourMinuteDateFormat(date));
  }
}

class MessageBodyTextWidget extends StatelessWidget {
  final String? body;
  final bool isMine;
  const MessageBodyTextWidget({super.key, this.body, required this.isMine});

  @override
  Widget build(BuildContext context) {
    return body != null && AppUtil.hasURLInText(body!)
        ? MessageBodyTextWithUrlsWidget(
            body: body!,
            isMine: isMine,
          )
        : Text(
            body ?? "",
            overflow: TextOverflow.visible,
            softWrap: true,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 17,
              color: isMine
                  ? ChatStyle.ownMessageTextColor
                  : Get.isPlatformDarkMode
                      ? ChatStyle.otherMessageTextDarkColor
                      : ChatStyle.otherMessageTextLightColor,
            ),
          );
  }
}

class MessageBodyTextWithUrlsWidget extends StatelessWidget {
  final String body;
  final bool isMine;

  const MessageBodyTextWithUrlsWidget(
      {super.key, required this.body, required this.isMine});

  @override
  Widget build(BuildContext context) {
    final urlPattern = AppPatterns.urlPattern;
    final defaultStyle = TextStyle(
      fontSize: 17,
      color: isMine
          ? ChatStyle.ownMessageTextColor
          : Get.isPlatformDarkMode
              ? ChatStyle.otherMessageTextDarkColor
              : ChatStyle.otherMessageTextLightColor,
    );

    const urlStyle = TextStyle(
      fontSize: 16,
      color: Colors.blue,
      decoration: TextDecoration.underline,
      fontStyle: FontStyle.italic,
    );

    final textSpans = <TextSpan>[];
    final matches = urlPattern.allMatches(body);

    int start = 0;

    for (final match in matches) {
      if (start < match.start) {
        final nonUrlText = body.substring(start, match.start);
        textSpans.add(TextSpan(text: nonUrlText, style: defaultStyle));
      }

      final urlText = body.substring(match.start, match.end);

      textSpans.add(
        TextSpan(
          text: urlText,
          style: urlStyle,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              showOptionsBottomSheet(context, urlText);
            },
        ),
      );
      start = match.end;
    }

    if (start < body.length) {
      final nonUrlText = body.substring(start);
      textSpans.add(TextSpan(text: nonUrlText, style: defaultStyle));
    }

    return RichText(
      overflow: TextOverflow.visible,
      softWrap: true,
      textAlign: TextAlign.left,
      text: TextSpan(
        children: textSpans,
      ),
    );
  }

  void showOptionsBottomSheet(BuildContext context, String url) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.open_in_browser),
              title: const Text('Open'),
              onTap: () {
                Navigator.pop(context);
                launchURL(url);
              },
            ),
            ListTile(
              leading: const Icon(Icons.content_copy),
              title: const Text('Copy'),
              onTap: () {
                Navigator.pop(context);
                Clipboard.setData(ClipboardData(text: url));
              },
            ),
          ],
        );
      },
    );
  }

  void launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      AppUtil.buildErrorDialog("Could not launch $url");
    }
  }
}

// class CustomTapGestureRecognizer extends TapGestureRecognizer {
//   final GestureTapCallback onTap;
//   final Function()? onLongPress;

//   CustomTapGestureRecognizer({required this.onTap, this.onLongPress});
// //  The handleTapDown method checks the tap duration, and if it's a long press (500 milliseconds in
// //  this example), it invokes the onLongPress callback. If it's a short tap, it invokes the onTap callback.
//   @override
//   void handleTapDown({required PointerDownEvent down}) {
//     super.handleTapDown(down: down);
//     // We handle onLongPress in handleTapDown by checking the tap duration
//     if (onLongPress != null) {
//       Timer(const Duration(milliseconds: 500), () {
//         if (onLongPress != null) {
//           invokeCallback<void>('onLongPress', onLongPress!);
//         }
//       });
//     }
//   }
// }

// class CustomTapGestureRecognizer extends TapGestureRecognizer {
//   // final GestureTapCallback? onTap;
//   // final Function()? onLongPress;
//   bool longPressTriggered = false;

//   CustomTapGestureRecognizer({GestureTapCallback? onTap, Function()? onLongPress}):this.onTap=onTap;

//   @override
//   void handleTapDown({required PointerDownEvent down}) {
//     super.handleTapDown(down: down);
//     // We handle onLongPress in handleTapDown by checking the tap duration
//     longPressTriggered = false;
//     Timer(const Duration(milliseconds: 500), () {
//       if (!longPressTriggered && onLongPress != null) {
//         invokeCallback<void>('onLongPress', onLongPress!);
//         longPressTriggered = true;
//       }
//     });
//   }

//   @override
//   void handleTapUp(
//       {required PointerDownEvent down, required PointerUpEvent up}) {
//     if (!longPressTriggered && onTap != null) {
//       invokeCallback<void>('onTap', onTap!);
//     }
//   }
// }

class DownloadUploadIconWithSizeWidget extends StatelessWidget {
  const DownloadUploadIconWithSizeWidget({
    super.key,
    required this.isMine,
    required UploadDownloadController controller,
    required this.size,
  }) : _controller = controller;

  final bool isMine;
  final UploadDownloadController _controller;
  final int size;

  @override
  Widget build(BuildContext context) {
    return PressableCircularContianerWidget(
      onPress: () {
        if (isMine) {
          _controller.startUploading();
        } else {
          _controller.startDownload();
        }
      },
      childPadding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DownloadUploadIconWidget(isMine: isMine),
          const SizedBox(width: 5),
          MultimediaSizeTextWidget(
            size: size,
            isMine: isMine,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}

class MultimediaSizeTextWidget extends StatelessWidget {
  const MultimediaSizeTextWidget({
    super.key,
    required this.size,
    required this.isMine,
    this.fontSize = 14,
    this.color,
  });

  final int size;
  final double fontSize;
  final bool isMine;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Text(
      AppUtil.getFormatedFileSize(size),
      style: TextStyle(
        color: color ??
            (isMine
                ? ChatStyle.ownMessageTextColor.withOpacity(0.7)
                : Get.isPlatformDarkMode
                    ? ChatStyle.otherMessageTextDarkColor.withOpacity(0.7)
                    : ChatStyle.otherMessageTextLightColor.withOpacity(0.7)),
        fontSize: fontSize,
      ),
    );
  }
}

class MultimediaExtentionTextWidget extends StatelessWidget {
  const MultimediaExtentionTextWidget({
    super.key,
    required this.path,
    required this.isMine,
    this.fontSize = 14,
  });

  final String path;
  final double fontSize;
  final bool isMine;
  @override
  Widget build(BuildContext context) {
    return Text(
      path.split('.').last,
      style: TextStyle(
        color: isMine
            ? ChatStyle.ownMessageTextColor.withOpacity(0.7)
            : Get.isPlatformDarkMode
                ? ChatStyle.otherMessageTextDarkColor.withOpacity(0.7)
                : ChatStyle.otherMessageTextLightColor.withOpacity(0.7),
        fontSize: fontSize,
      ),
    );
  }
}

class DownloadUploadIconWidget extends StatelessWidget {
  const DownloadUploadIconWidget({
    super.key,
    required this.isMine,
    this.iconSize = 18,
    this.color = Colors.white,
  });

  final bool isMine;
  final double iconSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      isMine ? Icons.upload : Icons.download,
      color: color,
      size: iconSize,
    );
  }
}

class DownloadinUploadingCicrularWidget extends StatelessWidget {
  const DownloadinUploadingCicrularWidget({
    super.key,
    this.cancelIconColor = Colors.white,
    required this.onCancel,
    this.scaleCircular = 0.6,
    this.iconSize = 12,
  });
  final VoidCallback? onCancel;
  final Color? cancelIconColor;
  final double scaleCircular;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.scale(
          scale: scaleCircular,
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.blue,
            ),
          ),
        ),
        InkWell(
          onTap: onCancel,
          child: Icon(
            FontAwesomeIcons.x,
            color: cancelIconColor,
            size: iconSize,
          ),
        ),
      ],
    );
  }
}

class DownloadingUploadingProgressPercent extends StatelessWidget {
  const DownloadingUploadingProgressPercent({
    super.key,
    required this.value,
  });

  final double value;

  @override
  Widget build(BuildContext context) {
    return Text(
      (value * 100).toStringAsFixed(2),
      style: const TextStyle(fontSize: 12),
    );
  }
}

class ImageVideoDeletedPlaceHolderWidget extends StatelessWidget {
  const ImageVideoDeletedPlaceHolderWidget({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const ImageVideoPlaceHolderWidget(),
        Container(
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class ImageVideoPlaceHolderWidget extends StatelessWidget {
  const ImageVideoPlaceHolderWidget({
    super.key,
    this.loadingPlaceHolder = false,
  });
  final bool loadingPlaceHolder;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Image.asset(
        loadingPlaceHolder
            ? AppImages.circularLoading
            : AppImages.imagePlaceholder,
        fit: BoxFit.contain,
      ),
    );
  }
}

class PressableCircularContianerWidget extends StatelessWidget {
  final void Function() onPress;

  final double borderRaduis;
  final EdgeInsetsGeometry childPadding;
  final Widget child;
  final Color color;
  final double? width;
  const PressableCircularContianerWidget({
    super.key,
    required this.onPress,
    required this.child,
    this.borderRaduis = 50,
    this.childPadding = const EdgeInsets.all(10),
    this.color = ChatStyle.iconsBackColor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRaduis),
        ),
        child: Padding(padding: childPadding, child: child),
      ),
    );
  }
}
