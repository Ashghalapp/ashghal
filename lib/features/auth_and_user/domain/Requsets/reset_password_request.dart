class ForgetPasswordRequest {
  final String? email;
  final String? phone;

  ForgetPasswordRequest._({this.email, this.phone});  
  
  factory ForgetPasswordRequest.withEmail(
          {required String email}) =>
      ForgetPasswordRequest._(email: email);

  factory ForgetPasswordRequest.withPhone(
          {required String phone}) =>
      ForgetPasswordRequest._(phone: phone);

  Map<String, String?> toJson() {
    return {
      'email_or_phone': email?? phone,
    };
  }
}

class ValidateResetPasswordCodeRequest extends ForgetPasswordRequest {
  final String code;
  ValidateResetPasswordCodeRequest.withEmail(
      {required String email, required this.code})
      : super._(email: email);

  ValidateResetPasswordCodeRequest.withPhone(
      {required String phone, required this.code})
      : super._(phone: phone);

  @override
  Map<String, String?> toJson() {
    return {
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      'code': code,
    };
  }
}

class ResetPasswordRequest extends ValidateResetPasswordCodeRequest {
  final String newPassword;
  ResetPasswordRequest.withEmail({
    required String email,
    required String code,
    required this.newPassword,
  }) : super.withEmail(email: email, code: code);

  ResetPasswordRequest.withPhone({
    required String phone,
    required String code,
    required this.newPassword,
  }) : super.withPhone(phone: phone, code: code);

  @override
  Map<String, String?> toJson() {
    return {
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (email != null) 'email_verification_code': code,
      if (phone != null) 'phone_verified_at': code,
      'new_password': newPassword,
    };
  }
}
