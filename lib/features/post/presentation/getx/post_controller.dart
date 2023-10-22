import 'dart:io';
import 'package:ashghal_app_frontend/app_library/app_data_types.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core_api/network_info/network_info.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/pagination_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/get_all_alive_post_us.dart';
import 'package:ashghal_app_frontend/features/post/domain/use_cases/post_use_case/get_current_user_posts_uc.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/custom_report_buttomsheet.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/popup_menu_button_widget.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/post_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../core/services/dependency_injection.dart' as di;

import '../../domain/entities/post.dart';

class PostController extends GetxController {
  // List<String> postsOptions = ['Save', 'Report', 'Copy'];
  // RxBool isimageUrlValid = true.obs;
  // RxString trueUrlOrReturnBlank = "".obs;
  RxBool isFavorite = false.obs;
  RxList<Post> postList = <Post>[].obs;
  // final title = ''.obs;
  // final content = ''.obs;

  int pageNumber = 1;
  int perPage = 15;
  // List<Post> alivesPosts = [];

  bool isRequestFinishWithoutData = false;

  // اخر بوست تم من عنده عمل طلب لجلب صفحة index متغير لتخزين
  // جديدة من البوستات وذلك حتى لا يتم تكرار الطلب عدة مرات
  int lastIndexToGetNewPage = 0;

  final GetAllAlivePostsUseCase _getAlivePostsUS = di.getIt();

  @override
  void onInit() {
    super.onInit();
    pageNumber = 1;
    perPage = 15;
    isRequestFinishWithoutData = false;
    // alivesPosts = [];
    getAlivePosts();

    // trueUrlOrReturnBlank = "".obs;
  }

  /// function to refresh the posts and get it from api
  void refreshPosts() {
    postList.value = [];
    isRequestFinishWithoutData = false;
    getAlivePosts();
  }

  Future<void> getAlivePosts() async {
    pageNumber = 1;
    perPage = 15;
    final result = _getAlivePostsUS
        .call(PaginationRequest(pageNumber: pageNumber, perPage: perPage));
    (await result).fold((failure) {
      AppUtil.hanldeAndShowFailure(failure);
      isRequestFinishWithoutData = true;
      postList.value = [];
    }, (posts) {
      isRequestFinishWithoutData = posts.isEmpty;
      postList.value = posts;
      print(">>>>>>>>>>>>>>>>>Done get alive Posts>>>>>>>>>>>>>>>");
    });
  }

  Future<void> loadNextPageOfPosts() async {
    if (await NetworkInfoImpl().isConnected) {
      printInfo(info: "Call loadNextPage");
      pageNumber++;
      final result = _getAlivePostsUS
          .call(PaginationRequest(pageNumber: pageNumber, perPage: perPage));

      (await result).fold((failure) {
        AppUtil.hanldeAndShowFailure(failure);
      }, (posts) {
        postList.addAll(posts);
        printInfo(info: "Done get page $pageNumber from alive Posts");
        // alivesPosts = posts;
      });
    } else {
      AppUtil.showMessage(
          AppLocalization.noInternet, Get.theme.colorScheme.error);
    }
  }

  PopupMenuButtonWidget getPostMenuButtonValuesWidget(int postId) {
    return PopupMenuButtonWidget(
      values: OperationsOnPostPopupMenuValues.values.asNameMap().keys.toList(),
      onSelected: (value) {
        return postPopupMenuButtonOnSelected(value, postId);
      },
    );
  }

  void postPopupMenuButtonOnSelected(String value, int postId) async {
    if (value == OperationsOnPostPopupMenuValues.save.name) {
    } else if (value == OperationsOnPostPopupMenuValues.report.name) {
      Get.bottomSheet(CustomBottomSheet());
    } else if (value == OperationsOnPostPopupMenuValues.copy.name) {
      Post p = postList.firstWhere((element) => element.id == postId);
      ClipboardData clipboardData = ClipboardData(text: p.content);
      await Clipboard.setData(clipboardData);
    }
  }

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

