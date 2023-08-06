
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



import '../../../../../core/config/app_routes.dart';
import '../../../../../core/services/dependency_injection.dart' as di;
import '../../../../../core_api/errors/failures.dart';
import '../../domain/Requsets/login_request.dart';
import '../../domain/entities/user.dart';
import '../../domain/use_cases/login.dart';
import 'chooseusertype_controller.dart';
import 'forgetpassword_controller.dart';
import 'singup_controller.dart';


class LoginController extends GetxController {
  // bool isVisible = true;
  // bool isLoading = false;
  // late TextEditingController emailController;
  // late TextEditingController passwordController;
  // GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  // late Rx<Either<Failure, User>> loginResult;
 

  // ///تسجيل الدخول
  // Future<void> login() async {
  //   LoginRequest loginRequest = LoginRequest.withEmail(
  //       password: passwordController.text.trim(),
  //       email: emailController.text.trim());
  //   LoginUseCase loginUseCase =di. getIt();
  //   final result = await loginUseCase(loginRequest);

  //   result.fold(
  //     (failure) => loginResult.value = left(failure),
  //     (user) => loginResult.value = right(user),
  //   );
  // }

  // ///
  // goToSignUp() {
  //   Get.lazyPut(() => SignUpController());
  //   Get.offNamed(AppRoutes.signUp);
  // }

  // goToForgetpassword() {
  //   Get.lazyPut(() => ForgetPasswordController());
  //   Get.toNamed(AppRoutes.forgetPassword);
  // }

  // @override
  // void onInit() {
  //   emailController = TextEditingController();
  //   passwordController = TextEditingController();
  //   super.onInit();
  // }

  // @override
  // void onClose() {
  //   emailController.dispose();
  //   passwordController.dispose();
  //   super.onClose();
  // }

  // changVisible() {
  //   isVisible = !isVisible;
  //   update();
  // }

  // goToHomeScreen() {
  //   // Get.lazyPut<MainScreenControllerImp>(() => MainScreenControllerImp());
  //   // Get.toNamed(AppRoute.homeScreen);
  //   // // changLoading();
  //   //     print('home screen $isLoading');
  // }

  // changLoading() {
  //   isLoading = !isLoading;
  //   update();
  // }

  // goToChooseTypeUser() {
  //   Get.lazyPut(() => ChooseUserTypeControllerImp());
  //   Get.offNamed(AppRoutes.chooseUserTypeScreen);
  // }

  // enterAsGuest() {
  //   // SharedPrefs().setUserLoggedInAsGuest(true);
  //   // SharedPrefs().setUserLoggedIn(true);

  //   // Get.lazyPut(() => MainScreenController());
  //   Get.offNamed(AppRoutes.mainScreen);
  // }
}
