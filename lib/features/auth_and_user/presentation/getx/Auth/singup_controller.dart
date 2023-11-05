import 'dart:math';

import 'package:ashghal_app_frontend/app_library/app_data_types.dart';
import 'package:ashghal_app_frontend/app_library/public_entities/address.dart';
import 'package:ashghal_app_frontend/app_library/public_entities/app_category.dart';
import 'package:ashghal_app_frontend/core/cities_and_districts.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/core_api/success/success.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/check_email_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/register_user_provider_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/entities/provider.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/use_cases/check_email_uc.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/use_cases/register_user_with_email_uc.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/screens/auth/signup_details_screen.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/screens/auth/signup_provider_data_screen.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/screens/success_screen.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/screens/validate_screen.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../config/app_routes.dart';
import '../../../domain/entities/user.dart';
import '../../../../../core/services/dependency_injection.dart' as di;

class SignUpController extends GetxController {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController jobNameController;
  late TextEditingController jobCategoryController;
  late TextEditingController jobDescController;
  GlobalKey<FormState> signUpFormKey = GlobalKey();
  GlobalKey<FormState> jobFormKey = GlobalKey();

  // late GlobalKey<FormState> addressFormKey;
  late TextEditingController cityController;
  late TextEditingController districtController;
  late TextEditingController descController;
  bool isVisible = true;

  // final RxList<Map<String, Object>> categoriesList = RxList([
  //   {'id': "1", 'name': 'Developer'},
  //   {'id': "2", 'name': 'Designer'},
  //   {'id': "3", 'name': 'Consultant'},
  //   {'id': "4", 'name': 'Student'},
  // ]);
  final String assetMaleImage = "assets/images/Profile.svg";
  final String assetFemaleImage = "assets/images/unKnown.jpg";
  RxString imagePath = "".obs;
  RxString selectedGender = "".obs;
  Rx<DateTime?> birthDate = Rx(null);
  // RxString city = "".obs;
  // RxString street = "".obs;
  // RxString addressDesc = "".obs;
// late Rx<User> userData;
  RxList<AppCategory> categories =
      SharedPref.getCategories()?.obs ?? <AppCategory>[].obs;
// RxString selectedItem = 'Item 1'.obs;
  // RxInt selectedCity = 0.obs;
  // int selectedDistrict = 0;

  final RxList<Map<String, Object>> selectedDistrictList =
      <Map<String, Object>>[].obs;

  // void updateDistrictDropdown(int selectedCity) {
  //      List<Map<String, Object>> selectedCityDistricts = cityDistricts[selectedDistrict-1]!;

  //    for (var district in selectedCityDistricts) {
  //   print('District (name_en): ${district['name_en']}');
  // }
  // print('Selected District (name_en): ${selectedCityDistricts}');

  // print(cities[selectedCity - 1]['name_en']);
  // print(cityDistricts[selectedDistrict - 1]![selectedCity]['name_en']);

  // selectedDistrict = 0; // Clear the selected district
  // }

  @override
  void onInit() async {
    try {
      // addressFormKey = GlobalKey();
      cityController = TextEditingController();
      districtController = TextEditingController();
      descController = TextEditingController();
      emailController = TextEditingController();
      passwordController = TextEditingController();
      nameController = TextEditingController();
      phoneController = TextEditingController();
      jobNameController = TextEditingController();
      jobDescController = TextEditingController();
      jobCategoryController = TextEditingController();

      emailController.text = "mohammed${Random().nextInt(1000)}@gmail.com";
      passwordController.text = "123456";
      nameController.text = "mohammed";
      if (categories.isEmpty) {
        await AppUtil.loadCategories();
        categories = SharedPref.getCategories()?.obs ?? <AppCategory>[].obs;
      }
      // phoneController.text = Random(773170413).nextInt(1000000000).toString();

      // final ApiResponseModel response =
      //     await ApiController().getAllCategories();
      // if (response.status && (response.data as List).isNotEmpty) {
      //   categoriesList.value = (response.data as List<CategoryModel>)
      //       .map((e) => {'id': e.id!, 'name': e.nameEn})
      //       .toList();
      // }
    } catch (e) {
      print("/////////////Error in signup controller onInit: $e");
      // buildErrorDialog("Something error!.. try again>>");
    }
    super.onInit();
  }

  @override
  void onClose() {
    cityController.dispose();
    districtController.dispose();
    descController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    jobNameController.dispose();
    jobDescController.dispose();
    jobCategoryController.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) imagePath.value = image.path;
  }

  dynamic isPhoneExist() async {
    // CheckEmailExistUseCase checkEmail = di.getIt();
    // return checkEmail(emailController.text);
  }

  Future<Either<Failure, Success>> checkEmail() {
    CheckEmailUseCase checkEmail = di.getIt();
    CheckEmailRequest request = CheckEmailRequest(
      email: emailController.text,
      userName: nameController.text,
    );

    return checkEmail.call(request);
  }

