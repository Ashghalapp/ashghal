import 'package:ashghal_app_frontend/app_library/public_entities/address.dart';
import 'package:ashghal_app_frontend/app_library/public_entities/app_category.dart';
import 'package:ashghal_app_frontend/core/cities_and_districts.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core/util/dialog_util.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/entities/user.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/post_request/add_update_post_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/post_request/delete_some_post_multimedia_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/multimedia.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/post.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/add_post_us.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/delete_some_post_multimedia_us.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/update_post_us.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/dependency_injection.dart' as di;

class AddUpdatePostController extends GetxController {
  final formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController contentController;
  late TextEditingController expireDateController;
  Rx<DateTime> expireDate = Rx(DateTime.now().add(const Duration(days: 30)));

  int? selectedCategory;
  RxList<District> cityDistricts = <District>[].obs;

  Rx<int?> selectedCityId = Rx(null);
  Rx<int?> selectedDistrictId = Rx(null);

  // XFile حفظ جميع الصور التي سيتم رفعها بالبوست ويتم حفظها بشكل
  // RxList<XFile> imagesXFiles = <XFile>[].obs;
  // حفظ مسار جميع الصور التي سيتم رفعها بالبوست
  RxList<String> imagesPaths = <String>[].obs;

  /// list to save the multimedia when edit found post
  List<Multimedia> multiMediaToEdit = [];

  /// list to save the ids of multimedia to delete them
  List<int> imagesIdToDelete = [];

  RxBool allowComment = true.obs;

  RxList<AppCategory> categories =
      SharedPref.getCategories()?.obs ?? <AppCategory>[].obs;

  bool get isValidateForm => formKey.currentState?.validate() ?? false;

  @override
  void onInit() async {
    super.onInit();
    titleController = TextEditingController();
    contentController = TextEditingController();
    expireDateController = TextEditingController();
    expireDateController.text = expireDate.value.toString().split(' ')[0];

    if (categories.isEmpty) {
      await AppUtil.loadCategories();
      categories = SharedPref.getCategories()?.obs ?? <AppCategory>[].obs;
    }

    loadLocationData();
  }

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    expireDateController.dispose();

