import 'dart:async';

import 'package:ashghal_app_frontend/core_api/errors/error_strings.dart';
import 'package:ashghal_app_frontend/core_api/errors/exceptions.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:dio/dio.dart';

import 'api_constant.dart';
import 'api_response_model.dart';
import 'public_interceptor.dart';

class DioService {
  final int connectTimeout = 60;
  late Dio _dio;
  DioService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: Duration(seconds: connectTimeout + 5),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      receiveDataWhenStatusError: true,
    ));
    _dio.interceptors.add(PublicInterceptor());
    _dio.interceptors
        .add(LogInterceptor(responseBody: true, requestBody: true));
  }

  Future<ApiResponseModel> get(String path, Object? data) async {
    print("?????????????????Before send request??????????????????????");
    CancelToken cancelToken = CancelToken();
    Response response =
        await _dio.get(path, data: data, cancelToken: cancelToken).timeout(
              Duration(seconds: connectTimeout),
              onTimeout: () => _onTimeOut(cancelToken),
              // () {
              //   cancelToken.cancel("error in dio service that the timeout");
              //   throw AppException(const ServerFailure(
              //     message: "The server was not ready or busy.. try again",
              //   ));
              // },
            );

    print("?????????????????after send request??????????????????????");
    if (response.statusCode == 200) {
      print("????????????????????Success status request???????????????????");
      ApiResponseModel responseModel = ApiResponseModel.fromJson(response.data);
      return responseModel;
    } else {
      return ApiResponseModel(
          status: false,
          message: response.statusMessage ?? ErrorString.SERVER_ERROR);
    }
  }

  Future<ApiResponseModel> post(String path, Object? data) async {
    print("???????????????????????????????????????");
    CancelToken cancelToken = CancelToken();
    Response response =
        await _dio.post(path, data: data, cancelToken: cancelToken).timeout(
              Duration(seconds: connectTimeout),
              onTimeout: () => _onTimeOut(cancelToken),
            );
    print("???????///////////?????????????????????????");
    print("?????????????????${response.statusCode}??${response.statusMessage}");
    if (response.statusCode == 200) {
      print("???????????????????????????????????????");
      ApiResponseModel responseModel = ApiResponseModel.fromJson(response.data);
      return responseModel;
    } else {
      return ApiResponseModel(
          status: false,
          message: response.statusMessage ?? ErrorString.SERVER_ERROR);
    }
  }

  Future<ApiResponseModel> delete(String path) async {
    CancelToken cancelToken = CancelToken();
    Response response = await _dio.delete(path).timeout(
          Duration(seconds: connectTimeout),
          onTimeout: () => _onTimeOut(cancelToken),
        );
    if (response.statusCode == 200) {
      print("???????????????????????????????????????");
      ApiResponseModel responseModel = ApiResponseModel.fromJson(response.data);
      return responseModel;
    } else {
      return ApiResponseModel(
          status: false,
          message: response.statusMessage ?? ErrorString.SERVER_ERROR);
    }
  }

  FutureOr<Response> _onTimeOut(CancelToken cancelToken) {
    cancelToken.cancel("error in dio service that the timeout");
    throw AppException(const ServerFailure(
      message: "The server was not ready or busy.. try again",
    ));
  }

  // Future<Response> getUsers() async {
  //   return await _dio.get("/user/get");
  // }

  // Future<Response> getSpecificUser() async {
  //   return await _dio.get("/user/get/5");
  // }
}
