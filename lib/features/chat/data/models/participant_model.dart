import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/participant.dart';

class ParticipantModel extends Participant {
  const ParticipantModel({
    required int id,
    required String name,
    String? email,
    String? phone,
    String? imageUrl,
  }) : super(
          id: id,
          name: name,
          email: email,
          phone: phone,
          imageUrl: imageUrl,
        );

  factory ParticipantModel.fromJson(Map<String, dynamic> json) {
    return ParticipantModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      imageUrl:
          json['image_url'] == null ? null : AppUtil.editUrl(json['image_url']),
    );
  }

  static List<ParticipantModel> fromJsonList(
      List<Map<String, dynamic>> jsonList) {
    return jsonList.map((json) => ParticipantModel.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'imageUrl': imageUrl,
    };
  }

  @override
  String toString() {
    return 'ExtendedParticipant(id: $id, name: $name, email: $email, phone: $phone, imageUrl: $imageUrl)';
  }

  ParticipantModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? imageUrl,
  }) {
    return ParticipantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
