class ValidateEmailVerificationCodeRequest {
  final String email;
  final String code;

  ValidateEmailVerificationCodeRequest({required this.email, required this.code});

  Map<String, String> toJson() {
    return {
      'email': email,
      'code': code,
    };
  }
}
