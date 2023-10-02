//This class is used to represent a response you get when you confirm that you recieved or read
//some messages sent to you
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/received_read_message.dart';
import 'package:moor_flutter/moor_flutter.dart';

class ReceivedReadMessageModel extends ReceivedReadMessage {
  const ReceivedReadMessageModel({required super.id, required super.at});

  factory ReceivedReadMessageModel.fromJson(Map<String, dynamic> json) {
    return ReceivedReadMessageModel(
      id: int.parse(json['id'].toString()),
      at: DateTime.parse(json['at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'at': at.toIso8601String(),
    };
  }

  MessagesCompanion toLocalOnReceived() => MessagesCompanion(
        remoteId: Value(id),
        recievedAt: Value(at),
      );

  MessagesCompanion toLocalOnRead() => MessagesCompanion(
        remoteId: Value(id),
        readAt: Value(at),
      );

  static List<ReceivedReadMessageModel> fromJsonList(
      List<Map<String, dynamic>> jsonList) {
    return jsonList
        .map((json) => ReceivedReadMessageModel.fromJson(json))
        .toList();
  }

  @override
  String toString() {
    return 'SuccessConfirmation(id: $id, at: $at)';
  }
}

// class ReceivedReadMessage extends Equatable {
//   final int id;
//   final DateTime at;

//   const ReceivedReadMessage({
//     required this.id,
//     required this.at,
//   });

//   @override
//   List<Object?> get props => [id, at];
// }
