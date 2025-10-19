

import 'package:dataplug/core/enum.dart';
import 'package:dataplug/core/model/core/giftcard.dart';

import '../../utils/utils.dart';

class GiftcardTxn {
  final String id;

  final String? bank_name;
  final String? account_name;
  final String? account_number;
  final String reference;
  final GiftCardTradeType trade_type;
  final GiftCardType card_type;
  final dynamic card;
  final String pin;
  final String comment;
  final num amount;
  final num service_charge;
  final num ngn_amount;

  final num rate;
  final int quantity;
  final num payable_amount;
  final String group_tag;

  final GiftcardAndCryptoTxnStatus status;
  final String review_note;
  final num? review_rate;
  final num? review_amount;
  final List<String>? review_proof;
  final DateTime? created_at;
  final Giftcard? gift_card;
  final dynamic? meta;
final List<CardDetail> cards;

  GiftcardTxn({
    required this.id,
    required this.bank_name,
    required this.account_name,
    required this.account_number,
    required this.reference,
    required this.trade_type,
    required this.card_type,
    required this.card,
    required this.pin,
    required this.comment,
    required this.amount,
    required this.service_charge,
    required this.ngn_amount,
    required this.rate,
    required this.quantity,
    required this.payable_amount,
    required this.group_tag,
    required this.status,
    required this.review_note,
    required this.review_rate,
    required this.review_amount,
    required this.review_proof,
    required this.created_at,
    required this.gift_card,
    required this.meta,
  required this.cards,
  });

  factory GiftcardTxn.fromMap(Map<String, dynamic> map) {
    return GiftcardTxn(
      id: map["id"].toString(),
      bank_name: map["bank_name"] ?? "",
      ngn_amount: map["ngn_amount"] == null || map["ngn_amount"].toString().isEmpty
          ? 0
          : num.tryParse(map["ngn_amount"].toString()) ?? 0,
      account_name: map["account_name"] ?? "",
      account_number: map["account_number"]?? '',
      meta: map["meta"],
      reference: map["reference"].toString(),
      trade_type: enumFromString(GiftCardTradeType.values, map["trade_type"])!,
      card_type: enumFromString(GiftCardType.values, map["card_type"])!,
      card: map["card"],
      pin: map["pin"].toString() ,
      comment: map["comment"].toString(),
      amount: num.tryParse("${map["amount"].toString()}") ?? 0,
      service_charge: num.tryParse("${map["service_charge"].toString()}") ?? 0,
      rate: num.tryParse("${map["rate"].toString()}") ?? 0,
      quantity: map["quantity"] == null || map["quantity"].toString().isEmpty
          ? 0
          : int.tryParse(map["quantity"].toString()) ?? 0,
      payable_amount: num.tryParse("${map["payable_amount"].toString()}") ?? 0,
      group_tag: map['group_tag'].toString(),
      status: enumFromString(GiftcardAndCryptoTxnStatus.values, map["status"])!,
      review_note: map["review_note"].toString(),
      review_rate: map["review_rate"] == null
          ? null
          : (map["review_rate"].toString().isEmpty
              ? 0
              : num.tryParse(map["review_rate"].toString()) ?? 0),
      review_amount: num.tryParse("${map["review_amount"].toString()}"),
      review_proof: map["review_proof"] == null
          ? null
          : (map["review_proof"] as List).map((e) => e.toString()).toList(),
      //
      created_at: DateTime.tryParse(map["created_at"]),
      gift_card:
          map["gift_card"] == null ? null : Giftcard.fromMap(map["gift_card"]),
      cards: map['cards'] != null
    ? List<CardDetail>.from(map['cards'].map((x) => CardDetail.fromJson(x)))
    : [],
          
    );
  }

  // toMap
  Map<String , dynamic> toMap() {
    return {
      "id": id,
      "bank_name": bank_name,
      "ngn_amount": ngn_amount,
      "account_name": account_name,
      "account_number": account_number,
      "meta": meta,
      "reference": reference,
      "trade_type": trade_type.index,
      "card_type": card_type.index,
      "card": card,
      "pin": pin,
      "comment": comment,
      "amount": amount,
      "service_charge": service_charge,
      "rate": rate,
      "payable_amount": payable_amount,
      "group_tag": group_tag,
      "status": status.index,
      "review_note": review_note,
      "review_rate": review_rate,
      "review_amount": review_amount,
      "review_proof": review_proof,
      "created_at": created_at,
      "gift_card": gift_card?.toMap(),
      "cards": cards.map((e) =>
      e.toJson()).toList(),
      };
      }
      // toString
}

class CardDetail {
  final String pinCode;
  final String cardNumber;

  CardDetail({required this.pinCode, required this.cardNumber});

  factory CardDetail.fromJson(Map<String, dynamic> json) {
    return CardDetail(
      pinCode: json['pinCode'] ?? '',
      cardNumber: json['cardNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pinCode': pinCode,
      'cardNumber': cardNumber,
    };
  }

  @override
  String toString() {
    return 'CardDetail(pinCode: $pinCode, cardNumber: $cardNumber)';
  }
}





