class ForgetPasswordRequest {
  final String? email;
  final String? phone;

  ForgetPasswordRequest._({this.email, this.phone});  
  
  factory ForgetPasswordRequest.withEmail(
          {required email}) =>
      ForgetPasswordRequest._(email: email);

  factory ForgetPasswordRequest.withPhone(
          {required phone}) =>
      ForgetPasswordRequest._(phone: phone);

  Map<String, String?> toJson() {
    return {
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
    };
  }
}

class VerifyResetPasswordCodeRequest extends ForgetPasswordRequest {
  final String code;
  VerifyResetPasswordCodeRequest.withEmail(
      {required String email, required this.code})
      : super._(email: email);//(email: email);

  VerifyResetPasswordCodeRequest.withPhone(
      {required String phone, required this.code})
      : super._(phone: phone);

  @override
  Map<String, String?> toJson() {
    return {
      ...super.toJson(),
      'otp_code': code,
    };
  }
}

class ResetPasswordRequest extends VerifyResetPasswordCodeRequest {
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
      ...super.toJson(),
      'password': newPassword,
    };
  }
}
