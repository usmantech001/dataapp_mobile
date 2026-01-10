import 'dart:convert';

// import 'package:fabspay/core/utils/utils.dart';

import '../constants.dart';
import '../model/core/bank.dart';
// import '../model/core/banner.dart';
// import '../model/core/country.dart';
// import '../model/core/faq.dart';
// import '../model/core/state.dart';
// import '../model/core/system_bank.dart';
// import '../model/core/virtual_account_provider.dart';
import '../model/core/banner.dart';
import '../model/core/country.dart';
import '../model/core/discount.dart';
import '../model/core/faq.dart';
import '../model/core/referral_term.dart';
import '../model/core/service_charge.dart';
import '../model/core/service_status.dart';
import '../model/core/state.dart';
import '../model/core/system_bank.dart';
import '../services/http_request.dart';
import 'package:http/http.dart' as http;

import '../utils/errors.dart';
import '../utils/utils.dart';

class GenericHelper {
  static Future<void> toastDelay() async {
    await Future.delayed(Constants.kDefaultToatDelay);
  }

  static Future<List<Bank>> getBankList({String? filterName}) async {
    String url = "/banks";
    // if (filterName != null) url = "/banks?filter[name]=$filterName";

    http.Response response = await HttpRequest.get(url).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      print('...bank response is ${res}');
      return (res['data'] as List).map((e) => Bank.fromMap(e)).toList();
    } else {
      throw throwHttpError(res);
    }
  }

  static Future<List<SystemBank>> getSystemBankList() async {
    String url = "/system-banks";
    http.Response response = await HttpRequest.get(url).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      return (res['data'] as List).map((e) => SystemBank.fromMap(e)).toList();
    }

    throw throwHttpError(res);
  }

  static Future<dynamic> getSupportInfo() async {
    http.Response response =
        await HttpRequest.get("/support").catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) return res['data'];
    throw throwHttpError(res);
  }

    static Future<ServiceCharge> serviceCharge() async {
    http.Response res = await HttpRequest.get("/service-charges").catchError((err) {
      throw OtherErrors(err);
    });

    print("Service Fee Response :: ${res.body}");

    Map decodedRes = json.decode(res.body);

    if (res.statusCode == 200) {
      return ServiceCharge.fromJson(decodedRes['data']);
    } else {
      throw decodedRes["message"];
    }
  }

  static Future<List<Faq>> getFaqs() async {
    http.Response response =
        await HttpRequest.get("/faq-categories?include=faqs").catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      print('...faq response is ${res}');
      return (res['data'] as List).map((e) => Faq.fromMap(e)).toList();
    }
    throw throwHttpError(res);
  }

  // static Future<bool> deleteCloudinaryUpload(String url) async {
  //   http.Response response =
  //       await HttpRequest.delete("/uploads/$url").catchError((err) {
  //     throw OtherErrors(err);
  //   });

  //   print(response.request?.url);

  //   print(response.statusCode);

  //   if (response.statusCode < 400) return true;
  //   return false;
  // }


    static Future<ServiceStatus> serviceStatus() async {
    http.Response res = await HttpRequest.get("/service-status-check").catchError((err) {
      throw OtherErrors(err);
    });

    Map decodedRes = json.decode(res.body);

    if (res.statusCode == 200) {
      return ServiceStatus.fromJson(decodedRes['data']);
    } else {
      throw decodedRes["message"];
    }
  }

  static Future<List<Country>> getCountries({String? filterName}) async {
    http.Response res =
        await HttpRequest.get("/countries?do_not_paginate=1").catchError((err) {
      throw OtherErrors(err);
    });

    Map decodedRes = json.decode(res.body);

    if (res.statusCode == 200) {
      List dt = decodedRes['data'];
      return dt.map((e) => Country.fromMap(e)).toList();
    } else {
      throw decodedRes["message"];
    }
  }

  static Future<Discount> getDiscount(
      String type, String? provider, dynamic amount,
      [String? code = ""]) async {
    print("$type ::: $provider ::: ");
    String url = "/discount?type=$type&amount=$amount";
    if (provider != null) url = "${url}&provider=$provider";
    if (code != null) url = "${url}&code=$code";
    http.Response res = await HttpRequest.get(url).catchError((err) {
      throw OtherErrors(err);
    });

    Map decodedRes = json.decode(res.body);

    if (res.statusCode == 200) {
      return Discount.fromJson(decodedRes['data']);
    } else {
      throw decodedRes["message"];
    }
  }

  static Future<List<AppState>> getState(String country_id) async {
    http.Response res = await HttpRequest.get(
            "/states?do_not_paginate=1&country_id=$country_id")
        .catchError((err) {
      throw OtherErrors(err);
    });
    Map decodedRes = json.decode(res.body);

    if (res.statusCode == 200) {
      List dt = decodedRes['data'];
      return dt.map((e) => AppState.fromMap(e)).toList();
    } else {
      throw decodedRes["message"];
    }
  }

  // static Future<List<Banners>> getBanners() async {
  //   http.Response res = await HttpRequest.get("/banners").catchError((err) {
  //     throw OtherErrors(err);
  //   });

  //   Map decodedRes = json.decode(res.body);

  //   if (res.statusCode == 200) {
  //     return (decodedRes['data'] as List)
  //         .map((e) => Banners.fromMap(e))
  //         .toList();
  //   } else {
  //     throw decodedRes["message"];
  //   }
  // }

  static Future<List<Banners>> getBanners() async {
    http.Response res = await HttpRequest.get("/banners").catchError((err) {
      throw OtherErrors(err);
    });

    Map decodedRes = json.decode(res.body);

    if (res.statusCode == 200) {
      return (decodedRes['data'] as List)
          .map((e) => Banners.fromMap(e))
          .toList();
    } else {
      throw decodedRes["message"];
    }
  }

  // static Future<String> getReferralTerm() async {
  //   http.Response res =
  //       await HttpRequest.get("/referral-terms?page=1&per_page=10")
  //           .catchError((err) {
  //     throw OtherErrors(err);
  //   });

  //   try {
  //     Map decodedRes = json.decode(res.body);

  //     if (res.statusCode == 200) return decodedRes["data"][0];
  //     throw decodedRes["message"];
  //   } catch (_) {
  //     rethrow;
  //   }
  // }

  static Future<ReferralTerm?> getReferralTerm() async {
  // Sending the GET request to the API
  http.Response res = await HttpRequest.get("/referral-terms?page=1&per_page=10")
      .catchError((err) {
    throw OtherErrors(err); // Handle the error if the request fails
  });

  try {
    // Decode the JSON response
    Map<String, dynamic> decodedRes = json.decode(res.body);

    // Check if the response status is OK (200)
    if (res.statusCode == 200) {
      // Return the ReferralTerm object created from the API response
      return ReferralTerm.fromJson(decodedRes['data'][0]);
    }

    // If the status code is not 200, throw the error message from the response
    throw decodedRes["message"];
  } catch (e) {
    // If any error occurs (decoding, bad response structure, etc.), rethrow the error
    rethrow;
  }
}

}
