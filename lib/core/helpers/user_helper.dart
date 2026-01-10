import 'dart:convert';

import 'package:dataplug/core/enum.dart';

import '../model/core/app_notification.dart';
import '../model/core/referral.dart';
import '../model/core/user.dart';
import 'package:http/http.dart' as http;

import '../model/core/user_bank.dart';
import '../services/http_request.dart';
import '../utils/errors.dart';
import '../utils/utils.dart';

class UserHelper {
  static Future<User> getProfileInfo() async {
    http.Response response =
        await HttpRequest.get("/auth/user").catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      User user = User.fromMap(res['data']);
      return user;
    } else {
      throw throwHttpError(res);
    }
  }

  // auth/profile

  static Future<User> updateProfile({
    String? firstname,
    String? lastname,
    String? username,
    String? phone_code,
    String? phone,
    String? country,
    String? state,
    String? avatar,
    String? gender,
  }) async {
    Map<String, dynamic> _body = {};

    if (firstname != null) _body["firstname"] = firstname;
    if (lastname != null) _body["lastname"] = lastname;
    if (username != null) _body["username"] = username;
    if (phone_code != null) _body["phone_code"] = phone_code;
    if (phone != null) _body["phone"] = phone;
    if (country != null) _body["country"] = country;
    if (state != null) _body["state"] = state;
    if (gender != null) _body["gender"] = gender;

    http.Response response =
        await HttpRequest.post("/auth/profile", _body).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = {};
    try {
      res = json.decode(response.body);
    } catch (_) {}

    if (response.statusCode < 400) return User.fromMap(res['data']);
    throw throwHttpError(res);
  }

  static Future<User> updateAvater(String avaterUrl) async {
    http.Response response =
        await HttpRequest.post("/auth/avatar", {"avatar": avaterUrl})
            .catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) return User.fromMap(res["data"]);
    throw throwHttpError(res);
  }

  static Future<String> updatePassword(
      {required String old_password, required String password}) async {
    http.Response response = await HttpRequest.post("/auth/password/update",
        {"old_password": old_password, "password": password}).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) return throwHttpError(res);
    throw throwHttpError(res);
  }

  // static Future<String> send2faToggleCode({required String email}) async {
  //   http.Response response =
  //       await HttpRequest.post("/auth/2fa/resend", {"email": email})
  //           .catchError((err) {
  //     throw OtherErrors(err);
  //   });

  //   Map res = {};
  //   try {
  //     res = json.decode(response.body);
  //   } catch (_) {}

  //   print(response.statusCode);
  //   print(response.body);

  //   if (response.statusCode == 200) return throwHttpError(res);

  //   throw throwHttpError(res);
  // }

  // static Future<User> toggle2Fa(String token) async {
  //   // TODO: uncomment -> update the endpoint when the api is available.
  //   http.Response response =
  //       await HttpRequest.post("/auth/2fa/toggle", {"token": token})
  //           .catchError((err) {
  //     throw OtherErrors(err);
  //   });

  //   Map res = json.decode(response.body);
  //   if (response.statusCode < 400) return User.fromMap(res["data"]);
  //   throw throwHttpError(res);
  // }

  static Future<List<UserBank>> getUsersBank() async {
    http.Response response =
        await HttpRequest.get("/bank-accounts").catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode < 400) {
      List<UserBank> result = [];
      for (final Map<String, dynamic> el in (res['data'] as List)) {
        if (el['deleted_at'] == null) {
          result.add(UserBank.fromMap(el));
        }
      }

      return result;
    } else {
      throw res["message"] ?? " An error occured. please try again.";
    }
  }

  static Future<String> saveBankInfo(
      {required String bank_id,
      required String account_number,
      required String account_name}) async {
    http.Response response = await HttpRequest.post("/bank-accounts", {
      "account_number": account_number,
      "bank_id": bank_id,
      "account_name": account_name,
    }).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);

    if (response.statusCode < 400) {
      return res['message'];
    } else {
      throw throwHttpError(res);
    }
  }

  static Future<String> verifyBankInfo(
      {required String bank_id, required String account_number}) async {
    http.Response response = await HttpRequest.post("/bank-accounts/verify", {
      "account_number": account_number,
      "bank_id": bank_id
    }).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    // print("res $res");
    if (response.statusCode < 400) return res["data"]["account_name"];
    throw throwHttpError(res);
  }

  static Future<String> deleteSavedBank(String bankAccountId) async {
    http.Response response = await HttpRequest.delete(
      "/bank-accounts/$bankAccountId",
    ).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) return throwHttpError(res);
    throw throwHttpError(res);
  }

  static Future<String> deleteAccount() async {
    http.Response response =
        await HttpRequest.post("/auth/deactivate", {}).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) return throwHttpError(res);
    throw throwHttpError(res);
  }

  static Future<User> toggleTwoFAStatus() async {
    http.Response response =
        await HttpRequest.put("/auth/2fa/toggle", {}).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = {};
    try {
      res = json.decode(response.body);
    } catch (_) {}
    if (response.statusCode < 400) return User.fromMap(res["data"]);
    throw throwHttpError(res);
  }

  static Future<ReferralInfo> getReferralInfo() async {
    String url = "/referrals?per_page=1&page=1";

    http.Response response = await HttpRequest.get(url).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      return ReferralInfo.fromJson(res["data"]);
    }

    throw throwHttpError(res);
  }

  static Future<List<Referral>> getReferrals(String per_page,
      {required ReferralStatus status, String? filter}) async {
    String url = "";

    switch (status) {
      case ReferralStatus.all:
        url = "/referrals?per_page=$per_page";
        break;
      case ReferralStatus.active:
        url = "/all-referrals?active=true&per_page=$per_page";
        break;
      case ReferralStatus.inactive:
        url = "/all-referrals?active=false&per_page=$per_page";
        break;
      default:
    }

    //
    if (filter != null) url += filter;

    http.Response response = await HttpRequest.get(url).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    if (response.statusCode < 400) {
      print('.....the referral $res');
      if (status == ReferralStatus.all) {
        return (res["data"]["referrals"] as List)
            .map((e) => Referral.fromMap(e))
            .toList();
      }

      return (res["data"] as List).map((e) => Referral.fromMap(e)).toList();
    }
    throw throwHttpError(res);
  }

  static Future<List<AppNotification>> getNotification(String per_page,
      {String? filter}) async {
    String url = "/notifications?per_page=$per_page";
    if (filter != null) url += filter;

    // print(url);

    http.Response response = await HttpRequest.get(url).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = json.decode(response.body);
    // print("res $res");
    if (response.statusCode < 400) {
      return (res['data'] as List)
          .map((e) => AppNotification.fromMap(e))
          .toList();
    } else {
      throw throwHttpError(res);
    }
  }

  static Future<bool> markNotificationAsRead(String id) async {
    http.Response response =
        await HttpRequest.put("/notifications/$id/read", {}).catchError((err) {
      throw OtherErrors(err);
    });

    if (response.statusCode < 400) return true;
    return true;
  }

  static Future updateFcmToken(String fcm_token) async {
    Map<String, dynamic> _body = {"fcm_token": fcm_token};

    // print("_body $_body");

    http.Response response =
        await HttpRequest.post("/auth/profile", _body).catchError((err) {
      throw OtherErrors(err);
    });

    // print(response.request?.url);

    // print("${response.statusCode}");
  }
}
