import 'pagination_request.dart';

class SearchRequest extends PaginationRequest {
  final String dataForSearch;

  SearchRequest({
    required this.dataForSearch,
    required super.pageNumber,
    required super.perPage,
  });

  @override
  Map<String, Object> toJson() {
    return {
      'data_for_search': dataForSearch,
      ...super.toJson(),
    };
  }
}
