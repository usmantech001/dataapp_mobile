class CardServiceBreakdown {
  final String currency;
  final num amount;
  final num rate;
  final num amountNgn;
  final num serviceCharge;
  final num serviceChargeNgn;
  final num totalAmount;
  final num totalAmountNgn;


  CardServiceBreakdown({
    required this.currency,
    required this.amount,
    required this.rate,
    required this.amountNgn,
    required this.serviceCharge,
    required this.serviceChargeNgn,
    required this.totalAmount,
    required this.totalAmountNgn,
  });

  factory CardServiceBreakdown.fromMap(Map<String, dynamic> map) {
    return CardServiceBreakdown(
      currency: map['currency'] ?? '',
      amount: num.tryParse(map['amount'].toString()) ?? 0,
      rate: num.tryParse(map['rate'].toString()) ?? 0,
      amountNgn: num.tryParse(map['amount_ngn'].toString()) ?? 0,
      serviceCharge: num.tryParse(map['service_charge'].toString()) ?? 0,
      serviceChargeNgn: num.tryParse(map['service_charge_ngn'].toString()) ?? 0,
      totalAmount: num.tryParse(map['total_amount'].toString()) ?? 0,
      totalAmountNgn: num.tryParse(map['total_amount_ngn'].toString()) ?? 0,
    );
  }
}