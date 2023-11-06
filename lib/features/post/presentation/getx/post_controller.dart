import 'package:ashghal_app_frontend/app_library/app_data_types.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core_api/network_info/network_info.dart';
import 'package:ashghal_app_frontend/app_library/public_request/pagination_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/get_all_alive_post_us.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/get_all_complete_post_us.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/get_all_posts_us.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/get_recent_posts_us.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/custom_report_buttomsheet.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/popup_menu_button_widget.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../core/services/dependency_injection.dart' as di;

import '../../domain/entities/post.dart';

enum PostFilters {
  all,
  recent,
  incomplete,
  complete,
}

extension PostFiltersExtension on PostFilters {
  String get value {
    switch (this) {
      case PostFilters.all:
        return AppLocalization.all;
      case PostFilters.recent:
        return AppLocalization.recentPosts;
      case PostFilters.incomplete:
        return AppLocalization.incompletePosts;
      case PostFilters.complete:
        return AppLocalization.completedPosts;
    }
  }
}

class PostAndPaginationRequestModel {
  RxList<Post> posts = <Post>[].obs;
  RxBool isRequestFinishWithoutData = false.obs;

  int pageNumber = 1;
  int perPage = 15;
  int lastIndexToGetNewPage = 0;
}

class PostController extends GetxController {
  // List<String> postsOptions = ['Save', 'Report', 'Copy'];
  // RxBool isimageUrlValid = true.obs;
  // RxString trueUrlOrReturnBlank = "".obs;
  RxBool isFavorite = false.obs;
  Rx<PostFilters> appliedFilter = PostFilters.all.obs;

  // RxList<Post> allPostsList = <Post>[].obs;
  // RxList<Post> recentPostsList = <Post>[].obs;
  // RxList<Post> alivePostsList = <Post>[].obs;
  // RxList<Post> completePostsList = <Post>[].obs;

  PostAndPaginationRequestModel allPostsModel = PostAndPaginationRequestModel();
  PostAndPaginationRequestModel recentPostsModel =
      PostAndPaginationRequestModel();
  PostAndPaginationRequestModel alivePostsModel =
      PostAndPaginationRequestModel();
  PostAndPaginationRequestModel completePostsModel =
      PostAndPaginationRequestModel();
  // Rx<RequestStatus>
  // final title = ''.obs;
  // final content = ''.obs;

  // int pageNumber = 1;
  // int perPage = 15;
  // List<Post> alivesPosts = [];

  // bool isRequestFinishWithoutData = false;

  // اخر بوست تم من عنده عمل طلب لجلب صفحة index متغير لتخزين
  // جديدة من البوستات وذلك حتى لا يتم تكرار الطلب عدة مرات
  // int lastIndexToGetNewPage = 0;

  @override
  void onInit() {
    super.onInit();
    // pageNumber = 1;
    // // perPage = 15;
    // isRequestFinishWithoutData = false;
    // alivesPosts = [];
    // getAlivePosts();
    getAllPosts();
    // filteredPosts;

    // trueUrlOrReturnBlank = "".obs;
  }

  /// function to refresh the posts and get it from api
  // void refreshPosts() {
  //   alivePostsList.value = [];
  //   isRequestFinishWithoutData = false;
  //   getAlivePosts();
  // }

  /// property to store the last index to retrieve a new page of filtered posts
  /// so that the page is not retrieved again
  set lastIndexToGetNextPage(int lastIndex) {
    switch (appliedFilter.value) {
      case PostFilters.all:
        allPostsModel.lastIndexToGetNewPage = lastIndex;
      case PostFilters.recent:
        recentPostsModel.lastIndexToGetNewPage = lastIndex;
      case PostFilters.incomplete:
        alivePostsModel.lastIndexToGetNewPage = lastIndex;
      case PostFilters.complete:
        completePostsModel.lastIndexToGetNewPage = lastIndex;
    }
  }

