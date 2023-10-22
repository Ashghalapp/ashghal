import 'dart:io';

import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/widget/app_buttons.dart';
import 'package:ashghal_app_frontend/core/widget/app_textformfield.dart';
import 'package:ashghal_app_frontend/core/widget/cashed_image_widget.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/post.dart';
import 'package:ashghal_app_frontend/features/post/presentation/getx/add_post_controller.dart';
import 'package:ashghal_app_frontend/features/post/presentation/getx/post_image_picker_controller.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/post_button.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class AddPostScreen extends StatelessWidget {
  final bool isUpdatePost;
  final Post? post;
  AddPostScreen({super.key, this.isUpdatePost = false, this.post});
  // final PostImageController postImageController =
  //     Get.put(PostImageController());

  late final addPostController = Get.find<AddPostController>();
  @override
  Widget build(BuildContext context) {
    if (isUpdatePost && post != null) {
      addPostController.loadPostDataToUpdate(post!);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isUpdatePost
            ? AppLocalization.updatePost
            : AppLocalization.createNewPost),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            // Title Input Field
            Form(
              key: addPostController.formKey,
              child: Column(
                children: [
                  // Title Input Field
                  AppTextFormField(
                    hintText: "Enter title",
                    label: "Enter title",
                    obscureText: false,
                    controller: addPostController.titleController,
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    validator: (newValue) {
                      if (newValue?.isEmpty ?? true) {
                        return AppLocalization.requiredField;
                      }
                      return null;
                    },
                  ),

                  // Content Input Field
                  AppTextFormField(
                    hintText: "Enter content",
                    label: "Enter content",
                    obscureText: false,
                    controller: addPostController.contentController,
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    minLines: 4,
                    maxLines: 6,
                    validator: (newValue) {
                      if (newValue?.isEmpty ?? true) {
                        return AppLocalization.requiredField;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 5),

            // Category Selection Dropdown
            _buildCategoryDropdownButton(),

            Obx(() => _buildImagesWidget()),

            // Create Post Button
            // PostButton(
            //   text: AppLocalization.addMedia,
            //   onPressed: () {
            //     controller.pickImages();
            //   },
            //   icon: Icons.camera_alt,
            // ),
            // addPostController.formKey.currentState?.validate()?? false
            // ?

            const SizedBox(height: 10),
            AppGesterDedector(
              text:
                  isUpdatePost ? AppLocalization.update : AppLocalization.send,
              color: Get.theme.primaryColor,
              onTap: () async {
                if (isUpdatePost && post != null) {
                  addPostController.updatePost(post!.id);
                } else {
                  addPostController.submitAddButton();
                }
                print(addPostController.imagesPaths);
              },
            ),
            // PostButton(
            //   text: isUpdatePost
            //       ? AppLocalization.update
            //       : AppLocalization.send,
            //   onPressed: () async {
            //     if (isUpdatePost && post != null) {
            //       addPostController.updatePost(post!.id);
            //     } else {
            //       addPostController.submitAddButton();
            //     }
            //     print(addPostController.imagesPaths);
            //   },
            //   icon: Icons.send,
            //   secondaryColor: Colors.green,
            // )
            // : const Text("")
          ],
        ),
      ),
    );
  }

  /// دالة لبناء القائمة الخاصة بتحديد الفئة
  Widget _buildCategoryDropdownButton() {
    var borderRadius = const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(12),
      ),
    );
    return DropdownButtonFormField(
      isExpanded: true,
      value: addPostController.selectedCategory,
      onChanged: (newValue) {
        addPostController.selectedCategory =
            int.parse(newValue?.toString() ?? "1");
      },
      style: Get.textTheme.bodyMedium,
      items: addPostController.categoryItems
          .map(
            (category) => DropdownMenuItem(
                value: category['id'],
                child: Center(child: Text(category['value'].toString()))),
          )
          .toList(),
      decoration: InputDecoration(
        hintText: 'Select category',
        hintStyle: Get.textTheme.labelSmall,
        border: borderRadius,
        enabledBorder: borderRadius.copyWith(
          borderSide: BorderSide.none,
        ),
        focusedBorder: borderRadius.copyWith(
          borderSide: BorderSide(color: Get.theme.primaryColor),
        ),
      ),
    );
  }

  final heightOfImages = 225.0;

  Widget _buildImagesWidget() {
    return SizedBox(
      height: heightOfImages,
      child: ListView.builder(
          scrollDirection: Axis.horizontal, // Horizontal scrolling
          itemCount: addPostController.imagesPaths.length + 1,
          itemBuilder: (context, index) {
            if (index == addPostController.imagesPaths.length) {
              return _buildAddMultiMediaButtonAsImage();
            }

            final imageUrl = addPostController.imagesPaths[index];
            print("<<<<<<<<<<$imageUrl>>>>>>>>>>");

            return Padding(
              padding: EdgeInsets.only(
                top: 15.0,
                bottom: 10,
                left: Get.locale?.languageCode == 'ar' ? 10 : 0,
                right: Get.locale?.languageCode == 'en' ? 10 : 0,
              ),
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () => addPostController.chooseImage(index),
                    child: imageUrl.startsWith('http')
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            // height: 200,
                            child: CashedNetworkImageWidget(
                              imageUrl: addPostController.imagesPaths[index],
                              errorAssetImagePath: "assets/images/unKnown.jpg",
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(addPostController.imagesPaths[index]),
                              // width: Get.width - 100,
                              // height: 200,
                            ),
                          ),
                  ),
                  Container(
                    alignment: AlignmentDirectional.topEnd,
                    child: InkWell(
                      onTap: () => addPostController.removeImage(index),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget _buildAddMultiMediaButtonAsImage() {
    return InkWell(
      onTap: () => addPostController.pickImages(),
      child: Container(
        alignment: AlignmentDirectional.topStart,
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Get.theme.inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(12),
        ),
        width: Get.width - 32,
        child: CustomTextAndIconButton(
          text:
              Text(AppLocalization.photoVideo, style: Get.textTheme.bodyMedium),
          onPressed: () => addPostController.pickImages(),
          icon: const Icon(Icons.add_photo_alternate),
        ),
      ),
    );
  }
}
