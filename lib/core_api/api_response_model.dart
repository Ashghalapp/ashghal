class ApiResponseModel {
  bool status;
  String? code;
  String message;
  dynamic data;
  Map<String, List<String>>? errors;

  ApiResponseModel({
    required this.status,
    this.code,
    required this.message,
    this.errors,
    this.data,
  });

  @override
  String toString() {
    return 'ApiResponseModel{status: $status, code: $code, message: $message, data: $data, errors: $errors';
  }

  factory ApiResponseModel.fromJson(Map<String, dynamic> json) {
    Map<String, List<String>>? errorsMap;
    if (json['errors'] != null) {
      errorsMap = {};
      json['errors'].forEach((field, messages) {
        if (messages is List<dynamic>) {
          errorsMap![field] = List<String>.from(messages);
        }
      });
    }
    return ApiResponseModel(
      status: json['status'],
      code: json['code'],
      message: json['message'],
      errors: errorsMap,
      data: json['data'] != null
          ? json['data'] is List
              ? (json['data'] as List).cast<Map<String, dynamic>>()
              : json['data']
          : null,
    );
  }
}
