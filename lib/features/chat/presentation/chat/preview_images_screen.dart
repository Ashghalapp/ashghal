import 'dart:io';
import 'package:ashghal_app_frontend/features/chat/presentation/chat/image_perview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PreviewImagesScreen extends StatefulWidget {
  const PreviewImagesScreen({super.key});

  @override
  State<PreviewImagesScreen> createState() => _PreviewImagesScreenState();
}

class _PreviewImagesScreenState extends State<PreviewImagesScreen> {
  File? _image;
  final picker = ImagePicker();

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  //Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  //Show options to get image from camera or gallery
  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Photo Gallery'),
            onPressed: () {
              Navigator.of(context).pop();

              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Camera'),
            onPressed: () {
              Navigator.of(context).pop();

              getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Picker'),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: showOptions,
            child: const Text('Select Image'),
          ),
          Center(
            child: _image == null
                ? const Text('No Image selected')
                : ImagePerview(path: _image!.path),

            //              Scaffold(
            //   backgroundColor: Colors.black,
            //   appBar: AppBar(
            //     backgroundColor: Colors.black,
            //     actions: [
            //       IconButton(
            //           icon: const Icon(
            //             Icons.crop_rotate,
            //             size: 27,
            //           ),
            //           onPressed: () {}),
            //       IconButton(
            //           icon: const Icon(
            //             Icons.emoji_emotions_outlined,
            //             size: 27,
            //           ),
            //           onPressed: () {}),
            //       IconButton(
            //           icon: const Icon(
            //             Icons.title,
            //             size: 27,
            //           ),
            //           onPressed: () {}),
            //       IconButton(
            //           icon: const Icon(
            //             Icons.edit,
            //             size: 27,
            //           ),
            //           onPressed: () {}),
            //     ],
            //   ),
            //   body: SizedBox(
            //     width: MediaQuery.of(context).size.width,
            //     height: MediaQuery.of(context).size.height,
            //     child: Stack(
            //       children: [
            //         SizedBox(
            //           width: MediaQuery.of(context).size.width,
            //           height: MediaQuery.of(context).size.height - 150,
            //         child: _image == null
            //   ? const Text('No Image selected')
            //   : Image.file(_image!,width: 100,height: 100,),
            //         ),
            //         Positioned(
            //           bottom: 0,
            //           child: Container(
            //             color: Colors.black38,
            //             width: MediaQuery.of(context).size.width,
            //             padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            //             child: TextFormField(
            //               style: const TextStyle(
            //                 color: Colors.white,
            //                 fontSize: 17,
            //               ),
            //               maxLines: 6,
            //               minLines: 1,
            //               decoration: InputDecoration(
            //                   border: InputBorder.none,
            //                   hintText: "Add Caption....",
            //                   prefixIcon: const Icon(
            //                     Icons.add_photo_alternate,
            //                     color: Colors.white,
            //                     size: 27,
            //                   ),
            //                   hintStyle: const TextStyle(
            //                     color: Colors.white,
            //                     fontSize: 17,
            //                   ),
            //                   suffixIcon: CircleAvatar(
            //                     radius: 27,
            //                     backgroundColor: Colors.tealAccent[700],
            //                     child: const Icon(
            //                       Icons.check,
            //                       color: Colors.white,
            //                       size: 27,
            //                     ),
            //                   )),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ),
        ],
      ),
    );
  }
}
