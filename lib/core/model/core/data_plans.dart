import 'package:dataplug/core/model/core/data_provider.dart';

class DataPlan {
  final String id;
  final String name;
  final String code;
  final num amount;
  final String duration;
  final String logo;
  final String bundle;
  final String type;
  final DataProvider? provider;

  DataPlan({
    required this.id,
    required this.name,
    required this.code,
    required this.amount,
    required this.duration,
    required this.bundle,
    required this.logo,
    required this.type,
   this.provider
  });

  factory DataPlan.fromMap(Map<String, dynamic> map) {
    return DataPlan(
      id: map["id"].toString(),
      name: map['name'].toString(),
      code: map["code"].toString(),
      amount: map["amount"],
      logo: map["logo"]??"",
      type: map["type"]??"",
      duration: map["duration"].toString(),
      bundle: map["bundle"] ?? "NA",
      provider: DataProvider.fromMap(map['service'])
    );
  }
}
