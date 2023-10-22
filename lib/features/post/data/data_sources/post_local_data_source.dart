
import 'dart:convert';

import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core_api/dio_service.dart';
import 'package:ashghal_app_frontend/core_api/errors/error_strings.dart';
import 'package:ashghal_app_frontend/core_api/errors/exceptions.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/post/data/models/comment_model.dart';
import 'package:ashghal_app_frontend/features/post/data/models/post_model.dart';
import 'package:ashghal_app_frontend/features/post/data/models/reply_model.dart';

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

  void cashePostComments(List<CommentModel> comments);
  
  List<CommentModel> getCashePostComments();

  void casheCommentReplies(List<ReplyModel> replies);

  List<ReplyModel> getCasheCommentReplies();
}

class PostCommentLocalDataSourceImpl implements PostCommentLocalDataSource {
  DioService dio = DioService();
  static String allPostsKey= "cached_posts";
  static String alivePostsKey= "cached_alive_posts";
  static String completePostsKey= "cached_complete_posts";
  static String currentUserPostsKey= "cached_current_user_posts";

  static String postCommentsKey= "cached_post_comments";
  static String commentRepliesKey= "cached_comment_replies";

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
    _cashedPosts(posts, allPostsKey);
  }
 
  @override
  List<PostModel> getCashedPosts() {
    return _getCashedPosts(allPostsKey);
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
  
  @override
  void casheCommentReplies(List<ReplyModel> replies) async {
   List repliesJson = replies
        .map<Map<String, dynamic>>((replyModel) => replyModel.toJson())
        .toList();
    var result = await SharedPref.setString(commentRepliesKey, jsonEncode(repliesJson));
    result
        ? print("::::::::::::::::::::Done cashed comment replies::::::::::::::::::")
        : print("::::::::::::::::::::Faild cashed comment replies::::::::::::::::::");
  }
  
  @override
  void cashePostComments(List<CommentModel> comments) async{
    List commentsJson = comments
        .map<Map<String, dynamic>>((commentModel) => commentModel.toJson())
        .toList();
    var result = await SharedPref.setString(postCommentsKey, jsonEncode(commentsJson));
    result
        ? print("::::::::::::::::::::Done cashed post comments: ${jsonEncode(commentsJson)}::::::::::::::::::")
        : print("::::::::::::::::::::Faild cashed post comments::::::::::::::::::");
  }
  
  @override
  List<ReplyModel> getCasheCommentReplies() {
    print(":::::::::::::::::::::Get comment replies from cashe::::::::::::::::::::::");
    final String? dataString = SharedPref.getString(commentRepliesKey);
    if (dataString!= null && dataString != ""){
      List repliesJson= jsonDecode(dataString);
      List<ReplyModel> replies =
          repliesJson.map((json) => ReplyModel.fromJson(json)).toList();
      return replies;
    }
    throw AppException(OfflineFailure(message: ErrorString.OFFLINE_ERROR));
  }
  
  @override
  List<CommentModel> getCashePostComments() {
    print(":::::::::::::::::::::Get post comments from cashe::::::::::::::::::::::");
    final String? dataString = SharedPref.getString(postCommentsKey);
    // print(":::::::::Post Comments Cashed are: $dataString");
    if (dataString!= null && dataString != ""){
      List commentsJson= jsonDecode(dataString);
      List<CommentModel> comments =
          commentsJson.map((json) => CommentModel.fromJson(json)).toList();
      return comments;
    }
    throw AppException(OfflineFailure(message: ErrorString.OFFLINE_ERROR));
  }
}
