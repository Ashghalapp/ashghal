import 'package:ashghal_app_frontend/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.isProvider,
    required super.isBlocked,
    required super.imageUrl,
    required super.followersUsers,
    required super.followingUsers,
    required super.followersRequestsWait,
    required super.followRequestsSent,
    super.email,
    super.phone,
  });

  User copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? password,
    bool? isProvider,
    bool? isBlocked,
    String? imageUrl,
    // AddressModel? address,
    List<int>? followersUsers,
    List<int>? followingUsers,
    List<int>? followersRequestsWait,
    List<int>? followRequestsSent,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    
      isProvider: isProvider ?? this.isProvider,
      isBlocked: isBlocked ?? this.isBlocked,
      imageUrl: imageUrl ?? this.imageUrl,
      // address: address ?? this.address,
      followersUsers: followersUsers ?? this.followersUsers,
      followingUsers: followingUsers ?? this.followingUsers,
      followersRequestsWait:
          followersRequestsWait ?? this.followersRequestsWait,
      followRequestsSent: followRequestsSent ?? this.followRequestsSent,
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
    
      isProvider: json['is_provider'],
      isBlocked: json['is_blocked'],
      imageUrl: json['image_url'],
      // address: json['address'] != null
      //     ? AddressModel.fromJson(json['address'])
      //     : null,
      followersUsers:
          List<int>.from(followersUsersJson.map((x) => x as int)).toList(),
      followingUsers:
          List<int>.from(followingUsersJson.map((x) => x as int)).toList(),
      followersRequestsWait:
          List<int>.from(followersRequestsWaitJson.map((x) => x as int)).toList(),
      followRequestsSent:
          List<int>.from(followRequestsSentJson.map((x) => x as int)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        
        'is_provider': isProvider,
        'is_blocked': isBlocked,
        'image_url': imageUrl,
        // 'address': address?.toJson(),
        'followers_users': followersUsers,
        'following_users': followingUsers,
        'followers_requests_wait': followersRequestsWait,
        'follow_requests_sent': followRequestsSent,
      };
}
