class Address {
  final int? id;
  final String? city;
  final String? district;
  // final String? street;
  // final String? district;
  final double? lat;
  final double? long;
  final String? desc;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Address._({
    this.id,
    this.city,
    this.district,
    this.lat,
    this.long,
    this.desc,
    this.createdAt,
    this.updatedAt,
  });

  factory Address.addRequest({
    required String city,
    required String district,
    String? desc,
    double? lat,
    double? long,
  }) =>
      Address._(city: city, district: district, desc: desc, lat: lat, long: long);

  factory Address.updateRequest({
    String? city,
    String? street,
    String? desc,
    double? lat,
    double? long,
  }) =>
      Address._(city: city, district: street, desc: desc, lat: lat, long: long);

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address._(
      id: json['id'],
      city: json['city'],
      district: json['street'],
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
      if (district != null) 'street': district,
      if (lat != null) 'lat': lat,
      if (long != null) 'long': long,
      if (desc != null) 'desc': desc,
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
    };
  }
}
