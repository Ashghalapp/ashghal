
class GetPostsRequest{
  final int pageNumber;
  final int perPage;

  GetPostsRequest({required this.pageNumber, required this.perPage});

  Map<String, Object> toJson(){
    return {
      'page_number': pageNumber,
      'per_page': perPage,
    };
  }
}