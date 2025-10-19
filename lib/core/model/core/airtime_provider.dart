import '../../../presentation/misc/custom_components/custom_dropdown_btn.dart';

class AirtimeProvider extends BaseCustomDropdownButtonFormFieldList {
  final String id;
  final String name;
  final String? logo;
  final String type;
  final String code;

  AirtimeProvider({
    required this.id,
    required this.name,
    required this.logo,
    required this.type,
    required this.code,
  });

  factory AirtimeProvider.fromMap(Map<String, dynamic> map) {
    return AirtimeProvider(
      id: map["id"].toString(),
      name: map['name'].toString(),
      logo: map["logo"],
      type: map["type"].toString(),
      code: map["code"].toString(),
    );
  }

  @override
  String toIcon() => logo ?? "";

  @override
  String toName() => name;

  @override
  bool hasIcon() => true;
}
