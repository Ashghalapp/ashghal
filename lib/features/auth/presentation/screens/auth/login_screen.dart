import 'package:ashghal_app_frontend/config/app_icons.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core/widget/app_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../config/app_routes.dart';
import '../../../../../core/localization/app_localization.dart';
import '../../../../../core/util/validinput.dart';
import '../../../../../core/widget/app_buttons.dart';
import '../../../../../core/widget/app_textformfield.dart';
import '../../getx/Auth/login_controller.dart';
import '../../widgets/logo.dart';
import '../../widgets/social_icons.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AppScaffold(
      // appBarTitle:  LocalizationString.signIn,
      onBack: () => AppUtil.exitApp(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: ListView(
          children: [
            const LogoWidget(),
            const SizedBox(
              height: 30,
            ),
            Text(
              textAlign: TextAlign.center,
              AppLocalization.logintoyouraccount,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(
              height: 30,
            ),
            // Text(
            //   LocalizationString.signInMessage,
            //   style:Theme.of(context).textTheme.bodyMedium,
            //   textAlign: TextAlign.center,
            // ),

            Form(
              key: controller.loginFormKey,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    // text
                    AppTextFormField(
                      hintText: AppLocalization.enterYourEmail,
                      // iconName:Icons.email_outlined,
                      iconName: AppIcons.email,
                      label: AppLocalization.email,
                      obscureText: false,
                      controller: controller.emailController,
                      validator: (val) {
                        return validInput(val?.trim(), 10, 50, 'email');
                      },
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    GetBuilder<LoginController>(
                      init: LoginController(),
                      initState: (_) {},
                      builder: (_) {
                        return AppTextFormField(
                          sufficxIconDataName: controller.isVisible
                              // ? Icons.visibility_off_outlined
                              // : Icons.visibility_outlined,
                              ? AppIcons.hide
                              : AppIcons.show,
                          obscureText: controller.isVisible,
                          onSuffixIconPressed: () => controller.changVisible(),
                          hintText: AppLocalization.pleaseEnterPassword,
                          // iconName: Iconsax.lock,
                          iconName: AppIcons.lock,
                          label: AppLocalization.password,
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
                            onPressed: () =>
                                Get.toNamed(AppRoutes.forgetPassword),
                            child: Text(
                              AppLocalization.forgotPwd,
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.labelMedium,
                            ))
                      ],
                    ),

                    AppGesterDedector(
                      text: AppLocalization.signIn,
                      color: Theme.of(context).primaryColor,
                      onTap: () {
                        controller.login();
                      },
                    ),
                    TextButton(
                      style: TextButton.styleFrom(shadowColor: Colors.white),
                      onPressed: () {
                        Get.offNamed(AppRoutes.mainScreen);
                      },
                      child: Text(
                        AppLocalization.enterAsGuest,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    const OrContiueWithWidget(),

                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    const SocialIconsWidget(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          style: Theme.of(context).textTheme.labelSmall,
                          AppLocalization.dontHaveAccount,
                        ),
                        TextButton(
                          onPressed: () => Get.toNamed(
                            AppRoutes.chooseUserTypeScreen,
                          ),
                          child: Text(AppLocalization.signUp,
                              style: Get.textTheme.labelMedium),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SocialIconsWidget extends StatelessWidget {
  const SocialIconsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialIcons(
          icon: 'facebook',
          press: () {},
        ),
        SocialIcons(icon: 'google', press: () {}),
        SocialIcons(
          icon: 'apple',
          press: () {},
        ),
      ],
    );
  }
}

class OrContiueWithWidget extends StatelessWidget {
  const OrContiueWithWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            color: Theme.of(context).dividerColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            AppLocalization.orContinueWith,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        Expanded(
          child: Divider(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ],
    );
  }
}
