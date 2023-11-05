import 'package:ashghal_app_frontend/app_library/app_data_types.dart';
import 'package:ashghal_app_frontend/core/cities_and_districts.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/bottom_sheet_util.dart';
import 'package:ashghal_app_frontend/core/widget/app_buttons.dart';
import 'package:ashghal_app_frontend/core/widget/circle_cached_networkimage.dart';
import 'package:ashghal_app_frontend/core/widget/circle_file_image_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/getx/settings/show_edit_profile_controller.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/screens/address_screen.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/settings/setting_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ShowEditProfileScreen extends StatelessWidget {
  // final User user;
  ShowEditProfileScreen({super.key});
  final editProfileController = Get.find<ShowEditProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.profile.tr),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text(AppLocalization.deleteProfileImage),
                  onTap: () => editProfileController.deleteProfileImage(),
                )
              ];
            },
          )
        ],
      ),
      body: GetX<ShowEditProfileController>(builder: (context) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            // الداله الخاصه بعرض الصورة في منتصف الصفحه
            _buildCircleEditableImageWidget(
              editProfileController.userData.value.imageUrl,
              () => editProfileController.pickImage(),
            ),

            const SizedBox(height: 15),

            // name
            SettingItemWidget(
              icon: Icons.text_fields_rounded,
              label: AppLocalization.name,
              data: editProfileController.name.value,
              onTap: () async {
                await BottomSheetUtil.buildButtomSheetToEditField(
                  title: AppLocalization.name,
                  initialValue: editProfileController.name.value,
                  autoFocuse: false,
                  onSave: (newValue) {
                    editProfileController.name.value = newValue;
                  },
                );
              },
            ),

            // gender
            SettingItemWidget(
              icon: Icons.man_3_outlined,
              label: AppLocalization.gender,
              data: editProfileController.selectedGender
                  .value, // editProfileController.userData.value.gender.name,
              onTap: () async {
                await BottomSheetUtil.buildButtomsheetToEditRadio(
                  title: AppLocalization.gender,
                  values: Gender.values.asNameMap().keys.toList(),
                  initialValue: editProfileController.selectedGender.value,
                  onSave: (newValue) {
                    editProfileController.selectedGender.value = newValue;
                  },
                );
              },
            ),

            // birth date
            SettingItemWidget(
              icon: Icons.date_range_rounded,
              label: AppLocalization.birthDate,
              data: DateFormat('yyyy-MM-dd')
                  .format(editProfileController.birthDate.value),
              onTap: () async {
                await _selectDate(editProfileController.birthDate);
              },
            ),

            // Information(NameLabel: 'Accont information'),

            ..._buildAddresFields(),

            // button to upload changes if found
            editProfileController.areThereChanges()
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: AppGesterDedector(
                      onTap: () async {
                        await editProfileController.updateUserData();
                      },
                      text: "Upload changes",
                    ),
                  )
                : const SizedBox(),
          ],
        );
      }),
    );
  }

  List<Widget> _buildAddresFields() {
    if (editProfileController.userData.value.address == null) {
      return [
        SettingItemWidget(
          icon: Icons.location_on,
          label: AppLocalization.address,
          data: AppLocalization.tapToAdd,
          onTap: () => Get.to(
            () =>
                AddressScreen(onSubmit: editProfileController.addAddressToUser),
          ),
        )
      ];
    }
    return [
      // city
      if (editProfileController.userData.value.address?.city != null)
        SettingItemWidget(
          icon: Icons.location_city_outlined,
          label: AppLocalization.city,
          data: City.getCityNameById(
              editProfileController.selectedCityId.value ??
                  1), // editProfileController.city.value,
          onTap: () async {
            await BottomSheetUtil.buildButtomsheetToEditList(
              title: AppLocalization.city,
              items: citiess.map((city) => city.toJson()).toList(),
              initialValue: editProfileController.selectedCityId.value ?? 1,
              onSave: (newValue) {
                editProfileController.selectedCityId.value = newValue;
              },
            );
            // await BottomSheetUtil.buildButtomSheetToEditField(
            //   title: AppLocalization.city,
            //   initialValue: editProfileController.city.value,
            //   onSave: (newValue) {
            //     editProfileController.city.value = newValue;
            //   },
            // );
          },
        ),

      // district
      if (editProfileController.userData.value.address?.district != null)
        SettingItemWidget(
          icon: Icons.location_history,
          label: AppLocalization.district,
          data:
              City.getCityById(editProfileController.selectedCityId.value ?? 1)
                  ?.getDistrictsNameById(
                      editProfileController.selectedDistrictId.value ??
                          1), //editProfileController.district.value,
          onTap: () async {
            await BottomSheetUtil.buildButtomsheetToEditList(
              title: AppLocalization.district,
              items: editProfileController
                      .getDistricts()
                      ?.map((e) => e.toJson())
                      .toList() ??
                  [],
              initialValue: editProfileController.selectedCityId.value ?? 1,
              onSave: (newValue) {
                editProfileController.selectedDistrictId.value = newValue;
              },
            );
            // await BottomSheetUtil.buildButtomSheetToEditField(
            //   title: AppLocalization.street,
            //   initialValue: editProfileController.district.value,
            //   onSave: (newValue) {
            //     editProfileController.district.value = newValue;
            //   },
            // );
          },
        ),

      // addres description
      if (editProfileController.userData.value.address?.desc != null)
        SettingItemWidget(
          icon: Icons.description,
          label: AppLocalization.addressDescription,
          data: editProfileController.addressDesc.value.isEmpty
              ? AppLocalization.tapToAdd
              : editProfileController.addressDesc.value,
          onTap: () async {
            await BottomSheetUtil.buildButtomSheetToEditField(
              title: AppLocalization.street,
              initialValue: editProfileController.addressDesc.value,
              onSave: (newValue) {
                editProfileController.addressDesc.value = newValue;
              },
            );
          },
        ),
    ];
  }

  Widget _buildCircleEditableImageWidget(
    String? imageUrl,
    void Function() onClick,
  ) {
    Widget imageWidget;
    if (editProfileController.imagePath.value.isEmpty &&
        editProfileController.userData.value.imageUrl == null) {
      imageWidget = SizedBox(
        width: 150,
        height: 150,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(150),
          child: Image.asset(
              editProfileController.userData.value.gender == Gender.male
                  ? editProfileController.assetMaleImage
                  : editProfileController.assetFemaleImage,
              fit: BoxFit.fill),
        ),
      );
    } else if (editProfileController.imagePath.value.isNotEmpty) {
      imageWidget = CircleFileImageWidget(
          imagePath: editProfileController.imagePath.value, radius: 150);
    } else {
      imageWidget =
          CircleCachedNetworkImageWidget(imageUrl: imageUrl, radius: 150);
    }
    return Stack(
      fit: StackFit.loose,
      children: <Widget>[
        Container(alignment: AlignmentDirectional.center, child: imageWidget),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     imageWidget
        //   ],
        // ),
        Positioned(
          top: 110,
          right: 0,
          left: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  right: Get.locale?.languageCode == 'ar' ? 60 : 0,
                  left: Get.locale?.languageCode == 'en' ? 60 : 0,
                ),
                child: Card(
                  shape: const CircleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      onTap: onClick,
                      child: const Icon(Icons.add_a_photo_rounded),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<void> _selectDate(Rx<DateTime> date) async {
    final DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: date.value,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
      locale: const Locale('en'), // تعيين اللغة لعرض التاريخ بالعربية
    );

    if (pickedDate != null && pickedDate != date.value) {
      date.value = pickedDate;
    }
  }
}
//   Widget Information({
//     required String NameLabel,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // name
//         SettingItemWidget(
//           icon: Icons.text_fields_rounded,
//           label: AppLocalization.name,
//           data: editProfileController.name.value,
//           onTap: () async {
//             await AppUtil.buildButtomSheetToEditField(
//               title: AppLocalization.name,
//               initialValue: editProfileController.name.value,
//               autoFocuse: false,
//               onSave: (newValue) {
//                 editProfileController.name.value = newValue;
//               },
//             );
//           },
//         ),

//         // gender
//         SettingItemWidget(
//           icon: Icons.man_3_outlined,
//           label: AppLocalization.gender,
//           data: editProfileController.selectedGender
//               .value, // editProfileController.userData.value.gender.name,
//           onTap: () async {
//             await AppUtil.buildButtomsheetToEditRadio(
//               title: AppLocalization.gender,
//               values: Gender.values.asNameMap().keys.toList(),
//               initialValue: editProfileController.selectedGender.value,
//               onSave: (newValue) {
//                 editProfileController.selectedGender.value = newValue;
//               },
//             );
//           },
//         ),

//         // birth date
//         SettingItemWidget(
//           icon: Icons.date_range_rounded,
//           label: AppLocalization.birthDate,
//           data: DateFormat('yyyy-MM-dd')
//               .format(editProfileController.birthDate.value),
//           onTap: () async {
//             await _selectDate(editProfileController.birthDate);
//             // await AppUtil.buildButtomSheetToEditField(
//             //   title: AppLocalization.birthDate,
//             //   initialValue: user.birthDate.toString(),
//             //   onSave: (newValue) {},
//             // );
//           },
//         ),

//         // buildIGroupItemWidget(
//         //     iconData: Icons.discount_rounded,
//         //     label: 'Abot',
//         //     data: 'freelancer ',
//         //     // next: false,
//         //     onClick: () async {
//         //       await buttomsheetedit(lable: 'Abot', lable1: 'freelancer');
//         //     }),
//         // buildIGroupItemWidget(
//         //     iconData: Icons.link,
//         //     label: 'Link',
//         //     data: 'kasswrh@gmail.com',
//         //     // next: false,
//         //     onClick: () async {
//         //       await buttomsheetedit(
//         //           lable: 'Link', lable1: 'kasswrh@gmail.com');
//         //     }),
//         // buildIGroupItemWidget(
//         //     iconData: Icons.cake_sharp,
//         //     label: 'Brath Day',
//         //     data: '2000/11/15',
//         //     // next: false,
//         //     onClick: () async {
//         //       await _selectDate(Get.context!);
//         //     }),
//         // buildIGroupItemWidget(
//         //     iconData: Icons.location_city_outlined,
//         //     label: 'Cantry',
//         //     data: 'Yemen',
//         //     // next: false,
//         //     onClick: () async {
//         //       await buttomsheetedit(lable: 'Cantry', lable1: 'Yemen');
//         //     }),
//         // buildIGroupItemWidget(
//         //     iconData: Icons.location_city_outlined,
//         //     label: 'cety ',
//         //     data: 'IBB',
//         //     // next: false,
//         //     onClick: () async {
//         //       await buttomsheetedit(lable: 'cety', lable1: 'IBB');
//         //     }),
//       ],
//     );
//   }

