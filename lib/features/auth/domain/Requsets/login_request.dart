class LoginRequest {
  final String password;
  final String? email;
  final String? phone;

  LoginRequest._({required this.password, this.email, this.phone});

  factory LoginRequest.withEmail({required password, required email}) =>
      LoginRequest._(password: password, email: email);

  factory LoginRequest.withPhone({required password, required phone}) =>
      LoginRequest._(password: password, phone: phone);

  Map<String, String?> toJson() {
    return {
      'password': password,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
    };
  }
}
