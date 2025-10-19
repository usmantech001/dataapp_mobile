class DataPlan {
  final String id;
  final String name;
  final String code;
  final num amount;
  final String duration;
  final String bundle;

  DataPlan({
    required this.id,
    required this.name,
    required this.code,
    required this.amount,
    required this.duration,
    required this.bundle,
  });

  factory DataPlan.fromMap(Map<String, dynamic> map) {
    return DataPlan(
      id: map["id"].toString(),
      name: map['name'].toString(),
      code: map["code"].toString(),
      amount: map["amount"],
      duration: map["duration"].toString(),
      bundle: map["bundle"] ?? "NA",
    );
  }
}
