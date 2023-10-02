import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/remote_multimedia.dart';

import 'package:moor_flutter/moor_flutter.dart';

class RemoteMultimediaModel extends RemoteMultimedia {
  const RemoteMultimediaModel({
    required super.id,
    required super.type,
    required super.fileName,
    required super.url,
    required super.createdAt,
    required super.updatedAt,
  });

  // Function to convert a Map to a MultimediaModel instance
  factory RemoteMultimediaModel.fromJson(Map<String, dynamic> json) {
    return RemoteMultimediaModel(
      id: json['id'],
      type: json['type'],
      fileName: json['file_name'],
      url: AppUtil.editUrl(json['file_url']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Function to convert a List of Maps to a List of MultimediaModel instances
  static List<RemoteMultimediaModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => RemoteMultimediaModel.fromJson(json))
        .toList();
  }

  // Function to convert a MultimediaModel instance to a Map
  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'type': type,
  //     'file_name': fileName,
  //     'is_message': isMessage ? 1 : 0, // Convert bool to INTEGER 0 or 1
  //     'referenced_id': parentId,
  //     'created_at': createdAt.toIso8601String(),
  //     'updated_at': updatedAt.toIso8601String(),
  //   };
  // }

  MultimediaCompanion toLocalMultimediaOnSend() {
    return MultimediaCompanion(
      // localId: Value(localId),
      remoteId: Value(id),
      // type: Value(type),
      // fileName: Value(fileName),
      url: Value(url),
      // messageId: Value(messageLocalId),
    );
  }

  MultimediaCompanion toLocalMultimediaOnReceive(int messageLocalId) {
    return MultimediaCompanion(
      remoteId: Value(id),
      type: Value(type),
      fileName: Value(fileName),
      url: Value(url),
      messageId: Value(messageLocalId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  @override
  String toString() {
    return 'MultimediaModel(id: $id, type: $type, fileName: $fileName, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  // Function to create a copy of the current instance with some updated fields
  RemoteMultimediaModel copyWith({
    int? id,
    String? type,
    String? path,
    String? url,
    String? fileName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RemoteMultimediaModel(
      id: id ?? this.id,
      type: type ?? this.type,
      fileName: fileName ?? this.fileName,
      url: url ?? this.url,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
