import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:dataplug/core/constants.dart';

import 'package:dataplug/core/enum.dart';
import 'package:dataplug/core/utils/utils.dart';

import '../model/core/giftcard.dart';
import '../model/core/giftcard_category_provider.dart';
import '../model/core/giftcard_txn.dart';
import '../services/http_request.dart';
import '../utils/errors.dart';

class GiftCardHelper {
  static Future<List<GiftcardCategory>> getGiftCardCategories(
      GiftCardTradeType giftCardTradeType,
      {String? filter}) async {
    String url = "/giftcard-categories?per_page=40";

    if (giftCardTradeType == GiftCardTradeType.buy) {
      url = "/giftcard-categories/buy?per_page=40";
    }

    if (filter != null) url += filter;
    http.Response response = await HttpRequest.get(url).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    print("Gitcacat ::: ${res}");
    try {
      if (response.statusCode < 400) {
        return (res['data'] as List)
            .map((e) => GiftcardCategory.fromJson(e))
            .toList();
      } else {
        throw throwHttpError(res);
      }
    } catch (error) {
      print(error);
      throw "Something is wrong $error";
    }
  }

  static Future<List<Giftcard>> getGiftcards(String per_page,
      {GiftCardTradeType? giftCardTradeType, String? filter}) async {
    String url = "/giftcards?include=category&per_page=$per_page";

    if (giftCardTradeType == GiftCardTradeType.buy) {
      url = "/giftcards/buy?include=category&per_page=$per_page";
    }

    if (filter != null) url += filter;

    http.Response response = await HttpRequest.get(url).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    // print("res $res");

    try {
      if (response.statusCode < 400) {
        return (res['data'] as List).map((e) => Giftcard.fromMap(e)).toList();
      } else {
        throw throwHttpError(res);
      }
    } catch (error) {
      print(error);
      // throw "Something went wrong";
      rethrow;
    }
  }

  // static Future<List<GiftcardRate>> getGiftcardRates(String per_page,
  //     {GiftCardTradeType? giftCardTradeType, String? filter}) async {
  //   String url = "/giftcard-rates?per_page=$per_page";

  //   if (filter != null) url += filter;
  //   http.Response response = await HttpRequest.get(url).catchError((err) {
  //     throw OtherErrors(err);
  //   });

  //   Map res = json.decode(response.body);

  //   if (response.statusCode < 400) {
  //     return (res['data'] as List).map((e) => GiftcardRate.fromMap(e)).toList();
  //   } else {
  //     throw throwHttpError(res);
  //   }
  // }

  //
  static Future<Map<String, dynamic>> getGiftcardBreakDown({
    required String giftcard_id,
    required num amount,
    required GiftCardTradeType trade_type,
  }) async {
    http.Response response = await HttpRequest.post("/giftcards/breakdown", {
      "giftcard_id": giftcard_id,
      "amount": "$amount",
      "trade_type": enumToString(trade_type)
    }).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    print("GiftcardBreakDown ::: $res");
    if (response.statusCode < 400) return (res['data']);
    throw throwHttpError(res);
  }

  static Future<String> createSale({
    required String giftcard_id,
    required num amount,
    required GiftCardTradeType trade_type,
    String? bank_account_id,
    required GiftCardType card_type,
    required num quantity,
    required String comment,
    required String transaction_pin,
    List<String>? imageLinks,
  }) async {
    Map<String, dynamic> body = {
      "giftcard_id": giftcard_id,
      "amount": "$amount",
      "trade_type": enumToString(trade_type),
      "card_type": enumToString(card_type),
      "comment": comment,
      "quantity": "$quantity",
      "pin": transaction_pin,
    };

    //
    int count = 0;
    for (final String el in (imageLinks ?? [])) {
      body["cards[${count.toString()}]"] = el;
      count += 1;
    }

    http.Response response =
        await HttpRequest.post("/giftcards", body).catchError((err) {
      throw OtherErrors(err);
    });

    Map<String, dynamic> res = json.decode(response.body);
    if (response.statusCode < 400) return res["message"];

    throw throwHttpError(res);
  }

  static Future<List<GiftcardTxn>> getGiftcardTxns(String? urlQuery) async {
    http.Response response = await HttpRequest.get(
            "/giftcard-transactions?include=giftCard,giftCard.category$urlQuery")
        .catchError((err) {
          log(err, name: "Error from G card transaction");
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    log(res.toString(), name: "Giftcard Response");

    // print("giftcrds ::: ${res['data'].first['meta']}");

    if (response.statusCode < 400) {
      return (res['data'] as List).map((e) => GiftcardTxn.fromMap(e)).toList();
    } else {
      log(res.toString());
      throw throwHttpError(res);
    }
  }

  static Future<GiftcardTxn> getGiftcardTxn({required String id}) async {
    http.Response response =
        await HttpRequest.get("/giftcard-transactions/$id").catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    log(res.toString(), name: "Giftcard Response");

    // print("giftcrds ::: ${res['data'].first['meta']}");

    if (response.statusCode < 400) {
      return GiftcardTxn.fromMap(res['data']);
    } else {
      log(res.toString());
      throw throwHttpError(res);
    }
  }
}
