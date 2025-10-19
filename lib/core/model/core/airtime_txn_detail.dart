class AirtimeTxnDetail {
  final String id;
  final String reference;
  final num amount;
  final String type;
  final String provider;
  final String remark;
  final String purpose;
  final String status;
  final DateTime? created_at;
  String logo;

  AirtimeTxnDetail({
    required this.id,
    required this.reference,
    required this.amount,
    required this.type,
    required this.provider,
    required this.remark,
    required this.purpose,
    required this.status,
    required this.created_at,
    this.logo = "",
  });

  factory AirtimeTxnDetail.fromMap(Map<String, dynamic> map) {
    return AirtimeTxnDetail(
      id: map["id"].toString(),
      reference: map["reference"].toString(),
      amount: map["amount"],
      type: map["type"].toString(),
      provider: map["provider"].toString(),
      remark: map["remark"].toString(),
      purpose: map["purpose"].toString(),
      status: map["status"].toString(),
      created_at: DateTime.tryParse(map["created_at"]),
    );
  }
}
