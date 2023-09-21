import 'package:ashghal_app_frontend/core/widget/app_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../config/app_routes.dart';
import '../../../../../core/localization/app_localization.dart';
import '../../../../../core/widget/app_buttons.dart';

class ChooseUserTypeScreen extends StatelessWidget {
  const ChooseUserTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AppScaffold(

      appBarTitle: AppLocalization.usertype,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
              const SizedBox(height: 50),
           
              MyGesterDedector(
                text: AppLocalization.provider,
                color: Theme.of(context).primaryColor,
                onTap: () => Get.toNamed(AppRoutes.signUp,
                    arguments: {'isPorvider': true}),
              ),
              SizedBox(height: size.height * 0.03),
         
              Text(
                AppLocalization.or,
                style: Theme.of(context).textTheme.labelSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              MyGesterDedector(
                text: AppLocalization.client,
                color: Theme.of(context).primaryColor,
                onTap: () => Get.toNamed(AppRoutes.signUp,
                    arguments: {'isPorvider': false}),
              ),
     
            ],
          ),
        ),
      ),
 );
  }
}
