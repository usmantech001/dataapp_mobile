import '../../../presentation/misc/custom_components/custom_dropdown_btn.dart';

class ElectricityProvider extends BaseCustomDropdownButtonFormFieldList {
  final String id;
  final String name;
  final String logo;
  final String type;
  final String code;

  ElectricityProvider({
    required this.id,
    required this.name,
    required this.logo,
    required this.type,
    required this.code,
  });

  factory ElectricityProvider.fromMap(Map<String, dynamic> map) {
    return ElectricityProvider(
      id: map["id"].toString(),
      name: map['name'].toString(),
      logo: map["logo"].toString(),
      type: map["type"].toString(),
      code: map["code"].toString(),
    );
  }

  @override
  String toIcon() => logo;

  @override
  String toName() => name;

  @override
  bool hasIcon() => true;
}

class ElectricityMeterType extends BaseCustomDropdownButtonFormFieldList {
  final String field;
  final bool isPrepaid;

  ElectricityMeterType(this.field, this.isPrepaid);

  //
  @override
  String toIcon() => "";

  @override
  String toName() => field;

  @override
  bool hasIcon() => false;
}
