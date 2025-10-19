import '../../enum.dart';
import '../../utils/utils.dart';

class ServiceTxn {
  final String id;
  final String reference;
  final num amount;
  final CashFlowType type;
  final String provider;
  final String remark;
  final num fee;
  final String discount;
  final num totalAmount;
  final ServicePurpose purpose;
  final Status status;
  final Map<String, dynamic> meta;
  final DateTime? createdAt;

  ServiceTxn({
    required this.id,
    required this.reference,
    required this.amount,
    required this.type,
    required this.provider,
    required this.remark,
    required this.totalAmount,
    required this.fee,
    required this.discount,
    required this.purpose,
    required this.status,
    required this.createdAt,
    required this.meta,
  });

  factory ServiceTxn.fromMap(Map<String, dynamic> map) {
    return ServiceTxn(
      id: map["id"].toString(),
      reference: map["reference"].toString(),
      amount: num.tryParse(map["amount"].toString()) ?? 0,
      type: enumFromString(CashFlowType.values, map["type"].toString())!,
      provider: map["provider"].toString(),
      fee: num.tryParse(map["fee"].toString()) ?? 0,
      discount: map["discount"].toString(),
      totalAmount: map["total_amount"] ?? 0,
      remark: map["remark"].toString(),
      purpose: walletServiceToEnum(map["purpose"]),
      status: enumFromString(Status.values, map["status"].toString())!,
      createdAt: DateTime.tryParse(map["created_at"].toString()),
      meta: map["meta"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "reference": reference,
      "amount": amount,
      "discount": discount,
      "fee": fee,
      "total_amount": totalAmount,
      "type": enumToString(type),
      "provider": provider,
      "remark": remark,
      "purpose": serviceEnumToString(purpose),
      "status": enumToString(status),
      "created_at": createdAt?.toIso8601String(),
      "meta": meta,
    };
  }

  static ServicePurpose walletServiceToEnum(String purpose) {
    if (purpose == "electricity") return ServicePurpose.electricity;
    if (purpose == "education") return ServicePurpose.education;
    if (purpose == "international-airtime")
      return ServicePurpose.internationalAirtime;
    if (purpose == "international-data")
      return ServicePurpose.internationalData;
    if (purpose == "airtime") return ServicePurpose.airtime;
    if (purpose == "data") return ServicePurpose.data;
    if (purpose == "betting") return ServicePurpose.betting;
    // if (purpose == "betting") return ServicePurpose.gamebetting;
    if (purpose == "deposit") return ServicePurpose.deposit;
    if (purpose == "withdrawal") return ServicePurpose.withdrawal;
    if (purpose == "transfer") return ServicePurpose.transfer;

    if (purpose == "tv-subscription" || purpose == "tv") {
      return ServicePurpose.tvSubscription;
    }

    if (purpose == "virtual-card" || purpose == "card") {
      return ServicePurpose.virtualCard;
    }

    return ServicePurpose.na;
  }

  static String serviceEnumToString(ServicePurpose purpose) {
    switch (purpose) {
      case ServicePurpose.airtime:
        return "Airtime";
      case ServicePurpose.data:
        return "Data";
      case ServicePurpose.tvSubscription:
        return "TV/Cable";
      case ServicePurpose.electricity:
        return "Electricity";

      case ServicePurpose.internationalAirtime:
        return "Int'l Airtime";

      case ServicePurpose.internationalData:
        return "Int'l Data";

      case ServicePurpose.education:
        return "E-PIN";
      case ServicePurpose.betting:
        return "betting";
      case ServicePurpose.deposit:
        return "Top Up";
      case ServicePurpose.transfer:
        return "Transfer";
      case ServicePurpose.withdrawal:
        return "Withdrawal";
      case ServicePurpose.virtualCard:
        return "Virtual Card";
      default:
        return enumToString(purpose);
    }
  }
}
