
import 'package:ashghal_app_frontend/features/post/domain/Requsets/pagination_request.dart';

class GetUserCommentsRequest extends PaginationRequest{
  final int userId;

  GetUserCommentsRequest({required this.userId,required super.pageNumber , required super.perPage});

  @override
  Map<String, Object> toJson(){
    return {
      'user_id': userId,
      ... super.toJson(),
    };
  }
}