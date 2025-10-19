import 'bank.dart';

class UserBank {
  final String id;
  final String bank_id;
  final String account_number;
  final String account_name;
  final String created_at;
  final String bank_name;
  final String bank_code;
  final Bank? bank;

  UserBank({
    required this.id,
    required this.bank_id,
    required this.account_number,
    required this.account_name,
    required this.created_at,
    required this.bank_name,
    required this.bank_code,
    required this.bank,
  });

  factory UserBank.fromMap(Map<String, dynamic> map) {
    return UserBank(
      id: map["id"].toString(),
      bank_id: map["bank_id"].toString(),
      account_number: map['account_number'],
      account_name: map["account_name"],
      created_at: map["created_at"],
      bank_name: map["bank_name"],
      bank_code: map["bank_code"],
      bank: map["bank"] == null ? null : Bank.fromMap(map["bank"]),
    );
  }
}
