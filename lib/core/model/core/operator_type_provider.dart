import 'package:dataplug/presentation/misc/custom_components/custom_dropdown_btn.dart';

class OperatorTypeProvider extends BaseCustomDropdownButtonFormFieldList {
  final String id;
  final String name;
  final String code;
  final String amount;
  final String amountNgn;

  final String logo;
  final String type;

  final String rate;
  OperatorTypeProvider({
    required this.id,
    required this.name,
    required this.logo,
    required this.type,
    required this.code,
    required this.amount,
    required this.amountNgn,
    required this.rate,
  });

  factory OperatorTypeProvider.fromMap(Map<String, dynamic> map) {
    return OperatorTypeProvider(
      id: map["id"].toString(),
      name: map['name'].toString(),
      logo: map["logo"].toString(),
      amount: map["amount"].toString(),
      rate: map['rate'].toString(),
      amountNgn: map['amount_ngn'].toString(),
      type: map["type"].toString(),
      code: map["code"].toString(),
    );
  }

  @override
  bool hasIcon() => true;

  @override
  String toIcon() => logo;

  @override
  String toName() => name;
}

