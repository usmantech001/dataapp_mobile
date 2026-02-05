import 'dart:convert';
import 'dart:developer';

import 'package:dataplug/core/model/core/card_data.dart';
import 'package:dataplug/core/model/core/card_rate.dart';
import 'package:dataplug/core/model/core/card_service_fee.dart';
import 'package:dataplug/core/model/core/giftcard_product_provider.dart';
import 'package:dataplug/core/model/core/spending_analysis_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../presentation/screens/dashboard/card/create_card/arg/card_request.dart';
import '../../presentation/screens/dashboard/card/create_card/arg/fund_card_request.dart';
import '../enum.dart';
import '../model/core/airtime_provider.dart';
import '../model/core/betting_provider.dart';
import '../model/core/breakdown.dart';
import '../model/core/cable_tv_plan.dart';
import '../model/core/cable_tv_provider.dart';
import '../model/core/card_transactions.dart';
import '../model/core/country.dart' as intlBillCountries;
import '../model/core/data_plans.dart';
import '../model/core/data_provider.dart';
import '../model/core/e_pin_product.dart';
import '../model/core/e_pin_provider.dart';
import '../model/core/electricity_provider.dart';
import '../model/core/giftcard_category_provider.dart';
import '../model/core/giftcard_txn.dart';
import '../model/core/operator_provider.dart';
import '../model/core/operator_type_provider.dart';
import '../model/core/service_txn.dart';
import '../model/core/user.dart';
import '../model/core/virtual_account_provider.dart';
import '../model/core/virtual_bank_detail.dart';
import '../model/electricity_customer.dart';
import '../services/http_request.dart';
import '../utils/errors.dart';
import '../utils/utils.dart';

