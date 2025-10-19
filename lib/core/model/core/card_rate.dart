class CardRate {
  final String currency;
  final num rate;

  CardRate({
    required this.currency,
    required this.rate,
  });

  factory CardRate.fromMap(Map<String, dynamic> map) {
    return CardRate(
      currency: map['currency'] ?? '',
      rate: num.tryParse(map['rate'].toString()) ?? 0,
    );
  }
}