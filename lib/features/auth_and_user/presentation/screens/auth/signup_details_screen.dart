import 'package:ashghal_app_frontend/config/app_icons.dart';
import 'package:ashghal_app_frontend/config/app_routes.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/widget/app_buttons.dart';
import 'package:ashghal_app_frontend/core/widget/app_dropdownbutton.dart';
import 'package:ashghal_app_frontend/core/widget/app_textformfield.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/screens/address_screen.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/screens/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../app_library/app_data_types.dart';
import '../../../../../core/util/bottom_sheet_util.dart';
import '../../../../../core/util/validinput.dart';
import '../../../../../core/widget/circle_cached_networkimage.dart';
import '../../../../../core/widget/circle_file_image_widget.dart';
import '../../getx/Auth/singup_controller.dart';

class SignupDetailsScreen extends GetView<SignUpController> {
  const SignupDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalization.personalInfo)),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: GetX<SignUpController>(
              builder: (_) => Column(
                children: [
                  // الداله الخاصه بعرض الصورة في منتصف الصفحه
                  _buildCircleEditableImageWidget(
                    controller.imagePath.value,
                    () => controller.pickImage(),
                  ),

                  AppTextFormField(
                    readOnly: true,
                    onTap: () async {
                      await _selectDate(controller.birthDate);
                    },
                    margin: const EdgeInsets.only(bottom: 10, top: 15),
                    obscureText: false,
                    sufficxIconDataName: AppIcons.calendar,
                    hintText:
                        //   AppLocalization.birthDate,
                        //    DateFormat('yyyy-MM-dd')
                        // .format(controller.birthDate.value),
                        //   hintText:
                        controller.birthDate.value != null
                            ? DateFormat('yyyy-MM-dd')
                                .format(controller.birthDate.value!)
                            : AppLocalization.birthDate,
                  ),

                  AppTextFormField(
                    readOnly: true,
                    onTap: () async {
                      await BottomSheetUtil.buildButtomsheetToEditRadio(
                        title: AppLocalization.gender,
                        values: Gender.values.asNameMap().keys.toList(),
                        initialValue: controller.selectedGender.value,
                        onSave: (newValue) {
                          controller.selectedGender.value = newValue;
                          print("<<<<<<<<${controller.selectedGender.value}>>>>>>>>");
                        },
                      );
                    },
                    margin: const EdgeInsets.only(bottom: 10),
                    obscureText: false,
                    sufficxIconDataName: AppIcons.arrowDown,
                    // labelText: AppLocalization.gender,
                    hintText: controller.selectedGender.value.isNotEmpty
                        ? controller.selectedGender.value.tr
                        : AppLocalization.gender,
                  ),

                  Visibility(
                    visible: (controller.selectedGender.value.isNotEmpty &&
                        controller.birthDate.value != null),
                    child: AppGesterDedector(
                      onTap: () {
                        Get.to(() => AddressScreen(
                          onSubmit: controller.submitAddressData,
                        ));
                        controller.getUserLocation();
                      },
                      text: AppLocalization.next,
                    ),
                  ),

                  // TextButton(onPressed: ()=>Get.toNamed(AppRoutes.addLocationScreen), child: Text(AppLocalization.skip))
                ],
              ),
            )),
      ),
    );
  }

  Future<void> _selectDate(Rx<DateTime?> date) async {
    final DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: date.value ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
      locale: const Locale('en'), // تعيين اللغة لعرض التاريخ بالعربية
    );

    if (pickedDate != null && pickedDate != date.value) {
      date.value = pickedDate;
    }
  }

  Widget _buildCircleEditableImageWidget(
    String? imageUrl,
    void Function() onClick,
  ) {
    Widget imageWidget;
    if (controller.imagePath.value.isEmpty) {
      imageWidget = SizedBox(
        width: 150,
        height: 150,
        child: CircleAvatar(
          backgroundColor: Get.theme.inputDecorationTheme.fillColor,
          radius: Get.width * 0.15,
          child: SvgPicture.asset(
            width: Get.width * 0.20,
            controller.assetMaleImage,
            colorFilter: ColorFilter.mode(
              Get.theme.primaryColor,
              BlendMode.srcIn,
            ),
          ),
        ),
      );
    } else {
      imageWidget = CircleFileImageWidget(
          imagePath: controller.imagePath.value, radius: 150);
    }
    return Stack(
      fit: StackFit.loose,
      children: <Widget>[
        Container(
            alignment: AlignmentDirectional.center,
            child: GestureDetector(onTap: onClick, child: imageWidget)),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     imageWidget
        //   ],
        // ),
        Positioned(
          top: 100,
          right: 0,
          left: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  right: Get.locale?.languageCode == 'ar' ? 0 : 0,
                  left: Get.locale?.languageCode == 'en' ? 0 : 0,
                ),
                child: controller.imagePath.value.isEmpty
                    ? Card(
                        color: Get.theme.inputDecorationTheme.fillColor,
                        shape: const CircleBorder(),
                        child: const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Icon(Icons.add_a_photo_rounded),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        )
      ],
    );
  }
}
