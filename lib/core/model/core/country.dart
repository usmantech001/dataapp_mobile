class Country {
  final String? id;
  final String? name;
  final String? code;
  final String? iso2;
  final String? iso3;
  final String? phone_code;
  final String? flagUrl;

  Country({
    required this.id,
    required this.name,
    required this.code,
    required this.iso2,
    required this.iso3,
    required this.phone_code,
    required this.flagUrl,
  });

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      id: map["id"].toString(),
      name: map["name"],
      code: map["code"],
      iso2: map["iso2"],
      iso3: map["iso3"],
      phone_code: map["phone_code"],
      flagUrl: map['flag_url'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'iso2': iso2,
      'iso3': iso3,
      'phone_code': phone_code,
      'flagUrl': flagUrl,
    };
  }
}
