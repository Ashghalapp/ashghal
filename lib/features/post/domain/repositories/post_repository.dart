// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: type=lint
import 'package:ashghal_app_frontend/features/post/domain/Requsets/post_request/add_update_post_request.dart';
import 'package:ashghal_app_frontend/app_library/public_request/search_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/post.dart';
import 'package:dartz/dartz.dart';

import '../../../../core_api/errors/failures.dart';
import '../../../../core_api/success/success.dart';
import '../Requsets/post_request/delete_some_post_multimedia_request.dart';
import '../Requsets/post_request/get_category_posts_request.dart';
import '../../../../app_library/public_request/pagination_request.dart';
import '../Requsets/post_request/get_user_posts_request.dart';

abstract class PostRepository {
  Future<Either<Failure, List<Post>>> getAllPosts(PaginationRequest request);
  
  Future<Either<Failure, List<Post>>> getRecentPosts(PaginationRequest request);

  Future<Either<Failure, List<Post>>> getAllAlivePosts(PaginationRequest request);

  Future<Either<Failure, List<Post>>> getAllCompletePosts(PaginationRequest request);

  /// الخاص به token تسجيل الدخول للمستخدم مع الاحتفاظ بالـ
  Future<Either<Failure, Post>> getSpecificPost(int postId);

  Future<Either<Failure, List<Post>>> getCategoryPosts(GetCategoryPostsRequest request);

  Future<Either<Failure, List<Post>>> getUserPosts(GetUserPostsRequest request);

  Future<Either<Failure, List<Post>>> getCurrentUserPosts(PaginationRequest request);

  Future<Either<Failure, Post>> addPost(AddPostRequest request);

  Future<Either<Failure, Post>> updatePost(UpdatePostRequest request);

  /// the search will be on title, desc, add_city, add_street, and add_desc
  Future<Either<Failure, List<Post>>> searchForPosts(SearchRequest request);


  Future<Either<Failure, Success>> deletePost(int id);

  /// دالة لحذف اي وسائط او ملفات متعلقة بالبوست
  Future<Either<Failure, Success>> deleteSomePostMultimedia(DeleteSomePostMultimediaRequest request);
}
//