class ServicesHelper {
  static Future<(List<ServiceTxn>, int, int)> getServiceTxns(
      {int perPage = 30,
     required int page,
      String? status,
      String? purpose,
      CashFlowType? cashFlowType,
      DateTime? startDate,
      DateTime? endDate}) async {
    //

    String url = "/transactions";

    Map<String, String>? queryParameters = {
      'per_page' : '10',
      'page' : '$page',
      if (status != null) 'filter[status]': status,
      if (purpose != null) 'filter[purpose]': purpose,
    };
    http.Response response =
        await HttpRequest.get(url, queryParameters: queryParameters)
            .catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode < 400) {
      print('..history data ${res['meta']}');
      int page = res['meta']['page'];
      int total = res['meta']['total'];
      final serviceTxnList = (res['data'] as List).map((e) => ServiceTxn.fromMap(e)).toList();
      return (serviceTxnList, page, total);
    } else {
      throw throwHttpError(res);
    }
  }

  static Future<SpendingAnalysisData> getSpendingAnalysis(
      {required String period}) async {
    //

    String url = "/spending-analysis?period=$period";

    http.Response response = await HttpRequest.get(url).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
     
    if (response.statusCode < 400) {
      return SpendingAnalysisData.fromJson(res['data']);
    } else {
      throw throwHttpError(res);
    }
  }

  static Future<List<VirtualAccountProvider>>
      getVirtualAccountProviders() async {
    http.Response response =
        await HttpRequest.get("/virtual-account-providers").catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode < 400) {
      return (res['data'] as List)
          .map((e) => VirtualAccountProvider.fromMap(e))
          .toList();
    } else {
      throw throwHttpError(res);
    }
  }

  static Future<CardServiceFee?> getCardServideFee(
      {required String currency}) async {
    http.Response response =
        await HttpRequest.get("/virtual-cards/fee/$currency").catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode == 200) {
      return CardServiceFee.fromMap(res['data']);
    }
    throw throwHttpError(res);
  }

  static Future<CardServiceFee?> getMinimumAmount(
      {required String currency}) async {
    http.Response response =
        await HttpRequest.get("/virtual-cards/mini-card/$currency")
            .catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode == 200) {
      return CardServiceFee.fromMap(res['data']);
    }
    throw throwHttpError(res);
  }

  static Future<CardRate?> getCardRate({required String currency}) async {
    http.Response response =
        await HttpRequest.get("/virtual-cards/rate/$currency")
            .catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode == 200) {
      return CardRate.fromMap(res['data']);
    }
    throw throwHttpError(res);
  }

  static Future<GiftcardTxn> buyGiftcard({
    required int giftcardId,
    required String amount,
    required String cardType,
    required String pin,
    required int quantity,
  }) async {
    Map<String, dynamic> body = {
      'giftcard_id': giftcardId.toString(),
      'amount': amount.toString(),
      'trade_type': 'buy',
      'card_type': cardType.toLowerCase(),
      // 'cards': cards,
      'pin': pin,
      // 'comment': "",
      'quantity': quantity.toString(),
      //'payout_method': payoutMethod,
    };
    log(pin.toString(), name: "Amount");
    http.Response response =
        await HttpRequest.post("/giftcards", body).catchError((err) {
      log(err.toString());

      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode < 400) {
      log(res['data'].toString());
      return GiftcardTxn.fromMap(res['data']);
    }
    log(response.body.toString(), name: "Log Card Error");
    throw throwHttpError(res);
  }

  static Future<List<intlBillCountries.Country>> getIntlBillCountries(
      {String? filterName, required String type}) async {
    http.Response res = await HttpRequest.get(type == 'airtime'
            ? "/international-airtime/countries?do_not_paginate=1"
            : "/international-data/countries?do_not_paginate=1")
        .catchError((err) {
      throw OtherErrors(err);
    });

    Map decodedRes = json.decode(res.body);

    log(res.body);

    log(res.statusCode.toString());

    if (res.statusCode == 200) {
      List dt = decodedRes['data'];
      return dt.map((e) => intlBillCountries.Country.fromMap(e)).toList();
    } else {
      throw decodedRes["message"];
    }
  }

  static Future<String> getWalletBalance() async {
    http.Response response = await HttpRequest.get("/wallet").catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    log(res.toString(), name: "Virtual Accounts");

    if (response.statusCode < 400) {
      String balance = res['data']['balance'].toString();
      return balance;
    } else {
      throw throwHttpError(res);
    }
  }

  static Future<List<VirtualBankDetail>?> getVirtualAccount() async {
    http.Response response =
        await HttpRequest.get("/wallet/accounts").catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    log(res.toString(), name: "Virtual Accounts");

    if (response.statusCode < 400) {
      if ((res['data'] as List).isEmpty) return null;
      return List.from(res['data'])
          .map((e) => VirtualBankDetail.fromMap(e))
          .toList();
    } else {
      throw throwHttpError(res);
    }
  }

  static Future<Map<String, dynamic>> fundWallet(
      {required String provider,
      required num amount,
      required String method}) async {
    Map<String, dynamic> _req = {};
    _req["provider"] = provider;
    _req["amount"] = amount.toString();
    _req["method"] = method;

    http.Response response =
        await HttpRequest.post("/wallet/fund", _req).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode < 400) {
      log(res['data'].toString());
      return res['data'];
    } else {
      throw throwHttpError(res);
    }
  }

  static Future<Map<String, dynamic>> getStaticAccount() async {
    //
    http.Response response =
        await HttpRequest.get("/wallet/accounts").catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      return res['data'];
    } else {
      throw throwHttpError(res);
    }
  }

  static Future<bool> requestSafeHavenOtp() async {
    http.Response response =
        await HttpRequest.post("/identity/request-otp", {}).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      // return false;
      return true;
    } else {
      throw throwHttpError(res);
    }
  }

  static Future<Map<String, dynamic>> validateBVN(
      {
      // required String type,
      required String number,
      required String dob,
      required String fName,
      required String lName}) async {
    //
    http.Response response = await HttpRequest.post("/validate-bvn", {
      "last_name": lName,
      "first_name": fName,
      "bvn": number,
      "dob": dob,
     // "type": 'type',
    }).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    log(response.body);

    if (response.statusCode < 400) {
      print(res);
      return res['data'];
    } else {
      throw throwHttpError(res);
    }
  }
  // static Future<Map<String, dynamic>> validateBVN(
  //     {required String type,
  //     required String number,
  //     required String dob,
  //     required String fName,
  //     required String lName}) async {
  //   //
  //   http.Response response = await HttpRequest.post("/identity/validate", {
  //     "last_name": lName,
  //     "first_name": fName,
  //     "number": number,
  //     "dob": dob,
  //     "type": type,
  //   }).catchError((err) {
  //     throw OtherErrors(err);
  //   });

  // Map res = json.decode(response.body);

  // log(response.body);

  // if (response.statusCode < 400) {
  //   print(res);
  //   return res['data'];
  // } else {
  //   throw throwHttpError(res);
  // }
  // }

  static Future<bool> validateIdentification(
      {String? number,
      String? dob,
      String? fName,
      String? lName,
      String? type}) async {
    //

    Map<String, dynamic> _req = {
      "number": number,
      "dob": dob,
      'first_name': fName,
      "last_name": lName,
      "type": type,
    };

    http.Response response =
        await HttpRequest.post("/identity/validate", _req).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    print("res $res\n\n");
    if (response.statusCode < 400) {
      // return false;
      return res['data']['requiresOtp'];
    } else {
      throw throwHttpError(res);
    }
  }

  static Future<Map<String, dynamic>> validateIdentificationOTP(
      {required String otp, required String type}) async {
    //
    http.Response response = await HttpRequest.post(
        "/identity/validate-otp", {"otp": otp, "type": type}).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    print("err $res\n\n");
    if (response.statusCode < 400) {
      return res['data'];
    } else {
      throw throwHttpError(res);
    }
  }

  static Future<VirtualBankDetail> generateVirtualAccount(
      String provider) async {
    //

    http.Response response = await HttpRequest.post(
        "/wallet/account/generate", {"provider": provider}).catchError((err) {
      debugPrint(err + "from /wallet/account/generate");
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    log(response.body);

    if (response.statusCode < 400) {
      return VirtualBankDetail.fromMap(res['data']);
    } else {
      print('..the error is $res');
      throw throwHttpError(res);
    }
  }

  static Future<Map<String, dynamic>> generateAccount(
      // {required String bvn}
      ) async {
    //
    http.Response response =
        await HttpRequest.post("/wallet/account/generate", {})
            .catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode < 400) {
      print(res);
      return res['data'];
    } else {
      throw throwHttpError(res);
    }
  }

  static Future<List<AirtimeProvider>> getAirtimeProviders() async {
    String url = "/airtime/providers";

    http.Response response = await HttpRequest.get(url).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      print('...airtime provider ${res}');
      return (res['data'] as List)
          .map((e) => AirtimeProvider.fromMap(e))
          .toList();
    } else {
      throw throwHttpError(res);
    }
  }

  static Future<ServiceTxn> buyAiritme({
    required String phone,
    required num amount,
    required String provider,
    required String pin,
    required bool isPorted,
  }) async {
    http.Response response = await HttpRequest.post("/airtime", {
      "phone": phone,
      "amount": "$amount",
      "provider": provider,
      "pin": pin,
      "is_ported": isPorted,
    }).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode == 200) {
      return ServiceTxn.fromMap(res['data']);
    }
    throw throwHttpError(res);
  }

  static Future<List<ElectricityProvider>> getElectricityProvider(
      {String? filter}) async {
    String url = "/electricity/providers?per_page=50";
    if (filter != null) url += filter;

    http.Response response = await HttpRequest.get(url).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode < 400) {
      return (res['data'] as List)
          .map((e) => ElectricityProvider.fromMap(e))
          .toList();
    } else {
      throw throwHttpError(res);
    }
  }

  static Future<ElectricityCustomer> verifyElectricityDetails({
    required String provider,
    required bool isPrepaid,
    required String number,
  }) async {
    http.Response response = await HttpRequest.post("/electricity/verify", {
      "provider": provider,
      "type": isPrepaid ? "prepaid" : "postpaid",
      "number": number
    }).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode == 200) {
      print('..successfully veryfied neter number ${res}');
      return ElectricityCustomer.fromJson(res['data']);
    }
    throw throwHttpError(res);
  }

  static Future<ServiceTxn> buyUnit({
    required String provider,
    required String type,
    required String number,
    required String phone,
    required num amount,
    required String pin,
  }) async {
    Map<String, dynamic> body = {
      "provider": provider,
      "type": type,
      "number": number,
      "phone": phone,
      "amount": "$amount",
      "pin": pin
    };

    print('body $body');

    http.Response response =
        await HttpRequest.post("/electricity", body).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode == 200) {
      return ServiceTxn.fromMap(res['data']);
    }
    throw throwHttpError(res);
  }

  static Future<List<EPinProvider>> getEPinProviders() async {
    http.Response response = await HttpRequest.get("/e-pin").catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      return (res['data'] as List).map((e) => EPinProvider.fromMap(e)).toList();
    } else {
      throw throwHttpError(res);
    }
  }

  static Future<List<EPinProduct>> getEPinProducts(String provider) async {
    http.Response response =
        await HttpRequest.get("/e-pin/$provider").catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      print('..epin products $res');
      return (res['data'] as List).map((e) => EPinProduct.fromMap(e)).toList();
    } else {
      throw throwHttpError(res);
    }
  }

  static Future<String> verifyEpinDetails({
    required String type,
    required String number,
  }) async {
    http.Response response = await HttpRequest.post(
        "/e-pin/verify", {"type": type, "number": number}).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode < 400) {
      return res["data"]["customer_name"] ?? res["data"]["name"];
    }
    throw throwHttpError(res);
  }

  static Future<ServiceTxn> purchaseEPin({
    required String product,
    required String number,
    required String pin,
  }) async {
    Map<String, dynamic> body = {
      "product": product,
      "number": number,
      "pin": pin
    };

    http.Response response =
        await HttpRequest.post("/e-pin", body).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) return ServiceTxn.fromMap(res['data']);
    throw throwHttpError(res);
  }

  //
  static Future<List<DataProvider>> getDataProvider() async {
    http.Response response =
        await HttpRequest.get("/data/direct").catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    log(res.toString());
    if (response.statusCode < 400) {
      return (res['data'] as List).map((e) => DataProvider.fromMap(e)).toList();
    } else {
      throw throwHttpError(res);
    }
  }

  // DataPlan
  static Future<List<DataPlan>> getDataPlan(
      String provider, String type) async {
    String url =
        //  duration == null  ||  duration.isEmpty
        //     ?
        "/data/$type/$provider";
    // : "/data/$type/$provider?filter[duration]=$duration";
    http.Response response = await HttpRequest.get(url).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      print('..plans $res');
      if (res['data'] is List && res['data'].isNotEmpty) {
        return (res['data'] as List).map((e) => DataPlan.fromMap(e)).toList();
      } else {
        return []; // Return an empty list if 'data' is empty or not a valid list
      }
    } else {
      // throw throwHttpError(res);
      return [];
    }
  }

  static Future<List<DataPlan>> getRecommendedDataPlan() async {
    String url = "/data-featured";
    http.Response response = await HttpRequest.get(url).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      print('..recommended plans $res');
      if (res['data'] is List && res['data'].isNotEmpty) {
        return (res['data'] as List).map((e) => DataPlan.fromMap(e)).toList();
      } else {
        return []; // Return an empty list if 'data' is empty or not a valid list
      }
    } else {
      // throw throwHttpError(res);
      return [];
    }
  }