  /// property to get the last index in which a new page of
  /// filtered posts was retrieved
  int get lastIndexToGetNextPage {
    switch (appliedFilter.value) {
      case PostFilters.all:
        return allPostsModel.lastIndexToGetNewPage;
      case PostFilters.recent:
        return recentPostsModel.lastIndexToGetNewPage;
      case PostFilters.incomplete:
        return alivePostsModel.lastIndexToGetNewPage;
      case PostFilters.complete:
        return completePostsModel.lastIndexToGetNewPage;
    }
  }

  RxBool get isRequestFinishWithoutData {
    switch (appliedFilter.value) {
      case PostFilters.all:
        return allPostsModel.isRequestFinishWithoutData;
      case PostFilters.recent:
        return recentPostsModel.isRequestFinishWithoutData;
      case PostFilters.incomplete:
        return alivePostsModel.isRequestFinishWithoutData;
      case PostFilters.complete:
        return completePostsModel.isRequestFinishWithoutData;
    }
  }

  int? get getCurrentUserId => SharedPref.getCurrentUserData()?.id;

  RxList<Post> get filteredPosts {
    switch (appliedFilter.value) {
      case PostFilters.all:
        return allPostsModel.posts;
      case PostFilters.recent:
        return recentPostsModel.posts;
      case PostFilters.incomplete:
        return alivePostsModel.posts;
      case PostFilters.complete:
        return completePostsModel.posts;
    }
  }

  /// function to apply specific filter on posts
  void applyFilter(PostFilters filter) async {
    printInfo(info: "---------apply filter: $filter");
    if (filter != appliedFilter.value) {
      appliedFilter.value = filter;
      switch (appliedFilter.value) {
        case PostFilters.all:
          if (allPostsModel.posts.isEmpty) await getAllPosts();
        case PostFilters.recent:
          if (recentPostsModel.posts.isEmpty) await getRecentPosts();
        case PostFilters.incomplete:
          if (alivePostsModel.posts.isEmpty) await getAlivePosts();
        case PostFilters.complete:
          if (completePostsModel.posts.isEmpty) await getCompletePosts();
      }
    }
  }

  Future<void> refreshFilteredPosts() async {
    // lastIndexToGetNewPage = 0;
    switch (appliedFilter.value) {
      case PostFilters.all:
        allPostsModel.lastIndexToGetNewPage = 0;
        await getAllPosts();
      case PostFilters.recent:
        recentPostsModel.lastIndexToGetNewPage = 0;
        await getRecentPosts();
      case PostFilters.incomplete:
        alivePostsModel.lastIndexToGetNewPage = 0;
        await getAlivePosts();
      case PostFilters.complete:
        completePostsModel.lastIndexToGetNewPage = 0;
        await getCompletePosts();
    }
  }

  void loadNextPageOfFilteredPosts() {
    switch (appliedFilter.value) {
      case PostFilters.all:
        loadNextPageOfAllPosts();
      case PostFilters.recent:
        loadNextPageOfRecentPosts();
      case PostFilters.incomplete:
        loadNextPageOfAlivePosts();
      case PostFilters.complete:
        loadNextPageOfCompletePosts();
    }
  }

  /// functions to get randomize posts to all filter
  Future<void> getAllPosts() async {
    // pageNumber = 1;
    allPostsModel.pageNumber = 1;
    // perPage = 15;
    await _sendRequestToGetAllPosts(
      PaginationRequest(
        pageNumber: allPostsModel.pageNumber,
        perPage: allPostsModel.perPage,
        currentUserIdi: getCurrentUserId,
      ),
    );
  }

  /// functions to get next  page of randomize posts to all filter
  Future<void> loadNextPageOfAllPosts() async {
    // pageNumber++;
    allPostsModel.pageNumber++;

    await _sendRequestToGetAllPosts(
      PaginationRequest(
        pageNumber: allPostsModel.pageNumber,
        perPage: allPostsModel.perPage,
        currentUserIdi: getCurrentUserId,
      ),
      isNextPage: true,
    );
  }

