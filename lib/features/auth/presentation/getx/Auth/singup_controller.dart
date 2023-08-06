// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../../../core_api/api_response_model.dart';


// class SignUpController extends GetxController {
//   late TextEditingController emailController;
//   late TextEditingController passwordController;
//   late TextEditingController nameController;
//   late TextEditingController phoneController;
//   late TextEditingController jobNameController;
//   late TextEditingController jobCategoryController;
//   late TextEditingController jobDescController;
//   GlobalKey<FormState> signUpFormKey = GlobalKey();
//   GlobalKey<FormState> jobFormKey = GlobalKey();
//   bool isVisible = true;

//   final RxList<Map<String, Object>> categoriesList = RxList([
//     {'id': "1", 'name': 'Developer'},
//     {'id': "2", 'name': 'Designer'},
//     {'id': "3", 'name': 'Consultant'},
//     {'id': "4", 'name': 'Student'},
//   ]);
// // RxString selectedItem = 'Item 1'.obs;

//     @override
//   void onInit() async {
//     try {
//       emailController = TextEditingController();
//       passwordController = TextEditingController();
//       nameController = TextEditingController();
//       phoneController = TextEditingController();
//       jobNameController = TextEditingController();
//       jobDescController = TextEditingController();
//       jobCategoryController = TextEditingController();

//       emailController.text = "hezbr${Random().nextInt(1000)}@gmail.com";
//       passwordController.text = "123456";
//       nameController.text = "hezbr";
//       // phoneController.text = Random(773170413).nextInt(1000000000).toString();

//       final ApiResponseModel response =
//           await ApiController().getAllCategories();
//       if (response.status && (response.data as List).isNotEmpty) {
//         categoriesList.value = (response.data as List<CategoryModel>)
//             .map((e) => {'id': e.id!, 'name': e.nameEn})
//             .toList();
//       }
//     } catch (e) {
//       print("/////////////Error in signup controller onInit: $e");
//       buildErrorDialog("Something error!.. try again>>");
//     }
//     super.onInit();
//   }

//   @override
//   void onClose() {
//     emailController.dispose();
//     passwordController.dispose();
//     nameController.dispose();
//     phoneController.dispose();
//     jobNameController.dispose();
//     jobDescController.dispose();
//     jobCategoryController.dispose();
//     super.onClose();
//   }

//   goToLogIn() {
//     Get.lazyPut(() => LoginController());
//     Get.offNamed(AppRoutes.logIn);
//   }

//   Widget hanldlingWaitingRequest(
//       {required RxBool isLoading, required Widget child}) {
//     return Obx(() => isLoading.value
//         ? const SizedBox(
//             width: 40,
//             height: 40,
//             child: CircularProgressIndicator(
//               backgroundColor: Colors.black,
//             ),
//           )
//         : child);
//   }
// //  var isLoading = false.obs;

// // 

//   dynamic isPhoneExist() async {
//     try {
//       String phone = phoneController.text;
//       ApiResponseModel response = await ApiController().checkPhoneExist(phone);
//       return response.data;
//     } catch (e) {
//       if (e is http.ClientException) {
//         throw ApiError('Request failed: ${e.message}', '');
//       } else {
//         throw ApiError('An error occurred during the request.', '');
//       }
//     }
//   }

//   dynamic isEmailExist() async {
//     try {
//       String email = emailController.text;
//       ApiResponseModel response = await ApiController().checkEmailExist(email);
//       return response.data;
//     } catch (e) {
//       if (e is http.ClientException) {
//         throw ApiError('Request failed: ${e.message}', '');
//       } else {
//         throw ApiError('An error occurred during the request.', '');
//       }
//     }
//   }

//   Future<bool> registerUser() async {
//     ApiResponseModel? response = await ApiController().registerUser(
//       name: nameController.text,
//       phone: phoneController.text,
//       email: emailController.text,
//       password: passwordController.text,
//     );

//     if (response?.status ?? false) {
//       showSnackBar("", "Register succesfully\nPlease verify your email.");
//       // print("////////token:: ${response?.data['token']}");
//       // SharedPrefs().setUserLoggedIn(true);
//       SharedPrefs().setAuthorizationKey(response?.data['token']);
//       return true;
//     } else if (response != null) {
//       handleShowResponseErrors(response.errors!);
//       return false;
//     }
//     return false;
//   }

//   Future<bool> registerProvider() async {
//     ApiResponseModel? response = await ApiController().registerProvider(
//       name: nameController.text,
//       password: passwordController.text,
//       email: emailController.text,
//       phone: phoneController.text,
//       jobName: jobNameController.text,
//       jobDesc: jobDescController.text,
//       categoryId: jobCategoryController.text,
//     );

