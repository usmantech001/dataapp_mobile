class BreakdownInfo {
  final String rate;
  final String serviceCharge;
  final String amount;
  final String payableAmount;

  BreakdownInfo({
    required this.rate,
    required this.serviceCharge,
    required this.amount,
    required this.payableAmount,
  });

  factory BreakdownInfo.fromJson(Map<String, dynamic> json) {
    return BreakdownInfo(
      rate: json['rate'].toString(),
      serviceCharge: json['service_charge'].toString(),
      amount: json['amount'].toString(),
      payableAmount: json['payable_amount'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rate': rate,
      'service_charge': serviceCharge,
      'amount': amount,
      'payable_amount': payableAmount,
    };
  }
}