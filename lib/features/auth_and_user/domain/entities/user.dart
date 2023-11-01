import 'package:ashghal_app_frontend/app_library/app_data_types.dart';

import '../../../../app_library/public_entities/address.dart';
import 'provider.dart';

class User {
  int id;
  String name;
  String? email;
  String? phone;
  String? imageUrl;
  DateTime birthDate;
  Gender gender;
  bool isBlocked;
  DateTime createdAt;
  DateTime updatedAt;
  Address? address;
  Provider? provider;
  List<int> followersUsers;
  List<int> followingUsers;
  List<int> followersRequestsWait;
  List<int> followRequestsSent;

  User({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.imageUrl,
    required this.birthDate,
    required this.gender,
    required this.isBlocked,
    this.address,
    this.provider,
    required this.createdAt,
    required this.updatedAt,    
    required this.followersUsers,
    required this.followingUsers,
    required this.followersRequestsWait,
    required this.followRequestsSent,
  });
}
