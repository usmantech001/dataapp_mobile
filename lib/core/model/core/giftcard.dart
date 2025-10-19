import 'dart:convert';

import 'package:dataplug/core/enum.dart';

import '../../utils/utils.dart';
import 'giftcard_category_provider.dart';


class Giftcard {
  final String id;
  final String icon;
  final String name;
  final num sell_rate;
  final num buy_rate;
  final num sell_min_amount;
  final num sell_max_amount;

  final String status;
  final DateTime? created_at;
  final GiftcardCategory? category;

  // BUY
  final num buy_min_amount;
  final num buy_max_amount;
  final GiftCardDenominationType? denomination_type;
  final String? currency;
  final List<num> price_list;

  

  Giftcard({
    required this.id,
    required this.name,
    required this.icon,
    required this.sell_rate,
    required this.buy_rate,
    required this.sell_min_amount,
    required this.sell_max_amount,
    required this.buy_min_amount,
    required this.buy_max_amount,
    required this.status,
    required this.created_at,
    required this.category,
    required this.denomination_type,
    required this.currency,
    required this.price_list,
  });

  factory Giftcard.fromMap(Map<String, dynamic> map) {
    print("giftcard ::: $map");
    return Giftcard(
      icon: map["icon"].toString(),
      id: map["id"].toString(),
      name: map['name'].toString(),
      sell_rate: map["sell_rate"] ?? 0,
      buy_rate: map["buy_rate"] ?? 0,
      sell_min_amount: map["sell_min_amount"] ?? 0,
      sell_max_amount: map["sell_max_amount"] ?? 0,
      status: map["status"].toString(),
      created_at: DateTime.tryParse(map["created_at"]),
      category: map["category"] == null
          ? null
          : GiftcardCategory.fromJson(map["category"]),
      buy_min_amount: getBuyMinAmount(map),
      buy_max_amount: getBuyMaxAmount(map),
      denomination_type: enumFromString(
          GiftCardDenominationType.values, map["denomination_type"]),
      currency: map["currency"],
      price_list:  getPriceList(map),
    );
  }

  static List<num> getPriceList(map) {
    List<num> dt = [];


    (map["price_list"] ?? []).forEach((element) {
      dt.add(element);
    });
   
    return dt.isEmpty ? [] : dt;
  }

  static num getBuyMinAmount(map) {
    if (map["denomination_type"].toString().toLowerCase() == "RANGE") {
      return map["buy_min_amount"] ?? map["min_amount"] ?? 0;
    }

    try {
      return (map["price_list"] as List).first;
    } catch (_) {
      return 0;
    }
  }

  static num getBuyMaxAmount(map) {
    if (map["denomination_type"].toString().toLowerCase() == "RANGE") {
      return map["buy_max_amount"] ?? map["max_amount"] ?? 0;
    }

    try {
      return (map["price_list"] as List).last;
    } catch (_) {
      return 0;
    }
  }

  // tomap
  Map<String , dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "icon": icon,
      "denomination_type": enumToString(denomination_type),
      "currency": currency,
      "category": category,
      "price_list": price_list,
      "buy_rate": buy_rate,
      "sell_min_amount": sell_min_amount,
      "sell_max_amount": sell_max_amount,
      "sell_rate": sell_rate,
      "buy_min_amount": buy_min_amount,
      "buy_max_amount": buy_max_amount,
      "created_at": created_at,
      "status": status,
      };
      }
}
