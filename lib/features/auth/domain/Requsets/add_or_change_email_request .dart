// ignore_for_file: file_names

class AddOrChangePhoneRequest{
  final String phone;
  final DateTime phoneVerifiedAt;

  AddOrChangePhoneRequest({required this.phone, required this.phoneVerifiedAt});

  Map<String, Object> toJson(){
    return {
      'phone': phone,
      'phone_verified_at': phoneVerifiedAt,
    };
  }
}