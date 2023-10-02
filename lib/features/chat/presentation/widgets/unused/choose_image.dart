// import 'dart:io';
// import 'package:ashghal_app_frontend/features/chat/presentation/getx/image_picker_controller.dart';
// import 'package:ashghal_app_frontend/features/chat/presentation/widgets/pick_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ImagePickerPage extends StatelessWidget {
//   final ImagePickerController controller = Get.put(ImagePickerController());

//   ImagePickerPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     controller.pickImages(); // Open file picker when the page is built

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Image Picker'),
//       ),
//       body: GetX<ImagePickerController>(
//         builder: (controller) => ListView(
//           children: [
//             Container(
//               height: 200,
//               width: 200,
//               margin: EdgeInsets.symmetric(horizontal: Get.width / 2 - 100),
//               color: const Color.fromARGB(255, 183, 175, 175),
//               child: MaterialButton(
//                 onPressed: () => controller.pickImages(),
//                 child: const Icon(Icons.add),
//               ),
//             ),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: List.generate(
//                   controller.images.length,
//                   (index) => Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Stack(
//                       children: [
//                         GestureDetector(
//                           onTap: () => controller.chooseImage(index),
//                           child: Image.file(
//                             File(controller.images[index].path),
//                             height: 200,
//                             width: 170,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         Positioned(
//                           top: 5,
//                           right: 5,
//                           child: GestureDetector(
//                             onTap: () => controller.removeImage(index),
//                             child: const Icon(
//                               Icons.delete,
//                               color: Colors.red,
//                               size: 25,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             controller.images.isNotEmpty
//                 ? Container(
//                     margin: const EdgeInsets.all(20),
//                     child: SendButton(
//                       text: "Send",
//                       onPressed: () {},
//                     ),
//                   )
//                 : const Text("")
//           ],
//         ),
//       ),
//     );
//   }
// }
