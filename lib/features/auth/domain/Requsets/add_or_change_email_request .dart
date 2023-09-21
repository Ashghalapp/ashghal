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