// Data plan types
  static Future<List<String>> getDataPlanTypes(String provider) async {
    try {
      http.Response response =
          await HttpRequest.get("/data-services/$provider");

      Map res = json.decode(response.body);
      if (response.statusCode < 400) {
        if (res['data'] is List) {
          // Safely map each item to a string
          return List<String>.from(res['data']);
        }
      }
      return [];
    } catch (err) {
      throw OtherErrors(err);
    }
  }

  // DataPlan service list
  static Future<List<String>> getProviderServiceList(String provider) async {
    try {
      http.Response response =
          await HttpRequest.get("/data-services/$provider");

      Map<String, dynamic> res = json.decode(response.body);

      if (response.statusCode < 400) {
        if (res['data'] is List && res['data'].isNotEmpty) {
          return (res['data'] as List).map((e) => e.toString()).toList();
        } else {
          return []; // Return an empty list if 'data' is empty or not a valid list
        }
      } else {
        throw throwHttpError(res);
        // return [];
      }
    } catch (err) {
      throw OtherErrors(err);
    }
  }

  static Future<ServiceTxn> buyData(
      {required String phone,
      required String code,
      required String provider,
      required String pin,
      required bool isPorted,
      required String dataPurchaseType}) async {
    String url = "/data/$dataPurchaseType";

    http.Response response = await HttpRequest.post(url, {
      "phone": phone,
      "provider": provider,
      "code": code,
      "pin": pin,
      "is_ported": isPorted,
    }).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    print("res $res");
    print(response.statusCode);

    if (response.statusCode == 200) {
      return ServiceTxn.fromMap(res['data']);
    }
    throw throwHttpError(res);
  }

  static Future<List<CableTvProvider>> getTVServiceProviders() async {
    http.Response response =
        await HttpRequest.get("/tv-subscription").catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      return (res['data'] as List)
          .map((e) => CableTvProvider.fromMap(e))
          .toList();
    } else {
      throw throwHttpError(res);
    }
  }

  static Future<String> verifyTvDetails({
    required String provider,
    required String number,
  }) async {
    http.Response response = await HttpRequest.post(
            "/tv-subscription/verify", {"provider": provider, "number": number})
        .catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      return res["data"]["customer_name"] ?? res["data"]["name"];
    }

    throw throwHttpError(res);
  }

  static Future<List<CableTvPlan>> getTvPlans(String provider) async {
    http.Response response =
        await HttpRequest.get("/tv-subscription/$provider").catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      print('....tv plans ${res['data']}');
      return (res['data'] as List).map((e) => CableTvPlan.fromMap(e)).toList();
    } else {
      throw throwHttpError(res);
    }
  }

  static Future<ServiceTxn> purchaseCableTv({
    required String provider,
    required String number,
    required String pin,
    required String code,
    required String type,
  }) async {
    Map<String, dynamic> body = {
      "provider": provider,
      "number": number,
      "pin": pin,
      "code": code,
      "type": type
    };

    http.Response response =
        await HttpRequest.post("/tv-subscription", body).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) return ServiceTxn.fromMap(res['data']);
    throw throwHttpError(res);
  }

  static Future<List<BettingProvider>> getBettingProviders() async {
    http.Response response =
        await HttpRequest.get("/betting/providers").catchError((err) {
      throw OtherErrors(err);
    });
    print(response.body);
    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      return (res['data'] as List).map((e) {
        return BettingProvider.fromMap(e);
      }).toList();
    } else {
      throw throwHttpError(res);
    }
  }

  static Future<String> verifyBettingDetails({
    required String provider,
    required String number,
  }) async {
    http.Response response = await HttpRequest.post(
            "/betting/verify", {"provider": provider, "number": number})
        .catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      return res["data"]["username"] ??
          "${res["data"]["firstname"]} ${res["data"]["lastname"]}";
    }

    throw throwHttpError(res);
  }

  static Future<ServiceTxn> fundBetting({
    required String provider,
    required String number,
    required String pin,
    required String amount,
  }) async {
    Map<String, dynamic> body = {
      "provider": provider,
      "number": number,
      "pin": pin,
      "amount": amount
    };

    http.Response response =
        await HttpRequest.post("/betting", body).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) return ServiceTxn.fromMap(res['data']);
    throw throwHttpError(res);
  }

  // static Future<ServiceTxn> buyGiftcard({
  //   required int giftcardId,
  //   required double amount,
  //   required String tradeType,
  //   required String cardType,
  //   required List<String> cards,
  //   required String pin,
  //   required int quantity,
  //   required String payoutMethod,
  // }) async {
  //   Map<String, dynamic> body = {
  //     'giftcard_id': giftcardId.toString(),
  //     'amount': amount.toString(),
  //     'trade_type': tradeType.toLowerCase(),
  //     'card_type': cardType.toLowerCase(),
  //     // 'cards': cards,
  //     'pin': pin,
  //     // 'comment': "",
  //     'quantity': quantity.toString(),
  //     'payout_method': payoutMethod,
  //   };
  //   log(pin.toString(), name: "Amount");
  //   http.Response response =
  //       await HttpRequest.post("/giftcards", body).catchError((err) {
  //     log(err.toString());

  //     throw OtherErrors(err);
  //   });

  //   Map res = json.decode(response.body);

  //   if (response.statusCode < 400) {
  //     log(res['data'].toString());
  //     return ServiceTxn.fromMap(res['data']);
  //   }
  //   throw throwHttpError(res);
  // }

  static Future<List<OperatorProvider>> getInternationalDataProviders(
      {required String iso2}) async {
    http.Response response =
        await HttpRequest.get("/international-data/providers/$iso2")
            .catchError((err) {
      throw OtherErrors(err);
    });
    print(response.body);
    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      return (res['data'] as List).map((e) {
        return OperatorProvider.fromMap(e);
      }).toList();
    } else {
      throw throwHttpError(res);
    }
  }

  static Future<List<OperatorTypeProvider>> getInternationalDataPlans(
      {required String providerId}) async {
    http.Response response =
        await HttpRequest.get("/international-data/products/$providerId")
            .catchError((err) {
      throw OtherErrors(err);
    });
    print("intl data plan ${response.body}");
    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      return (res['data'] as List).map((e) {
        return OperatorTypeProvider.fromMap(e);
      }).toList();
    } else {
      throw throwHttpError(res);
    }
  }

  static Future<List<OperatorProvider>> getInternationalAirtimeProviders(
      {required String iso2}) async {
    http.Response response =
        await HttpRequest.get("/international-airtime/providers/$iso2")
            .catchError((err) {
      throw OtherErrors(err);
    });
    print(response.body);
    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      return (res['data'] as List).map((e) {
        return OperatorProvider.fromMap(e);
      }).toList();
    } else {
      throw throwHttpError(res);
    }
  }

  static Future<ServiceTxn> buyInternationalAirtime({
    required String amount,
    required String phone,
    required String provider,
    required String pin,
  }) async {
    Map<String, dynamic> body = {
      "phone": phone,
      "amount": "$amount",
      "provider": provider,
      "pin": pin
    };

    http.Response response =
        await HttpRequest.post("/international-airtime", body)
            .catchError((err) {
      log(err.toString());

      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode < 400) {
      log(res['data'].toString());
      return ServiceTxn.fromMap(res['data']);
    }
    throw throwHttpError(res);
  }

  static Future<ServiceTxn> buyInternationalData({
    required String code,
    required String phone,
    required String provider,
    required String pin,
  }) async {
    Map<String, dynamic> body = {
      "phone": phone,
      "code": code,
      "provider": provider,
      "pin": pin
    };

    http.Response response =
        await HttpRequest.post("/international-data", body).catchError((err) {
      log(err.toString());

      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode < 400) {
      log(res['data'].toString());
      return ServiceTxn.fromMap(res['data']);
    }
    throw throwHttpError(res);
  }

  static Future<ServiceTxn> makeWithdrawal({
    required String bank_account_id,
    required String amount,
    required String pin,
  }) async {
    http.Response response = await HttpRequest.post("/wallet/withdraw", {
      "bank_account_id": bank_account_id,
      "amount": amount,
      "pin": pin
    }).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode < 400) {
      return ServiceTxn.fromMap(res['data']);
    }
    throw throwHttpError(res);
  }

  static Future<GiftcardCategoryProviderResponse> getGiftcardCategories({
    String? search,
    int page = 1,
    int perPage = 200,
  }) async {
    final url = '/giftcard-categories/buy?page=$page&per_page=$perPage';
    log(url);

    http.Response response = await HttpRequest.get(url).catchError((err) {
      throw OtherErrors(err);
    });

    final res = json.decode(response.body);
    if (response.statusCode < 400) {
      return GiftcardCategoryProviderResponse.fromMap(res);
    } else {
      throw throwHttpError(res);
    }
  }

  static Future<GiftcardProductResponse> getGiftcardProduct(
      {required String categoryId, required String countryId}) async {
    http.Response response = await HttpRequest.get(
            "/giftcards/buy?filter[category_id]=$categoryId&filter[country_id]=$countryId&include=category")
        .catchError((err, s) {
      log("Error during HTTP request: $err", name: "HTTP_REQUEST_ERROR");
      log("StackTrace: $s", name: "STACK_TRACE");

      throw OtherErrors(err);
    });

    final res = json.decode(response.body);
    if (response.statusCode < 400) {
      return GiftcardProductResponse.fromMap(res);
      // return (res['data'] as List)
      //     .map((e) {

      //       return GiftcardCategoryProviderResponse.fromMap(e);
      //     })
      //     .toList();
    } else {
      throw throwHttpError(res);
    }
  }

  static Future<User> verifyInAppTransferBeneficiaryDetails(
      String beneficiary) async {
    http.Response response = await HttpRequest.post(
            "/wallet/beneficiaries", {"beneficiary": beneficiary})
        .catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) return User.fromMap(res["data"]);

    throw throwHttpError(res);
  }

  static Future<ServiceTxn> inAppTransfer({
    required String beneficiary,
    required String amount,
    required String pin,
  }) async {
    http.Response response = await HttpRequest.post("/wallet/transfer", {
      "beneficiary": beneficiary,
      "amount": amount,
      "pin": pin
    }).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    print(response.statusCode);
    print("res $res");

    if (response.statusCode < 400) return ServiceTxn.fromMap(res['data']);

    throw throwHttpError(res);
  }

  static Future<BreakdownInfo> getBreakdown(Map<String, dynamic> body) async {
    String url = "/giftcards/breakdown";

    // Convert all values in body to strings to avoid type cast errors
    Map<String, String> stringBody =
        body.map((key, value) => MapEntry(key, value.toString()));

    http.Response res =
        await HttpRequest.post(url, stringBody).catchError((err) {
      throw OtherErrors(err);
    });

    Map decodedRes = json.decode(res.body);

    if (res.statusCode == 200) {
      return BreakdownInfo.fromJson(decodedRes['data']);
    } else {
      throw decodedRes["message"];
    }
  }

  static Future<CardData> createCard({
    required CreateCardRequest request,
  }) async {
    try {
      Map<String, dynamic> jsonMap = request.toJson();

      // Convert all values in jsonMap to strings, including nested maps
      Map<String, dynamic> stringBody = {};
      jsonMap.forEach((key, value) {
        if (value is Map) {
          // Convert nested map to JSON string
          stringBody[key] = value;
        } else {
          stringBody[key] = value.toString();
        }
      });

      http.Response response =
          await HttpRequest.post("/virtual-cards/create", request.toJson());

      Map res = json.decode(response.body);
      log(response.statusCode.toString());
      log(res.toString(), name: "Response");

      if (response.statusCode == 200) {
        return CardData.fromJson(res['data']);
      }

      throw throwHttpError(res);
    } catch (e, stackTrace) {
      debugPrint("Error occurred in createCard: $e");
      debugPrint("Stack trace:\n$stackTrace");

      throw OtherErrors(e.toString());
    }
  }

  static Future<CardData> fundCard({
    required FundCardRequest request,
    required String id,
  }) async {
    try {
      Map<String, dynamic> jsonMap = request.toJson();

      // Convert all values in jsonMap to strings, including nested maps
      Map<String, dynamic> stringBody = {};
      jsonMap.forEach((key, value) {
        if (value is Map) {
          // Convert nested map to JSON string
          stringBody[key] = value;
        } else {
          stringBody[key] = value.toString();
        }
      });

      http.Response response =
          await HttpRequest.post("/virtual-cards/$id/fund", request.toJson());

      Map res = json.decode(response.body);
      log(response.statusCode.toString());
      log(res.toString(), name: "Response");

      if (response.statusCode == 200) {
        return CardData.fromJson(res['data']);
      }

      throw throwHttpError(res);
    } catch (e, stackTrace) {
      debugPrint("Error occurred in createCard: $e");
      debugPrint("Stack trace:\n$stackTrace");

      throw OtherErrors(e.toString());
    }
  }

  static Future<CardData> toggleCardStatus({
    required String id,
    required String method,
    required String pin,
  }) async {
    try {
      Map<String, dynamic> jsonMap = {
        "_method": method,
        "pin": pin,
      };

      // Convert all values in jsonMap to strings, including nested maps
      Map<String, dynamic> stringBody = {};
      jsonMap.forEach((key, value) {
        if (value is Map) {
          // Convert nested map to JSON string
          stringBody[key] = value;
        } else {
          stringBody[key] = value.toString();
        }
      });

      http.Response response =
          await HttpRequest.post("/virtual-cards/$id/status", stringBody);

      Map res = json.decode(response.body);
      log(response.statusCode.toString());
      log(res.toString(), name: "Response");

      if (response.statusCode == 200) {
        return CardData.fromJson(res['data']);
      }

      throw throwHttpError(res);
    } catch (e, stackTrace) {
      debugPrint("Error occurred in createCard: $e");
      debugPrint("Stack trace:\n$stackTrace");

      throw OtherErrors(e.toString());
    }
  }

  static Future<CardData> withdrawFromCard({
    required FundCardRequest request,
    required String id,
  }) async {
    try {
      Map<String, dynamic> jsonMap = request.toJson();

      // Convert all values in jsonMap to strings, including nested maps
      Map<String, dynamic> stringBody = {};
      jsonMap.forEach((key, value) {
        if (value is Map) {
          // Convert nested map to JSON string
          stringBody[key] = value;
        } else {
          stringBody[key] = value.toString();
        }
      });

      http.Response response = await HttpRequest.post(
          "/virtual-cards/$id/withdraw", request.toJson());

      Map res = json.decode(response.body);
      log(response.statusCode.toString());
      log(res.toString(), name: "Response");

      if (response.statusCode == 200) {
        return CardData.fromJson(res['data']);
      }

      throw throwHttpError(res);
    } catch (e, stackTrace) {
      debugPrint("Error occurred in createCard: $e");
      debugPrint("Stack trace:\n$stackTrace");

      throw OtherErrors(e.toString());
    }
  }

  static Future<List<CardData>> getUsersCards() async {
    http.Response response =
        await HttpRequest.get("/virtual-cards").catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    log(res.toString(), name: "Card API response");

    if (response.statusCode < 400) {
      List<CardData> result = [];
      for (final Map<String, dynamic> el in (res['data'] as List)) {
        result.add(CardData.fromJson(el));
      }

      return result;
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  static Future<List<CardTransaction>> getUsersCardTransactions(
      {required String id}) async {
    http.Response response =
        await HttpRequest.get("/virtual-cards/$id/transactions")
            .catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode < 400) {
      List<CardTransaction> result = [];
      for (final Map<String, dynamic> el in (res['data'] as List)) {
        result.add(CardTransaction.fromJson(el));
      }

      return result;
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  static Future<String> generateCardToken({
    required String cardId,
  }) async {
    http.Response response =
        await HttpRequest.get("/virtual-cards/$cardId/token").catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode < 400) {
      return res['data']['token'];
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }
}
