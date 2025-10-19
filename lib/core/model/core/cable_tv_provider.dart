import 'package:dataplug/presentation/misc/custom_components/custom_dropdown_btn.dart';

class CableTvProvider extends BaseCustomDropdownButtonFormFieldList {
  final String id;
  final String name;
  final String? logo;
  final String type;
  final String code;

  CableTvProvider({
    required this.id,
    required this.name,
    required this.logo,
    required this.type,
    required this.code,
  });

  factory CableTvProvider.fromMap(Map<String, dynamic> map) {
    return CableTvProvider(
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

class CableTvType extends BaseCustomDropdownButtonFormFieldList {
  final String type;

  CableTvType(this.type);

  //
  @override
  String toIcon() => "";

  @override
  String toName() => type;

  @override
  bool hasIcon() => false;
}