    super.onClose();
  }

  /// functions to initial address filtters with user address
  void loadLocationData() {
    final User? currentUser = SharedPref.getCurrentUserData();
    if (currentUser != null && currentUser.address != null) {
      City? city = City.getCityByNameEn(currentUser.address?.city ?? "");
      printError(info: "<<<<<<<<<<<<<<City data: ${city?.toJson()}");
      if (city != null) {
        selectedCityId.value = city.id;
        cityDistricts.addAll(city.districts);

        District? district =
            city.getDistrictByNameEn(currentUser.address?.district ?? "");
        printError(info: "<<<<<<<<<<<<<<District data: ${district?.toJson()}");
        if (district != null) {
          selectedDistrictId.value = district.id;
        }
      }
    }
  }

  var cities = citiess;

  void onCityChangeFunction(selectedValue) {
    if (selectedValue != null) {
      selectedCityId.value = int.parse(selectedValue.toString());
      printInfo(info: selectedCityId.value.toString());
      print(
          "<<<<<<<<${cities.firstWhere((element) => element.id == 1).districts[0].name}>>>>>>>>");
      cityDistricts.clear();
      cityDistricts.addAll(citiess
          .firstWhere((city) => city.id == selectedCityId.value)
          .districts);
      selectedDistrictId.value = 1;

      // citiess.map((e) {
      //   print("-----------${e.id.toString()}");
      // });
      // printInfo(info: "city: ${selectedCityId.value}");
      // printInfo(
      //     info: citiess
      //         .firstWhere((city) => city.id == selectedCityId.value)
      //         .districts
      //         .toString());
    }
  }

  void loadPostDataToUpdate(Post post) {
    titleController.text = post.title;
    contentController.text = post.content;
    selectedCategory = int.parse(post.categoryData['id'].toString());
    multiMediaToEdit = post.multimedia ?? [];
    imagesPaths.value = post.multimedia?.map((e) => e.url).toList() ?? [];
    expireDate.value = post.expireDate;
    expireDateController.text = expireDate.value.toString().split(' ')[0];
    allowComment.value = post.allowComment;
    if (post.address != null) {
      selectedCityId.value = City.getCityByNameEn(post.address?.city ?? "")?.id;
      onCityChangeFunction(selectedCityId);
      selectedDistrictId.value = City.getCityById(selectedCityId.value)
          ?.getDistrictByNameEn(post.address?.district)
          ?.id;
      // printError(info: "district id: ${City.getCityById(selectedCityId.value)
      //     ?.getDistrictByNameEn(post.address?.district)
      //     ?.id}");
    }

    imagesIdToDelete.clear();
  }

  Future<void> submitAddButton() async {
    try {
      if (!isValidateForm || selectedCategory == null) return;
      EasyLoading.show(status: AppLocalization.loading);

      AddPostUseCase addPostUS = di.getIt();
      City city = City.getCityById(selectedCityId.value!)!;
      District district = city.getDistrictById(selectedDistrictId.value!)!;

      var result = addPostUS.call(
        AddPostRequest(
          title: titleController.text,
          content: contentController.text,
          categoryId: selectedCategory,
          multimediaPaths: imagesPaths,
          expireDate: expireDate.value,
          allowComment: allowComment.value,
          address:
              Address.addRequest(city: city.nameEn, district: district.nameEn),
        ),
      );

      (await result).fold((failure) {
        AppUtil.hanldeAndShowFailure(failure);
      }, (post) {
        AppUtil.showMessage(AppLocalization.successAddPost, Colors.green);
        Get.back();
      });
      EasyLoading.dismiss();
    } catch (e) {
      AppUtil.showMessage(
          AppLocalization.thereIsSomethingError, Get.theme.colorScheme.error);
    }
  }

  Future<void> updatePost(int postId) async {
    if (!isValidateForm || selectedCategory == null) return;

    EasyLoading.show(status: AppLocalization.loading);
    // delete the specific post images
    if (!await deleteSomePostMultimedia(postId)) {
      EasyLoading.dismiss();
      return;
    }

    UpdatePostUseCase updatePostUS = di.getIt();
    City city = City.getCityById(selectedCityId.value!)!;
    District district = city.getDistrictById(selectedDistrictId.value!)!;

    var result = updatePostUS.call(
      UpdatePostRequest(
        postId: postId,
        title: titleController.text,
        content: contentController.text,
        categoryId: selectedCategory,
        address:
            Address.updateRequest(city: city.nameEn, district: district.nameEn),
        multimediaPaths: imagesPaths
            .where((imagePath) => !imagePath.startsWith('http'))
            .toList(),
        expireDate: expireDate.value,
        allowComment: allowComment.value,
      ),
    );

    (await result).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
    }, (post) {
      AppUtil.showMessage(AppLocalization.successAddPost, Colors.green);
      Get.back<Post>(result: post);
    });
    EasyLoading.dismiss();
  }

  /// دالة لحذف الصور المحدد حذفها من البوست
  Future<bool> deleteSomePostMultimedia(int postId) async {
    bool isImagesDeleted = true;
    if (imagesIdToDelete.isNotEmpty) {
      DeleteSomePostMultimediaUseCase deletePostMultimedia = di.getIt();
      var result = deletePostMultimedia.call(
        DeleteSomePostMultimediaRequest(
            postId: postId, multimediaIds: imagesIdToDelete),
      );

      isImagesDeleted = (await result).fold(
        (failure) {
          AppUtil.hanldeAndShowFailure(failure);
          return false;
        },
        (success) => true,
      );
    }
    return isImagesDeleted;
  }

  // عبئة قائمة مسارات الصور
  // void getImagePaths() {
  //   for (var xFile in imagesXFiles) {
  //     imagesPaths.add(xFile.path);
  //   }
  // }

  // اختيار صور متعدده وتعبئتها الى قائمة الصور وتعبئة المسارات الخاصة بها
  Future<void> pickImages() async {
    final imagePicker = ImagePicker();
    List<XFile>? pickedFiles = await imagePicker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      for (XFile file in pickedFiles) {
        imagesPaths.add(file.path);
      }
      // imagesXFiles.addAll(pickedFiles);
      // getImagePaths();
    }
  }

  // دالة استبدال صورة في القائمة بصورة اخرى
  void chooseImage(int index) async {
    final imagePicker = ImagePicker();
    var pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // imagesXFiles[index] = pickedFile;
      imagesPaths[index] = pickedFile.path;
    }
  }

  // حذف صورة وحذف مسارها واضافتها الى قائمة الصور التي سيتم حذفها في حالةكانت العملية تعديل بوست
  void removeImage(int index) {
    DialogUtil.showDialog(
      title: AppLocalization.warning,
      message: AppLocalization.areYouSureToDelete,
      onSubmit: () {
        Get.back();
        int multimediaIndex = multiMediaToEdit
            .indexWhere((element) => element.url == imagesPaths[index]);
        if (multimediaIndex != -1) {
          imagesIdToDelete.add(multiMediaToEdit[multimediaIndex].id);
        }
        // imagesIdToDelete.add(multiMediaToEdit
        //     .firstWhere((element) => element.url == imagesPaths[index])
        //     .id);
        imagesPaths.removeAt(index);
      },
      submitText: AppLocalization.ok,
    );
  }
}
