import 'package:ashghal_app_frontend/core/cities_and_districts.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/validinput.dart';
import 'package:ashghal_app_frontend/core/widget/app_buttons.dart';
import 'package:ashghal_app_frontend/core/widget/app_dropdownbuttonformfield.dart';
import 'package:ashghal_app_frontend/core/widget/app_textformfield.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/getx/address_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressScreen extends StatelessWidget {
  final void Function(
      {required String city, required String district, String? desc}) onSubmit;
  AddressScreen({super.key, required this.onSubmit});

  final addressController = Get.put(AddressController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalization.addAddress)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          const SizedBox(height: 20),
          /*Form(
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
          ),*/
          Form(
            key: addressController.addressFormKey,
            child: Column(
              children: [
                // city DropDownButton
                AppDropDownButton(
                  items: citiess.map((city) => city.toJson()).toList(),
                  //  cities
                  //     .map<Map<String, Object>>((e) => {
                  //           'id': e['id'] ?? 1,
                  //           'name': Get.locale?.languageCode == 'ar'
                  //               ? e['name_ar'] ?? ''
                  //               : e['name_en'] ?? ''
                  //         })
                  //     .toList(),
                  // initialValue: controller.selectedCity.value,
                  labelText: AppLocalization.city,
                  hintText: 'Select a city',
                  onChange: (selectedValue) {
                    if (selectedValue != null) {
                      addressController.selectedCityId.value =
                          int.parse(selectedValue.toString());

                      addressController.districts.value = citiess
                          .firstWhere((city) =>
                              city.id == addressController.selectedCityId.value)
                          .districts;
                    }
                    // addressController.selectedCity.value =
                    //     int.parse(selectedValue?.toString() ?? '1');
                    // addressController.districts.value =
                    //     cityDistricts[addressController.selectedCity] ?? [];

                    // addressController.selectedCity.value =
                    //     int.parse(selectedValue.toString());
                    // controller.updateDistrictDropdown(
                    //     int.parse(selectedValue.toString()));
                  },
                ),

                // districts dropdown
                Obx(
                  () => AppDropDownButton(
                    margin: const EdgeInsets.only(top: 20),
                    items: addressController.districts
                        .map((district) => district.toJson())
                        .toList(),
                    // initialValue: controller.selectedDistrict.value,
                    labelText: 'District',
                    hintText: 'Select a district',
                    onChange: (selectedValue) {
                      addressController.selectedDistrict.value =
                          int.parse(selectedValue?.toString() ?? '1');
                      // controller.selectedDistrict =
                      //     int.parse(selectedValue.toString());
                    },
                  ),
                ),

                // description form field
                AppTextFormField(
                  obscureText: false,
                  controller: addressController.descController,
                  labelText:
                      "${AppLocalization.description} ${AppLocalization.optional}",
                  minLines: 3,
                  maxLines: 6,
                  hintText: AppLocalization.enterAddressDescription,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  margin: const EdgeInsets.symmetric(vertical: 20),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // submit address button
          AppGesterDedector(
            text: AppLocalization.next,
            onTap: () {
              String cityName = "";
              String districtName = "";
              // final int cityIndex = citiess.indexWhere(
              //     (city) => city.id == addressController.selectedCity.value);

              final City? selectedCity = City.getCityById(
                  addressController.selectedCityId.value ?? -1);
              // cityName = City.getCityNameById(
              //         citiess, addressController.selectedCityId.value ?? -1) ??
              //     "";

              final District? selectedDistrict = selectedCity?.getDistrictById(
                  addressController.selectedDistrict.value ?? -1);
              districtName = "1";

               printInfo(info: "========city index: ${addressController.selectedCityId.value}");
               printInfo(info: "========district index: ${addressController.selectedDistrict.value}");

              // // final int districtIndex = citiess
              // //         .firstWhere((city) =>
              // //             city.id == addressController.selectedCityId.value)
              // //         .cityDistricts[addressController.selectedCityId.value]
              // //         ?.indexWhere((district) =>
              // //             district['id'] ==
              // //             addressController.selectedDistrict.value) ??
              // //     -1;
              // cityDistricts[addressController.selectedCityId.value]?.indexWhere(
              //         (district) =>
              //             district['id'] ==
              //             addressController.selectedDistrict.value) ??
              //     -1;

              printInfo(info: "<<<<<<<<<city name: ${selectedCity?.name}");
              printInfo(
                  info: "<<<<<<<<<district name: ${selectedDistrict?.name}");
              // final int cityIndex = cities.indexWhere(
              //     (city) => city['id'] == addressController.selectedCity.value);

              // printInfo(info: "========city index: $cityIndex");
              // if (cityIndex != -1) {
              //   cityName = cities[cityIndex]['name_en'].toString();
              // }

              // final int districtIndex =
              //     cityDistricts[addressController.selectedCity.value]
              //             ?.indexWhere((district) =>
              //                 district['id'] ==
              //                 addressController.selectedDistrict.value) ??
              //         -1;
              // printInfo(info: "========district index: $districtIndex");
              // if (districtIndex != -1) {
              //   districtName = cityDistricts[addressController.selectedCity]
              //               ?[districtIndex]['name_en']
              //           .toString() ??
              //       "";
              // }
              // printInfo(info: "<<<<<<<<<city name: $cityName");
              // printInfo(info: "<<<<<<<<<district name: $districtName");

              Get.focusScope?.unfocus();
              if (addressController.addressFormKey.currentState?.validate() ??
                  false) {
                onSubmit(
                  city: cityName,
                  district: districtName,
                  desc: addressController.descController.text,
                );
              }
            },
            // onTap: () {
            //   Get.focusScope?.unfocus();
            //   if (addressController.addressFormKey.currentState?.validate() ??
            //       false) {
            //     onSubmit(
            //       city: addressController.cityController.text,
            //       street: addressController.streetController.text,
            //       desc: addressController.descController.text,
            //     );
            //   }
            // },
          )
        ],
      ),
    );
  }
}
