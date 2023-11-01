
import 'package:ashghal_app_frontend/app_library/public_request/pagination_request.dart';

class GetCategoryPostsRequest extends PaginationRequest{
  final int categoryId;

  GetCategoryPostsRequest({required this.categoryId,required super.pageNumber , required super.perPage});

  @override
  Map<String, Object> toJson(){
    return {
      'category_id': categoryId,
      ... super.toJson(),
    };
  }
}