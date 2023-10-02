import 'package:ashghal_app_frontend/core_api/api_response_model.dart';
import 'package:ashghal_app_frontend/core_api/dio_service.dart';
import 'package:ashghal_app_frontend/core_api/errors/exceptions.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/remote_conversation_model.dart';

abstract class ConversationRemoteSource {
  /// Initiates a new conversation remotely with a user specified by his ID.
  ///
  /// This method sends a POST request to the server to start a conversation with a specific user.
  ///
  /// Returns a [Future] that resolves to a [RemoteConversationModel] representing the newly created conversation
  /// if the operation is successful.
  ///
  /// Throws an [AppException] with a [ServerFailure] containing an error message if the server request fails.
  ///
  /// Example usage:
  /// ```dart
  /// final remoteDataSource = ConversationRemoteDataSourceImp();
  /// final data = {
  ///   "user_id": 123, // Replace with the user's ID
  /// };
  /// final conversation = await remoteDataSource.startConversation(data);
  ///
  /// print("New conversation started remotely: $conversation");
  /// ```
  /// - [data]: A [Map] containing the user's `userId` to initiate the conversation.
  Future<RemoteConversationModel> startConversation(Map<String, dynamic> data);

  /// Fetches updates for user conversations.
  ///
  /// This method sends a POST request to the remote server to retrieve updates
  /// for user conversations. Updates include conversations that have received new messages
  /// or contain received or read messages that the user should be informed about.
  ///
  /// Returns a [Future] that resolves to a list of [RemoteConversationModel] objects
  /// representing the updated conversations.
  ///
  /// Throws an [AppException] with a [ServerFailure] if the server request fails or returns an error.
  ///
  /// Example usage:
  /// ```dart
  /// final dataSource = RemoteDataSource();
  /// final updates = await dataSource.getUserConversationsUpdates();
  ///
  /// updates.forEach((conversation) {
  ///   print("Updated Conversation: $conversation");
  /// });
  /// ```
  Future<List<RemoteConversationModel>> getUserConversationsUpdates();

  /// Blocks a conversation using the provided [data].
  ///
  /// Sends a POST request to the server to block a conversation based on the provided data.
  ///
  /// - [data]: A Map containing the necessary data {'conversation_id': conversationId} for blocking the conversation.
  ///
  /// Returns an [ApiResponseModel] representing the server's response.
  ///
  /// Throws an [AppException] with a [ServerFailure] if the server response indicates an error.
  ///
  /// Example usage:
  /// ```dart
  /// final conversationSource = ConversationRemoteSourceImp();
  /// final data = {'conversation_id': 123};
  /// final response = await conversationSource.unblockConversation(data);
  ///
  /// if (response.status) {
  ///   print("Conversation unblocked successfully.");
  /// } else {
  ///   throw ServerFailure(message: response.message);
  /// }
  /// ```
  ///

  Future<ApiResponseModel> blockConversation(Map<String, dynamic> data);

  /// Unblocks a conversation using the provided [data].
  ///
  /// Sends a POST request to the server to unblock a conversation based on the provided data.
  ///
  /// - [data]: A Map containing the necessary data {'conversation_id': conversationId} for unblocking the conversation.
  ///
  /// Returns an [ApiResponseModel] representing the server's response.
  ///
  /// Throws an [AppException] with a [ServerFailure] if the server response indicates an error.
  ///
  /// Example usage:
  /// ```dart
  /// final conversationSource = ConversationRemoteSourceImp();
  /// final data = {'conversation_id': 123};
  /// final response = await conversationSource.unblockConversation(data);
  ///
  /// if (response.status) {
  ///   print("Conversation unblocked successfully.");
  /// } else {
  ///   throw ServerFailure(message: response.message);
  /// }
  /// ```
  ///
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
