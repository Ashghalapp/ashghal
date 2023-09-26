// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: type=lint
import 'package:ashghal_app_frontend/features/post/domain/Requsets/add_update_post_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/post.dart';
import 'package:dartz/dartz.dart';

import '../../../../core_api/errors/failures.dart';
import '../../../../core_api/success/success.dart';
import '../Requsets/delete_some_post_multimedia_request.dart';
import '../Requsets/get_category_posts_request.dart';
import '../Requsets/get_posts_request.dart';
import '../Requsets/get_user_posts_request.dart';




abstract class PostCommentRepository {
  Future<Either<Failure, List<Post>>> getAllPosts(GetPostsRequest request);

  Future<Either<Failure, List<Post>>> getAllAlivePosts(GetPostsRequest request);

  Future<Either<Failure, List<Post>>> getAllCompletePosts(GetPostsRequest request);

  /// الخاص به token تسجيل الدخول للمستخدم مع الاحتفاظ بالـ
  Future<Either<Failure, Post>> getSpecificPost(int postId);

  Future<Either<Failure, List<Post>>> getCategoryPosts(GetCategoryPostsRequest request);

  Future<Either<Failure, List<Post>>> getUserPosts(GetUserPostsRequest request);

  Future<Either<Failure, List<Post>>> getCurrentUserPosts(GetPostsRequest request);

  Future<Either<Failure, Post>> addPost(AddPostRequest request);

  Future<Either<Failure, Post>> updatePost(UpdatePostRequest request);

  /// the search will be on title, desc, add_city, add_street, and add_desc
  Future<Either<Failure, List<Post>>> searchForPost(String data);


  Future<Either<Failure, Success>> deletePost(int id);

  /// دالة لحذف اي وسائط او ملفات متعلقة بالبوست
  Future<Either<Failure, Success>> deleteSomePostMultimedia(DeleteSomePostMultimediaRequest request);
}
//