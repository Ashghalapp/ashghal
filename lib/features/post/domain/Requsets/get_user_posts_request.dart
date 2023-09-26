import 'get_posts_request.dart';

class GetUserPostsRequest extends GetPostsRequest {
  final int userId;

  GetUserPostsRequest(
      {required this.userId,
      required super.pageNumber,
      required super.perPage});

  @override
  Map<String, Object> toJson() {
    return {
      'user_id': userId,
      ...super.toJson(),
    };
  }
}
