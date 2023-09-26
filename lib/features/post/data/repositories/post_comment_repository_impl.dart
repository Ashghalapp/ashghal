import 'package:ashghal_app_frontend/core_api/errors/error_strings.dart';
import 'package:ashghal_app_frontend/core_api/errors/exceptions.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/core_api/network_info/network_info.dart';
import 'package:ashghal_app_frontend/core_api/success/success.dart';
import 'package:ashghal_app_frontend/features/post/data/data_sources/post_comment_local_data_source.dart';
import 'package:ashghal_app_frontend/features/post/data/data_sources/post_comment_remote_data_source.dart';
import 'package:ashghal_app_frontend/features/post/data/models/post_model.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/add_update_post_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/delete_some_post_multimedia_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/get_category_posts_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/get_posts_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/Requsets/get_user_posts_request.dart';
import 'package:ashghal_app_frontend/features/post/domain/entities/post.dart';
import 'package:ashghal_app_frontend/features/post/domain/repositories/post_comment_repository.dart';
import 'package:dartz/dartz.dart';

class PostCommentRepositoryImpl extends PostCommentRepository {
  PostCommentRemoteDataSource postCommentRemoteDS = PostCommentRemoteDataSourceImpl();
  PostCommentLocalDataSource postCommentLocalDS = PostCommentLocalDataSourceImpl();
  NetworkInfo networkInfo = NetworkInfoImpl();

  @override
  Future<Either<Failure, Post>> addPost(AddPostRequest request) async {
    var result = await _handleErrors(() async {
      return await postCommentRemoteDS.addPost(request);
    });
    return result is Post ? Right(result) : Left(result);
  }

  @override
  Future<Either<Failure, Success>> deletePost(int id) async{
    var result = await _handleErrors(() async {
      return await postCommentRemoteDS.deletePost(id);
    });
    return result is Success ? Right(result) : Left(result);
  }

  @override
  Future<Either<Failure, Success>> deleteSomePostMultimedia(DeleteSomePostMultimediaRequest request)async {
    var result = await _handleErrors(() async {
      return await postCommentRemoteDS.deleteSomePostMultimedia(request);
    });
    return result is Success ? Right(result) : Left(result);
  }

  @override
  Future<Either<Failure, List<Post>>> getAllAlivePosts(GetPostsRequest request) async{
    try {
      if (await networkInfo.isConnected) {
        List<PostModel> posts = await postCommentRemoteDS.getAllAlivePosts(request);
        postCommentLocalDS.casheAlivePosts(posts);
        return Right(posts);
      } else {
        return Right(postCommentLocalDS.getCashedAlivePosts());
      }
    } on AppException catch (e) {
      return Left(e.failure);
    } catch (e) {
      print(">>>>>>>>>>Exception in repository: $e");
      return Left(NotSpecificFailure(message: e.toString()));
    }
    // var result = await _handleErrors(() async {
    //   return await postCommentRemoteDS.getAllAlivePosts(request);
    // });
    // return result is List<Post> ? Right(result) : Left(result);
  }

  @override
  Future<Either<Failure, List<Post>>> getAllCompletePosts(GetPostsRequest request) async{
    try {
      if (await networkInfo.isConnected) {
        List<PostModel> posts = await postCommentRemoteDS.getAllCompletePosts(request);
        postCommentLocalDS.casheCompletePosts(posts);
        return Right(posts);
      } else {
        return Right(postCommentLocalDS.getCashedCompletePosts());
      }
    } on AppException catch (e) {
      return Left(e.failure);
    } catch (e) {
      print(">>>>>>>>>>Exception in repository: $e");
      return Left(NotSpecificFailure(message: e.toString()));
    }
    // var result = await _handleErrors(() async {
    //   return await postCommentRemoteDS.getAllCompletePosts(request);
    // });
    // return result is List<Post> ? Right(result) : Left(result);
  }
  // Future<Either<Failure, List<Post>>> _h(dynamic request, Future<List<PostModel>> Function(dynamic request) getRemoteDataFun, void Function(List<PostModel>) casheDataFun, List<PostModel> Function() getCashedDataFun) async{
  //   try {
  //     if (await networkInfo.isConnected) {
  //       List<PostModel> posts = await getRemoteDataFun(request);
  //       casheDataFun(posts);
  //       return Right(posts);
  //     } else {
  //       return Right(getCashedDataFun());
  //     }
  //   } on AppException catch (e) {
  //     return Left(e.failure);
  //   } catch (e) {
  //     print(">>>>>>>>>>Exception in repository: $e");
  //     return Left(NotSpecificFailure(message: e.toString()));
  //   }
  // }

