class CableTvPlan {
  final String id;
  final String name;
  final String code;
  final num amount;

  CableTvPlan({
    required this.id,
    required this.name,
    required this.code,
    required this.amount,
  });

  factory CableTvPlan.fromMap(Map<String, dynamic> map) {
    return CableTvPlan(
      id: map["id"].toString(),
      name: map['name'].toString(),
      code: map["code"].toString(),
      amount: map["amount"],
    );
  }
}
