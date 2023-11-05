class CheckEmailRequest{
  final String email;
  final String userName;

  CheckEmailRequest({required this.email, required this.userName});

  Map<String, Object> toJson(){
    return {
      'email': email,
      'user_name': userName,
    };
  }
}