  @override
  Future<Either<Failure, List<Post>>> getAllPosts(GetPostsRequest request) async{
    try {
      if (await networkInfo.isConnected) {
        List<PostModel> posts = await postCommentRemoteDS.getAllPosts(request);
        postCommentLocalDS.cashePosts(posts);
        return Right(posts);
      } else {
        return Right(postCommentLocalDS.getCashedPosts());
      }
    } on AppException catch (e) {
      return Left(e.failure);
    } catch (e) {
      print(">>>>>>>>>>Exception in repository: $e");
      return Left(NotSpecificFailure(message: e.toString()));
    }
    // var result = await _handleErrors(() async {
    //   return await postCommentRemoteDS.getAllPosts(request);
    // });
    // return result is List<Post> ? Right(result) : Left(result);
  }

  @override
  Future<Either<Failure, List<Post>>> getCategoryPosts(GetCategoryPostsRequest request) async{
    var result = await _handleErrors(() async {
      return await postCommentRemoteDS.getCategoryPosts(request);
    });
    return result is List<Post> ? Right(result) : Left(result);
  }

  @override
  Future<Either<Failure, List<Post>>> getCurrentUserPosts(GetPostsRequest request)async {
    try {
      if (await networkInfo.isConnected) {
        List<PostModel> posts = await postCommentRemoteDS.getCurrentUserPosts(request);
        postCommentLocalDS.casheCurrentUserPosts(posts);
        return Right(posts);
      } else {
        return Right(postCommentLocalDS.getCashedCurrentUserPosts());
      }
    } on AppException catch (e) {
      return Left(e.failure);
    } catch (e) {
      print(">>>>>>>>>>Exception in repository: $e");
      return Left(NotSpecificFailure(message: e.toString()));
    }
  //  var result = await _handleErrors(() async {
  //     return await postCommentRemoteDS.getCurrentUserPosts(request);
  //   });
  //   return result is List<Post> ? Right(result) : Left(result);
  }

  @override
  Future<Either<Failure, Post>> getSpecificPost(int postId) async{
    var result = await _handleErrors(() async {
      return await postCommentRemoteDS.getSpecificPost(postId);
    });
    return result is Post ? Right(result) : Left(result);
  }

  @override
  Future<Either<Failure, List<Post>>> getUserPosts(GetUserPostsRequest request) async{
    var result = await _handleErrors(() async {
      return await postCommentRemoteDS.getUserPosts(request);
    });
    return result is List<Post> ? Right(result) : Left(result);
  }

  @override
  Future<Either<Failure, List<Post>>> searchForPost(String data) async{
    var result = await _handleErrors(() async {
      return await postCommentRemoteDS.searchForPost(data);
    });
    return result is List<Post> ? Right(result) : Left(result);
  }

  @override
  Future<Either<Failure, Post>> updatePost(UpdatePostRequest request) async {
    var result = await _handleErrors(() async {
      return await postCommentRemoteDS.updatePost(request);
    });
    return result is Post ? Right(result) : Left(result);
  }

  Future _handleErrors(Function function) async {
    try {
      if (await networkInfo.isConnected) {
        return await function();
      }
      return OfflineFailure(message: ErrorString.OFFLINE_ERROR);
    } on AppException catch (e) {
      return (e.failure as ServerFailure);
    } catch (e) {
      print(">>>>>>>>>>Exception in repository: $e");
      return NotSpecificFailure(message: e.toString());
    }
  }
}
