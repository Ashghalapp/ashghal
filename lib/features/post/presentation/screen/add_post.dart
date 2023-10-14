import 'dart:io';

import 'package:ashghal_app_frontend/features/post/presentation/getx/post_image_picker_controller.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/post_button.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class UploadPostPage extends StatelessWidget {
  UploadPostPage({super.key});
  final PostImageController postImageController =
      Get.put(PostImageController());

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create new Post', style: TextStyle(color: Colors.black87),),
      ),
      body: GetX<PostImageController>(
        builder: (controller) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              // Title Input Field
              Obx(() {
                return TextField(
                  onChanged: (text) {
                    postImageController.title.value = text;
                  },
                  minLines: 1,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Enter title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    errorText:
                        postImageController.title.isEmpty ? 'Required' : null,
                  ),
                );
              }),
              const SizedBox(height: 10.0),

              // Content Input Field
              Obx(() {
                return TextField(
                  onChanged: (text) {
                    postImageController.content.value = text;
                  },
                  minLines: 4,
                  maxLines: 6,
                  decoration: InputDecoration(
                    labelText: 'Enter content',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    errorText:
                        postImageController.content.isEmpty ? 'Required' : null,
                  ),
                );
              }),
              const SizedBox(height: 10.0),

              // Category Selection Dropdown
              DropdownButtonFormField(
                value: postImageController.selectedCategory.value,
                onChanged: (newValue) {
                  postImageController.selectedCategory.value = int.parse(newValue?.toString() ?? "1");
                },
                items: postImageController.categoryItems.map(
                    (category) => DropdownMenuItem(
                    value: category['id'], // Ensure each value is unique
                    child: Center(child: Text(category['value'].toString())),
                  ),
                ).toList(),
                decoration: InputDecoration(
                  labelText: 'Select category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  // errorText: postImageController.selectedCategory.isEmpty
                  //     ? 'Required'
                  //     : null,
                ),
              ),

              const SizedBox(height: 10.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    controller.imagesXFiles.length,
                    (index) => Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () => controller.chooseImage(index),
                            child: Image.file(
                              File(controller.imagesPaths[index]),
                              height: 80,
                              width: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 1,
                            right: 1,
                            child: GestureDetector(
                              onTap: () => controller.removeImage(index),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Create Post Button
              PostButton(
                text: 'Choose Media',
                onPressed: () {
                  controller.pickImages();
                },
                icon: Icons.camera_alt,
              ),
              postImageController.isFormValid
                  ? PostButton(
                      text: "Send",
                      onPressed: () async {
                        await postImageController.onUploadPost();
                        print(postImageController.imagesPaths);
                      },
                      icon: Icons.send,
                      secondaryColor: Colors.green,
                    )
                  : const Text("")
            ],
          ),
        ),
      ),
    );
  }
}
