
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../../../core/constant/app_colors.dart';
// import '../../../../../core/core/localization/localization_strings.dart';
// import '../../../../../core/core/widget/app_buttons.dart';
// import '../../widgets/my_appbartext.dart';





// class VerficationResetpasswordScreen
//     extends GetView<VerficationResetPasswordController> {
//   const VerficationResetpasswordScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         title:  MyAppBarText(
//           text: LocalizationString.verify,
//         ),
//         // ignore: prefer_const_constructors
//         leading: MyCircularIconButton(
//           onPressed: () {
//             Get.back();
//           },
//           iconData: Icons.arrow_back_ios,
//           iconColor: AppColors.gray,
//         ),
//       ),
//       body: Container(
//         padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 15),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Text(
//                 textAlign: TextAlign.center,
//            LocalizationString.otpVerification,
//                 style: Theme.of(context).textTheme.displayMedium,
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//                Text(
//                LocalizationString.pleaseEnterOneTimePassword,
//                 style: const TextStyle(color: AppColors.gray),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 30),
//               Form(
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: Column(
//                     children: [
//                       OtpTextField(
//                         clearText: true,
//                         focusedBorderColor: Theme.of(context).primaryColor,
//                         fieldWidth:50,
//                         cursorColor: Theme.of(context).primaryColor,
//                         borderRadius: BorderRadius.circular(20),
//                         numberOfFields: 6,
//                         borderColor: Theme.of(context).primaryColor,
//                         //set to true to show as box or false to show as dash
//                         showFieldAsBox: true,
//                         //runs when a code is typed in
//                         onCodeChanged: (String code) {
//                           //handle validation or checks here
//                         },
//                         //runs when every textfield is filled
//                         onSubmit: (String verificationCode) {
                          
//                           controller.checkCode(verificationCode);
//                         }, // end onSubmit
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                          GetBuilder<VerficationResetPasswordController>(
//                 builder: (controller) {
//                   RxInt remainingSeconds = controller.remainingSeconds;
//                   return Column(
//                     children: [
//                       if (remainingSeconds.value <= 0)
//                         TextButton(
//                           onPressed: () {
//                             controller.resendCode();
//                           },
//                           child:  Text(
//                             'Resend Code',
//                             style: TextStyle(color: Theme.of(context).primaryColor),
//                           ),
//                         ),
//                       if (remainingSeconds.value > 0)
//                        Obx(() =>  Text(
//                           'Resend code in ${remainingSeconds.value} seconds',
//                           style: const TextStyle(color: AppColors.gray),
//                         ),)
//                     ],
//                   );
//                 },
//               ),
                 
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
