// import 'dart:io';
import 'package:ashghal_app_frontend/app_library/app_data_types.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core/widget/app_buttons.dart';
import 'package:ashghal_app_frontend/core/widget/circle_cached_networkimage.dart';
import 'package:ashghal_app_frontend/core/widget/circle_file_image_widget.dart';
import 'package:ashghal_app_frontend/features/account/getx/edit_profile_controller.dart';
import 'package:ashghal_app_frontend/features/account/widgets/settings_widget.dart/setting_item_widget.dart';
import 'package:ashghal_app_frontend/features/auth/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

TextEditingController username = TextEditingController();

class EditAccountScreen extends StatelessWidget {
  // final User user;
  EditAccountScreen({super.key});
  final editProfileController = Get.find<EditProfileController>();

  @override
  Widget build(BuildContext context) {
    // editProfileController.setValues(user);
    // Get.lazyPut(() => MainController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          // الداله الخاصه بعرض الصورة في منتصف الصفحه
          _buildCircleEditableImageWidget(
            editProfileController.userData.value.imageUrl,
            () async {
              editProfileController.pickImage();
              //  await MainController.getImage();
            },
          ),
          const SizedBox(height: 15),
          Information(NameLabel: 'Accont information'),
          if (editProfileController.userData.value.address == null)
            SettingItemWidget(
              icon: Icons.location_on,
              label: AppLocalization.address,
              data: AppLocalization.tapToAdd,
              onTap: () async {},
            ),
          if (editProfileController.userData.value.address != null)
            ..._buildAddresFields(),
          Obx(
            () => editProfileController
                    .areThereChanges(editProfileController.userData.value)
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: AppGesterDedector(
                        onTap: () async {
                          await editProfileController.submitUploadChangesButton(
                              editProfileController.userData.value);
                        },
                        text: "Upload changes"),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAddresFields() {
    return [
      // city
      if (editProfileController.userData.value.address?.city != null)
        Obx(
          () => SettingItemWidget(
            icon: Icons.location_city_outlined,
            label: AppLocalization.city,
            data: editProfileController.city.value,
            onTap: () async {
              await AppUtil.buildButtomSheetToEditField(
                title: AppLocalization.city,
                initialValue: editProfileController.city.value,
                onSave: (newValue) {
                  editProfileController.city.value = newValue;
                },
              );
            },
          ),
        ),

      // street
      if (editProfileController.userData.value.address?.street != null)
        Obx(
          () => SettingItemWidget(
            icon: Icons.location_history,
            label: AppLocalization.street,
            data: editProfileController.street.value,
            onTap: () async {
              await AppUtil.buildButtomSheetToEditField(
                title: AppLocalization.street,
                initialValue: editProfileController.street.value,
                onSave: (newValue) {
                  editProfileController.street.value = newValue;
                },
              );
            },
          ),
        ),

      // addres description
      Obx(
        () => SettingItemWidget(
          icon: Icons.description,
          label: AppLocalization.addressDescription,
          data: editProfileController.addressDesc.value.isEmpty
              ? AppLocalization.tapToAdd
              : editProfileController.addressDesc.value,
          onTap: () async {
            await AppUtil.buildButtomSheetToEditField(
              title: AppLocalization.street,
              initialValue: editProfileController.addressDesc.value,
              onSave: (newValue) {
                editProfileController.addressDesc.value = newValue;
              },
            );
          },
        ),
      ),
    ];
  }

  Future<void> _selectDate(Rx<DateTime> date) async {
    final DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: date.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: const Locale('en'), // تعيين اللغة لعرض التاريخ بالعربية
    );

    if (pickedDate != null && pickedDate != date.value) {
      date.value = pickedDate;
    }
  }

  Widget _buildCircleEditableImageWidget(
      String? imageUrl, void Function() onClick) {
    return Stack(
      fit: StackFit.loose,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () {
                if (editProfileController.imagePath.value.isEmpty &&
                    editProfileController.userData.value.imageUrl == null) {
                  return CircleFileImageWidget(
                      imagePath: editProfileController.userData.value.gender ==
                              Gender.male
                          ? editProfileController.assetMaleImage
                          : editProfileController.assetFemaleImage,
                      radius: 150);
                } else if (editProfileController.imagePath.value.isNotEmpty) {
                  return CircleFileImageWidget(
                      imagePath: editProfileController.imagePath.value,
                      radius: 150);
                } else {
                  return CircleCachedNetworkImageWidget(
                      imageUrl: imageUrl, radius: 150);
                }
              },
            )
          ],
        ),
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

