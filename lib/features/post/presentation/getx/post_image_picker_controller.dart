import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/post_request/add_update_post_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/add_post_us.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/dependency_injection.dart' as di;

class PostImageController extends GetxController {
  
  // XFile حفظ جميع الصور التي سيتم رفعها بالبوست ويتم حفظها بشكل
  RxList<XFile> imagesXFiles = <XFile>[].obs;
  // حفظ مسار جميع الصور التي سيتم رفعها بالبوست
  RxList<String> imagesPaths = <String>[].obs;
  // عنوان البوست
  final title = ''.obs;
  // محتوى البوست النصي
  final content = ''.obs;
  // الفئة التي ينتمي لها البوست
  final selectedCategory = 1.obs;
  // الفئات التي سينتمي لها البوست
  List<Map<String, Object>> categoryItems = [
    {'id': 1, 'value': 'برمجة'},
    {'id': 2, 'value': 'طب'},
    {'id': 3, 'value': 'هندسة'},
    {'id': 4, 'value': 'حرفة يدوية'},
    {'id': 5, 'value': 'تصميم'},
  ];

  @override
  void onInit() {
    super.onInit();
    selectedCategory.value = 1;
  }

  // عبئة قائمة مسارات الصور
  void getImagePaths() {
    for (var xFile in imagesXFiles) {
      imagesPaths.add(xFile.path);
    }
  }

  // قاعدة تحقق من ان عنوان والمحتوى النصي والفئة التي ينتمي لها البوست تحمل قيم وغير فارغة
  bool get isFormValid =>
      title.isNotEmpty && content.isNotEmpty;
  
  // اختيار صور متعدده وتعبئتها الى قائمة الصور وتعبئة المسارات الخاصة بها
  Future<void> pickImages() async {
    final imagePicker = ImagePicker();
    List<XFile>? pickedFiles = await imagePicker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      imagesXFiles.addAll(pickedFiles);
      getImagePaths();
    }
  }

  // دالة رفع البوست
  Future onUploadPost() async {
    EasyLoading.show(status: AppLocalization.loading);

    AddPostUseCase addPostUS= di.getIt();
    var result = addPostUS.call(
      AddPostRequest(
          title: title.value,
          content: content.value,
          categoryId: selectedCategory.value,
          multimediaPaths: imagesPaths),
    );

    (await result).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
    }, (post) {
      AppUtil.showMessage(AppLocalization.successAddPost, Colors.green);
      Get.back();
    });
    EasyLoading.dismiss();
  }

  // دالة استبدال صورة في القائمة بصورة اخرى
  void chooseImage(int index) async {
    final imagePicker = ImagePicker();
    var pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imagesXFiles[index] = pickedFile;
      imagesPaths[index] = pickedFile.path;
    }
  }

// حذف صورة وحذف مسارها
  void removeImage(int index) {
    imagesXFiles.removeAt(index);
    imagesPaths.removeAt(index);
  }
}
