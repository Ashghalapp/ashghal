import 'package:any_link_preview/any_link_preview.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/message_and_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

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
          // Container(
          //   decoration: const BoxDecoration(
          //     color: Colors.black,
          //     borderRadius: BorderRadius.only(
          //       topLeft: Radius.circular(30),
          //       bottomLeft: Radius.circular(30),
          //     ),
          //   ),
          //   width: 7,
          //   height: 155,
          //   // child: Col,
          //   // height: double.maxFinite,
          // ),
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
              // Container(
              //   color: Colors.grey[300],
              //   child: const Text('Oops!'),
              // ),
              // errorImage: "https://google.com/",
              cache: const Duration(days: 7),
              // backgroundColor: Colors.grey[300],
              backgroundColor: isMine
                  ? Colors.black38
                  : Get.isPlatformDarkMode
                      ? Colors.white38
                      : Colors.white60,
              // borderRadius: 15,
              removeElevation: false,
              boxShadow: const [BoxShadow(blurRadius: 1, color: Colors.grey)],
              onTap: () async {
                await launchURL(link!);
              }, // This disables tap event
            ),
          ),
        ],
      ),
    );
    // LinkPreview(
    //   openOnPreviewImageTap: true,
    //   openOnPreviewTitleTap: true,
    //   hideImage: false,
    //   width: double.maxFinite,
    //   previewBuilder: (ctx,data){

    //   },
    //   //  widget.isMine
    //   //     ? MediaQuery.sizeOf(context).width - 120
    //   //     : MediaQuery.sizeOf(context).width - 140,
    //   enableAnimation: true,
    //   onPreviewDataFetched: (data) {
    //     setState(() {
    //       previewData = data;
    //     });
    //   },
    //   onLinkPressed: (link) {},
    //   previewData: previewData,
    //   text: widget.message.message.body!,

    //   // width: MediaQuery.of(context).size.width,
    // );
  }
}
