class LoginRequest {
  final String? email;
  final String? phone;
  final String password;

  LoginRequest._({required this.password, this.email, this.phone});

  factory LoginRequest.withEmail({required password, required email}) =>
      LoginRequest._(password: password, email: email);

  factory LoginRequest.withPhone({required password, required phone}) =>
      LoginRequest._(password: password, phone: phone);

  Map<String, String?> toJson() {
    return {
      'email_or_phone': email ?? phone,
      'password': password,      
    };
  }
}
