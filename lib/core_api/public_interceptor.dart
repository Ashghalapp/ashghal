
import 'package:dio/dio.dart';

import '../core/helper/shared_preference.dart';
import 'api_constant.dart';

class PublicInterceptor extends Interceptor{
  // @override
  // void onError(DioException err, ErrorInterceptorHandler handler) {
  //   print("<>::::::::::::Error in dio :${err.message}");
  //     // handler.next(err);
  // }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers = ApiConstants.headers;
    String? authToken=  SharedPref.getUserToken();
    if (authToken!=null){
      options.headers['Authorization'] = 'Bearer $authToken';
    }
    return super.onRequest(options, handler);
  }

  // @override
  // void onResponse(Response response, ResponseInterceptorHandler handler) {
  //   print("<>::::::::::::Error in dio :${response}");
  //   return super.onResponse(response, handler);
  // }

}