  Future<bool> filterValidImages(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      if (response.statusCode == 200) {
        printError(info: ":::::valid image::::::::");
        return true;
      }
      printError(info: "::::in valid image:::::");
      return false;
    } catch (e) {
      printError(info: "::::::in valid image in catch::::::");
      return false;
    }
  }

  Future<String?> loadImage(String imageUrl) async {
    try {
      if (!(await filterValidImages(imageUrl))) return null;
      DefaultCacheManager cacheManager = DefaultCacheManager();
      FileInfo? fileInfo = await cacheManager.getFileFromCache(imageUrl);
      if (fileInfo == null) {
        // Image is not cached, download and store it locally.
        await cacheManager.downloadFile(imageUrl, force: true);
        fileInfo = await cacheManager.getFileFromCache(imageUrl);
      }
      return fileInfo?.file.path;
    } catch (e) {
      print("::::::::: Error: $e");
      // AppUtil.showMessage(AppLocalization.thereIsSomethingError, Colors.green);
    }
    return null;
  }

  Future<bool> isImage(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      if (response.statusCode == 200) {
        // Check if the content type is an image type.
        return response.headers['content-type']?.startsWith('image/') ?? false;
      }
      return false;
    } catch (e) {
      // Handle errors (e.g., invalid URL, network error).
      return false;
    }
  }

  Future<Widget> getImage(String imageUrl) async {
    try {
      if (await isImage(imageUrl)) {
        return CachedNetworkImage(
          imageUrl: imageUrl,
          // placeholder: ,
          errorWidget: (context, url, error) => Text(error.toString()),
        );
      }
      return Image.asset("assets/images/unKnown.jpg");
    } on SocketException catch (e) {
      print(e);
      // return Image.asset("assets/images/unKnown.jpg");
      throw Exception("hhhhhhhhhhhhhhhhhhh");
    } on HttpException catch (e) {
      print(e);
      throw Exception("hhhhhhhhhhhhhhhhhhh");
    } catch (e) {
      print(e);
      // return Image.asset("assets/images/unKnown.jpg");
      throw Exception("hhhhhhhhhhhhhhhhhhh");
    }
  }

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
      categoryId: 1,
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
      updatedAt: DateTime.now(),
    ),
    Post(
      id: 2,
      title: "شخص يبحث عن مبرمج لتطوير تطبيق موبايل",
      content:
          "أنا أبحث عن مبرمج محترف يمكنه تطوير تطبيق موبايل لنظام Android و iOS. يجب أن يكون لديك خبرة في Flutter و Dart. يرجى التواصل معي إذا كنت مهتمًا.",
      categoryId: 1,
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
      updatedAt: DateTime.now(),
    ),
    Post(
      id: 3,
      title: "شخص يبحث عن مبرمج لتطوير تطبيق موبايل",
      content:
          "أنا أبحث عن مبرمج محترف يمكنه تطوير تطبيق موبايل لنظام Android و iOS. يجب أن يكون لديك خبرة في Flutter و Dart. يرجى التواصل معي إذا كنت مهتمًا.",
      categoryId: 1,
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
      updatedAt: DateTime.now(),
    ),
    Post(
      id: 4,
      title: "شخص يبحث عن مبرمج لتطوير تطبيق موبايل",
      content:
          "أنا أبحث عن مبرمج محترف يمكنه تطوير تطبيق موبايل لنظام Android و iOS. يجب أن يكون لديك خبرة في Flutter و Dart. يرجى التواصل معي إذا كنت مهتمًا.",
      categoryId: 1,
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
      updatedAt: DateTime.now(),
    ),
    Post(
      id: 5,
      title: "شخص يبحث عن مبرمج لتطوير تطبيق موبايل",
      content:
          "أنا أبحث عن مبرمج محترف يمكنه تطوير تطبيق موبايل لنظام Android و iOS. يجب أن يكون لديك خبرة في Flutter و Dart. يرجى التواصل معي إذا كنت مهتمًا.",
      categoryId: 1,
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
      updatedAt: DateTime.now(),
    ),
    Post(
      id: 6,
      title: "شخص يبحث عن مبرمج لتطوير تطبيق موبايل",
      content:
          "أنا أبحث عن مبرمج محترف يمكنه تطوير تطبيق موبايل لنظام Android و iOS. يجب أن يكون لديك خبرة في Flutter و Dart. يرجى التواصل معي إذا كنت مهتمًا.",
      categoryId: 1,
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
      updatedAt: DateTime.now(),
    ),
    Post(
      id: 7,
      title: "شخص يبحث عن مبرمج لتطوير تطبيق موبايل",
      content:
          "أنا أبحث عن مبرمج محترف يمكنه تطوير تطبيق موبايل لنظام Android و iOS. يجب أن يكون لديك خبرة في Flutter و Dart. يرجى التواصل معي إذا كنت مهتمًا.",
      categoryId: 1,
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
