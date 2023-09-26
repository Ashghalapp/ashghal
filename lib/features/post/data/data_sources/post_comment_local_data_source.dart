
import 'dart:convert';

import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core_api/dio_service.dart';
import 'package:ashghal_app_frontend/core_api/errors/error_strings.dart';
import 'package:ashghal_app_frontend/core_api/errors/exceptions.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/post/data/models/post_model.dart';



// لكل implement الكلاس الاساسي والي يحتوي العمليات الاساسية حتى يتم منه عمل
// تقنية مستخدمة حتى تمثل مصدر البيانات، وهكذا تسهل عملية التعديل وايضا التغيير
abstract class PostCommentLocalDataSource {
  void casheAlivePosts(List<PostModel> posts);

  List<PostModel> getCashedAlivePosts();

  void casheCompletePosts(List<PostModel> posts);

  List<PostModel> getCashedCompletePosts();

  void cashePosts(List<PostModel> posts);

  List<PostModel> getCashedPosts();

  void casheCurrentUserPosts(List<PostModel> posts);

  List<PostModel> getCashedCurrentUserPosts();
}

class PostCommentLocalDataSourceImpl implements PostCommentLocalDataSource {
  static String authEndPoint = "user/";
  DioService dio = DioService();
  static String postsKey= "cached_posts";
  static String alivePostsKey= "cached_alive_posts";
  static String completePostsKey= "cached_complete_posts";
  static String currentUserPostsKey= "cached_current_user_posts";

  void _cashedPosts(List<PostModel> posts, String key) async{
    List postsJson = posts
        .map<Map<String, dynamic>>((postModel) => postModel.toJson())
        .toList();
    var result = await SharedPref.setString(key, jsonEncode(postsJson));
    result
        ? print("::::::::::::::::::::Done cashed Posts::::::::::::::::::")
        : print("::::::::::::::::::::Faild cashed Posts::::::::::::::::::");
  }

  List<PostModel> _getCashedPosts(String key){
    print(":::::::::::::::::::::Get posts from cashe::::::::::::::::::::::");
    final String? dataString = SharedPref.getString(key);
    if (dataString!= null && dataString != ""){
      List postsJson= jsonDecode(dataString);
      List<PostModel> posts =
          postsJson.map<PostModel>((json) => PostModel.fromJson(json)).toList();
      return posts;
    }
    throw AppException(OfflineFailure(message: ErrorString.OFFLINE_ERROR));
  }

  @override
  Future<void> casheAlivePosts(List<PostModel> posts) async {
    _cashedPosts(posts, alivePostsKey);
  }

  @override
  List<PostModel> getCashedAlivePosts() {
    return _getCashedPosts(alivePostsKey);
  }
  
  @override
  void casheCompletePosts(List<PostModel> posts) {
    _cashedPosts(posts, completePostsKey);
  }

  @override
  List<PostModel> getCashedCompletePosts() {
    return _getCashedPosts(completePostsKey);
  }
  
  @override
  void cashePosts(List<PostModel> posts) {
    _cashedPosts(posts, postsKey);
  }
 
  @override
  List<PostModel> getCashedPosts() {
    return _getCashedPosts(postsKey);
  }
  
  @override
  void casheCurrentUserPosts(List<PostModel> posts) {
    _cashedPosts(posts, currentUserPostsKey);
  }
  
  @override
  List<PostModel> getCashedCurrentUserPosts() {
    print("<<<<<<<<<<<<getCashedCurrentUserPosts>>>>>>>>>>>>");
    return _getCashedPosts(currentUserPostsKey);
  }
}
