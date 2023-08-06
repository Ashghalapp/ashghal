import 'package:ashghal/core/constant/app_colors.dart';
import 'package:ashghal/core/localization/localization_strings.dart';
import 'package:ashghal/core/widget/app_buttons.dart';
import 'package:ashghal/features/auth/presntaion/getx/Auth/chooseusertype_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';




class ChooseUserTypePage extends GetView<ChooseUserTypeControllerImp> {
  const ChooseUserTypePage({super.key});

  @override
  Widget build(BuildContext context) {
     Get.lazyPut(() => ChooseUserTypeControllerImp());
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: MyAppBar().myappbar('52'.tr),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            
            
              Text(
                textAlign: TextAlign.center,
                '51'.tr,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                '53'.tr,
                style: const TextStyle(color: AppColors.gray),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              // SvgPicture.asset(
              //   'assets/images/Programmer-bro.svg',
              //   height: size.height * 0.25,
              // ),
              MyGesterDedector(
                  text: '54'.tr, color:Theme.of(context).primaryColor, 
                  onTap: ()=>controller.goToNextSignUp(true)),
                    SizedBox(height:size.height*0.03),
              // SvgPicture.asset(
              //   'assets/images/Businessman-amico.svg',
              //   height: size.height * 0.25,
              // ),
                  Text(
                LocalizationString.or,
                style: const TextStyle(color: AppColors.gray),
                textAlign: TextAlign.center,
              ),
                    const SizedBox(height: 20),
                 MyGesterDedector(
                  text: '55'.tr, color:Theme.of(context).primaryColor,
                  onTap: () =>controller.goToNextSignUp(false)),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     MyElevatedButton(
              //       color: AppColors.PRIMARY_COLOR,
              //       child: Text(
              //         '54'.tr,
              //       ),
              //     ),
              //     MyElevatedButton(
              //         color: AppColors.PRIMARY_COLOR,
              //       child: Text(
              //         '55'.tr,
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
