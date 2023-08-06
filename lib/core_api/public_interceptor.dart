import 'package:ashghal_app_frontend/core/shared_preference.dart';
import 'package:dio/dio.dart';

import 'api_constant.dart';

class PublicInterceptor extends Interceptor{
  // @override
  // void onError(DioException err, ErrorInterceptorHandler handler) {
  //     handler.next(err);
  // }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers = ApiConstants.headers;
    String? authToken= await SharedPref.getUserToken();
    if (authToken!=null){
      options.headers['Authorization'] = 'Bearer $authToken';
    }
    return super.onRequest(options, handler);
  }

  // @override
  // void onResponse(Response response, ResponseInterceptorHandler handler) {
  //   return super.onResponse(response, handler);
  // }

}