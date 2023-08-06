import 'dart:math';

import 'package:ashghal_app_frontend/core/localization/localization_strings.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/auth/domain/Requsets/register_user_provider_request.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/check_email_exist.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/register_provider_with_email.dart';
import 'package:ashghal_app_frontend/features/auth/domain/use_cases/register_user_with_email.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/config/app_routes.dart';
import 'login_controller.dart';
import 'verficationsignup_controller.dart';
import '../../../../core/services/dependency_injection.dart' as di;

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
  RxBool isLoading = RxBool(false);
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
      // print("/////////////Error in signup controller onInit: $e");
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

  goToLogIn() {
    Get.lazyPut(() => LoginController());
    Get.offNamed(AppRoutes.logIn);
  }

  dynamic isPhoneExist() async {
    // CheckEmailExistUseCase checkEmail = di.getIt();
    // return checkEmail(emailController.text);
  }

  Future<Either<Failure, bool>> isEmailExist() {
    CheckEmailExistUseCase checkEmail = di.getIt();
    return checkEmail(emailController.text);
  }

  Future<void> submitEmailNamePass(bool isProviderSignUp) async {
    if (!signUpFormKey.currentState!.validate()) return;
    isLoading.value = true;
    Get.focusScope!.unfocus(); // اخفاء الكيبورد
    (await isEmailExist()).fold((failure) {
      AppUtil.showMessage(failure.message, Get.theme.colorScheme.error);
    }, (isExist) async {
      if (isExist) {
        AppUtil.showMessage(LocalizationString.emailAlreadyExist, Get.theme.colorScheme.error);
      } else {
        isProviderSignUp
            ? Get.toNamed(AppRoutes.singUpScreenJob)
            : (await registerUser())
                ? Get.toNamed(AppRoutes.verficationSignUp)
                : AppUtil.showMessage(
                    LocalizationString.failed, Get.theme.colorScheme.error);
        // if (isProviderSignUp) {
        //   Get.toNamed(AppRoutes.singUpScreenJob);
        // } else if (await registerUser()) {
        //   Get.toNamed(AppRoutes.verficationSignUp);
        // } else {
        //   AppUtil.showMessage(
        //       LocalizationString.failed, Get.theme.colorScheme.error);
        // }
      }
    });
    isLoading.value = false;
  }

  Future<bool> registerUser() async {
    RegisterUserWithEmailUseCase registerUserWithEmail= di.getIt();
    RegisterUserRequest request = RegisterUserRequest.withEmail(
      name: nameController.text,
      password: passwordController.text,
      email: emailController.text,
    );
    var result = await registerUserWithEmail.call(request);
    return result.fold((failure) {
      AppUtil.showMessage(failure.message, Get.theme.colorScheme.error);
      return false;
    }, (user) {
      // some code for user data
      AppUtil.showMessage(LocalizationString.successRegister, Colors.green);
      return true;
    });
  }

  Future<void> submitJobInfo() async {
    if (!jobFormKey.currentState!.validate()) return;
    isLoading.value = true;
    Get.focusScope!.unfocus(); // اخفاء الكيبورد
    if (await registerProvider()) Get.toNamed(AppRoutes.verficationSignUp);    
    isLoading.value = false;
  }
  
  Future<bool> registerProvider() async {
    RegisterProviderWithEmailUseCase registerProviderWithEmail= di.getIt();
    RegisterProviderRequest request = RegisterProviderRequest.withEmail(
      name: nameController.text,
      password: passwordController.text,
      email: emailController.text,
      jobName: jobNameController.text,
      jobDesc: jobDescController.text,
      categoryId: int.parse(jobCategoryController.text),
    );
    var result = await registerProviderWithEmail.call(request);
    return result.fold((failure) {
      AppUtil.showMessage(failure.message, Get.theme.colorScheme.error);
      return false;
    }, (provider) {
      // some code for provider data      
      AppUtil.showMessage(LocalizationString.successRegister, Colors.green);
      return true;
    });
  }


  //  void verifyEmail(String otpCode, ) async {
  //   AppUtil.checkInternet().then((hasInternet) async {
  //     if (hasInternet) {
  //       statusRequest = StatusRequest.loading;
  //       // String? authKey =await SharedPrefs().getAuthorizationKey();
  //       await ApiController()
  //           .verifyEmail(email: emailController.text.trim(), otpCode:otpCode)
  //           .then((response) {
  //         statusRequest = StatusRequest.none;
  //         if (response!.status) {
  //           // Email verified successfully, you can navigate to a success screen or perform other actions
  //           // For example, if you have a SuccessScreen, you can navigate to it using Get.off()
  //           Get.off(() => const );
  //         } else {
  //           // Handle errors and constraints violations here
  //           if (response.errors != null &&
  //               response.errors is Map<String, dynamic>) {
  //             Map<String, dynamic>? errors = response.errors;
  //             // Handle constraint violations
  //             // You can access the error details using the 'errors' map
  //             // For example, to show an error message for 'email':
  //             if (errors!.containsKey('email')) {
  //               showErrorMessage(errors['email'][0], );
  //             }
  //             // Handle 'otp_code' errors
  //             if (errors.containsKey('otp_code')) {
  //               showErrorMessage(errors['otp_code'][0], );
  //             }
  //             // Handle other fields' errors as needed
  //           } else {
  //             // Handle other errors
  //             if (response.code == 'E00013') {
  //               showErrorMessage('Constriants violation, The given data is invalid.', );
  //             } else if (response.code == 'E00014') {
  //               showErrorMessage('OTP does not exist', );
  //             } else {
  //               showErrorMessage('Failed to verify email', );
  //             }
  //           }
  //         }
  //       }).catchError((error) {
  //         // Handle any other errors that might occur during the API call
  //         debugPrint('Error: $error');
  //         showErrorMessage('An error occurred during the request.', );
  //       });
  //     } else {
  //       showErrorMessage('No internet connection', );
  //     }
  //   });
  // }
  goToVerficationSignUp() {
    Get.lazyPut(() => VerficationSignUpController());
    Get.offNamed(AppRoutes.verficationSignUp);
  }

  goToSuccesSignUp() {
    Get.offNamed(AppRoutes.succesSignUp);
  }

  changVisible() {
    isVisible = !isVisible;
    update();
  }

  //
  // firebaseAuth() {
  //   FirebaseAuth.instance.authStateChanges().listen((User? user) {
  //     if (user == null) {
  //       print('User is currently signed out!');
  //     } else {
  //       print('User is signed in!');
  //     }
  //     if (user != null) {
  //       print(user.uid);
  //     }
  //   });
  //   FirebaseAuth.instance.userChanges().listen((User? user) {
  //     if (user == null) {
  //       print('User is currently signed out!');
  //     } else {
  //       print('User is signed in!');
  //     }
  //   });
  // }

  //
  // firebaseSignup() async {
  //   try {
  //     UserCredential userCredential =
  //         await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: emailController.text.trim(),
  //       password: passwordController.text.trim(),
  //     );
  //     goToSuccesSignUp();
  //     return userCredential;
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       Get.defaultDialog(
  //           title: 'Error',
  //           content: const Text('The password provided is too weak.'),
  //           onConfirm: () => Get.back(),
  //           middleText: "");
  //       print('The password provided is too weak.');
  //     } else if (e.code == 'email-already-in-use') {
  //       Get.defaultDialog(
  //           title: 'Error',
  //           content: const Text('The account already exists for that email.'),
  //           onConfirm: () => Get.back(),
  //           middleText: "");
  //       print('The account already exists for that email.');
  //     }
  //   } catch (e) {
  //     statusRequest=StatusRequest.failure;
  //     print(e);
  //   }
  //   update();
  // }

  //
  // sendEmailVerification() async {
  //   User? user = FirebaseAuth.instance.currentUser;

  //   if (user != null && !user.emailVerified) {
  //     await user.sendEmailVerification();
  //   }
  // }
}
