import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/post.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/get_marked_post_uc.dart';
import 'package:get/get.dart';
import '../../../../../../core/services/dependency_injection.dart' as di;

class MarkedPostsController extends GetxController {
  RxBool isMarketRequestFinishWithoutData = false.obs;
  RxList<Post> markedPostList = <Post>[].obs;

  @override
  void onInit(){
    super.onInit();
    getMarkedPosts();
  }
  Future<void> getMarkedPosts() async {
    final GetMarkedPostUseCase getMarkedPostsUC = di.getIt();
    var result = getMarkedPostsUC.call();

    isMarketRequestFinishWithoutData.value = false;
    (await result).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
      isMarketRequestFinishWithoutData.value = true;
      markedPostList.value = [];
    }, (posts) {
      isMarketRequestFinishWithoutData.value = posts.isEmpty;
      markedPostList.value = posts;
      print(">>>>>>>>>>>>>>>>>Done get marked posts>>>>>>>>>>>>>>>");
    });
  }
}
