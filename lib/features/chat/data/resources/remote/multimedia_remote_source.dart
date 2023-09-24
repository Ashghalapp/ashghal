// import 'package:ashghal_app_frontend/core_api/api_response_model.dart';
// import 'package:ashghal_app_frontend/core_api/dio_service.dart';
// import 'package:ashghal_app_frontend/core_api/errors/exceptions.dart';
// import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
// import 'package:ashghal_app_frontend/features/chat/data/models/remote_Multimedia_model.dart';

// abstract class MultimediaRemoteSource {
//   Future<RemoteMultimediaModel> uploadFile(Map<String, dynamic> data);
//   Future<List<RemoteMultimediaModel>> getUserMultimediasUpdates();
// }

// class MultimediaRemoteSourceImp extends MultimediaRemoteSource {
//   static const String endPoint = "chat/";
//   final DioService _service = DioService();
//   @override
//   Future<List<RemoteMultimediaModel>> uploadFile() async {
//     ApiResponseModel response =
//         await _service.post("${endPoint}updated-Multimedias", null);
//     if (response.status) {
//       // debugPrint("::: S End getAllPosts func in remote datasource");
//       return RemoteMultimediaModel.fromJsonList(
//           (response.data as List).cast<Map<String, dynamic>>());
//     }
//     throw MyException(ServerFailure(response.message));
//   }

//   @override
//   Future<RemoteMultimediaModel> startMultimedia(
//       Map<String, dynamic> data) async {
//     ApiResponseModel response =
//         await _service.post("${endPoint}start-Multimedia-with", data);
//     if (response.status) {
//       // debugPrint("::: S End getAllPosts func in remote datasource");
//       return RemoteMultimediaModel.fromJson(response.data);
//     }
//     throw MyException(ServerFailure(response.message));
//   }
// }
