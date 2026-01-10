class Bank {
  final String id;
  final String name;
  final String code;
  final String? icon;
  final String deleted_at;

  Bank({
    required this.id,
    required this.name,
    required this.code,
     this.icon,
    required this.deleted_at,
  });

  factory Bank.fromMap(Map<String, dynamic> map) {
    return Bank(
      id: map["id"].toString(),
      name: map['name'].toString(),
      code: map["code"].toString(),
      icon: map["icon"],
      deleted_at: map["deleted_at"].toString(),
    );
  }
}
