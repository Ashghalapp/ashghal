import 'package:ashghal_app_frontend/config/app_icons.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/validinput.dart';
import 'package:ashghal_app_frontend/core/widget/app_buttons.dart';
import 'package:ashghal_app_frontend/core/widget/app_dropdownbuttonformfield.dart';
import 'package:ashghal_app_frontend/core/widget/app_scaffold_widget.dart';
import 'package:ashghal_app_frontend/core/widget/app_textformfield.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/getx/Auth/singup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpProviderDataScreen extends StatelessWidget {
  final bool isUpdateAccount;
  final Future<void> Function() nextButtonFunction;

  final List<Map<String, Object>> categories;
  final TextEditingController categoryController;
  final TextEditingController jobNameController;
  final TextEditingController jobDescController;
  SignUpProviderDataScreen({
    super.key,
    required this.categories,
    required this.categoryController,
    required this.jobNameController,
    required this.jobDescController,
    this.isUpdateAccount = false,
    required this.nextButtonFunction,
  });

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return AppScaffold(
      // appBarTitle: AutofillHints.jobTitle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(height: 60),
            Text(
              textAlign: TextAlign.center,
              AppLocalization.choosejobcategory,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 50),
            Form(
              key: formKey,
              child: Column(
                children: [
                  AppDropDownButton(
                    items: categories,
                    hintText: AppLocalization.selectCategory,
                    labelText: AppLocalization.category,
                    onChange: (selectedValue) {
                      categoryController.text =
                          selectedValue?.toString() ?? "";
                    },
                  ),

                  const SizedBox(height: 20),

                  // job name field
                  AppTextFormField(
                    // labelText: AppLocalization.jobname,
                    // iconName: Icons.work_outline_rounded,
                    iconName: AppIcons.work,
                    hintText: AppLocalization.jobname,
                    obscureText: false,
                    controller: jobNameController,
                    validator: (val) {
                      return validInput(val!, 5, 10, 'jobname');
                    },
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    margin: const EdgeInsets.only(bottom: 20),
                  ),

                  // job description field
                  AppTextFormField(
                    // labelText: AppLocalization.jobdesc,
                    // iconName: Icons.work_outline_rounded,
                    // iconName: AppIcons.work,
                    hintText: AppLocalization.jobdesc,
                    obscureText: false,
                    controller: jobDescController,
                    validator: (val) {
                      return validInput(val!, 5, 10, 'jobdesc');
                    },
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    margin: const EdgeInsets.only(bottom: 20),
                  ),
                ],
              ),
            ),
            AppGesterDedector(
              text: AppLocalization.next,
              color: Theme.of(context).primaryColor,
              onTap: () async {
                Get.focusScope?.unfocus();
                if (formKey.currentState?.validate() ?? false) {
                  await nextButtonFunction();
                }
              },
              // onTap: () async => await controller.submitJobInfo(),
            ),
            // SizedBox(height: size.height * 0.03),
          ],
        ),
      ),
    );
  }
}
