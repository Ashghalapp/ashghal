import 'package:dio/dio.dart';

import '../core/helper/shared_preference.dart';
import 'api_constant.dart';

class PublicInterceptor extends Interceptor {
  // @override
  // void onError(DioException err, ErrorInterceptorHandler handler) {
  //     handler.next(err);
  // }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers = ApiConstants.headers;
    String? authToken = SharedPref.getUserToken();
    if (authToken != null) {
      options.headers['Authorization'] = 'Bearer $authToken';
      // options.headers['Authorization'] =
      //     'Bearer ToPDmCqO832mEK5fP5n8R6ACngtRPuDOfLLRnG61';
    }
    return super.onRequest(options, handler);
  }

  // @override
  // void onResponse(Response response, ResponseInterceptorHandler handler) {
  //   return super.onResponse(response, handler);
  // }
}
