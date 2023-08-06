class RegisterUserRequest {
  final String name;
  final String password;
  final String? phone;
  final String? email;
  final bool? isProvider;
  final bool? isBlocked;
  final String? image;
  // AddressModel? address;

  RegisterUserRequest._({
    required this.name,
    required this.password,
    this.phone,
    this.email,
    this.isProvider,
    this.isBlocked,
    this.image,
  });

  factory RegisterUserRequest.withEmail({
    required name,
    required password,
    required email,
    isProvider,
    isBlocked,
    image,
  }) =>
      RegisterUserRequest._(
        name: name,
        password: password,
        email: email,
        isProvider: isProvider,
        isBlocked: isBlocked,
        image: image,
      );

  factory RegisterUserRequest.withPhone({
    required name,
    required password,
    required phone,
    isProvider,
    isBlocked,
    image,
  }) =>
      RegisterUserRequest._(
        name: name,
        password: password,
        phone: phone,
        isProvider: isProvider,
        isBlocked: isBlocked,
        image: image,
      );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'password': password,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (isProvider != null) 'is_provider': isProvider,
      if (isBlocked != null) 'is_blocked': isBlocked,
      if (image != null) 'image': image,
    };
  }
}



class RegisterProviderRequest extends RegisterUserRequest {
  final String jobName;
  final String? jobDesc;
  final int categoryId;

  RegisterProviderRequest.withEmail({
    required name,
    required password,
    required email,
    isProvider,
    isBlocked,
    image,
    required this.jobName,
    this.jobDesc,
    required this.categoryId,
  }) : super._(
            name: name,
            password: password,
            email: email,
            isProvider: isProvider,
            isBlocked: isBlocked,
            image: image);

  RegisterProviderRequest.withPhone({
    required name,
    required password,
    required phone,
    isProvider,
    isBlocked,
    image,
    required this.jobName,
    this.jobDesc,
    required this.categoryId,
  }) : super._(
            name: name,
            password: password,
            phone: phone,
            isProvider: isProvider,
            isBlocked: isBlocked,
            image: image);

  @override
  Map<String, Object?> toJson() {
    return {
      ...super.toJson(),
      'job_name': jobName,
      if (jobDesc != null) 'job_desc': jobDesc,
      'category_id': categoryId,
    };
  }
}
