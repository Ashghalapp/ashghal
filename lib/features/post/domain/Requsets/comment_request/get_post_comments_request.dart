
import 'package:ashghal_app_frontend/app_library/public_request/pagination_request.dart';

class GetPostCommentsRequest extends PaginationRequest{
  final int postId;

  GetPostCommentsRequest({required this.postId,required super.pageNumber , super.perPage});

  @override
  Map<String, Object> toJson(){
    return {
      'post_id': postId,
      ... super.toJson(),
    };
  }
}