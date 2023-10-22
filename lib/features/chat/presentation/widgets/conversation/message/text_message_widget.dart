import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/message_and_multimedia.dart';
// import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/image_message_widget.dart';
// import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/message_text_status_icon.dart';
// import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/video_message_widget.dart';
// import 'package:ashghal_app_frontend/features/chat/presentation/widgets/style2.dart';
// import 'package:flutter/material.dart';

// class TextMessageWidget extends StatelessWidget {
//   const TextMessageWidget({
//     super.key,
//     required this.message,
//     required this.isMine,
//   });

//   final MessageAndMultimedia message;
//   final bool isMine;

//   @override
//   Widget build(BuildContext context) {
//     return ConstrainedBox(
//       constraints: BoxConstraints(
//         maxWidth: MediaQuery.sizeOf(context).width - 120,
//         minWidth: 105,
//       ),
//       child: Card(
//         color: isMine ? ChatStyle.ownMessageColor : ChatStyle.otherMessageColor,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(isMine ? 0.0 : 15.0),
//             topRight: Radius.circular(isMine ? 0.0 : 15.0),
//             bottomLeft: Radius.circular(isMine ? 15.0 : 1.0),
//             bottomRight: Radius.circular(isMine ? 0.0 : 15.0),
//           ),
//         ),
//         // margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             if (message.multimedia != null &&
//                 message.multimedia!.type == "image")
//               ImageMessage(
//                 multimedia: message.multimedia!,
//                 isMine: isMine,
//               ),
//             if (message.multimedia != null &&
//                 message.multimedia!.type == "video")
//               VideoMessageWidget(
//                 multimedia: message.multimedia!,
//                 isMine: isMine,
//               ),
//             MessageTextAndStatusIcon(message: message.message, isMine: isMine),
//           ],
//         ),
//       ),
//     );
//   }
// }
