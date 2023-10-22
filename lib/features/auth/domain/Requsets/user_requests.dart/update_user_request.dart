import 'package:ashghal_app_frontend/app_library/app_data_types.dart';
import 'package:ashghal_app_frontend/app_library/public_entities/address.dart';
import 'package:ashghal_app_frontend/features/auth/domain/entities/provider.dart';
import 'package:dio/dio.dart';

class UpdateUserRequest {
  String? name;
  String? imagePath;
  DateTime? birthDate;
  Gender? gender;
  Address? address;
  Provider? provider;

  UpdateUserRequest({
    this.name,
    this.imagePath,
    this.birthDate,
    this.gender,
    this.address,
    this.provider,
  });

  Future<FormData> toJson() async {
    MultipartFile? image;
    if (imagePath != null) {
      image = await MultipartFile.fromFile(imagePath!);
    }

    print("<<<<<<<<${address?.toJson()}>>>>>>>>");
    print("<<<<<<<<${birthDate}>>>>>>>>");
    return FormData.fromMap({
      if (name != null) 'name': name,
      if (image != null) 'image': image,
      if (birthDate != null) 'birth_date': birthDate,
      if (gender != null) 'gender': gender!.name,
      if (address != null) 'address': address!.toJson(),
      if (provider != null) 'provider': provider!.toJson(),
    }, ListFormat.multiCompatible);
  }
}
