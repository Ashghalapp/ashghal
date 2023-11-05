import 'package:dio/dio.dart';

import '../../../../app_library/app_data_types.dart';
import '../../../../app_library/public_entities/address.dart';
import '../entities/provider.dart';

class RegisterUserRequest {
  final String name;
  final String password;
  final String? phone;
  final String? email;
  final String?
      emailVerificationCode; //The code used to verify email if the registration by email
  final String?
      phoneVerifiedAt; //should be included if the registration by phone
  final DateTime birthDate;
  final Gender gender;
  final String? imagePath;
  final Address? address;
  final Provider? provider;
  final DateTime? updatedAt;

  RegisterUserRequest._({
    required this.name,
    required this.password,
    this.phone,
    this.email,
    this.emailVerificationCode,
    this.phoneVerifiedAt,
    required this.birthDate,
    required this.gender,
    this.imagePath,
    this.address,
    this.provider,
    this.updatedAt,
  });

  factory RegisterUserRequest.withEmail({
    required String name,
    required String password,
    required String email,
    required String emailVerificationCode,
    required DateTime birthDate,
    required Gender gender,
    String? imagePath,
    Address? address,
    Provider? provider,
    DateTime? updatedAt,
  }) =>
      RegisterUserRequest._(
        name: name,
        password: password,
        email: email,
        emailVerificationCode: emailVerificationCode,
        birthDate: birthDate,
        gender: gender,
        imagePath: imagePath,
        address: address,
        provider: provider,
        updatedAt: updatedAt,
      );

  factory RegisterUserRequest.withPhone({
    required String name,
    required String password,
    required String phone,
    required String phoneVerifiedAt,
    required DateTime birthDate,
    required Gender gender,
    String? imagePath,
    Address? address,
    Provider? provider,
    DateTime? updatedAt,
  }) =>
      RegisterUserRequest._(
        name: name,
        password: password,
        phone: phone,
        phoneVerifiedAt: phoneVerifiedAt,
        birthDate: birthDate,
        gender: gender,
        imagePath: imagePath,
        address: address,
        provider: provider,
        updatedAt: updatedAt,
      );

  toJson() async {
    MultipartFile? image;
    if (imagePath != null) {
      image = await MultipartFile.fromFile(imagePath!);
    }

    print(">>>>>>>>>>>>>>>>${gender.name.toString()}");
    return FormData.fromMap({
      'name': name,
      'password': password,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (emailVerificationCode != null)
        'email_verification_code': emailVerificationCode,
      if (phoneVerifiedAt != null) 'phone_verified_at': phoneVerifiedAt,
      'birth_date': birthDate.toString(),
      'gender': gender.name,
      if (image != null) 'image': image,
      if (address != null) 'address': address?.toJson(),
      if (provider != null) 'provider': provider?.toJson(),
      if (updatedAt != null) 'updated_at': updatedAt,
    }, ListFormat.multiCompatible);
  }
}

// class ProviderDataRequest{
//   final String jobName;
//   final String? jobDesc;
//   final int categoryId;

//   ProviderDataRequest({required this.jobName, this.jobDesc, required this.categoryId});

//   Map<String, Object?> toJson(){
//     return {
//       'job_name': jobName,
//       'job_desc': jobDesc,
//       'category_id': categoryId,
//     };
//   }
// }



// class RegisterProviderRequest extends RegisterUserRequest {
//   final String jobName;
//   final String? jobDesc;
//   final int categoryId;

//   RegisterProviderRequest.withEmail({
//     required name,
//     required password,
//     required email,
//     isProvider,
//     isBlocked,
//     image,
//     required this.jobName,
//     this.jobDesc,
//     required this.categoryId,
//   }) : super._(
//             name: name,
//             password: password,
//             email: email,
//             isProvider: isProvider,
//             isBlocked: isBlocked,
//             image: image);

//   RegisterProviderRequest.withPhone({
//     required name,
//     required password,
//     required phone,
//     isProvider,
//     isBlocked,
//     image,
//     required this.jobName,
//     this.jobDesc,
//     required this.categoryId,
//   }) : super._(
//             name: name,
//             password: password,
//             phone: phone,
//             isProvider: isProvider,
//             isBlocked: isBlocked,
//             image: image);

//   @override
//   Map<String, Object?> toJson() {
//     return {
//       ...super.toJson(),
//       'job_name': jobName,
//       if (jobDesc != null) 'job_desc': jobDesc,
//       'category_id': categoryId,
//     };
//   }
// }
