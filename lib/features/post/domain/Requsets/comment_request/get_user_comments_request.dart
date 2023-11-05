
import 'package:ashghal_app_frontend/app_library/public_request/pagination_request.dart';

class GetUserCommentsRequest extends PaginationRequest{
  final int currentUserIdi;

  GetUserCommentsRequest({required this.currentUserIdi,required super.pageNumber , required super.perPage});

  @override
  Map<String, Object> toJson(){
    return {
      'user_id': currentUserIdi,
      ... super.toJson(),
    };
  }
}