//     if (response?.status ?? false) {
//       showSnackBar("", "Register succesfully\nPlease verify your email.");
//       // print("////////token:: ${response?.data['token']}");
//       // SharedPrefs().setUserLoggedIn(true);
//       SharedPrefs().setAuthorizationKey(response?.data['token']);
//       return true;
//     } else if (response != null) {
//       handleShowResponseErrors(response.errors!);
//       return false;
//     }
//     return false;
//   }

//   void updateLoginStatus(StatusRequest status) {
//     statusRequest = status;
//     update();
//   }
//   // void showErrorMessage(String message) {

//   //   debugPrint(message);
//   // }

//   //  void verifyEmail(String otpCode, ) async {
//   //   AppUtil.checkInternet().then((hasInternet) async {
//   //     if (hasInternet) {
//   //       statusRequest = StatusRequest.loading;
//   //       // String? authKey =await SharedPrefs().getAuthorizationKey();
//   //       await ApiController()
//   //           .verifyEmail(email: emailController.text.trim(), otpCode:otpCode)
//   //           .then((response) {
//   //         statusRequest = StatusRequest.none;
//   //         if (response!.status) {
//   //           // Email verified successfully, you can navigate to a success screen or perform other actions
//   //           // For example, if you have a SuccessScreen, you can navigate to it using Get.off()
//   //           Get.off(() => const );
//   //         } else {
//   //           // Handle errors and constraints violations here
//   //           if (response.errors != null &&
//   //               response.errors is Map<String, dynamic>) {
//   //             Map<String, dynamic>? errors = response.errors;
//   //             // Handle constraint violations
//   //             // You can access the error details using the 'errors' map
//   //             // For example, to show an error message for 'email':
//   //             if (errors!.containsKey('email')) {
//   //               showErrorMessage(errors['email'][0], );
//   //             }
//   //             // Handle 'otp_code' errors
//   //             if (errors.containsKey('otp_code')) {
//   //               showErrorMessage(errors['otp_code'][0], );
//   //             }
//   //             // Handle other fields' errors as needed
//   //           } else {
//   //             // Handle other errors
//   //             if (response.code == 'E00013') {
//   //               showErrorMessage('Constriants violation, The given data is invalid.', );
//   //             } else if (response.code == 'E00014') {
//   //               showErrorMessage('OTP does not exist', );
//   //             } else {
//   //               showErrorMessage('Failed to verify email', );
//   //             }
//   //           }
//   //         }
//   //       }).catchError((error) {
//   //         // Handle any other errors that might occur during the API call
//   //         debugPrint('Error: $error');
//   //         showErrorMessage('An error occurred during the request.', );
//   //       });
//   //     } else {
//   //       showErrorMessage('No internet connection', );
//   //     }
//   //   });
//   // }
//   goToVerficationSignUp() {
//     Get.lazyPut(() => VerficationSignUpController());
//     Get.offNamed(AppRoutes.verficationSignUp);
//   }

//   goToSuccesSignUp() {
//     Get.offNamed(AppRoutes.succesSignUp);
//   }

//   changVisible() {
//     isVisible = !isVisible;
//     update();
//   }

//   //
//   // firebaseAuth() {
//   //   FirebaseAuth.instance.authStateChanges().listen((User? user) {
//   //     if (user == null) {
//   //       print('User is currently signed out!');
//   //     } else {
//   //       print('User is signed in!');
//   //     }
//   //     if (user != null) {
//   //       print(user.uid);
//   //     }
//   //   });
//   //   FirebaseAuth.instance.userChanges().listen((User? user) {
//   //     if (user == null) {
//   //       print('User is currently signed out!');
//   //     } else {
//   //       print('User is signed in!');
//   //     }
//   //   });
//   // }

//   //
//   // firebaseSignup() async {
//   //   try {
//   //     UserCredential userCredential =
//   //         await FirebaseAuth.instance.createUserWithEmailAndPassword(
//   //       email: emailController.text.trim(),
//   //       password: passwordController.text.trim(),
//   //     );
//   //     goToSuccesSignUp();
//   //     return userCredential;
//   //   } on FirebaseAuthException catch (e) {
//   //     if (e.code == 'weak-password') {
//   //       Get.defaultDialog(
//   //           title: 'Error',
//   //           content: const Text('The password provided is too weak.'),
//   //           onConfirm: () => Get.back(),
//   //           middleText: "");
//   //       print('The password provided is too weak.');
//   //     } else if (e.code == 'email-already-in-use') {
//   //       Get.defaultDialog(
//   //           title: 'Error',
//   //           content: const Text('The account already exists for that email.'),
//   //           onConfirm: () => Get.back(),
//   //           middleText: "");
//   //       print('The account already exists for that email.');
//   //     }
//   //   } catch (e) {
//   //     statusRequest=StatusRequest.failure;
//   //     print(e);
//   //   }
//   //   update();
//   // }

//   //
//   // sendEmailVerification() async {
//   //   User? user = FirebaseAuth.instance.currentUser;

//   //   if (user != null && !user.emailVerified) {
//   //     await user.sendEmailVerification();
//   //   }
//   // }
// }
