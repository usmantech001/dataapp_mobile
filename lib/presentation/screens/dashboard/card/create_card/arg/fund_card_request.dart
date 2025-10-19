class FundCardRequest {
  final String currency;
  final num amount;
  final String pin;

  FundCardRequest({
    required this.currency,
    required this.amount,
    required this.pin,
  });

  Map<String, dynamic> toJson() {
    return {
      'currency': currency.toUpperCase(),
      'amount': amount, // nested object
      'pin': pin,
    };
  }
}
