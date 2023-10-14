
class PaginationRequest{
  final int pageNumber;
  final int? perPage;

  PaginationRequest({required this.pageNumber, this.perPage});

  Map<String, dynamic> toJson(){
    return {
      'page_number': pageNumber,
      if (perPage != null) 'per_page': perPage,
    };
  }
}