import 'package:ashghal_app_frontend/config/app_icons.dart';
import 'package:ashghal_app_frontend/core/widget/app_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../config/app_routes.dart';
import '../../../../../core/localization/app_localization.dart';
import '../../../../../core/widget/app_buttons.dart';
import '../../getx/Auth/chooseusertype_controller.dart';

class ChooseUserTypeScreen extends GetView<ChooseUserTypeController> {
  const ChooseUserTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ChooseUserTypeController());
    Size size = MediaQuery.of(context).size;
    return AppScaffold(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: Column(
       
          children: [
            Text(
              textAlign: TextAlign.center,
              AppLocalization.chooseusertype,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              AppLocalization.chooseusertypebody,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: size.height * 0.07),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(() {
                  return customCard(
                    context: context,
                    userType: AppLocalization.provider,
                    desc: AppLocalization.providerDesc,
                    avatarUrl: AppIcons.workBorder,
                    isSelected: controller.isProviderSelected.value,
                    onSelectionChanged: () {
                      controller.toggleProvider();
                      debugPrint(
                          'provider ${controller.isProviderSelected.value}');
                    },
                  );
                }),
                Obx(() {
                  return customCard(
                    context: context,
                    userType: AppLocalization.client,
                    desc: AppLocalization.clientDesc,
                    avatarUrl: AppIcons.employeesBorder,
                    isSelected: controller.isClientSelected.value,
                    onSelectionChanged: () {
                      controller.toggleClient();
                      debugPrint(
                        'client ${controller.isClientSelected.value}',
                      );
                    },
                  );
                }),
              ],
            ),
            SizedBox(height: size.height * 0.03),
            Obx(
              //التحقق اذا اختار المستخدم احد الخيارات
              () => (controller.isProviderSelected.value ||
                      controller.isClientSelected.value)
                  ? MyGesterDedector(
                      text: AppLocalization.next,
                      color: Theme.of(context).primaryColor,
                      onTap: () {
                        debugPrint(
                          'Is Provider ${controller.isProviderSelected.value}',
                        );
                        final isProvider =
                            controller.isProviderSelected.value;

                        // Navigate to the next screen and pass the selected user type
                        Get.offNamed(AppRoutes.signUp,
                            arguments: {'isProvider': isProvider});
                      },
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}

Widget customCard({
  required String userType,
  required String desc,
  required String avatarUrl,
  required bool isSelected,
  required void Function() onSelectionChanged,
  required BuildContext context,
}) {
  return GestureDetector(
    onTap: () {
      onSelectionChanged();
    },
    child: Container(
      height: 240,
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Theme.of(context).inputDecorationTheme.fillColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).dividerColor,
          width: 2, // Adjust the width as needed
        ),
      ),
      child: Card(
        elevation: 0.0,
        shadowColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 15.0),
              CircleAvatar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                radius: 50.0,
                child: SvgPicture.asset(
                  width: 70,
                  avatarUrl,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).primaryColor,
                    BlendMode.srcIn,
                  ),
                ),
                // backgroundImage: AssetImage(avatarUrl),
              ),
              const SizedBox(height: 16.0),
              Text(userType, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12.0),
              Text(desc, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    ),
  );
}
