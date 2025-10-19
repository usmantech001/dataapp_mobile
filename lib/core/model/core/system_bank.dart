class SystemBank {
  final String id;
  final String bank_name;
  final String bank_code;
  final String account_name;
  final String account_number;
  final String status;
  final String created_at;

  SystemBank({
    required this.id,
    required this.account_number,
    required this.account_name,
    required this.created_at,
    required this.bank_name,
    required this.bank_code,
    required this.status,
  });

  factory SystemBank.fromMap(Map<String, dynamic> map) {
    return SystemBank(
      id: map["id"].toString(),
      status: map["status"].toString(),
      account_number: map['account_number'],
      account_name: map["account_name"],
      created_at: map["created_at"],
      bank_name: map["bank_name"],
      bank_code: map["bank_code"],
    );
  }
}
