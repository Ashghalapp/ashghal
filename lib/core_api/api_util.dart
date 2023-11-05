import 'package:ashghal_app_frontend/app_library/public_entities/app_category.dart';
import 'package:ashghal_app_frontend/core_api/api_constant.dart';
import 'package:ashghal_app_frontend/core_api/api_response_model.dart';
import 'package:ashghal_app_frontend/core_api/dio_service.dart';
import 'package:ashghal_app_frontend/core_api/errors/error_strings.dart';
import 'package:ashghal_app_frontend/core_api/errors/exceptions.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/core_api/network_info/network_info.dart';
import 'package:dartz/dartz.dart';

class ApiUtil {
  static Future<ApiResponseModel> sendRequest(
      {required String method, required String endpoint, Object? data}) async {
    DioService dio = DioService();
    ApiResponseModel response;
    if (method == "get") {
      response = await dio.get(endpoint, data);
    } else if (method == "post") {
      response = await dio.post(endpoint, data);
    } else if (method == "delete") {
      response = await dio.delete(endpoint);
    } else {
      response = ApiResponseModel(
          status: false, message: "Not Specific method to send request");
    }

    if (response.status) {
      print("::: S End sendRequest func in comment_remote_datasource");
      return response;
    }
    print(
        "::: F End sendRequest func in comment_remote_datasource: ${response.message}");
    throw AppException(
        ServerFailure(message: response.message, errors: response.errors));
  }

  // static Future handleErrors(Function function) async {
  //   try {
  //     if (await networkInfo.isConnected) {
  //       return await function();
  //     }
  //     return OfflineFailure(message: ErrorString.OFFLINE_ERROR);
  //   } on AppException catch (e) {
  //     return (e.failure as ServerFailure);
  //   } catch (e) {
  //     print(">>>>>>>>>>Exception in repository: $e");
  //     return NotSpecificFailure(message: e.toString());
  //   }
  // }

  static Future<Either<Failure, List<AppCategory>>> getCategoriesFromApi() async {
    try {
      if (await NetworkInfoImpl().isConnected) {
        return Right(AppCategory.fromJsonList((await sendRequest(
          method: 'get',
          endpoint: ApiConstants.GET_CATEGORIES,
        )).data));
      }
      return Left(OfflineFailure(message: ErrorString.OFFLINE_ERROR));
    } on AppException catch (e) {
      return Left(e.failure as ServerFailure);
    } catch (e) {
      print(">>>>>>>>>>Exception in repository: $e");
      return Left(NotSpecificFailure(message: e.toString()));
    }
  }
}
