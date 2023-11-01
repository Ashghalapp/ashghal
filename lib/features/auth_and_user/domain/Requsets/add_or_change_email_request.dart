class AddOrChangeEmailRequest{
  final String newEmail;
  final String emailVerificationCode;

  AddOrChangeEmailRequest({required this.newEmail, required this.emailVerificationCode});

  Map<String, Object> toJson(){
    return {
      'new_email': newEmail,
      'email_verification_code': emailVerificationCode,
    };
  }
}