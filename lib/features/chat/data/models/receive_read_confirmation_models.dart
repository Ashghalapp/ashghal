import 'package:ashghal_app_frontend/features/chat/data/models/receive_read_message_model.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/receive_read_confirmation.dart';

class RecieveReadConfirmationModel extends RecieveReadConfirmation {
  const RecieveReadConfirmationModel({
    required super.success,
    required super.failed,
  });

  factory RecieveReadConfirmationModel.fromJson(Map<String, dynamic> json) {
    return RecieveReadConfirmationModel(
      success: ReceivedReadMessageModel.fromJsonList(json['success']),
      failed: List<int>.from(
        json['failed'],
      ),
    );
  }

  static List<RecieveReadConfirmationModel> fromJsonList(
      List<Map<String, dynamic>> jsonList) {
    return jsonList
        .map((json) => RecieveReadConfirmationModel.fromJson(json))
        .toList();
  }
}

class RecieveReadGotConfirmationModel extends RecieveReadGotConfirmation {
  const RecieveReadGotConfirmationModel({
    required super.success,
    required super.failed,
  });

  factory RecieveReadGotConfirmationModel.fromJson(Map<String, dynamic> json) {
    return RecieveReadGotConfirmationModel(
      success: List<int>.from(json['success']),
      failed: List<int>.from(json['failed']),
    );
  }

  static List<RecieveReadGotConfirmationModel> fromJsonList(
      List<Map<String, dynamic>> jsonList) {
    return jsonList
        .map((json) => RecieveReadGotConfirmationModel.fromJson(json))
        .toList();
  }
}

class ReceivedReadConfimationResponseModel
    extends RecieveReadGotConfirmationModel {
  const ReceivedReadConfimationResponseModel(
      {required super.success, required super.failed});

  @override
  factory ReceivedReadConfimationResponseModel.fromJson(
      Map<String, dynamic> json) {
    return ReceivedReadConfimationResponseModel(
      success: List<int>.from(json['success']),
      failed: List<int>.from(json['failed']),
    );
  }

  static List<ReceivedReadConfimationResponseModel> fromJsonList(
      List<Map<String, dynamic>> jsonList) {
    return jsonList
        .map((json) => ReceivedReadConfimationResponseModel.fromJson(json))
        .toList();
  }
}
