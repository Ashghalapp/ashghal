import 'package:ashghal_app_frontend/features/auth/domain/entities/user.dart';

import '../../../../app_library/app_data_types.dart';
import '../../../../app_library/public_entities/address.dart';
import '../../domain/entities/provider.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    super.email,
    super.phone,
    super.imagePath,
    required super.birthDate,
    required super.gender,
    required super.isBlocked,
    super.address,
    super.provider,
    required super.createdAt,
    required super.updatededAt,
    required super.followersUsers,
    required super.followingUsers,
    required super.followersRequestsWait,
    required super.followRequestsSent,
  });

  User copyWith({
    required int id,
    required String name,
    String? phone,
    String? email,
    String? imagePath,
    required DateTime birthDate,
    required Gender gender,
    required bool isBlocked,
    required bool isAdmin,
    required DateTime createdAt,
    required DateTime updatedAt,
    Address? address,
    Provider? provider,
    required List<int> followersUsers,
    required List<int> followingUsers,
    required List<int> followersRequestsWait,
    required List<int> followRequestsSent,
  }) {
    return User(
      id: id,
      name: name,
      phone: phone,
      email: email,
      isBlocked: isBlocked,
      imagePath: imagePath,
      birthDate: birthDate,
      gender: gender,
      createdAt: createdAt,
      updatededAt: updatededAt,
      address: address,
      provider: provider,
      followersUsers: followersUsers,
      followingUsers: followingUsers,
      followersRequestsWait: followersRequestsWait,
      followRequestsSent: followRequestsSent,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> followersUsersJson = json['followers_users'] ?? [];
    List<dynamic> followingUsersJson = json['following_users'] ?? [];
    List<dynamic> followersRequestsWaitJson =
        json['followers_requests_wait'] ?? [];
    List<dynamic> followRequestsSentJson = json['follow_requests_sent'] ?? [];
    
    return UserModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      isBlocked: json['is_blocked'],
      imagePath: json['image_path'],
      birthDate: DateTime.parse(json['birth_date']),
      gender: json['gender']=='male'? Gender.male: Gender.female,
      createdAt: DateTime.parse(json['created_at']),
      updatededAt: DateTime.parse(json['updated_at']),
      address: json['address'] != null? Address.fromJson(json['address']): null,
      provider: json['provider'] != null? Provider.fromJson(json['provider']): null,
      followersUsers:
          List<int>.from(followersUsersJson.map((x) => int.parse(x))).toList(),
      followingUsers:
          List<int>.from(followingUsersJson.map((x) => int.parse(x))).toList(),
      followersRequestsWait:
          List<int>.from(followersRequestsWaitJson.map((x) => int.parse(x)))
              .toList(),
      followRequestsSent:
          List<int>.from(followRequestsSentJson.map((x) => int.parse(x)))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,        
        'image_path': imagePath,
        'birth_date': birthDate,
        'gender': gender,
        'is_blocked': isBlocked,
        'address': address?.toJson(),
        'provider': provider?.toJson(),
        'created_at': createdAt,
        'updateded_at': updatededAt,        
        'followers_users': followersUsers,
        'following_users': followingUsers,
        'followers_requests_wait': followersRequestsWait,
        'follow_requests_sent': followRequestsSent,
      };
}
