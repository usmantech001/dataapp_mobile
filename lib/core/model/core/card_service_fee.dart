class CardServiceFee {
  final String name;
  final String code;
  final String type;
  final num value;

  CardServiceFee({
    required this.name,
    required this.code,
    required this.type,
    required this.value,
  });

  factory CardServiceFee.fromMap(Map<String, dynamic> map) {
    return CardServiceFee(
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      type: map['type'] ?? '',
      value: num.tryParse(map['value'].toString()) ?? 0,
    );
  }
}