// get the user location
  Future<Position?> getUserLocation() async {
    Position? userLocation;

    try {
      // Check if location services are enabled, and request to enable if not.
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await Geolocator.openLocationSettings();
        if (!serviceEnabled) {
          return null; // Location services were not enabled.
        }
      }

      // Check if the app has location permission, and request it if not granted.
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          AppUtil.showMessage(
              AppLocalization.pleaseGrantRequiredPermission, Colors.red);
          return null; // Location permission was not granted.
        }
      }

      // Get the user's location with high accuracy.
      userLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error while getting location: $e');
    }

    return userLocation;
  }

  Future<void> submitEmailNamePass(bool isProviderSignUp) async {
    if (!(signUpFormKey.currentState?.validate() ?? false)) return;
    EasyLoading.show(status: AppLocalization.loading);
    Get.focusScope!.unfocus(); // اخفاء الكيبورد

    (await checkEmail()).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
    }, (success) async {
      print(success.message);
      isProviderSignUp
          ? Get.to(() => SignUpProviderDataScreen(
                categories:
                    categories.map((category) => category.toJson()).toList(),
                categoryController: jobCategoryController,
                jobNameController: jobNameController,
                jobDescController: jobDescController,
                nextButtonFunction: submitProviderData,
              ))
          : Get.to(() => const SignupDetailsScreen()
              //  ValidateScreen(
              //       message: AppLocalization.pleaseEnterVerifyEmailCode,
              //       resendCodeFunction: resendSignUpCode,
              //       verifyCodeFunction: verifySignUpCode,
              //     )
              );
    });
    EasyLoading.dismiss();
  }

  /// function used to send register data to api
  Future<Either<Failure, User>> sendSignUpUserRequest(String verficationCode,
      {bool isProviderSignUp = false}) async {
    RegisterUserWithEmailUseCase registerUserWithEmail = di.getIt();
    RegisterUserRequest request = RegisterUserRequest.withEmail(
        name: nameController.text,
        password: passwordController.text,
        email: emailController.text,
        image: imagePath.value,
        birthDate: birthDate.value ?? DateTime(2000),
        provider: isProviderSignUp
            ? Provider.addRequest(
                jobName: jobNameController.text,
                jobDesc: jobDescController.text,
                categoryId: int.parse(jobCategoryController.text),
              )
            : null,
        emailVerificationCode: verficationCode,
        gender: Gender.values.byName(selectedGender.value),
        address: Address.addRequest(
          city: cityController.text,
          district: districtController.text,
          desc: descController.text.isNotEmpty ? descController.text : null,
        ));
    // city: cities
    //     .firstWhere(
    //         (element) => element['id'] == selectedCity)['name_en']
    //     .toString(),
    // district: (cityDistricts[selectedCity]!.firstWhere(
    //         (element) => element['id'] == selectedDistrict)['name_en'])
    //     .toString()));

    return await registerUserWithEmail.call(request);
  }

  /// function used when the user click on next button in address screen
  void submitAddressData({
    required String city,
    required String district,
    String? desc,
  }) {
    cityController.text = city;
    districtController.text = district;
    descController.text = desc ?? "";

    Get.to(() => ValidateScreen(
          message: AppLocalization.pleaseEnterVerifyEmailCode,
          resendCodeFunction: resendSignUpCode,
          verifyCodeFunction: verifySignUpCode,
        ));
  }

  /// function used when submit provider data
  Future<void> submitProviderData() async {
    // if (!(jobFormKey.currentState?.validate() ?? false)) return;
    EasyLoading.show(status: AppLocalization.loading);
    Get.focusScope!.unfocus(); // اخفاء الكيبورد
    // Get.toNamed(AppRoutes.verficationSignUp);
    Get.to(
      () => ValidateScreen(
        message: AppLocalization.pleaseEnterVerifyEmailCode,
        resendCodeFunction: resendSignUpCode,
        verifyCodeFunction: verifySignUpCode,
      ),
    );
    EasyLoading.dismiss();
  }

  /// دالة تستخدم للتحقق من كود البريد مع انشاء حساب المستخدم اذا كان الكود صحيح
  Future verifySignUpCode(String verficationCode) async {
    (await sendSignUpUserRequest(verficationCode)).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
    }, (user) {
      AppUtil.showMessage(AppLocalization.successRegister, Colors.green);
      // go to successResetPassword screen
      Get.offAll(() => SuccessScreen(
            message: AppLocalization.successRegister,
            buttonText: AppLocalization.signIn,
            onClick: () => Get.offAllNamed(AppRoutes.logIn),
          ));
      // Get.offNamed(AppRoutes.succesSignUp);
    });
  }

  Future<bool> resendSignUpCode() async {
    EasyLoading.show(status: AppLocalization.loading);
    bool isResend = false;

    (await checkEmail()).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
      isResend = false;
    }, (success) async {
      AppUtil.showMessage(AppLocalization.success, Colors.green);
      isResend = true;
    });
    EasyLoading.dismiss();
    return isResend;
  }

  void changVisible() {
    isVisible = !isVisible;
    update();
  }
}
