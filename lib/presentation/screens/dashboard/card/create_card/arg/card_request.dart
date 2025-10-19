import 'card_summary_arg.dart';

class CreateCardRequest {
  final String currency;
  final num amount;
  final String name;
  final String brand;
  final Address address;
  final String pin;

  CreateCardRequest({
    required this.currency,
    required this.amount,
    required this.name,
    required this.brand,
    required this.address,
    required this.pin,
  });

  Map<String, dynamic> toJson() {
    return {
      'currency': currency.toUpperCase(),
      'amount': amount,
      'name': name,
      'brand': brand.toUpperCase(), // MASTERCARD or VISA
      'address': address.toJson(),  // nested object
      'pin': pin,
    };
  }
}
