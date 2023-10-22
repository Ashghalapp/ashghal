import 'dart:async';

import 'dart:convert';

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

  Future<ApiResponseModel> get(String path, [Object? data]) async {
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

  Future<bool> head(String path) async {
    try {
      final response = await _dio.head(path);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
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

  Future<Response> download({
    required String url,
    required String savePath,
    void Function(int, int)? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    // print("???????????????????????????????????????");
    return await _dio.download(
      url,
      savePath,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
    );
    // print("???????///////////?????????????????????????");
    // print("?????????????????${response.statusCode}??${response.statusMessage}");
    // if (response.statusCode == 200) {
    //   // print("???????????????????????????????????????");
    //   ApiResponseModel responseModel = ApiResponseModel.fromJson(response.data);
    //   return true;
    // } else {
    // response.
    // return false;
    // }
  }

  Future<ApiResponseModel> uploadMultimedia(String path, Object? data,
      {void Function(int, int)? onSendProgress,
      CancelToken? cancelToken}) async {
    // print("???????????????????????????????????????");
    Response response = await _dio.post(path,
        data: data, onSendProgress: onSendProgress, cancelToken: cancelToken);
    // print("???????///////////?????????????????????????");
    print("?????????????????${response.statusCode}??${response.statusMessage}");
    if (response.statusCode == 200) {
      // print("???????????????????????????????????????");
      ApiResponseModel responseModel = ApiResponseModel.fromJson(response.data);
      return responseModel;
    } else {
      return ApiResponseModel(
          status: false,
          message: response.statusMessage ?? ErrorString.SERVER_ERROR);
    }
  }

  Future<dynamic> autherizeUserOnChannel(
      {required String socketId, required String channelName}) async {
    Response response = await _dio.post(
      ApiConstants.channelsAutherizingUrl,
      data: {'socket_id': socketId, 'channel_name': channelName},
      // options: Options(
      //   headers: {
      //     'Authorization': 'Bearer H1yyza0I8r87vRAJXWn3H84EN3SjiEqn3QePFV2q',
      //   },
      // ),
    );
    print("?????????????????${response.statusCode}??${response.statusMessage}");
    print("?????????????????${response.data}??${response.statusMessage}");
    // var json = jsonDecode(response.data);
    return response.data;
    // if (response.statusCode == 200) {
    //   var json = jsonDecode(response.data);
    //   return json;
    // } else {
    //   throw Exception("Failed to authenticate the user in such a channel");
    // }
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

  // Future<Response> getUsers()  async {
  //   return await _dio.get("/user/get");
  // }

  // Future<Response> getSpecificUser()  async {
  //   return await _dio.get("/user/get/5");
  // }
}
