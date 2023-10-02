import 'package:ashghal_app_frontend/core_api/api_response_model.dart';
import 'package:ashghal_app_frontend/core_api/dio_service.dart';
import 'package:ashghal_app_frontend/core_api/errors/exceptions.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/receive_read_confirmation_models.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/remote_message_model.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/download_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/receive_read_confirmation_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/send_message_request.dart';
import 'package:dio/dio.dart';

/// An abstract class defining methods for interacting with remote chat-messages-related operations.
///
/// Implement this class to create a concrete implementation for handling chat-messages-related requests
/// such as sending messages, confirming message reception, confirming message reading,
/// and receiving confirmation responses.
abstract class MessageRemoteSource {
  /// Sends a message to the remote server.
  ///
  /// - [request]: A [SendMessageRequest] object containing the message to be sent.
  Future<RemoteMessageModel> sendMessage(SendMessageRequest request);

  /// Confirms the reception of messages.
  ///
  /// - [request]: A [ReceiveReadConfirmationRequest] object containing the messages to confirm reception for.
  Future<ReceivedReadConfimationResponseModel> confirmMessagesReceieve(
      ReceiveReadConfirmationRequest request);

  /// Confirms the reading of messages.
  ///
  /// - [request]: A [ReceiveReadConfirmationRequest] object containing the messages to confirm reading for.
  Future<ReceivedReadConfimationResponseModel> confirmMessagesRead(
      ReceiveReadConfirmationRequest request);

  /// Confirms the reception of receive message responses.
  ///
  /// - [messagesIds]: A list of message IDs to confirm reception of receive responses for.
  Future<RecieveReadGotConfirmationModel> confirmGettenReceiveResponse(
      List<int> messagesIds);

  /// Confirms the receiving of read message responses.
  ///
  /// - [messagesIds]: A list of message IDs to confirm receiving of read responses for.
  Future<RecieveReadGotConfirmationModel> confirmGettenReadResponse(
      List<int> messagesIds);

  Future<bool> downloadMultimedia(DownloadRequest request);
  Future<RemoteMessageModel> uploadMultimedia(SendMessageRequest request);
}

/// Implementation of the [MessageRemoteSource] interface responsible for handling remote chat messages operations.
///
/// This class interacts with the remote chat service to send messages, confirm message reception,
/// confirm message reading, and receive confirmation responses.
class MessageRemoteSourceImp extends MessageRemoteSource {
  static const String endPoint = "chat/";
  final DioService _service = DioService();

  /// Handles a chat-messages-related request and processes the response.
  ///
  /// This method takes a route, a function to handle success, and optional data, sends a post request
  /// to the chat server, and processes the response accordingly.
  ///
  /// - [route]: The API route for the request.
  /// - [onSuccess]: A function to process the successful response data.
  /// - [data]: Optional request data to include in the request.
  Future<T> _handleChatRequest<T>({
    required String route,
    required T Function(dynamic) onSuccess,
    Object? data,
  }) async {
    ApiResponseModel response =
        await _service.post("${endPoint}${route}", data);
    if (response.status) {
      return onSuccess(response.data);
    }
    throw AppException(ServerFailure(message: response.message));
  }

  @override
  Future<RemoteMessageModel> uploadMultimedia(
      SendMessageRequest request) async {
    ApiResponseModel response = await _service.uploadMultimedia(
      "${endPoint}send-message",
      await request.toJson(),
      onSendProgress: request.onSendProgress,
      cancelToken: request.cancelToken,
    );
    if (response.status) {
      return RemoteMessageModel.fromJson(response.data);
    }
    throw AppException(ServerFailure(message: response.message));
  }

  @override
  Future<RemoteMessageModel> sendMessage(SendMessageRequest request) async {
    if (request.filePath != null) {
      return await uploadMultimedia(request);
    }
    return await _handleChatRequest<RemoteMessageModel>(
      route: "send-message",
      onSuccess: (data) => RemoteMessageModel.fromJson(data),
      data: await request.toJson(),
    );
  }

  @override
  Future<bool> downloadMultimedia(DownloadRequest request) async {
    Response response = await _service.download(
        url: request.url,
        savePath: request.savePath,
        onReceiveProgress: request.onReceiveProgress,
        cancelToken: request.cancelToken);
    if (response.statusCode == 200) {
      return true;
    }
    throw AppException(ServerFailure(
        message: "Failed to download this file ${response.statusMessage}"));
  }

  @override
  Future<ReceivedReadConfimationResponseModel> confirmMessagesReceieve(
      ReceiveReadConfirmationRequest request) async {
    print(request.toJson().toString());
    return await _handleChatRequest<ReceivedReadConfimationResponseModel>(
      route: "messages-recieved",
      onSuccess: (data) => ReceivedReadConfimationResponseModel.fromJson(data),
      data: request.toJson(),
    );
  }

  @override
  Future<ReceivedReadConfimationResponseModel> confirmMessagesRead(
      ReceiveReadConfirmationRequest request) async {
    return await _handleChatRequest<ReceivedReadConfimationResponseModel>(
      route: "messages-read",
      onSuccess: (data) => ReceivedReadConfimationResponseModel.fromJson(data),
      data: request.toJson(),
    );
  }

  @override
  Future<RecieveReadGotConfirmationModel> confirmGettenReceiveResponse(
      List<int> messagesIds) async {
    return await _handleChatRequest<RecieveReadGotConfirmationModel>(
      route: "got-recieve-response",
      onSuccess: (data) => RecieveReadGotConfirmationModel.fromJson(data),
      data: {"messages_ids": messagesIds},
    );
  }

  @override
  Future<RecieveReadGotConfirmationModel> confirmGettenReadResponse(
      List<int> messagesIds) async {
    return await _handleChatRequest<RecieveReadGotConfirmationModel>(
      route: "got-read-response",
      onSuccess: (data) => RecieveReadGotConfirmationModel.fromJson(data),
      data: {"messages_ids": messagesIds},
    );
  }
}
