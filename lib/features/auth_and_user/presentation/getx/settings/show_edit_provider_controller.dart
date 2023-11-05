import 'package:ashghal_app_frontend/app_library/public_entities/app_category.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/user_requests.dart/convert_user_to_provider_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/user_requests.dart/update_user_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/entities/provider.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/use_cases/user_usecases/convert_client_to_provider_uc.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/use_cases/user_usecases/update_user_uc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ashghal_app_frontend/core/services/dependency_injection.dart'
    as di;

// TextEditingController? Email;
class ShowEditProviderController extends GetxController {
  late Rx<Provider?> providerData;

  RxString jobName = "".obs;
  RxInt categoryId = 0.obs;
  RxString jobDesc = "".obs;

  TextEditingController categoryController = TextEditingController();
  TextEditingController jobNameController = TextEditingController();
  TextEditingController jobDescController = TextEditingController();

  // final List<Map<String, Object>> categories = [
  //   {'id': 1, 'name': 'Developer'},
  //   {'id': 2, 'name': 'Designer'},
  //   {'id': 3, 'name': 'Consultant'},
  //   {'id': 4, 'name': 'Student'},
  // ];

  RxList<AppCategory> categories =
      SharedPref.getCategories()?.obs ?? <AppCategory>[].obs;

  @override
  void onInit() {
    super.onInit();
    providerData = Rx(getCurrentProviderDataOffline);
    setValues();
  }

  Provider? get getCurrentProviderDataOffline {
    return SharedPref.getCurrentUserData()!.provider;
  }

  void setValues() {
    jobName.value = providerData.value?.jobName ?? "";

    categoryId.value = providerData.value?.categoryId! ?? 0;
    jobDesc.value = providerData.value?.jobDesc ?? "";
  }

  bool areThereChanges() =>
      jobName.value != (providerData.value?.jobName ?? "") ||
      categoryId.value != (providerData.value?.categoryId ?? 0) ||
      jobDesc.value != (providerData.value?.jobDesc ?? "");

  Future<void> updateProviderData() async {
    EasyLoading.show(status: AppLocalization.loading);
    final Provider provider = Provider.updateRequest(
      categoryId: categoryId.value != providerData.value?.categoryId
          ? categoryId.value
          : null,
      jobName:
          jobName.value != providerData.value?.jobName ? jobName.value : null,
      jobDesc:
          jobDesc.value != providerData.value?.jobDesc ? jobDesc.value : null,
    );

    await uploadUpdateProviderRequest(provider);
    EasyLoading.dismiss();
  }

  Future<void> upgradeToProviderAccount() async {
    EasyLoading.show(status: AppLocalization.loading);

    final ConvertClientToProviderRequest provider =
        ConvertClientToProviderRequest(
      categoryId: int.parse(categoryController.text),
      jobName: jobNameController.text,
      jobDesc:
          jobDescController.text.isNotEmpty ? jobDescController.text : null,
    );

    final ConvertClientToProviderUseCase upgradeToProviderUC = di.getIt();
    (await upgradeToProviderUC.call(provider)).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
    }, (user) {
      AppUtil.showMessage(
          AppLocalization.successUpgradeToProviderAccount, Colors.green);
      providerData.value = user.provider;
      setValues();
      SharedPref.setCurrentUserData(user);
      Get.back();
    });

    EasyLoading.dismiss();
  }

  Future<void> uploadUpdateProviderRequest(Provider provider) async {
    final UpdateUserUseCase updateUserUS = di.getIt();

    final result = updateUserUS.call(UpdateUserRequest(provider: provider));

    (await result).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
    }, (user) {
      AppUtil.showMessage(
          AppLocalization.successUpgradeToProviderAccount, Colors.green);
      providerData.value = user.provider;
      setValues();
      SharedPref.setCurrentUserData(user);
    });
  }

  // Future<void> pickImage() async {
  //   final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (image != null) imagePath.value = image.path;
  // }

  // TextEditingController Accont1 = TextEditingController();
  // String Password = '123';
  // // Rx<bool> Flage = false.obs;
  // void check_email(String password) {
  //   if (password == Password) {
  //     // Flage.value = true;
  //   } else {
  //     // Flage.value= false;
  //     Get.snackbar("erorr", "كلمة السر غير صحيحه ");
  //   }
  // }
}
