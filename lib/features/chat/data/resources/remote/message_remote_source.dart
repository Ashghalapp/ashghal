import 'package:ashghal_app_frontend/core_api/api_response_model.dart';
import 'package:ashghal_app_frontend/core_api/dio_service.dart';
import 'package:ashghal_app_frontend/core_api/errors/exceptions.dart';
import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/receive_read_confirmation_models.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/remote_message_model.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/receive_read_confirmation_request.dart';
import 'package:ashghal_app_frontend/features/chat/domain/requests/send_message_request.dart';

abstract class MessageRemoteSource {
  Future<RemoteMessageModel> sendMessage(SendMessageRequest request);
  // Future<List<RemoteMessageModel>> sendSomeMessages(
  //     SendSomeMessageRequest request);
  // Future<List<RemoteMessageModel>> getConversationNewMessages(
  //   SendSomeMessageRequest request);
  Future<ReceivedReadConfimationResponseModel> confirmMessagesReceieve(
      ReceiveReadConfirmationRequest request);
  Future<ReceivedReadConfimationResponseModel> confirmMessagesRead(
      ReceiveReadConfirmationRequest request);
  Future<RecieveReadGotConfirmationModel> confirmGettenReceiveResponse(
      List<int> messagesIds);
  Future<RecieveReadGotConfirmationModel> confirmGettenReadResponse(
      List<int> messagesIds);
}

class MessageRemoteSourceImp extends MessageRemoteSource {
  static const String endPoint = "chat/";
  final DioService _service = DioService();

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
  Future<RemoteMessageModel> sendMessage(SendMessageRequest request) async {
    return await _handleChatRequest<RemoteMessageModel>(
      route: "send-message",
      onSuccess: (data) => RemoteMessageModel.fromJson(data),
      data: request.toJson(),
    );
    // ApiResponseModel response =
    //     await _service.post("${endPoint}send-message", request.toJson());
    // if (response.status) {
    //   return RemoteMessageModel.fromJson(response.data);
    // }
    // throw MyException(ServerFailure(response.message));
  }

  // @override
  // Future<List<RemoteMessageModel>> sendSomeMessages(
  //     SendSomeMessageRequest request) async {
  //   return await _handleChatRequest<List<RemoteMessageModel>>(
  //     route: "send-some-messages",
  //     onSuccess: (data) => RemoteMessageModel.fromJsonList(data),
  //     data: request.toJson(),
  //   );
  // }

  // @override
  //     Future<List<RemoteMessageModel>> getConversationNewMessages(
  //     SendSomeMessageRequest request) async{
  //       return await
  //     }

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
