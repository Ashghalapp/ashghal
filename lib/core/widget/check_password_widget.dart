import 'package:ashghal_app_frontend/config/app_icons.dart';
import 'package:ashghal_app_frontend/config/app_routes.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/services/dependency_injection.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core/util/validinput.dart';
import 'package:ashghal_app_frontend/core/widget/app_textformfield.dart';
import 'package:ashghal_app_frontend/core/widget/scale_down_transition.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/use_cases/user_usecases/check_password_uc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class CheckPasswordWidget extends StatelessWidget {
  final void Function() onCorrectCheck;
  CheckPasswordWidget({super.key, required this.onCorrectCheck});

  final controller = Get.put(CheckPasswordController());

  @override
  Widget build(BuildContext context) {
    // controller.errorPassword.value = null;
    // controller.passwordController.text = "";
    final animationCon = AnimationController(
      vsync: Navigator.of(context),
      duration: const Duration(milliseconds: 450),
    );

    final scaleAnimation = CurvedAnimation(
      parent: animationCon..forward(),
      curve: Curves.easeIn,
      reverseCurve: Curves.elasticOut,
    );  

    return Center(
      child: ScaleTransition(
        scale: scaleAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          color: Theme.of(context).scaffoldBackgroundColor,
          // color: Get.theme.scaffoldBackgroundColor,
          // height: 500,
          // width: Get.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: AlignmentDirectional.center,
                margin: const EdgeInsets.all(10),
                child: Text(AppLocalization.pleaseEnterYourPassword.tr),
              ),
      
              // old password
              Form(
                key: controller.formKey,
                child: Obx(
                  () => AppTextFormField(
                    sufficxIconDataName: controller.securePassword.value
                        ? AppIcons.hide
                        : AppIcons.show,
                    obscureText: controller.securePassword.value,
                    onSuffixIconPressed: () => controller.changPasswordVisible(),
                    controller: controller.passwordController,
                    // labelText: AppLocalization.oldPassword,
                    hintText: AppLocalization.enterYourPassword,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    validator: (val) => validInput(val!, 6, 30, 'password'),
                    errorText: controller.errorPassword.value,
                    margin: const EdgeInsets.only(top: 10),
                  ),
                ),
              ),
      
              // forget password
              Container(
                height: 35,
                margin: const EdgeInsets.only(bottom: 10),
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.forgetPassword),
                  child: Text(
                    AppLocalization.forgetPassword,
                    style: Get.textTheme.labelSmall,
                  ),
                ),
              ),
      
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ScaleDownTransitionWidget(
                      child: TextButton(
                        onPressed: () async {
                          await animationCon.reverse();
                          Get.back();
                        },
                        child: Text(AppLocalization.cancel),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        if (await controller.checkPassword()) {
                          await animationCon.reverse();
                          onCorrectCheck();
                        }
                      },
                      child: Text(AppLocalization.check),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CheckPasswordController extends GetxController {
  late GlobalKey<FormState> formKey;
  RxBool securePassword = true.obs;
  late TextEditingController passwordController;
  Rx<String?> errorPassword = Rx(null);

  @override
  void onInit() {
    passwordController = TextEditingController();
    formKey = GlobalKey<FormState>();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    // Get.delete<CheckPasswordController>();
    // formKey.currentState?.deactivate();
    // passwordController.dispose();
  }

  void changPasswordVisible() {
    securePassword.value = !securePassword.value;
  }

  Future<bool> checkPassword() async {
    if (!(formKey.currentState?.validate() ?? false)) return false;

    EasyLoading.show(status: AppLocalization.loading);
    final CheckPasswordUseCase checkPasswordUC = getIt();
    final result = (await checkPasswordUC.call(passwordController.text)).fold(
      (failure) {
        // AppUtil.hanldeAndShowFailure(failure);
        errorPassword.value = failure.message;
        return false;
      },
      (checkResult) {
        // AppUtil.showMessage(checkResult.toString(), Colors.green);
        if (!checkResult) {
          errorPassword.value = AppLocalization.incorrectPassword;
        }
        return checkResult;
      },
    );
    EasyLoading.dismiss();
    return result;
  }
}
