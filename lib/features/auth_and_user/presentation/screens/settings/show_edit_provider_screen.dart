import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/bottom_sheet_util.dart';
import 'package:ashghal_app_frontend/core/widget/app_buttons.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/getx/settings/show_edit_provider_controller.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/entities/provider.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/screens/auth/signup_provider_data_screen.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/settings/setting_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowEditProviderScreen extends StatelessWidget {
  ShowEditProviderScreen({super.key});

  // final editProfileController = Get.find<ShowEditProfileController>();
  final providerController = Get.find<ShowEditProviderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GetX<ShowEditProviderController>(
        builder: (context) {
          return Container(
            alignment: providerController.providerData.value == null
                ? AlignmentDirectional.center
                : null,
            child: ListView(
              shrinkWrap: true,
              children: [
                if (providerController.providerData.value != null)
                  ..._buildProviderDataWidgets(
                    providerController.providerData.value!,
                  ),
                if (providerController.providerData.value == null)
                  ..._buildUpgradeToProviderWidgets(),

                // button to upload changes if found
                providerController.areThereChanges()
                    ? Padding(
                        padding: const EdgeInsets.all(10),
                        child: AppGesterDedector(
                          onTap: () async {
                            await providerController.updateProviderData();
                          },
                          text: AppLocalization.uploadChanges.tr,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          );
        }
      ),
    );
  }

  List<Widget> _buildUpgradeToProviderWidgets() {
    return [
      Container(
        alignment: AlignmentDirectional.center,
        child: Text(AppLocalization.yourAccountNotProviderAccount),
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: TextButton(
          child: Text("Upgrade your account to provider account"),
          onPressed: () => Get.to(
            () => SignUpProviderDataScreen(
              categories: providerController.categories.map((category) => category.toJson()).toList(),
              categoryController: providerController.categoryController,
              jobNameController: providerController.jobNameController,
              jobDescController: providerController.jobDescController,
              nextButtonFunction: providerController.upgradeToProviderAccount,
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildProviderDataWidgets(Provider provider) {
    int categoryIndex = providerController.categories.indexWhere(
        (element) => element.id == providerController.categoryId.value);
    String category = providerController
        .categories[categoryIndex != -1 ? categoryIndex : 0].name
        .toString();
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          AppLocalization.providerData.tr,
          style: Get.textTheme.bodyMedium,
        ),
      ),
      // job name
      SettingItemWidget(
        icon: Icons.text_fields_rounded,
        label: AppLocalization.jobname,
        data: providerController.jobName.value,
        onTap: () async {
          await BottomSheetUtil.buildButtomSheetToEditField(
            title: AppLocalization.name,
            initialValue: providerController.jobName.value,
            autoFocuse: false,
            onSave: (newValue) {
              providerController.jobName.value = newValue;
            },
          );
        },
      ),

      // job description
      SettingItemWidget(
        icon: Icons.description_outlined,
        label: AppLocalization.jobDesc,
        data: providerController.jobDesc.value.isEmpty 
              ? AppLocalization.tapToAdd.tr
              : providerController.jobDesc.value,
        onTap: () async {
          await BottomSheetUtil.buildButtomSheetToEditField(
            title: AppLocalization.name,
            initialValue: providerController.jobDesc.value,
            autoFocuse: false,
            onSave: (newValue) {
              providerController.jobDesc.value = newValue;
            },
          );
        },
      ),

      // category
      SettingItemWidget(
        icon: Icons.category,
        label: AppLocalization.category,
        data: category,
        onTap: () async {
          await BottomSheetUtil.buildButtomsheetToEditList(
            title: AppLocalization.selectCategory,
            initialValue: providerController.categoryId.value,
            controller: providerController.categoryController,
            onSave: (int newValue){
              providerController.categoryId.value = newValue;
            },
            items: providerController.categories.map((category) => category.toJson()).toList(),
          );
        },
      ),
    ];
  }
}