  Widget Information({
    required String NameLabel,
  }) {
    return Container(
      // padding: const EdgeInsets.all(8.0),
      // width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   NameLabel,
          //   style: const TextStyle(
          //     color: Colors.black,
          //     fontSize: 18,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          // name
          Obx(
            () => SettingItemWidget(
              icon: Icons.text_fields_rounded,
              label: AppLocalization.name,
              data: editProfileController.name.value,
              onTap: () async {
                await AppUtil.buildButtomSheetToEditField(
                  title: AppLocalization.name,
                  initialValue: editProfileController.name.value,
                  autoFocuse: false,
                  onSave: (newValue) {
                    editProfileController.name.value = newValue;
                  },
                );
              },
            ),
          ),

          // gender
          Obx(
            () => SettingItemWidget(
              icon: Icons.man_3_outlined,
              label: AppLocalization.gender,
              data: editProfileController.selectedGender
                  .value, // editProfileController.userData.value.gender.name,
              onTap: () async {
                await AppUtil.buildButtomsheetToEditRadio(
                  title: AppLocalization.gender,
                  values: Gender.values.asNameMap().keys.toList(),
                  initialValue: editProfileController.selectedGender.value,
                  onSave: (newValue) {
                    editProfileController.selectedGender.value = newValue;
                  },
                );
              },
            ),
          ),

          // birth date
          Obx(
            () => SettingItemWidget(
              icon: Icons.date_range_rounded,
              label: AppLocalization.birthDate,
              data: DateFormat('yyyy-MM-dd')
                  .format(editProfileController.birthDate.value),
              onTap: () async {
                await _selectDate(editProfileController.birthDate);
                // await AppUtil.buildButtomSheetToEditField(
                //   title: AppLocalization.birthDate,
                //   initialValue: user.birthDate.toString(),
                //   onSave: (newValue) {},
                // );
              },
            ),
          ),

          // buildIGroupItemWidget(
          //     iconData: Icons.discount_rounded,
          //     label: 'Abot',
          //     data: 'freelancer ',
          //     // next: false,
          //     onClick: () async {
          //       await buttomsheetedit(lable: 'Abot', lable1: 'freelancer');
          //     }),
          // buildIGroupItemWidget(
          //     iconData: Icons.link,
          //     label: 'Link',
          //     data: 'kasswrh@gmail.com',
          //     // next: false,
          //     onClick: () async {
          //       await buttomsheetedit(
          //           lable: 'Link', lable1: 'kasswrh@gmail.com');
          //     }),
          // buildIGroupItemWidget(
          //     iconData: Icons.cake_sharp,
          //     label: 'Brath Day',
          //     data: '2000/11/15',
          //     // next: false,
          //     onClick: () async {
          //       await _selectDate(Get.context!);
          //     }),
          // buildIGroupItemWidget(
          //     iconData: Icons.location_city_outlined,
          //     label: 'Cantry',
          //     data: 'Yemen',
          //     // next: false,
          //     onClick: () async {
          //       await buttomsheetedit(lable: 'Cantry', lable1: 'Yemen');
          //     }),
          // buildIGroupItemWidget(
          //     iconData: Icons.location_city_outlined,
          //     label: 'cety ',
          //     data: 'IBB',
          //     // next: false,
          //     onClick: () async {
          //       await buttomsheetedit(lable: 'cety', lable1: 'IBB');
          //     }),
        ],
      ),
    );
  }
}


//////////////////////////////////////////////////////////////////////////////////////////////
// Padding(
//   padding: const EdgeInsets.all(8.0),
//   child: Form(
//     child: Padding(
//       padding: const EdgeInsets.all(13.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           const Text("Name",
//               style: TextStyle(
//                   fontSize: 18, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 10),
//           MyTextFormField(
//             controller: username,
//             hintText: '',
//             lable: 'Name',
//             obscureText: false,
//           ),
//           const Text("Email"), const SizedBox(height: 10),
//           MyTextFormField(
//             controller: username,
//             hintText: '',
//             lable: 'Email',
//             obscureText: false,
//             onPressed: () {
//               Get.to(() => const Restert_Email_Screen());
//             },
//           ),
//           const Text("Password"), const SizedBox(height: 10),

//           MyTextFormField(
//             controller: username,
//             hintText: '',
//             lable: 'Password',
//             obscureText: true,
//             onPressed: () {
//               Get.to(() => const ResetertPasswordScreen());
//             },
//           ),
//           // buildFieldWithLabel(
//           //     label: "Email",
//           //     readonly: true,
//           //     onClick: () {
//           //       Get.to(() => const Rest_Email());
//           //     }),
//           // buildFieldWithLabel(
//           //     label: "Password",
//           //     isSecure: false,
//           //     onClick: () {
//           //       Get.to(() => const Rest_password());
//           //     }),
//           const Text("Phone"), const SizedBox(height: 10),

