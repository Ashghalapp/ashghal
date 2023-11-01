class ValidateEmailCodeRequest {
  final String email;
  final String code;

  ValidateEmailCodeRequest({required this.email, required this.code});

  Map<String, String> toJson() {
    return {
      'email': email,
      'code': code,
    };
  }
}
