class Address {
  final int id;
  final String? city;
  final String? street;
  final double? lat;
  final double? long;
  final String? desc;
  final DateTime createdAt;
  final DateTime updatedAt;

  Address({
    required this.id,
    this.city,
    this.street,
    this.lat,
    this.long,
    this.desc,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Address.fromJson(Map<String, dynamic> json){
    return Address(
      id: json['id'],
      city: json['city'],
      street: json['street'],
      lat: json['lat'],
      long: json['long'],
      desc: json['desc'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, Object?> toJson(){
    return {
      'city': city,
      'street': street,
      'lat': lat,
      'long': long,
      'desc': desc,
    };
  }
}
