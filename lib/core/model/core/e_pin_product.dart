import 'package:dataplug/presentation/misc/custom_components/custom_dropdown_btn.dart';

class EPinProduct extends BaseCustomDropdownButtonFormFieldList {
  final String id;
  final String name;
  final String code;
  final num amount;

  EPinProduct({
    required this.id,
    required this.name,
    required this.code,
    required this.amount,
  });

  factory EPinProduct.fromMap(Map<String, dynamic> map) {
    return EPinProduct(
      id: map["id"].toString(),
      name: map['name'].toString(),
      code: map["code"].toString(),
      amount: map["amount"],
    );
  }

  @override
  bool hasIcon() => false;

  @override
  String toIcon() => "";

  @override
  String toName() => name;
}

class EPinProductType extends BaseCustomDropdownButtonFormFieldList {
  final String field;

  EPinProductType(this.field);

  //
  @override
  String toIcon() => "";

  @override
  String toName() => field;

  @override
  bool hasIcon() => false;
}
