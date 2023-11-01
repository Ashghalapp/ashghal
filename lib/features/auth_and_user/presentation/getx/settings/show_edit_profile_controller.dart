import 'package:ashghal_app_frontend/app_library/app_data_types.dart';
import 'package:ashghal_app_frontend/app_library/public_entities/address.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/user_requests.dart/update_user_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/entities/provider.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/entities/user.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/use_cases/user_usecases/update_user_uc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ashghal_app_frontend/core/services/dependency_injection.dart'
    as di;

// TextEditingController? Email;
class ShowEditProfileController extends GetxController {
  late Rx<User> userData; // = Rx(getCurrentUserDataOffline);
  final String assetMaleImage = "assets/images/unKnown.jpg";
  final String assetFemaleImage = "assets/images/unKnown.jpg";
  RxString imagePath = "".obs;
  RxString name = "".obs;
  RxString selectedGender = "".obs;
  Rx<DateTime> birthDate = DateTime.now().obs;
  RxString city = "".obs;
  RxString street = "".obs;
  RxString addressDesc = "".obs;

  TextEditingController categoryController = TextEditingController();
  TextEditingController jobNameController = TextEditingController();
  TextEditingController jobDescController = TextEditingController();

  final List<Map<String, Object>> categoriesList = [
    {'id': "1", 'name': 'Developer'},
    {'id': "2", 'name': 'Designer'},
    {'id': "3", 'name': 'Consultant'},
    {'id': "4", 'name': 'Student'},
  ];

  User get getCurrentUserDataOffline {
    return SharedPref.getCurrentUserData()!;
  }

  @override
  void onInit() {
    super.onInit();
    userData = Rx(getCurrentUserDataOffline);
    setValues();
  }

  void setValues() {
    imagePath.value = "";
    name.value = userData.value.name;
    selectedGender.value = userData.value.gender.name;
    birthDate.value = userData.value.birthDate;
    if (userData.value.address != null) {
      city.value = userData.value.address?.city ?? "";
      street.value = userData.value.address?.street ?? "";
      addressDesc.value = userData.value.address?.desc ?? "";
    }
  }

  bool areThereChanges() =>
      imagePath.value.isNotEmpty ||
      name.value != userData.value.name ||
      selectedGender.value != userData.value.gender.name ||
      birthDate.value != userData.value.birthDate ||
      city.value != (userData.value.address?.city ?? "") ||
      street.value != (userData.value.address?.street ?? "") ||
      addressDesc.value != (userData.value.address?.desc ?? "");

  UpdateUserRequest getUpdatedDataRequest() {
    UpdateUserRequest request = UpdateUserRequest();
    if (imagePath.isNotEmpty) request.imagePath = imagePath.value;
    if (name.value != userData.value.name) request.name = name.value;
    if (birthDate.value != userData.value.birthDate) {
      request.birthDate = birthDate.value;
    }
    if (selectedGender.value != userData.value.gender.name) {
      request.gender = Gender.values.byName(selectedGender.value);
    }

    // ارسال بيانات الموقع لتحديثها في حالة كان المستخدم لديه موقع 
    // وكذلك في حالة تم التعديل على بيانات الموقع
    if (userData.value.address != null) {
      if (city.value != userData.value.address?.city ||
          street.value != userData.value.address?.street ||
          addressDesc.value != userData.value.address?.desc) {
        Address address = Address.updateRequest(
          city: city.value != userData.value.address?.city ? city.value : null,
          street: street.value != userData.value.address?.street
              ? street.value
              : null,
          desc: addressDesc.value != userData.value.address?.desc
              ? addressDesc.value
              : null,
        );
        request.address = address;
      }
    }

    print("<<<<<<<<<<${request.address?.toJson()}>>>>>>>>>>");
    return request;
  }

  Future<void> updateUserData() async {
    EasyLoading.show(status: AppLocalization.loading);
    final UpdateUserUseCase updateUserUS = di.getIt();

    (await updateUserUS.call(getUpdatedDataRequest())).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
    }, (user) {
      AppUtil.showMessage(AppLocalization.successModifyYourData, Colors.green);
      imagePath.value = "";
      userData.value = user;
      setValues();
      SharedPref.setCurrentUserData(user);
    });
    EasyLoading.dismiss();
  }

  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) imagePath.value = image.path;
  }

  // TextEditingController Accont1 = TextEditingController();
  // String Password = '123';
  // // Rx<bool> Flage = false.obs;
  // void check_email(String password) {
  //   if (password == Password) {
  //     // Flage.value = true;
  //   } else {
  //     // Flage.value= false;
  //     Get.snackbar("erorr", "كلمة السر غير صحيحه ");
  //   }
  // }
}
