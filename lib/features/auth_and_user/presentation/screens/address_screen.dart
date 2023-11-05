import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/validinput.dart';
import 'package:ashghal_app_frontend/core/widget/app_buttons.dart';
import 'package:ashghal_app_frontend/core/widget/app_textformfield.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/getx/address_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressScreen extends StatelessWidget {
  final void Function(
      {required String city, required String street, String? desc}) onSubmit;
  AddressScreen({super.key, required this.onSubmit});

  final addressController = Get.put(AddressController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalization.addAddress)),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Form(
            key: addressController.addressFormKey,
            child: Column(
              children: [
                // city form field
                AppTextFormField(
                  obscureText: false,
                  controller: addressController.cityController,
                  labelText: AppLocalization.city,
                  hintText: AppLocalization.enterCityName,
                  validator: (val) {
                    return validInput(val!, 2, null, 'requiredField');
                  },
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                ),

                // street form field
                AppTextFormField(
                  obscureText: false,
                  controller: addressController.streetController,
                  labelText: AppLocalization.street,
                  hintText: AppLocalization.enterStreetName,
                  validator: (val) {
                    return validInput(val!, 2, null, 'requiredField');
                  },
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                ),

                // description form field
                AppTextFormField(
                  obscureText: false,
                  controller: addressController.descController,
                  labelText:
                      "${AppLocalization.description} ${AppLocalization.optional}",
                  hintText: AppLocalization.enterAddressDescription,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // submit address button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: AppGesterDedector(
              text: AppLocalization.next,
              onTap: () {
                Get.focusScope?.unfocus();
                if (addressController.addressFormKey.currentState?.validate() ??
                    false) {
                  onSubmit(
                    city: addressController.cityController.text,
                    street: addressController.streetController.text,
                    desc: addressController.descController.text,
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
