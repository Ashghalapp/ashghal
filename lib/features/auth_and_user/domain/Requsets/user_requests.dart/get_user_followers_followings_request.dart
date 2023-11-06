import 'package:ashghal_app_frontend/app_library/public_request/pagination_request.dart';

class GetUserFollowersFollowingsRequest extends PaginationRequest{
  int currentUserIdi;


  GetUserFollowersFollowingsRequest({
    required this.currentUserIdi,
    required super.pageNumber,
    super.perPage,
  });

  @override
  Map<String, Object> toJson() {
    return {
      'user_id': currentUserIdi,
      ...super.toJson(),
    };
  }
}
