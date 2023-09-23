import 'dart:math';

import 'package:ashghal_app_frontend/app_library/app_data_types.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/core_api/success/success.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/check_email_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/register_user_provider_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/check_email_uc.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/register_user_with_email_uc.dart';
import 'package:ashghal_app_frontend/features/auth/presentation/screens/success_screen.dart';
import 'package:ashghal_app_frontend/features/auth/presentation/screens/validate_screen.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

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
  // RxBool isLoading = RxBool(false);
  bool isVisible = true;

  final RxList<Map<String, Object>> categoriesList = RxList([
    {'id': "1", 'name': 'Developer'},
    {'id': "2", 'name': 'Designer'},
    {'id': "3", 'name': 'Consultant'},
    {'id': "4", 'name': 'Student'},
  ]);
// RxString selectedItem = 'Item 1'.obs;

  @override
  void onInit() async {
    try {
      emailController = TextEditingController();
      passwordController = TextEditingController();
      nameController = TextEditingController();
      phoneController = TextEditingController();
      jobNameController = TextEditingController();
      jobDescController = TextEditingController();
      jobCategoryController = TextEditingController();

      emailController.text = "hezbr${Random().nextInt(1000)}@gmail.com";
      passwordController.text = "123456";
      nameController.text = "hezbr";
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
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    jobNameController.dispose();
    jobDescController.dispose();
    jobCategoryController.dispose();
    super.onClose();
  }

  dynamic isPhoneExist() async {
    // CheckEmailExistUseCase checkEmail = di.getIt();
    // return checkEmail(emailController.text);
  }

  Future<Either<Failure, Success>> checkEmail() {
    CheckEmailUseCase checkEmail = di.getIt();
    CheckEmailRequest request = CheckEmailRequest(
        email: emailController.text, userName: nameController.text);

    return checkEmail.call(request);
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
          ? Get.toNamed(AppRoutes.singUpJobScreen)
          // : Get.toNamed(AppRoutes.verficationSignUp);
          : Get.to(
              () => ValidateScreen(
                message: AppLocalization.pleaseEnterVerifyEmailCode,
                resendCodeFunction: resendSignUpCode,
                submitCodeFunction: verifySignUpCode,
              ),
            );
    });
    EasyLoading.dismiss();
  }

  Future<Either<Failure, User>> signUpUser(String verficationCode,
      {bool isProviderSignUp = false}) async {
    RegisterUserWithEmailUseCase registerUserWithEmail = di.getIt();
    RegisterUserRequest request = RegisterUserRequest.withEmail(
      name: nameController.text,
      password: passwordController.text,
      email: emailController.text,
      birthDate: DateTime.now(),
      provider: isProviderSignUp
          ? ProviderDataRequest(
              jobName: jobNameController.text,
              jobDesc: jobDescController.text,
              categoryId: int.parse(jobCategoryController.text),
            )
          : null,
      emailVerificationCode: verficationCode,
      gender: Gender.male,
    );

    return await registerUserWithEmail.call(request);
  }

  Future<void> submitJobInfo() async {
    if (!(jobFormKey.currentState?.validate() ?? false)) return;
    EasyLoading.show(status: AppLocalization.loading);
    Get.focusScope!.unfocus(); // اخفاء الكيبورد
    // Get.toNamed(AppRoutes.verficationSignUp);
    Get.to(
      () => ValidateScreen(
        message: AppLocalization.pleaseEnterVerifyEmailCode,
        resendCodeFunction: resendSignUpCode,
        submitCodeFunction: verifySignUpCode,
      ),
    );
    EasyLoading.dismiss();
  }

  /// دالة تستخدم للتحقق من كود البريد مع انشاء حساب المستخدم اذا كان الكود صحيح
  Future verifySignUpCode(String verficationCode) async {
    (await signUpUser(verficationCode)).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
    }, (user) {
      AppUtil.showMessage('Successfully Registered', Colors.green);
      Get.offAll(
          () => const SuccesResetPassword(message: 'Successfully Registered'));
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
