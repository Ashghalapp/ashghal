import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/Requsets/user_requests.dart/get_user_followers_followings_request.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/entities/user.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/use_cases/user_usecases/get_user_followers_uc.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/use_cases/user_usecases/get_user_following_uc.dart';
import 'package:get/get.dart';
import '../../../../../../core/services/dependency_injection.dart' as di;

class UserAndPaginationRequestModel {
  RxList<User> users = <User>[].obs;
  RxBool isRequestFinishWithoutData = false.obs;

  int pageNumber = 1;
  int perPage = 10;
  int lastIndexToGetNewPage = 0;
}

class FollowController extends GetxController {
  // int pageNumber = 1;
  // int perPage = 5;

  UserAndPaginationRequestModel followersModel =
      UserAndPaginationRequestModel();
  UserAndPaginationRequestModel followingsModel =
      UserAndPaginationRequestModel();

  // bool isRequestFinishWithoutData = false;

  // final RxList<User> followersList = <User>[].obs;
  // final RxList<User> followingsList = <User>[].obs;

  @override
  dispose() {
    Get.delete<FollowController>();
    super.dispose();
  }

  Future<void> getFollowers(int userId) async {
    followersModel.pageNumber = 1;
    await _sendRequestToGetFollowers(userId);
  }

  Future<void> loadNextPageOfFollowers(int userId) async {
    followersModel.pageNumber++;
    await _sendRequestToGetFollowers(userId, isNextPage: true);
  }

  Future<void> _sendRequestToGetFollowers(int userId,
      {bool isNextPage = false}) async {
    followersModel.isRequestFinishWithoutData.value = false;
    final GetUserFollowersUseCase getUserFollowers = di.getIt();
    printError(info: "<<<<<<<<$userId");
    final result = getUserFollowers.call(
      GetUserFollowersFollowingsRequest(
          currentUserIdi: userId,
          pageNumber: followersModel.pageNumber,
          perPage: followersModel.perPage),
    );

    (await result).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
      followersModel.isRequestFinishWithoutData.value = true;
      // users.c.value = null;
    }, (users) {
      followersModel.isRequestFinishWithoutData.value = users.isEmpty;
      if (isNextPage) {
        followersModel.users.addAll(users);
      } else {
        followersModel.users.value = users;
      }
      print(">>>>>>>Done get followers of $userId User Data>>>>>>>>>");
    });
  }


  Future<void> getFollowings(int userId) async {

    followingsModel.pageNumber = 1;
    await _sendRequestToGetFollowings(userId);
  }


  Future<void> loadNextPageOfFollowings(int userId) async {
    followingsModel.pageNumber++;
    await _sendRequestToGetFollowings(userId, isNextPage: true);
  }

  Future<void> _sendRequestToGetFollowings(int userId,
      {bool isNextPage = false}) async {
    followingsModel.isRequestFinishWithoutData.value = false;
    final GetUserFollowingsUseCase getUserFollowings = di.getIt();
    printError(info: "<<<<<<<<$userId");
    final result = getUserFollowings.call(
      GetUserFollowersFollowingsRequest(
          currentUserIdi: userId,
          pageNumber: followingsModel.pageNumber,
          perPage: followingsModel.perPage),
    );

    (await result).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
      followingsModel.isRequestFinishWithoutData.value = true;
      // users.c.value = null;
    }, (users) {
      followingsModel.isRequestFinishWithoutData.value = users.isEmpty;
      if (isNextPage) {
        followingsModel.users.addAll(users);
      } else {
        followingsModel.users.value = users;
      }
      print(">>>>>>>Done get followings of $userId User Data>>>>>>>>>");
    });
  }

  // Future<void> getFollowings(int userId) async {
  //   isRequestFinishWithoutData = false;
  //   final GetUserFollowingsUseCase getUserFollowings = di.getIt();

  //   (await getUserFollowings.call(userId)).fold((failure) {
  //     AppUtil.hanldeAndShowFailure(failure);
  //     isRequestFinishWithoutData = true;
  //     // users.c.value = null;
  //   }, (users) {
  //     isRequestFinishWithoutData = users.isEmpty;
  //     followingsList.value = users;
  //     print(">>>>>>>Done get followings of $userId User Data>>>>>>>>>");
  //   });
  // }
}