  /// functions to send reqest into api to get randomize posts
  Future<void> _sendRequestToGetAllPosts(PaginationRequest request,
      {bool isNextPage = false}) async {
    final GetAllPostsUseCase getAllPostsUS = di.getIt();

    allPostsModel.isRequestFinishWithoutData.value = false;

    (await getAllPostsUS.call(request)).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
      allPostsModel.isRequestFinishWithoutData.value = true;
      // allPostsModel.posts.value = [];
    }, (posts) {
      allPostsModel.isRequestFinishWithoutData.value = posts.isEmpty;
      printError(info: ":::::the length before ${allPostsModel.posts.length}");
      if (isNextPage) {
        // allPostsList.addAll(posts);
        allPostsModel.posts.addAll(posts);
      } else {
        // allPostsList.value = posts;
        allPostsModel.posts.value = posts;
      }
      printError(info: ":::::the length after ${allPostsModel.posts.length}");
      printInfo(info: ">>>>>>Done get all Posts>>>>>");
    });
  }

  Future<void> getAlivePosts() async {
    // pageNumber = 1;
    alivePostsModel.pageNumber = 1;
    // perPage = 15;
    await _sendRequestToGetAlivePosts(
      PaginationRequest(
        pageNumber: alivePostsModel.pageNumber,
        perPage: alivePostsModel.perPage,
      ),
    );
  }

  Future<void> loadNextPageOfAlivePosts() async {
    if (await NetworkInfoImpl().isConnected) {
      printInfo(info: "Call loadNextPage");
      // pageNumber++;
      alivePostsModel.pageNumber++;
      await _sendRequestToGetAlivePosts(
        PaginationRequest(
          pageNumber: alivePostsModel.pageNumber,
          perPage: alivePostsModel.perPage,
        ),
        isNextPage: true,
      );
    } else {
      AppUtil.showMessage(
          AppLocalization.noInternet, Get.theme.colorScheme.error);
    }
  }

  /// functions to send reqest into api to get incomplete posts
  Future<void> _sendRequestToGetAlivePosts(PaginationRequest request,
      {bool isNextPage = false}) async {
    final GetAllAlivePostsUseCase getAlivePostsUS = di.getIt();
    alivePostsModel.isRequestFinishWithoutData.value = false;
    (await getAlivePostsUS.call(request)).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
      alivePostsModel.isRequestFinishWithoutData.value = true;
      // alivePostsModel.posts.value = [];
    }, (posts) {
      printError(
          info: ":::::the length before ${alivePostsModel.posts.length}");
      alivePostsModel.isRequestFinishWithoutData.value = posts.isEmpty;
      if (isNextPage) {
        // alivePostsList.addAll(posts);
        alivePostsModel.posts.addAll(posts);
      } else {
        // alivePostsList.value = posts;
        alivePostsModel.posts.value = posts;
      }
      printError(info: ":::::the length after ${alivePostsModel.posts.length}");
      print(">>>>>>>>>>>>>>>>>Done get InComplete Posts>>>>>>>>>>>>>>>");
    });
  }

  /// functions to get recent posts to recent filter
  Future<void> getRecentPosts() async {
    printInfo(info: "::::::::::In Get Recent Posts");
    // pageNumber = 1;
    recentPostsModel.pageNumber = 1;
    // perPage = 15;
    await _sendRequestToGetRecentPosts(
      PaginationRequest(
        pageNumber: recentPostsModel.pageNumber,
        perPage: recentPostsModel.perPage,
        currentUserIdi: getCurrentUserId,
      ),
    );
  }

  /// functions to get next page of recent posts to recent filter
  Future<void> loadNextPageOfRecentPosts() async {
    printInfo(info: "::::::::::In Get load next page of Recent Posts");
    // pageNumber++;
    recentPostsModel.pageNumber++;
    await _sendRequestToGetRecentPosts(
      PaginationRequest(
        pageNumber: recentPostsModel.pageNumber,
        perPage: recentPostsModel.perPage,
        currentUserIdi: getCurrentUserId,
      ),
      isNextPage: true,
    );
  }

  /// functions to send reqest into api to get recent posts
  Future<void> _sendRequestToGetRecentPosts(PaginationRequest request,
      {bool isNextPage = false}) async {
    final GetRecentPostsUseCase getAllPostsUS = di.getIt();
    recentPostsModel.isRequestFinishWithoutData.value = false;

    (await getAllPostsUS.call(request)).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
      recentPostsModel.isRequestFinishWithoutData.value = true;
      // recentPostsModel.posts.value = [];
    }, (posts) {
      recentPostsModel.isRequestFinishWithoutData.value = posts.isEmpty;
      printError(
          info: ":::::the length before ${recentPostsModel.posts.length}");
      if (isNextPage) {
        // recentPostsList.addAll(posts);
        recentPostsModel.posts.addAll(posts);
      } else {
        // recentPostsList.value = posts;
        recentPostsModel.posts.value = posts;
      }
      printError(
          info: ":::::the length after ${recentPostsModel.posts.length}");
      printInfo(info: ">>>>>>Done get recent Posts>>>>>");
    });
  }

  /// functions to get complete posts to complete filter
  Future<void> getCompletePosts() async {
    printInfo(info: "::::::::::In Get Complete Posts");
    completePostsModel.pageNumber = 1;
    await _sendRequestToGetCompletePosts(
      PaginationRequest(
        pageNumber: completePostsModel.pageNumber,
        perPage: completePostsModel.perPage,
        currentUserIdi: getCurrentUserId,
      ),
    );
  }

  /// functions to get next page of recent posts to complete filter
  Future<void> loadNextPageOfCompletePosts() async {
    printInfo(info: "::::::::::In Get load next page of Recent Posts");
    recentPostsModel.pageNumber++;
    await _sendRequestToGetCompletePosts(
      PaginationRequest(
        pageNumber: recentPostsModel.pageNumber,
        perPage: recentPostsModel.perPage,
        currentUserIdi: getCurrentUserId,
      ),
      isNextPage: true,
    );
  }

  /// functions to send reqest into api to get complete posts
  Future<void> _sendRequestToGetCompletePosts(PaginationRequest request,
      {bool isNextPage = false}) async {
    final GetAllCompletePostsUseCase getCompletePostsUS = di.getIt();
    completePostsModel.isRequestFinishWithoutData.value = false;
    (await getCompletePostsUS.call(request)).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
      completePostsModel.isRequestFinishWithoutData.value = true;
      completePostsModel.posts.value = [];
    }, (posts) {
      completePostsModel.isRequestFinishWithoutData.value = posts.isEmpty;
      printError(
          info: ":::the length before ${completePostsModel.posts.length}");
      if (isNextPage) {
        completePostsModel.posts.addAll(posts);
      } else {
        completePostsModel.posts.value = posts;
      }
      printError(
          info: ":::the length after ${completePostsModel.posts.length}");
      printInfo(info: ">>>>>>Done get complete Posts>>>>>");
    });
  }

  // PopupMenuButtonWidget getPostMenuButtonValuesWidget(Post post) {
  //   final values = [AppLocalization.copy, AppLocalization.report];

  //   return PopupMenuButtonWidget(
  //     items: values,
  //     onSelected: (value) {
  //       return postPopupMenuButtonOnSelected(value, post);
  //     },
  //   );
  // }

  // void postPopupMenuButtonOnSelected(String value, Post post) async {
  //   if (value == AppLocalization.copy) {

  //     ClipboardData clipboardData = ClipboardData(text: post.content);
  //     await Clipboard.setData(clipboardData);
  //   } else if (value == AppLocalization.report) {
  //     Get.bottomSheet(CustomBottomSheet());
  //   }
    // if (value == OperationsOnPostPopupMenuValues.save.name) {
    // } else if (value == OperationsOnPostPopupMenuValues.report.name) {
    //   Get.bottomSheet(CustomBottomSheet());
    // } else if (value == OperationsOnPostPopupMenuValues.copy.name) {
    //   Post p =
    //       alivePostsModel.posts.firstWhere((element) => element.id == postId);
    //   ClipboardData clipboardData = ClipboardData(text: p.content);
    //   await Clipboard.setData(clipboardData);
    // }
  // }

  // trying() async{
  //   GetSpecificPostUseCase t = di.getIt();
  //   var r = await (t.call(95));
  //   r.fold((l) => print("..............${l.message}"), (r) => print(">>>>>>>>>>>>>>>${r.toString()}"));
  // }

  /// creating a list of PostCardWidget elements from a list of Posts and then placing them in a Column.
  // List<Widget> fillPostIntoList() {
  //   List<Widget> postListElements = [];
  //   postListElements.add(PostWidget(
  //       post: Post(
  //     id: 1,
  //     // userName: "ابراهيم علوان",
  //     title: "شخص يبحث عن مبرمج لتطوير تطبيق موبايل",
  //     content:
  //         "أنا أبحث عن مبرمج محترف يمكنه تطوير تطبيق موبايل لنظام Android و iOS. يجب أن يكون لديك خبرة في Flutter و Dart. يرجى التواصل معي إذا كنت مهتمًا.",
  //     // imageUrl:
  //     //     "https://images.unsplash.com/photo-1545996124-0501ebae84d0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fGZhY2V8ZW58MHx8MHx8fDA=&w=1000&q=80",
  //     // userId: 1,
  //     categoryId: 1,
  //     allowComment: true,
  //     basicUserData: const {
  //       'id': 1,
  //       'name': "ابراهيم علوان",
  //       'image_url':
  //           "https://images.unsplash.com/photo-1545996124-0501ebae84d0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fGZhY2V8ZW58MHx8MHx8fDA=&w=1000&q=80",
  //     },
  //     commentsCount: 10,
  //     createdAt: DateTime.now(),
  //     expireDate: DateTime.now(),
  //     isComplete: false,
  //     updatedAt: DateTime.now(),
  //   )));

  //   for (int index = 0; index < postList.length; index++) {
  //     postListElements.add(PostWidget(post: postList[index]));
  //   }

  //   // return Column(
  //   // children:
  //   return postListElements;
  //   // );
  // }

  // postPopupMenuButtonOnSelected(
  //     PostPopupMenuItemsValues value, int postId) async {
  //   if (value == PostPopupMenuItemsValues.save) {
  //   } else if (value == PostPopupMenuItemsValues.report) {
  //     Get.bottomSheet(CustomBottomSheet());
  //   } else if (value == PostPopupMenuItemsValues.copy) {
  //     Post p = postList.firstWhere((element) => element.id == postId);
  //     ClipboardData clipboardData = ClipboardData(text: p.content);
  //     await Clipboard.setData(clipboardData);
  //   }
  // }

  // Future<bool> filterValidImages(String url) async {
  //   try {
  //     final response = await http.head(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       printError(info: ":::::valid image::::::::");
  //       return true;
  //     }
  //     printError(info: "::::in valid image:::::");
  //     return false;
  //   } catch (e) {
  //     printError(info: "::::::in valid image in catch::::::");
  //     return false;
  //   }
  // }

  // Future<String?> loadImage(String imageUrl) async {
  //   try {
  //     if (!(await filterValidImages(imageUrl))) return null;
  //     DefaultCacheManager cacheManager = DefaultCacheManager();
  //     FileInfo? fileInfo = await cacheManager.getFileFromCache(imageUrl);
  //     if (fileInfo == null) {
  //       // Image is not cached, download and store it locally.
  //       await cacheManager.downloadFile(imageUrl, force: true);
  //       fileInfo = await cacheManager.getFileFromCache(imageUrl);
  //     }
  //     return fileInfo?.file.path;
  //   } catch (e) {
  //     print("::::::::: Error: $e");
  //     // AppUtil.showMessage(AppLocalization.thereIsSomethingError, Colors.green);
  //   }
  //   return null;
  // }

  // Future<bool> isImage(String url) async {
  //   try {
  //     final response = await http.head(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       // Check if the content type is an image type.
  //       return response.headers['content-type']?.startsWith('image/') ?? false;
  //     }
  //     return false;
  //   } catch (e) {
  //     // Handle errors (e.g., invalid URL, network error).
  //     return false;
  //   }
  // }

  // Future<Widget> getImage(String imageUrl) async {
  //   try {
  //     if (await isImage(imageUrl)) {
  //       return CachedNetworkImage(
  //         imageUrl: imageUrl,
  //         // placeholder: ,
  //         errorWidget: (context, url, error) => Text(error.toString()),
  //       );
  //     }
  //     return Image.asset("assets/images/unKnown.jpg");
  //   } on SocketException catch (e) {
  //     print(e);
  //     // return Image.asset("assets/images/unKnown.jpg");
  //     throw Exception("hhhhhhhhhhhhhhhhhhh");
  //   } on HttpException catch (e) {
  //     print(e);
  //     throw Exception("hhhhhhhhhhhhhhhhhhh");
  //   } catch (e) {
  //     print(e);
  //     // return Image.asset("assets/images/unKnown.jpg");
  //     throw Exception("hhhhhhhhhhhhhhhhhhh");
  //   }
  // }

  final userData = {
    'id': 1,
    'name': "ابراهيم علوان",
    'image_url':
        "https://images.unsplash.com/photo-1545996124-0501ebae84d0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fGZhY2V8ZW58MHx8MHx8fDA=&w=1000&q=80",
  };

  List<Post> postData = [
    Post(
      id: 1,
      // userName: "ابراهيم علوان",
      title: "شخص يبحث عن مبرمج لتطوير تطبيق موبايل",
      content:
          "أنا أبحث عن مبرمج محترف يمكنه تطوير تطبيق موبايل لنظام Android و iOS. يجب أن يكون لديك خبرة في Flutter و Dart. يرجى التواصل معي إذا كنت مهتمًا.",
      // imageUrl:
      //     "https://images.unsplash.com/photo-1545996124-0501ebae84d0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fGZhY2V8ZW58MHx8MHx8fDA=&w=1000&q=80",
      // userId: 1,
      // categoryId: 1,
      categoryData: {},
      allowComment: true,
      basicUserData: const {
        'id': 1,
        'name': "ابراهيم علوان",
        'image_url':
            "https://images.unsplash.com/photo-1545996124-0501ebae84d0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fGZhY2V8ZW58MHx8MHx8fDA=&w=1000&q=80",
      },
      commentsCount: 10,
      createdAt: DateTime.now(),
      expireDate: DateTime.now(),
      isComplete: false,
      isMarked: true,
      updatedAt: DateTime.now(),
    ),
    Post(
      id: 2,
      title: "شخص يبحث عن مبرمج لتطوير تطبيق موبايل",
      content:
          "أنا أبحث عن مبرمج محترف يمكنه تطوير تطبيق موبايل لنظام Android و iOS. يجب أن يكون لديك خبرة في Flutter و Dart. يرجى التواصل معي إذا كنت مهتمًا.",
      // categoryId: 1,
      categoryData: {},
      allowComment: true,
      basicUserData: const {
        'id': 1,
        'name': "ابراهيم علوان",
        'image_url':
            "https://images.unsplash.com/photo-1545996124-0501ebae84d0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fGZhY2V8ZW58MHx8MHx8fDA=&w=1000&q=80",
      },
      commentsCount: 10,
      createdAt: DateTime.now(),
      expireDate: DateTime.now(),
      isComplete: false,
      isMarked: true,
      updatedAt: DateTime.now(),
    ),
    Post(
      id: 3,
      title: "شخص يبحث عن مبرمج لتطوير تطبيق موبايل",
      content:
          "أنا أبحث عن مبرمج محترف يمكنه تطوير تطبيق موبايل لنظام Android و iOS. يجب أن يكون لديك خبرة في Flutter و Dart. يرجى التواصل معي إذا كنت مهتمًا.",
      // categoryId: 1,
      categoryData: {},
      allowComment: true,
      basicUserData: const {
        'id': 1,
        'name': "ابراهيم علوان",
        'image_url':
            "https://images.unsplash.com/photo-1545996124-0501ebae84d0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fGZhY2V8ZW58MHx8MHx8fDA=&w=1000&q=80",
      },
      commentsCount: 10,
      createdAt: DateTime.now(),
      expireDate: DateTime.now(),
      isComplete: false,
      isMarked: false,
      updatedAt: DateTime.now(),
    ),
  ];
  //   Post(
  //     id: 2,
  //     userName: "قصورة حاشد",
  //     title: "فرصة عمل: مطور ويب محترف مطلوب",
  //     content:
  //         "نحن نبحث عن مطور ويب محترف للانضمام إلى فريق العمل لدينا. يجب أن يكون لديك خبرة في تطوير واجهات المستخدم وبرمجة الخادم. إذا كنت تمتلك المهارات اللازمة، فلا تتردد في التقديم.",
  //     imageUrl:
  //         "https://media.istockphoto.com/id/153536653/photo/a-portrait-of-a-man-with-a-stern-face.jpg?s=612x612&w=0&k=20&c=-zYg04_ZmcQzBISYEBOkUfKHWBppALWBFaT9DgY0kOQ=",
  //     userId: 2,
  //     categoryId: 2,
  //   ),
  //   Post(
  //     id: 3,
  //     userName: "هزبوووري",
  //     title: "مطلوب مبرمج Python لمشروع مثير",
  //     content:
  //         "نبحث عن مبرمج متميز في لغة Python للعمل على مشروع مبتكر في مجال الذكاء الاصطناعي. إذا كنت تمتلك الخبرة في هذا المجال، فنحن مهتمون بالتعاون معك.",
  //     imageUrl:
  //         "https://t4.ftcdn.net/jpg/00/76/27/53/360_F_76275384_mRNrmAI89UPWoWeUJfCL9CptRxg3cEoF.jpg",
  //     userId: 3,
  //     categoryId: 1,
  //   ),
  //   Post(
  //     id: 4,
  //     userName: "mujahid",
  //     title: "وظيفة شاغرة: مصمم جرافيك محترف",
  //     content:
  //         "شركتنا تبحث عن مصمم جرافيك محترف لإنشاء تصاميم مبتكرة وجذابة. إذا كنت تمتلك مهارات في تصميم الجرافيك والإبداع، نرجو منك التقديم على الوظيفة.",
  //     imageUrl:
  //         "https://media.gettyimages.com/id/107797653/photo/baby-making-faces-at-camera-portrait.jpg?s=612x612&w=0&k=20&c=4HDA4gFI6M50ErwJZMpeg_jTXzE2drKHpZidulvCTPE=",
  //     userId: 4,
  //     categoryId: 2,
  //   ),
  //   Post(
  //     id: 5,
  //     userName: "hamoody",
  //     title: "تعلم برمجة الألعاب باستخدام Unity",
  //     content:
  //         "هل ترغب في تعلم كيفية برمجة الألعاب باستخدام محرك Unity؟ نقدم دورة تعليمية مجانية تغطي جميع جوانب تطوير الألعاب. التسجيل مفتوح للجميع.",
  //     imageUrl:
  //         "https://st.depositphotos.com/1385248/3882/i/600/depositphotos_38820511-stock-photo-portrait-of-young-woman-face.jpg",
  //     userId: 5,
  //     categoryId: 1,
  //   ),
  //   // Add more Post objects as needed
  // ];
  List<String> imageUrls = [
    'https://irs.www.warnerbros.com/keyart-jpeg/movies/media/browser/wonder_woman_whv_keyart.jpg',
    'https://people.com/thmb/QLKXIR1C66uSxH98VRYpLfX3210=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc():focal(999x0:1001x2)/wonder-woman1-1-5f9c6dc8800c40dea1294e0c0aad70e4.jpg',
    'https://people.com/thmb/QLKXIR1C66uSxH98VRYpLfX3210=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc():focal(999x0:1001x2)/wonder-woman1-1-5f9c6dc8800c40dea1294e0c0aad70e4.jpg',
    // 'https://irs.www.warnerbros.com/keyart-jpeg/movies/media/browser/wonder_woman_whv_keyart.jpg',
    // 'https://people.com/thmb/QLKXIR1C66uSxH98VRYpLfX3210=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc():focal(999x0:1001x2)/wonder-woman1-1-5f9c6dc8800c40dea1294e0c0aad70e4.jpg',
    // 'https://irs.www.warnerbros.com/keyart-jpeg/movies/media/browser/wonder_woman_whv_keyart.jpg',
  ];
}
