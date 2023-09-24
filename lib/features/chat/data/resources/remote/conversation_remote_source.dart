import 'package:ashghal_app_frontend/core_api/api_response_model.dart';
import 'package:ashghal_app_frontend/core_api/dio_service.dart';
import 'package:ashghal_app_frontend/core_api/errors/exceptions.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/remote_conversation_model.dart';

abstract class ConversationRemoteSource {
  Future<RemoteConversationModel> startConversation(Map<String, dynamic> data);
  Future<List<RemoteConversationModel>> getUserConversationsUpdates();
  Future<ApiResponseModel> blockConversation(Map<String, dynamic> data);
  Future<ApiResponseModel> unblockConversation(Map<String, dynamic> data);
}

class ConversationRemoteSourceImp extends ConversationRemoteSource {
  static const String endPoint = "chat/";
  final DioService _service = DioService();
  @override
  Future<List<RemoteConversationModel>> getUserConversationsUpdates() async {
    ApiResponseModel response =
        await _service.post("${endPoint}updated-conversations", null);
    if (response.status) {
      // debugPrint("::: S End getAllPosts func in remote datasource");
      return RemoteConversationModel.fromJsonList(
          (response.data as List).cast<Map<String, dynamic>>());
    }
    throw AppException(ServerFailure(message: response.message));
  }

  @override
  Future<RemoteConversationModel> startConversation(
      Map<String, dynamic> data) async {
    ApiResponseModel response =
        await _service.post("${endPoint}start-conversation-with", data);
    if (response.status) {
      // debugPrint("::: S End getAllPosts func in remote datasource");
      return RemoteConversationModel.fromJson(response.data);
    }
    throw AppException(ServerFailure(message: response.message));
  }

  @override
  Future<ApiResponseModel> blockConversation(Map<String, dynamic> data) async {
    ApiResponseModel response =
        await _service.post("${endPoint}block-conversation", data);
    if (response.status) {
      // debugPrint("::: S End getAllPosts func in remote datasource");
      return response;
    }
    throw AppException(ServerFailure(message: response.message));
  }

  @override
  Future<ApiResponseModel> unblockConversation(
      Map<String, dynamic> data) async {
    ApiResponseModel response =
        await _service.post("${endPoint}unblock-conversation", data);
    if (response.status) {
      // debugPrint("::: S End getAllPosts func in remote datasource");
      return response;
    }
    throw AppException(ServerFailure(message: response.message));
  }
}
