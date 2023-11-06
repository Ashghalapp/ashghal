import '../../../../../app_library/public_request/pagination_request.dart';

class GetUserPostsRequest extends PaginationRequest {
  final int currentUserIdi;

  GetUserPostsRequest(
      {required this.currentUserIdi,
      required super.pageNumber,
      required super.perPage});

  @override
  Map<String, Object> toJson() {
    return {
      'user_id': currentUserIdi,
      ...super.toJson(),
    };
  }
}
