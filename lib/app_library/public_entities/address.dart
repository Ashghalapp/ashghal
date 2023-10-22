class Address {
  final int? id;
  final String? city;
  final String? street;
  final double? lat;
  final double? long;
  final String? desc;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Address._({
    this.id,
    this.city,
    this.street,
    this.lat,
    this.long,
    this.desc,
    this.createdAt,
    this.updatedAt,
  });

  factory Address.addRequest({
    required String city,
    required String street,
    String? desc,
    double? lat,
    double? long,
  }) =>
      Address._(city: city, street: street, desc: desc, lat: lat, long: long);

  factory Address.updateRequest({
    String? city,
    String? street,
    String? desc,
    double? lat,
    double? long,
  }) =>
      Address._(city: city, street: street, desc: desc, lat: lat, long: long);

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address._(
      id: json['id'],
      city: json['city'],
      street: json['street'],
      lat: json['lat'] is double
          ? json['lat']
          : (json['lat'] is int ? (json['lat'] as int).toDouble() : null),
      long: json['long'] is double
          ? json['long']
          : (json['long'] is int ? (json['long'] as int).toDouble() : null),
      desc: json['desc'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, Object?> toJson() {
    return {
      if (city != null) 'city': city,
      if (street != null) 'street': street,
      if (lat != null) 'lat': lat,
      if (long != null) 'long': long,
      if (desc != null) 'desc': desc,
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
    };
  }
}
