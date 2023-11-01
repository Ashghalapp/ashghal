import 'package:ashghal_app_frontend/config/app_routes.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/services/dependency_injection.dart'
    as di;
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/use_cases/user_usecases/delete_account_uc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  void logOut() {
    SharedPref.clearPreferences();
    Get.offAllNamed(AppRoutes.logIn);
  }

  Future<void> submitDeleteAccount() async {
    AppUtil.buildDialog(
      AppLocalization.warning,
      AppLocalization.areYouSureToDeleteYourAccount,
      submitButtonText: AppLocalization.sure,
      () {
        Get.back();
        AppUtil.buildDialog(
          AppLocalization.warning,
          AppLocalization.noteForDeleteAccount,
          () {
            Get.back();
            AppUtil.buildDialog(
              AppLocalization.warning,
              AppLocalization.noteForDeleteAccountThatWillDeleteAllPosts,
              () {
                Get.back();
                deleteAccount();
              },
              submitButtonText: AppLocalization.delete,
            );
          },
          submitButtonText: AppLocalization.confirm,
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
