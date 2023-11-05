import 'package:ashghal_app_frontend/config/app_icons.dart';
import 'package:ashghal_app_frontend/core/widget/app_dropdownbuttonformfield.dart';
import 'package:ashghal_app_frontend/core/widget/app_scaffold_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../config/app_routes.dart';
import '../../../../../core/localization/app_localization.dart';
import '../../../../../core/util/validinput.dart';
import '../../../../../core/widget/app_buttons.dart';
import '../../../../../core/widget/app_textformfield.dart';
import '../../getx/Auth/singup_controller.dart';
import '../../widgets/social_icons.dart';
import '../validate_screen.dart';
import 'login_screen.dart';

class SignUpScreen extends GetView<SignUpController> {
  SignUpScreen({super.key});
  final RxBool isLoading = RxBool(false);
  final bool? isProviderSignUp = Get.arguments?['isProvider'] ?? false;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SignUpController());
    Size size = MediaQuery.of(context).size;
    return AppScaffold(
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
              AppLocalization.createNewAccount,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 30),
            Form(
              key: controller.signUpFormKey,
              child: Column(
                children: [
                  AppTextFormField(
                    // labelText: AppLocalization.fullName,
                    // iconName: Icons.person_outline_outlined,
                    iconName: AppIcons.user,
                    hintText: AppLocalization.fullName,
                    obscureText: false,
                    controller: controller.nameController,
                    validator: (val) {
                      return validInput(val!, 5, 20, 'name');
                    },
                  ),
                  const SizedBox(height: 20),

                  // MyTextFormField(
                  //   textInputtype: TextInputType.number,
                  //   inputformater: <TextInputFormatter>[
                  //     FilteringTextInputFormatter.digitsOnly
                  //   ],
                  //   prefixtext: "+967 ",
                  //   hintText: '22'.tr,
                  //   iconData: Icons.phone_iphone_rounded,
                  //   lable: '56'.tr,
                  //   obscureText: false,
                  //   controller: controller.phoneController,
                  //   validator: (val) {
                  //     return validInput(val!, 9, 9, 'phonenumber');
                  //   },
                  // ),
                  // const SizedBox(height: 20),

                  AppTextFormField(
                    // labelText: AppLocalization.email,
                    // iconName: Icons.email_outlined,
                    iconName: AppIcons.email,
                    hintText: AppLocalization.enterYourEmail,
                    obscureText: false,
                    controller: controller.emailController,
                    validator: (val) {
                      return validInput(val!, 10, 50, 'email');
                    },
                  ),
                  const SizedBox(height: 20),

                  GetBuilder<SignUpController>(
                    init: SignUpController(),
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
                        // labelText: AppLocalization.password,
                        // iconName: Icons.lock_open_outlined,
                        iconName: AppIcons.lock,
                        hintText: AppLocalization.password,
                        controller: controller.passwordController,
                        validator: (val) {
                          return validInput(val!, 6, 50, 'password');
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // next button
                  AppGesterDedector(
                    text: AppLocalization.next,
                    color: Theme.of(context).primaryColor,
                    onTap: () async => await controller
                        .submitEmailNamePass(isProviderSignUp ?? false),
                  ),
                  SizedBox(height: size.height * 0.04),
                  const OrContiueWithWidget(),
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
                      SocialIcons(
                        icon: 'google',
                        press: () {},
                      ),
                      SocialIcons(
                        icon: 'apple',
                        press: () {},
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        style: Theme.of(context).textTheme.labelSmall,
                        AppLocalization.alreadyHaveAcc,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(shadowColor: Colors.white),
                        onPressed: () => Get.offAllNamed(
                          AppRoutes.logIn,
                        ),
                        child: Text(AppLocalization.login,
                            style: Get.textTheme.labelMedium),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignupAddressScreen extends GetView<SignUpController> {
  const SignupAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalization.addAddress)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          const SizedBox(height: 20),
          Form(
            key: controller.addressFormKey,
            child: Column(
              children: [
                // City DropDownButton
                AppDropDownButton(
                  items: controller.cities
                      .map<Map<String, Object>>((e) => {
                            'id': e['id'] ?? 1,
                            'name': Get.locale?.languageCode == 'ar'
                                ? e['name_ar'] ?? ''
                                : e['name_en'] ?? ''
                          })
                      .toList(),
                  // initialValue: controller.selectedCity.value,
                  labelText: 'City',
                  hintText: 'Select a city',
                  onChange: (selectedValue) {
                    controller.selectedCity.value =
                        int.parse(selectedValue.toString());
                    controller.updateDistrictDropdown(
                        int.parse(selectedValue.toString()));
                  },
                ),
                const SizedBox(height: 20),
                Obx(() => AppDropDownButton(
                      items: controller
                              .cityDistricts[controller.selectedCity.value]
                              ?.map<Map<String, Object>>((e) => {
                                    'id': e['id'] ?? 1,
                                    'name': Get.locale?.languageCode == 'ar'
                                        ? e['name_ar'] ?? ''
                                        : e['name_en'] ?? ''
                                  })
                              .toList() ??
                          [],
                      // initialValue: controller.selectedDistrict.value,
                      labelText: 'District',
                      hintText: 'Select a district',
                      onChange: (selectedValue) {
                        controller.selectedDistrict =
                            int.parse(selectedValue.toString());
                      },
                    )),
                // description form field
                AppTextFormField(
                  obscureText: false,
                  controller: controller.descController,
                  labelText:
                      "${AppLocalization.description} ${AppLocalization.optional}",
                  minLines: 4,
                  maxLines: 6,
                  hintText: AppLocalization.enterAddressDescription,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          //
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: AppGesterDedector(
              text: AppLocalization.next,
              onTap: () {
                print(controller.cities.firstWhere((element) => element['id']==controller.selectedCity.value)['name_en']);
                print((controller.cityDistricts[controller.selectedCity]!.firstWhere((element) => element['id']==controller.selectedDistrict)['name_en']).toString());
                Get.focusScope?.unfocus();
                if (controller.addressFormKey.currentState?.validate() ??
                    false) {
                  ValidateScreen(
                    message: AppLocalization.pleaseEnterVerifyEmailCode,
                    resendCodeFunction: controller.resendSignUpCode,
                    verifyCodeFunction: controller.verifySignUpCode,
                  );
                  // onSubmit(
                  //   city: controller.cityController.text,
                  //   street: controller.streetController.text,
                  //   desc: controller.descController.text,
                  // );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
