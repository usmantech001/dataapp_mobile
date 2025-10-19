import 'package:dataplug/presentation/misc/custom_components/custom_dropdown_btn.dart';

class OperatorProvider extends BaseCustomDropdownButtonFormFieldList {
  final String id;
  final String name;
  final String code;
  final String currency;
  final String? logo;
  final bool active;
  final String minAmount;
  final String maxAmount;
  final String minAmountNgn;
  final String maxAmountNgn;
  final num rate;
  OperatorProvider({
    required this.id,
    required this.name,
    required this.logo,
    required this.active,
    required this.code,
    required this.currency,
    required this.minAmount,
    required this.minAmountNgn,
    required this.maxAmount,
    required this.maxAmountNgn,
    required this.rate,
  });

  factory OperatorProvider.fromMap(Map<String, dynamic> map) {
    return OperatorProvider(
      id: map["id"].toString(),
      name: map['name'].toString(),
      logo: map["logo"].toString(),
      currency: map["currency"].toString(),
      rate: map['rate'] ?? 0,
      maxAmount: map['max_amount'].toString(),
      maxAmountNgn: map['max_amount_ngn'].toString(),
      minAmount: map['min_amount'].toString(),
      minAmountNgn: map['min_amount_ngn'].toString(),
      active: map["active"] ?? false,
      code: map["code"].toString(),
    );
  }

  @override
  bool hasIcon() => true;

  @override
  String toIcon() => logo ?? "";

  @override
  String toName() => name;
}

class BettingType extends BaseCustomDropdownButtonFormFieldList {
  final String type;

  BettingType(this.type);

  //
  @override
  String toIcon() => "";

  @override
  String toName() => type;

  @override
  bool hasIcon() => false;
}
