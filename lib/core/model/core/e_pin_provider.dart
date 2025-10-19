import 'package:dataplug/presentation/misc/custom_components/custom_dropdown_btn.dart';

class EPinProvider extends BaseCustomDropdownButtonFormFieldList {
  final String id;
  final String name;
  final String? logo;
  final String type;
  final String code;

  EPinProvider({
    required this.id,
    required this.name,
    required this.logo,
    required this.type,
    required this.code,
  });

  factory EPinProvider.fromMap(Map<String, dynamic> map) {
    return EPinProvider(
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
