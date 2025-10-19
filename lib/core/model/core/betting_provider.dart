import 'package:dataplug/presentation/misc/custom_components/custom_dropdown_btn.dart';

class BettingProvider extends BaseCustomDropdownButtonFormFieldList {
  final String id;
  final String name;
  final String? logo;
  final String type;
  final String code;

  BettingProvider({
    required this.id,
    required this.name,
    required this.logo,
    required this.type,
    required this.code,
  });

  factory BettingProvider.fromMap(Map<String, dynamic> map) {
    return BettingProvider(
      id: map["id"].toString(),
      name: map['name'].toString(),
      logo: map["logo"],
      type: map["type"].toString(),
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
