
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../../../config/app_colors.dart';

import '../../../../../core/localization/localization_strings.dart';
import '../../../../../core/util/validinput.dart';
import '../../../../../core/widget/app_buttons.dart';
import '../../../../../core/widget/app_textformfield.dart';
import '../../getx/Auth/login_controller.dart';
import '../../widgets/social_icons.dart';


class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => LoginController());
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          LocalizationString.signIn,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            // fontSize: 22,
            color: AppColors.SECONDARY_TEXT,
          ),
        ),
        leading: MyCircularIconButton(
          onPressed: () {
            // Get.back();
            // Get.toNamed(AppRoute.onBoarding);
          },
          iconData: Icons.arrow_back_ios,
          iconColor: AppColors.secondaryText,
        ),
        actions: [
          IconButton(
            onPressed: () {
              ///تغيير الثيم لابيض او اسود
              // Get.changeTheme(
              //     Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
            },
            icon: Icon(Get.isDarkMode
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined),
            color: AppColors.secondaryText,
          )
        ],
      ),
      body: WillPopScope(
        ///دالة لمنع الخروج من التطبيق
        onWillPop: () =>AppUtil. exitApp(context),
        child:

            Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ///صورة لتسجيل الدخول
              // Center(
              //   child: SvgPicture.asset(
              //     'assets/images/login.svg',
              //     height: size.height * 0.35,
              //   ),
              // ),
  
              Text(
                textAlign: TextAlign.center,
                LocalizationString.welcome,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                LocalizationString.signInMessage,
                style: const TextStyle(color: AppColors.gray),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Form(
                key: controller.loginFormKey,
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      MyTextFormField(
                        hintText: LocalizationString.enterYourEmail,
                        iconData: Icons.email_outlined,
                        lable: LocalizationString.email,
                        obscureText: false,
                        controller: controller.emailController,
                        validator: (val) {
                          return validInput(val!, 10, 50, 'email');
                        },

                        ///حقل ادخال لرقم الهاتف
                      ),
                      // MyTextFormField(
                      //   textDirection:  MyServices().box.read('lang')=='ar'?TextDirection.ltr:TextDirection.rtl,
                      //   textInputtype: TextInputType.number,
                      //   inputformater: <TextInputFormatter>[
                      //     FilteringTextInputFormatter.digitsOnly
                      //   ],
                      //   prefixtext: '+967  ',
                      //   hintText: '22'.tr,
                      //   iconData: Icons.phone,
                      //   lable: '56'.tr,
                      //   obscureText: false,
                      //   controller: controller.emailController,
                      //   validator: (val) {
                      //     return validInput(
                      //         val!, 9, 9, 'phonenumber');
                      //   },
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      GetBuilder<LoginController>(
                        init: LoginController(),
                        initState: (_) {},
                        builder: (_) {
                          return MyTextFormField(
                            sufficxIconData: controller.isVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            obscureText: controller.isVisible,
                            onPressed: () => controller.changVisible(),
                            hintText: LocalizationString.pleaseEnterPassword,
                            iconData: Icons.lock_open_outlined,
                            lable: LocalizationString.password,
                            controller: controller.passwordController,
                            validator: (val) {
                              return validInput(val!, 6, 50, 'password');
                            },
                          );
                        },
                      ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () => controller.goToForgetpassword(),
                              child: Text(
                                LocalizationString.forgotPwd,
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.secondaryText),
                              ))
                        ],
                      ),

                      MyGesterDedector(
                        text: '9'.tr,
                        color: Theme.of(context).primaryColor,
                        onTap: () {
                          controller.login();
                        },
                      ),

                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.SECONDARY_TEXT,
                            ),
                            '16'.tr,
                          ),
                          TextButton(
                            style:
                                TextButton.styleFrom(shadowColor: Colors.white),
                            onPressed: () {
                              controller.goToChooseTypeUser();
                            },
                            child: Text(
                              '17'.tr,
                              style:  TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialIcons(
                            icon: 'facebook',
                            press: () {},
                          ),
                          SocialIcons(icon: 'twitter', press: () {}),
                          SocialIcons(icon: 'google-plus', press: () {}),
                        ],
                      ),
                      TextButton(
                        style: TextButton.styleFrom(shadowColor: Colors.white),
                        onPressed: () {
                          controller.enterAsGuest();
                        },
                        child:  Text(
                          "Guest",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        //   ),
        // ),
      ),
    );
  }
}
