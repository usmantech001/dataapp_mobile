class CardSummaryArg {
  final String type;
  final num amount;
  final num amountInNaira;
  final num fee;
  final num rate;
  final String issuer;
   Address address;
  final String holderName;

  CardSummaryArg({
    required this.type,
    required this.amount,
    required this.amountInNaira,
    required this.fee,
    required this.rate,
    required this.issuer,
    required this.address,
    required this.holderName,
  });
}


class Address {
   String line1;
   String city;
   String state;
   String postalCode;
   String country;

  Address({
    required this.line1,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      line1: json['line1'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postalCode: json['postal_code'] ?? '',
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'line1': line1,
      'city': city,
      'state': state,
      'postal_code': postalCode,
      'country': country,
    };
  }

  @override
  String toString() {
    return '$line1, $city, $state, $postalCode, $country';
  }
}
