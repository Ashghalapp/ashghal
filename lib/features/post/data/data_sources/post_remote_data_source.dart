import 'package:ashghal_app_frontend/core_api/api_constant.dart';
import 'package:ashghal_app_frontend/core_api/api_response_model.dart';
import 'package:ashghal_app_frontend/core_api/dio_service.dart';
import 'package:ashghal_app_frontend/core_api/errors/exceptions.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/core_api/success/success.dart';
import 'package:ashghal_app_frontend/features/post/data/models/post_model.dart';
import 'package:ashghal_app_frontend/app_library/public_request/search_request.dart';

import '../../domain/Requsets/post_request/add_update_post_request.dart';
import '../../domain/Requsets/post_request/delete_some_post_multimedia_request.dart';
import '../../domain/Requsets/post_request/get_category_posts_request.dart';
import '../../../../app_library/public_request/pagination_request.dart';
import '../../domain/Requsets/post_request/get_user_posts_request.dart';

// لكل implement الكلاس الاساسي والي يحتوي العمليات الاساسية حتى يتم منه عمل
// تقنية مستخدمة حتى تمثل مصدر البيانات، وهكذا تسهل عملية التعديل وايضا التغيير
abstract class PostRemoteDataSource {
  Future<List<PostModel>> getAllPosts(PaginationRequest request);

  Future<List<PostModel>> getRecentPosts(PaginationRequest request);

  Future<List<PostModel>> getAllAlivePosts(PaginationRequest request);

  Future<List<PostModel>> getAllCompletePosts(PaginationRequest request);

  /// الخاص به token تسجيل الدخول للمستخدم مع الاحتفاظ بالـ
  Future<PostModel> getSpecificPost(int postId);

  Future<List<PostModel>> getCategoryPosts(GetCategoryPostsRequest request);

  Future<List<PostModel>> getUserPosts(GetUserPostsRequest request);

  Future<List<PostModel>> getCurrentUserPosts(PaginationRequest request);

  Future<PostModel> addPost(AddPostRequest request);

  Future<PostModel> updatePost(UpdatePostRequest request);

  /// the search will be on title, desc, add_city, add_street, and add_desc
  Future<List<PostModel>> searchForPosts(SearchRequest request);

  Future<Success> deletePost(int id);

  /// دالة لحذف اي وسائط او ملفات متعلقة بالبوست
  Future<Success> deleteSomePostMultimedia(
      DeleteSomePostMultimediaRequest request);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  // static String authEndPoint = "user/";
  DioService dio = DioService();

  @override
  Future<List<PostModel>> getAllPosts(PaginationRequest request) async {
    ApiResponseModel response =
        await dio.get(ApiConstants.GET_ALL_POSTS, request.toJson());
    if (response.status) {
      print("::: S End getAllPosts func in post_comment_remote_datasource");
      return PostModel.fromJsonList(response.data);
    }
    throw AppException(
        ServerFailure(message: response.message, errors: response.errors));
  }

   @override
  Future<List<PostModel>> getRecentPosts(PaginationRequest request) async {
    ApiResponseModel response =
        await dio.get(ApiConstants.GET_RECENT_POSTS, request.toJson());
    if (response.status) {
      print("::: S End getRecentPosts func in post_remote_datasource");
      return PostModel.fromJsonList(response.data);
    }
    throw AppException(
        ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<List<PostModel>> getAllAlivePosts(PaginationRequest request) async {
    ApiResponseModel response =
        await dio.get(ApiConstants.GET_ALL_ALIVE_POSTS, request.toJson());
    if (response.status) {
      print(
          "::: S End getAllAlivePosts func in post_comment_remote_datasource");
      return PostModel.fromJsonList(response.data);
    }
    throw AppException(
        ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<List<PostModel>> getAllCompletePosts(PaginationRequest request) async {
    ApiResponseModel response =
        await dio.get(ApiConstants.GET_ALL_COMPLETE_POSTS, request.toJson());
    if (response.status) {
      print(
          "::: S End getAllCompletePosts func in post_comment_remote_datasource");
      return PostModel.fromJsonList(response.data);
    }
    throw AppException(
        ServerFailure(message: response.message, errors: response.errors));
  }

 

  @override
  Future<List<PostModel>> getCategoryPosts(
      GetCategoryPostsRequest request) async {
    ApiResponseModel response =
        await dio.get(ApiConstants.GET_CATEGORY_POSTS, request.toJson());
    if (response.status) {
      print(
          "::: S End getCategoryPosts func in post_comment_remote_datasource");
      return PostModel.fromJsonList(response.data);
    }
    throw AppException(
        ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<List<PostModel>> getCurrentUserPosts(PaginationRequest request) async {
    ApiResponseModel response =
        await dio.get(ApiConstants.GET_CURRENT_USER_POSTS, request.toJson());
    if (response.status) {
      print(
          "::: S End getCurrentUserPosts func in post_comment_remote_datasource");
      return PostModel.fromJsonList(response.data);
    }
    throw AppException(
        ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<PostModel> getSpecificPost(int postId) async {
    ApiResponseModel response =
        await dio.get("${ApiConstants.GET_SPECIFIC_POST}$postId", null);
    if (response.status) {
      print("::: S End getSpecificPost func in post_comment_remote_datasource");
      return PostModel.fromJson(response.data);
    }
    throw AppException(
        ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<List<PostModel>> getUserPosts(GetUserPostsRequest request) async {
    ApiResponseModel response =
        await dio.get(ApiConstants.GET_USER_POSTS, request.toJson());
    if (response.status) {
      print("::: S End getUserPosts func in post_comment_remote_datasource");
      return PostModel.fromJsonList(response.data);
    }
    throw AppException(
        ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<PostModel> addPost(AddPostRequest request) async {
    ApiResponseModel response =
        await dio.post(ApiConstants.ADD_POST, await request.toJson());
    if (response.status) {
      print("::: S End addPost func in post_comment_remote_datasource");
      return PostModel.fromJson(response.data);
    }
    throw AppException(
        ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<Success> deletePost(int id) async {
    ApiResponseModel response =
        await dio.delete("${ApiConstants.DELETE_POST}$id");
    if (response.status) {
      print("::: S End deletePost func in post_comment_remote_datasource");
      return ServerSuccess(response.message);
    }
    throw AppException(
        ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<Success> deleteSomePostMultimedia(
      DeleteSomePostMultimediaRequest request) async {
    ApiResponseModel response = await dio.post(
        ApiConstants.DELETE_SOME_POST_MULTIMEDIA, request.toJson());
    if (response.status) {
      print(
          "::: S End deleteSomePostMultimedia func in post_comment_remote_datasource");
      return ServerSuccess(response.message);
    }
    throw AppException(
        ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<List<PostModel>> searchForPosts(SearchRequest request) async {
    ApiResponseModel response =
        await dio.get(ApiConstants.SEARCH_FOR_POSTS, request.toJson());
    if (response.status) {
      print("::: S End searchForPost func in post_comment_remote_datasource");
      return PostModel.fromJsonList(response.data);
    }
    throw AppException(
        ServerFailure(message: response.message, errors: response.errors));
  }

  @override
  Future<PostModel> updatePost(UpdatePostRequest request) async {
    ApiResponseModel response =
        await dio.post(ApiConstants.UPDATE_POST, await request.toJson());
    if (response.status) {
      print("::: S End updatePost func in post_comment_remote_datasource");
      return PostModel.fromJson(response.data);
    }
    throw AppException(
        ServerFailure(message: response.message, errors: response.errors));
  }
}
