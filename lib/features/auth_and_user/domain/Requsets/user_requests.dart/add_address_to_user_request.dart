class AddAddressToUserRequest {
  String city;
  String district;
  String? street;
  String? desc;

  AddAddressToUserRequest({
    required this.city,
    required this.district,
    this.street,
    this.desc,
  });

  Map<String, Object> toJson() {
    return {
      'city': city,
      'district': district,
      if (street != null) 'street': desc!,
      if (desc != null) 'desc': desc!,
    };
  }
}
