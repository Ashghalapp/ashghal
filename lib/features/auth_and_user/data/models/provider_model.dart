

// import 'package:ashghal_app_frontend/features/auth/domain/entities/provider.dart';

// class ProviderModel extends Provider{
//   ProviderModel({
//     required super.id,
//     required super.name,
//     super.email,
//     super.phone,
//     super.imagePath,
//     required super.birthDate,
//     required super.gender,
//     required super.isProvider,
//     required super.isBlocked,
//     required super.isAdmin,
//     super.address,
//     required super.pId,
//     required super.jobName,
//     super.jobDesc,
//     required super.categoryId,
//     required super.pCreatedAt,
//     required super.pUpdatedAt,
    
//     required super.createdAt,
//     required super.updatededAt,
//     required super.followersUsers,
//     required super.followingUsers,
//     required super.followersRequestsWait,
//     required super.followRequestsSent,  
//   });

//   ProviderModel copyWith({
//     int? jobId,
//     String? jobName,
//     String? jobDesc,
//     int? categoryId,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//     int? id,
//     String? name,
//     String? phone,
//     String? email,
//     String? password,
//     bool? isProvider,
//     bool? isBlocked,
//     String? imageUrl,
//     // AddressModel? address,
//     List<int>? followersUsers,
//     List<int>? followingUsers,
//     List<int>? followersRequestsWait,
//     List<int>? followRequestsSent,
//   }) {
//     return ProviderModel(
//       jobId: jobId ?? this.pId,
//       jobName: jobName ?? this.jobName,
//       jobDesc: jobDesc ?? this.jobDesc,
//       categoryId: categoryId ?? this.categoryId,
//       createdAt: createdAt ?? this.pCreatedAt,
//       updatedAt: updatedAt ?? this.pUpdatedAt,
//       id: id ?? this.id,
//       name: name ?? this.name,
//       phone: phone ?? this.phone,
//       email: email ?? this.email,
   
//       isProvider: isProvider ?? this.isProvider,
//       isBlocked: isBlocked ?? this.isBlocked,
//       imageUrl: imageUrl ?? this.imagePath,
//       // address: address ?? this.address,
//       followersUsers: followersUsers ?? this.followersUsers,
//       followingUsers: followingUsers ?? this.followingUsers,
//       followersRequestsWait:
//           followersRequestsWait ?? this.followersRequestsWait,
//       followRequestsSent: followRequestsSent ?? this.followRequestsSent,
//     );
//   }

//   factory ProviderModel.fromJson(Map<String, dynamic> json) {
//     Map<String, dynamic> provider= json['provider'] as Map<String, dynamic>;
//     return ProviderModel(
//       jobId: provider["id"],
//       jobName: provider["job_name"],
//       jobDesc: provider["job_desc"],
//       categoryId: provider["category_id"],
//       createdAt: DateTime.parse(json["created_at"]),
//       updatedAt: DateTime.parse(json["updated_at"]),
//       id: json['id'],
//       name: json['name'],
//       phone: json['phone'],
//       email: json['email'],
  
//       isProvider: json['is_provider'],
//       isBlocked: json['is_blocked'],
//       imageUrl: json['image_url'],
//       // address: json['address'] != null
//       //     ? AddressModel.fromJson(json['address'])
//       //     : null,
//       followersUsers:
//           List<int>.from(json["followers_users"].map((x) => x.cast<int>())),
//       followingUsers:
//           List<int>.from(json["following_users"].map((x) => x.cast<int>())),
//       followersRequestsWait: List<int>.from(
//           json["followers_requests_wait"].map((x) => x.cast<int>())),
//       followRequestsSent: List<int>.from(
//           json["follow_requests_sent"].map((x) => x.cast<int>())));
//   }


//   Map<String, dynamic> toJson() => {
//         "job_id": pId,
//         "job_name": jobName,
//         "job_desc": jobDesc,
//         "category_id": categoryId,
//         "created_at": pCreatedAt!.toIso8601String(),
//         "updated_at": pUpdatedAt!.toIso8601String(),
//         'id': id,
//         'name': name,
//         'phone': phone,
//         'email': email,
       
//         'is_provider': isProvider,
//         'is_blocked': isBlocked,
//         'image_url': imagePath,
//         // 'address': address?.toJson(),
//         'followers_users': followersUsers,
//         'following_users': followingUsers,
//         'followers_requests_wait': followersRequestsWait,
//         'follow_requests_sent': followRequestsSent,
//       };
// }