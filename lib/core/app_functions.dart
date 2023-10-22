import 'package:ashghal_app_frontend/app_library/app_data_types.dart';
import 'package:ashghal_app_frontend/config/app_routes.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/features/auth/domain/entities/user.dart';
import 'package:get/get.dart';

class AppFunctions {
  static String handleImagesToEmulator(String path) {
    return path.replaceFirst("localhost", "10.0.2.155");
  }

  static User get fakeUserData => User(
      id: 0,
      name: "name",
      birthDate: DateTime.now(),
      gender: Gender.male,
      isBlocked: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      followersUsers: [],
      followingUsers: [],
      followersRequestsWait: [],
      followRequestsSent: []);

  // static User get getCurrentUserDataOffline {
  //   return SharedPref.getCurrentUserData();
  //   Map<String, dynamic>? data = SharedPref.getCurrentUserData();
  //   if (data == null) {
  //     Get.offAllNamed(AppRoutes.logIn);
  //     return fakeUserData;
  //   }
  //   return User(
  //     id: data['id'],
  //     name: data['name'],
  //     email: data['email'],
  //     phone: data['phone'],
  //     birthDate: DateTime.now(),
  //     gender: Gender.male,
  //     isBlocked: false,
  //     createdAt: DateTime.now(),
  //     updatededAt: DateTime.now(),
  //     followersUsers: [],
  //     followingUsers: [],
  //     followersRequestsWait: [],
  //     followRequestsSent: [],
  //   );
  // }
}
