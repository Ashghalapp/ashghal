class AddAddressToUserRequest {
  String city;
  String street;
  String? desc;

  AddAddressToUserRequest({
    required this.city,
    required this.street,
    this.desc,
  });

  Map<String, Object> toJson() {
    return {
      'city': city,
      'street': street,
      if (desc != null) 'desc': desc!,
    };
  }
}
