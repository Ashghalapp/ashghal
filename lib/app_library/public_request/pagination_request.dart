
class PaginationRequest{
  final int pageNumber;
  final int? perPage;
  final int? currentUserIdi;

  PaginationRequest({required this.pageNumber, this.perPage, this.currentUserIdi});

  Map<String, dynamic> toJson(){
    return {
      'page_number': pageNumber,
      if (perPage != null) 'per_page': perPage,
      if (currentUserIdi != null) 'user_id': currentUserIdi,
    };
  }
}