class VerifyEmailRequest {
  final String code;

  VerifyEmailRequest({required this.code});

  Map<String, String> toJson() {
    return {
      'otp_code': code,
    };
  }
}
