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
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() {
                  return customCard(
                    context: context,
                    userType: AppLocalization.provider,
                    desc: AppLocalization.clientDesc,
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
                    desc: AppLocalization.providerDesc,
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
                  ? AppGesterDedector(
                      text: AppLocalization.next,
                      color: Theme.of(context).primaryColor,
                      onTap: () {
                        debugPrint(
                          'Is Provider ${controller.isProviderSelected.value}',
                        );
                        final isProvider =
                            controller.isProviderSelected.value;
        
                        // Navigate to the next screen and pass the selected user type
                        Get.toNamed(AppRoutes.signUp,
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
  final mediaQuery = MediaQuery.of(context);
  final cardHeight = mediaQuery.size.height * 0.3; // Adjust the card height as needed
  final borderRadius = BorderRadius.circular(20);

  return GestureDetector(
    onTap: () {
      onSelectionChanged();
    },
    child: Container(
      width: (Get.width/2)-15,
      height: cardHeight,
      // margin: EdgeInsets.all(mediaQuery.size.width * 0.01), // Adjust margin based on screen width
      decoration: BoxDecoration(
        // color: Colors.amber,
        color: Theme.of(context).inputDecorationTheme.fillColor,
        borderRadius: borderRadius,
        border: Border.all(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).dividerColor,
          width: 2, 
        ),
      ),
      child: Card(
        elevation: 0.0,
        shadowColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(mediaQuery.size.width * 0), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: mediaQuery.size.height * 0.02), 
              CircleAvatar(
                backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
                radius: mediaQuery.size.width * 0.15, 
                child: SvgPicture.asset(
                  width: mediaQuery.size.width * 0.20, 
                  avatarUrl,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).primaryColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              SizedBox(height: mediaQuery.size.height * 0.015), 
              Text(textAlign: TextAlign.center, userType, style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: mediaQuery.size.height * 0.01), 
              Expanded(child: Text (textAlign: TextAlign.center, desc, style: Theme.of(context).textTheme.bodyMedium)),
            ],
          ),
        ),
      ),
    ),
  );
}
