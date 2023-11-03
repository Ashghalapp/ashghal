import 'dart:io';

import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/widget/app_buttons.dart';
import 'package:ashghal_app_frontend/core/widget/app_dropdownbuttonformfield.dart';
import 'package:ashghal_app_frontend/core/widget/app_textformfield.dart';
import 'package:ashghal_app_frontend/core/widget/cashed_image_widget.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/post.dart';
import 'package:ashghal_app_frontend/features/post/presentation/getx/add_update_post_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class AddUpdatePostScreen extends StatelessWidget {
  final bool isUpdatePost;
  final Post? post;
  AddUpdatePostScreen({super.key, this.isUpdatePost = false, this.post});
  // final PostImageController postImageController =
  //     Get.put(PostImageController());

  late final addPostController =
      Get.find<AddUpdatePostController>(tag: isUpdatePost ? 'update' : 'add');
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
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Form(
              key: addPostController.formKey,
              child: Column(
                children: [
                  // Title Input Field
                  AppTextFormField(
                    labelText: AppLocalization.title,
                    hintText: AppLocalization.enterTitle,
                    obscureText: false,
                    controller: addPostController.titleController,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
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
                    labelText: AppLocalization.content,
                    hintText: AppLocalization.enterContent,
                    obscureText: false,
                    controller: addPostController.contentController,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
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

            // Category Dropdown
            Obx(
              () => AppDropDownButton(
                items: addPostController.categories
                    .map((category) => category.toJson())
                    .toList(),
                onChange: (newValue) {
                  addPostController.selectedCategory =
                      int.parse(newValue?.toString() ?? "1");
                },
                hintText: AppLocalization.selectCategory,
                labelText: AppLocalization.category,
                initialValue: addPostController.selectedCategory,
              ),
            ),

            // images widgets
            Obx(() => _buildImagesWidget()),

            // Expire date Field
            AppTextFormField(
              labelText: "Expire date",
              hintText: "Select expire date",
              obscureText: false,
              controller: addPostController.expireDateController,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              margin: const EdgeInsets.symmetric(vertical: 5),
              readOnly: true,
              onTap: () async {
                await _selectDate(addPostController.expireDate);
                addPostController.expireDateController.text =
                    addPostController.expireDate.value.toString().split(' ')[0];
                print("<<<<<<<${addPostController.expireDate.value}>>>>>>>");
              },
              validator: (newValue) {
                if (newValue?.isEmpty ?? true) {
                  return AppLocalization.requiredField;
                }
                return null;
              },
            ),

            // allow comment widget
            Obx(
              () => CheckboxListTile(
                title: Text(
                  AppLocalization.allowComments.tr,
                  style: Get.textTheme.bodyMedium,
                ),
                value: addPostController.allowComment.value,
                contentPadding: EdgeInsets.only(
                  left: Get.locale?.languageCode == 'en' ? 5 : 0,
                  right: Get.locale?.languageCode == 'ar' ? 5 : 0,
                ),
                onChanged: (newValue) {
                  addPostController.allowComment.value = newValue ?? true;
                },
              ),
            ),

            // send/update post button
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
          ],
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
            // if (index == addPostController.imagesPaths.length) {
            if (index == 0) {
              print("{{{{{{{$index}}}}}}}");
              return _buildAddMultiMediaButtonAsImage(
                  addPostController.imagesPaths.isNotEmpty ? 115 : null);
            }

            final imageUrl = addPostController.imagesPaths[index - 1];
            print("<<<<<<<<<<$imageUrl>>>>>>>>>>");

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () => addPostController.chooseImage(index),
                    child:
                        // imageUrl.startsWith('http')            ?
                        ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      // height: 200,
                      child: imageUrl.startsWith('http')
                          ? CashedNetworkImageWidget(
                              height: 200,
                              imageUrl: imageUrl,
                              errorAssetImagePath: "assets/images/unKnown.jpg",
                            )
                          : Image.file(
                              File(imageUrl),
                              // width: Get.width - 100,
                              height: 200,
                            ),
                    ),
                  ),
                  Container(
                    alignment: AlignmentDirectional.topEnd,
                    child: InkWell(
                      onTap: () => addPostController.removeImage(index - 1),
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

  Widget _buildAddMultiMediaButtonAsImage([double? width]) {
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
        width: width ?? Get.width - 20,
        child: CustomTextAndIconButton(
          text: Text(
            AppLocalization.photoVideo,
            style: Get.textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
          onPressed: () => addPostController.pickImages(),
          icon: const Icon(Icons.add_photo_alternate),
        ),
      ),
    );
  }

  Future<void> _selectDate(Rx<DateTime> date) async {
    final DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: date.value,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
      locale: const Locale('en'), // تعيين اللغة لعرض التاريخ بالعربية
    );

    if (pickedDate != null && pickedDate != date.value) {
      date.value = pickedDate;
    }
  }
}
