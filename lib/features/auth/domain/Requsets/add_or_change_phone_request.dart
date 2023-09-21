class AddOrChangeEmailRequest{
  final String phone;
  final DateTime phoneVerifiedAt;

  AddOrChangeEmailRequest({required this.phone, required this.phoneVerifiedAt});

  Map<String, Object> toJson(){
    return {
      'new_email': phone,
      'email_verification_code': phoneVerifiedAt,
    };
  }
}