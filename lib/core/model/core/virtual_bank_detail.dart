class VirtualBankDetail {
  final String provider;
  final String bank_code;
  final String bank_name;
  final String account_name;
  final String customer_name;
  final String account_number;
  final String account_reference;
  final DateTime? expired_at;

  VirtualBankDetail({
    required this.provider,
    required this.bank_code,
    required this.bank_name,
    required this.account_name,
    required this.customer_name,
    required this.account_number,
    required this.account_reference,
    required this.expired_at,
  });

  factory VirtualBankDetail.fromMap(Map<String, dynamic> map) {
    return VirtualBankDetail(
      provider: map["provider"] ?? "",
      bank_code: map["bank_code"] ?? "",
      bank_name: map["bank_name"] ?? "",
      account_name: map["account_name"] ?? "",
      customer_name: map["customer_name"] ?? "",
      account_number: map["account_number"] ?? "",
      account_reference: map["account_reference"] ?? "",
      expired_at: map["expired_at"] == null
          ? null
          : DateTime.tryParse(map["expired_at"]),
    );
  }

  // tojson

    Map<String, dynamic> toMap() {
    return {
      "provider": provider,
      "bank_code": bank_code,
      "bank_name": bank_name,
      "account_name": account_name,
      "customer_name": customer_name,
      "account_number": account_number,
      "account_reference": account_reference,
      "expired_at": expired_at?.toIso8601String(),
    };
  }
}
