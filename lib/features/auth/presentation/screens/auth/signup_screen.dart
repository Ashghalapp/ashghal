import 'package:ashghal_app_frontend/core/widget/app_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/app_colors.dart';
import '../../../../../config/app_routes.dart';
import '../../../../../core/localization/localization_strings.dart';
import '../../../../../core/util/validinput.dart';
import '../../../../../core/widget/app_buttons.dart';
import '../../../../../core/widget/app_textformfield.dart';
import '../../../../../core/widget/custom_appbar.dart';
import '../../../../../core/widget/loading_state.dart';
import '../../getx/Auth/singup_controller.dart';
import '../../widgets/social_icons.dart';

class SignUpScreen extends GetView<SignUpController> {
  SignUpScreen({super.key});
  final RxBool isLoading = RxBool(false);
  final bool? isProviderSignUp = Get.arguments?['isPorvider'] ?? false;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SignUpController());
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          '17'.tr,
          style:  TextStyle(
            // fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            // fontSize: 22,
            color: AppColors.grey,
          ),
        ),
        leading: MyCircularIconButton(
          onPressed: () {
            Get.back();
          },
          iconData: Icons.arrow_back_ios,
          iconColor: AppColors.grey,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
        child: ListView(
          children: [
            // Center(
            //   child: SvgPicture.asset(
            //     'assets/images/Personal site-rafiki.svg',
            //     height: size.height * 0.35,
            //   ),
            // ),
            // const Logo(),
            //                 SizedBox(
            //   height: size.height * 0.08,
            // ),
            // const Logo(),

            Text(
              textAlign: TextAlign.center,
              LocalizationString.signUpMessage,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '11'.tr,
              style:  TextStyle(color: AppColors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Form(
              key: controller.signUpFormKey,
              child: Column(
                children: [
                  MyTextFormField(
                    hintText: '23'.tr,
                    iconData: Icons.person_outline_outlined,
                    lable: '20'.tr,
                    obscureText: false,
                    controller: controller.nameController,
                    validator: (val) {
                      return validInput(val!, 5, 20, 'name');
                    },
                  ),
                  const SizedBox(height: 20),

                  // MyTextFormField(
                  //   textInputtype: TextInputType.number,
                  //   inputformater: <TextInputFormatter>[
                  //     FilteringTextInputFormatter.digitsOnly
                  //   ],
                  //   prefixtext: "+967 ",
                  //   hintText: '22'.tr,
                  //   iconData: Icons.phone_iphone_rounded,
                  //   lable: '56'.tr,
                  //   obscureText: false,
                  //   controller: controller.phoneController,
                  //   validator: (val) {
                  //     return validInput(val!, 9, 9, 'phonenumber');
                  //   },
                  // ),
                  // const SizedBox(height: 20),

                  MyTextFormField(
                    hintText: '12'.tr,
                    iconData: Icons.email_outlined,
                    lable: '18'.tr,
                    obscureText: false,
                    controller: controller.emailController,
                    validator: (val) {
                      return validInput(val!, 10, 50, 'email');
                    },
                  ),
                  const SizedBox(height: 20),

                  GetBuilder<SignUpController>(
                    init: SignUpController(),
                    initState: (_) {},
                    builder: (_) {
                      return MyTextFormField(
                        sufficxIconData: controller.isVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        obscureText: controller.isVisible,
                        onPressed: () => controller.changVisible(),
                        hintText: '13'.tr,
                        iconData: Icons.lock_open_outlined,
                        lable: '19'.tr,
                        controller: controller.passwordController,
                        validator: (val) {
                          return validInput(val!, 6, 50, 'password');
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  MyGesterDedector(
                    text: '17'.tr,
                    color: Theme.of(context).primaryColor,
                    onTap: () async => await controller
                        .submitEmailNamePass(isProviderSignUp ?? false),
                  ),
                  SizedBox(height: size.height * 0.03),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        style: const TextStyle(
                          color: AppColors.textgray,
                        ),
                        '25'.tr,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(shadowColor: Colors.white),
                        onPressed: () => Get.toNamed(AppRoutes.logIn),
                        child: Text(
                          '9'.tr,
                          style: const TextStyle(
                            color: AppColors.appColorPrimaryDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialIcons(
                        icon: 'facebook',
                        press: () {},
                      ),
                      SocialIcons(
                        icon: 'twitter',
                        press: () {},
                      ),
                      SocialIcons(
                        icon: 'google-plus',
                        press: () {},
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SingUpScreenJob extends GetView<SignUpController> {
  const SingUpScreenJob({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AppScaffold(appBarTitle: AutofillHints.jobTitle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Form(
                key: controller.jobFormKey,
                child: Column(
                  children: [
                    DropdownButtonFormField(
                      isDense: true,
                      hint: const Text("Select category"),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      items: [
                        ...controller.categoriesList.map((e) {
                          return DropdownMenuItem(
                            value: e['id'],
                            child: Text("${e['name']}"),
                          );
                        }).toList()
                      ],
                      validator: (value) => validInput(value?.toString() ?? "",
                          null, null, 'selectedCategory'),
                      onChanged: (value) {
                        controller.jobCategoryController.text =
                            value?.toString() ?? "";
                      },
                    ),
                    const SizedBox(height: 20),
                    MyTextFormField(
                      hintText: 'jobnamehint'.tr,
                      iconData: Icons.work_outline_rounded,
                      lable: 'jobname'.tr,
                      obscureText: false,
                      controller: controller.jobNameController,
                      validator: (val) {
                        return validInput(val!, 5, 10, 'jobname');
                      },
                    ),
                    const SizedBox(height: 20),
                    MyTextFormField(
                      hintText: 'jobdescriptionhint'.tr,
                      iconData: Icons.work_outline_rounded,
                      lable: 'jobdescription'.tr,
                      obscureText: false,
                      controller: controller.jobDescController,
                      validator: (val) {
                        return validInput(val!, 5, 10, 'jobdesc');
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              MyGesterDedector(
                text: '61'.tr,
                color: Theme.of(context).primaryColor,
                onTap: () async => await controller.submitJobInfo(),
              ),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}

// class SingUpScreenEmail extends GetView<SignUpController> {
//   const SingUpScreenEmail({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: MyAppBar().myappbar('18'),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
//         child: SingleChildScrollView(
//           child: Column(children: [
//             SizedBox(
//               height: size.height * 0.03,
//             ),
//             Text(
//               textAlign: TextAlign.center,
//               ' Email Verfication',
//               style: Theme.of(context).textTheme.displayMedium,
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             const Text(
//               'Please Enter your Email To Send The Verfication Code  ',
//               style: TextStyle(color: AppColors.gray),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 30),
//             const SizedBox(height: 30),
//             MyTextFormField(
//               hintText: '12'.tr,
//               iconData: Icons.email_outlined,
//               lable: '18'.tr,
//               obscureText: false,
//               controller: controller.emailController,
//               validator: (val) {
//                 return validInput(val!, 10, 50, 'email');
//               },
//             ),
//             SizedBox(
//               height: size.height * 0.03,
//             ),
//             MyGesterDedector(
//               text: '17'.tr,
//               color:Theme.of(context).primaryColor,
//               onTap: () {
//                 Get.toNamed(AppRoutes.verficationSignUp);
//               },
//             ),
//             SizedBox(
//               height: size.height * 0.03,
//             ),
//             TextButton(
//               style: TextButton.styleFrom(shadowColor: Colors.white),
//               onPressed: () => Get.offNamed(AppRoutes.succesSignUp),
//               child: Text(
//                 '58'.tr,
//                 style: const TextStyle(
//                   color: AppColors.darkPrimaryColor,
//                 ),
//               ),
//             ),
//           ]),
//         ),
//       ),
//     );
//   }
// }

// class SignUpScreenLocation extends StatefulWidget {
//   const SignUpScreenLocation({super.key});

//   @override
//   State<SignUpScreenLocation> createState() => _SignUpScreenLocationState();
// }

// class _SignUpScreenLocationState extends State<SignUpScreenLocation> {
//   final TextEditingController _locationController = TextEditingController();
//   // LatLng? _selectedLocation;
//   // Location location = new Location();

//   // Future<LocationData?> getLocation() async {
//   //   bool _serviceEnabled;
//   //   PermissionStatus _permissionGranted;
//   //   LocationData? _locationData;
//   //   try {
//   //     _serviceEnabled = await location.serviceEnabled();
//   //     if (!_serviceEnabled) {
//   //       _serviceEnabled = await location.requestService();
//   //       if (!_serviceEnabled) {
//   //         return null;
//   //       }
//   //     }
//   //     _permissionGranted = await location.hasPermission();
//   //     if (_permissionGranted == PermissionStatus.denied) {
//   //       _permissionGranted = await location.requestPermission();
//   //       if (_permissionGranted != PermissionStatus.granted) {
//   //         ScaffoldMessenger.of(context).showSnackBar(
//   //             const SnackBar(content: Text('لم يتم السماح بالوصول للموقع')));
//   //         return null;
//   //       }
//   //     }
//   //     _locationData = await location.getLocation();
//   //   } catch (e) {
//   //     ScaffoldMessenger.of(context)
//   //         .showSnackBar(const SnackBar(content: Text('حدث خطأ أثناء تحديد الموقع')));
//   //     print('حدث خطأ أثناء تحديد الموقع: $e');
//   //     return null;
//   //   }
//   //   return _locationData;
//   // }

//   // void _selectLocation() async {
//   //   LocationData? result = await getLocation();
//   //   if (result != null) {
//   //     LatLng location = LatLng(result.latitude!, result.longitude!);
//   //     _mapController?.animateCamera(
//   //       CameraUpdate.newCameraPosition(
//   //         CameraPosition(target: location, zoom: 15),
//   //       ),
//   //     );
//   //     setState(() {
//   //       _selectedLocation = location;
//   //       _locationController.text =
//   //         'Latitude: ${_selectedLocation?.latitude}, Longitude: ${_selectedLocation?.longitude}';
//   //     });
//   //   }
//   // }

//   // void _confirmLocation() {
//   //   if (_selectedLocation != null) {
//   //     _locationController.text =
//   //         'Latitude: ${_selectedLocation?.latitude}, Longitude: ${_selectedLocation?.longitude}';
//   //     // CircularNotchedRectangle();
//   //     // Future.delayed(Duration(seconds: 3), () {
//   //     //   Navigator.pop(context, _selectedLocation.toString());
//   //     // });
//   //   }
//   // }
//   // void _onMapCreated(GoogleMapController controller) {
//   //   _mapController = controller;
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: MyAppBar().myappbar('59'.tr),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(5.0),
//             child: TextField(
//               controller: _locationController,
//               decoration: InputDecoration(
//                 labelText: '61'.tr,
//               ),
//             ),
//           ),
//           Expanded(
//             child: GoogleMap(
//               // onMapCreated: _onMapCreated,
//               initialCameraPosition: const CameraPosition(
//                 target: LatLng(37.7749, -122.4194),
//                 zoom: 12,
//               ),
//               markers: _selectedLocation != null
//                   ? {
//                       Marker(
//                         markerId: const MarkerId('selectedLocation'),
//                         position: _selectedLocation!,
//                         icon: BitmapDescriptor.defaultMarker,
//                       ),
//                     }
//                   : {},
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 FloatingActionButton(
//                   onPressed: () {
//                     // _selectLocation();
//                   },
//                   child: const Icon(Icons.add_location),
//                 ),
//                 const SizedBox(width: 10),
//                 FloatingActionButton(
//                   onPressed: () {
//                     // _confirmLocation();
//                   },
//                   child: const Icon(Icons.check),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
