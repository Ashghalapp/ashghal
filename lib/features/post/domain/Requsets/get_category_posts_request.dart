
import 'package:ashghal_app_frontend/features/post/domain/Requsets/get_posts_request.dart';

class GetCategoryPostsRequest extends GetPostsRequest{
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