//           Row(
//             children: [
//               Flexible(
//                 flex: 2,
//                 child: MyTextFormField(
//                   controller: username,
//                   hintText: '',
//                   lable: 'Phone',
//                   obscureText: true,
//                   textInputtype: TextInputType.phone,
//                   onPressed: () {},
//                 ),
//               ),
//               const SizedBox(width: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   Get.to(() => const Restert_Email_Screen());
//                 },
//                 child: const Text(
//                   "Save ",
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//           // buildFieldWithLabel(
//           //     label: "Phone", keyboardType: TextInputType.phone),
//           const SizedBox(height: 10),
//           const
//           // buldFieldWithlabelgander(),s
//           Text("Gender",
//               style: TextStyle(
//                   fontSize: 18, fontWeight: FontWeight.bold)),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               SizedBox(
//                 width: 140,
//                 child: RadioListTile(
//                   title: const Text(
//                     'Male',
//                     style: TextStyle(
//                       color: Colors.black,
//                       // color: Colors.grey[700],
//                       fontFamily: 'Nunito',
//                       fontSize: 15,
//                     ),
//                   ),
//                   value: 'Male',
//                   groupValue: "selectedGender",
//                   onChanged: (Object? value) {},
//                   // onChanged: (value) => setSelectedGender(
//                   //     value!, 'assets/images/profile.png'),
//                 ),
//               ),
//               SizedBox(
//                 width: 140,
//                 child: RadioListTile(
//                   title: const Text(
//                     'Femle',
//                     style: TextStyle(
//                       color: Colors.black,
//                       // color: Colors.grey[700],
//                       fontFamily: 'Nunito',
//                       fontSize: 15,
//                     ),
//                   ),
//                   value: 'Male',
//                   groupValue: "selectedGender",
//                   onChanged: (Object? value) {},
//                   // onChanged: (value) => setSelectedGender(
//                   //     value!, 'assets/images/profile.png'),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           const Text("Birth Day",
//               style: TextStyle(
//                   fontSize: 18, fontWeight: FontWeight.bold)),
//           TextFormField(
//             keyboardType: TextInputType.datetime,
//             // inputFormatters: inputformater,
//             // validator: validator,
//             controller: username,
//             obscureText: false,
//             cursorColor: Theme.of(context).primaryColor,
//             style: const TextStyle(
//                 fontWeight: FontWeight.normal,
//                 fontSize: 12,
//                 height: 2,
//                 color: Colors.grey),
//             decoration: InputDecoration(
//               // prefixText: "prefixtext",
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(
//                     color: Theme.of(context).primaryColor, width: 2),
//               ),
//               hintText: DateFormat('yyyy-MM-dd').format(selectedDate),

//               hintStyle: const TextStyle(color: Colors.grey),

//               contentPadding: const EdgeInsets.symmetric(
//                   vertical: 10, horizontal: 30),
//               floatingLabelBehavior: FloatingLabelBehavior.always,
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             readOnly: true,
//             onTap: () async {
//               await _selectDate(context);
//               // print("***********************************");
//             },
//           ),
//           const SizedBox(height: 10),
//           const Text(
//             "Cantry and city ",
//             style:
//                 TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 10),
//           const ExpansionTile(
//             title: Text('Click to cantry'),
//             children: [
//               ListTile(
//                 title: Text('Item 1'),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           const ExpansionTile(
//             title: Text('Click to city'),
//             children: [
//               ListTile(
//                 title: Text('Item 1'),
//               ),
//               ListTile(
//                 title: Text('Item 2'),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 child: Text(
//                   "Save Chimg",
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 // style: ButtonStyle().copyWith(
//                 // ),
//                 //  padding: EdgeInsets.symmetric(
//                 //     horizontal: 60, vertical: 10),
//                 style: ButtonStyle().copyWith(
//                   padding: MaterialStateProperty.all(
//                     EdgeInsets.symmetric(
//                         horizontal: 60, vertical: 10),
//                   ),
//                   backgroundColor:
//                       MaterialStateProperty.all(Colors.blueAccent),
//                   shape: MaterialStateProperty.all(
//                     RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                   ),
//                 ),
//                 onPressed: null,
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//   ),
// ),

// Widget buildFieldWithLabel({
//   required String label,
//   TextInputType? keyboardType,
//   TextEditingController? controller,
//   bool isSecure = false,
//   void Function()? onClick,
//   bool readonly = false,
// }) {
//   return Padding(
//     padding: const EdgeInsets.only(bottom: 12),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 10),
//         Text(label,
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 10),
//         TextFormField(
//           readOnly: readonly,
//           keyboardType: keyboardType,
//           controller: controller,
//           obscureText: isSecure,
//           cursorColor: Get.theme.primaryColor,
//           style: const TextStyle(
//               fontWeight: FontWeight.normal,
//               fontSize: 12,
//               height: 2,
//               color: Colors.black),
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide(color: Get.theme.primaryColor, width: 2),
//             ),
//             hintStyle: const TextStyle(color: Colors.grey),
//             contentPadding:
//                 const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
//             floatingLabelBehavior: FloatingLabelBehavior.always,
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//           // focusNode:,
//           onTap: onClick,
//         ),
//       ],
//     ),
//   );
// }
