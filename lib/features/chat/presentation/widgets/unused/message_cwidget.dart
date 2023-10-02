// import 'package:flutter/material.dart';



// Widget chatMessages(List<MessageTile> testData, ChatController chatController) {
//   return GetBuilder<ChatController>(
//     builder: (controller) {
//       if (controller.testDatas.isNotEmpty) {
//         return ListView.builder(
//           itemCount: controller.testDatas.length,
//           itemBuilder: (context, index) {
//             final message = controller.testDatas[index];
//             if (message.image != null) {
//               // Display received image
//               return Column(
//                 children: [
//                   MessageTile(
//                     image: message.image!,
//                     message: message.message,
//                     sender: message.sender,
//                     sentByMe: message.sentByMe,
//                   ),
//                 ],
//               );
//             } else if (message.video != null) {
//               // Display received video
//               return Column(
//                 children: [
//                   // AspectRatio(
//                   //   aspectRatio: 16 / 9,
//                   //   child:
//                   //       VideoPlayer(message.video! as VideoPlayerController),
//                   // ),

//                   MessageTile(
//                     video: message.video,
//                     message: message.message,
//                     sender: message.sender,
//                     sentByMe: message.sentByMe,
//                   ),
//                 ],
//               );
//             } else {
//               // Display regular received message
//               return MessageTile(
//                 message: message.message,
//                 sender: message.sender,
//                 sentByMe: message.sentByMe,
//               );
//             }
//           },
//         );
//       } else {
//         return Center(
//           child: Container(
//             child: const Text(
//               "Start your conversation",
//               style: TextStyle(color: Colors.black, fontSize: 22),
//             ),
//           ),
//         );
//       }
//     },
//   );
// }
