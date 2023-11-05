import 'package:ashghal_app_frontend/config/app_routes.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/services/dependency_injection.dart'
    as di;
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core/util/dialog_util.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/use_cases/user_usecases/delete_account_uc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  void logOut() { 
    SharedPref.logout();
    Get.offAllNamed(AppRoutes.logIn);
  }

  Future<void> submitDeleteAccount() async {
    DialogUtil.showDialog(
      title: AppLocalization.warning,
      message: AppLocalization.areYouSureToDeleteYourAccount,
      submitText: AppLocalization.sure,
      onSubmit: () {
        Get.back();
        DialogUtil.showDialog(
          title: AppLocalization.warning,
          message: AppLocalization.noteForDeleteAccount,
          onSubmit: () {
            Get.back();
            DialogUtil.showDialog(
              title: AppLocalization.warning,
              message:
                  AppLocalization.noteForDeleteAccountThatWillDeleteAllPosts,
              onSubmit: () {
                Get.back();
                deleteAccount();
              },
              submitText: AppLocalization.delete,
            );
          },
          submitText: AppLocalization.confirm,
        );
      },
    );
  }

  Future<void> deleteAccount() async {
    EasyLoading.show(status: AppLocalization.loading);
    DeleteAccountUseCase deleteAccountUC = di.getIt();

    (await deleteAccountUC.call()).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
    }, (success) {
      AppUtil.showMessage(success.message, Colors.green);
      logOut();
    });
    EasyLoading.dismiss();
  }
}
