class StaticBankDetail {
  final String bank_code;
  final String bank_name;
  final String account_name;
  final String customer_name;
  final String account_number;


  StaticBankDetail({
    required this.bank_code,
    required this.bank_name,
    required this.account_name,
    required this.customer_name,
    required this.account_number,

  });

  factory StaticBankDetail.fromMap(Map<String, dynamic> map) {
    return StaticBankDetail(
      bank_code: map["bank_code"] ?? "",
      bank_name: map["bank_name"] ?? "",
      account_name: map["account_name"] ?? "",
      customer_name: map["customer_name"] ?? "",
      account_number: map["account_number"] ?? "",
    );
  }
}
