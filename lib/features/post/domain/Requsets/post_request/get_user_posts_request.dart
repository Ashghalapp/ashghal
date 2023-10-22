import '../pagination_request.dart';

class GetUserPostsRequest extends PaginationRequest {
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
