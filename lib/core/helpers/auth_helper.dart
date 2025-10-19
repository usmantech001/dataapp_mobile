import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
// import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../app/app.dart';
// import '../../presentation/authentication/setup_txn_pin/setup_txn_pin_view.dart';
// import '../../presentation/authentication/verify_email/verify_email_view.dart';
import '../../presentation/misc/route_manager/routes_manager.dart';
import '../../presentation/screens/auth/verify_email.dart/misc/verify_email_arg.dart';
import '../constants.dart';
import '../enum.dart';
// import '../model/core/user.dart';
import '../model/core/user.dart';
import '../providers/user_provider.dart';
import '../services/http_request.dart';
import '../services/secure_storage.dart';
import '../utils/errors.dart';
import '../utils/utils.dart';

class AuthHelper {
  static Future<Map<String, dynamic>> signUp(
      {required String firstname,
      required String lastname,
      required String email,
      required String password,
      required String phone,
      String? referrerCode}) async {
    //

    Map<String, dynamic> _body = {
      "firstname": firstname,
      "lastname": lastname,
      "email": email,
      "password": password,
      "phone": phone,
    };

    if ((referrerCode ?? "").trim().isNotEmpty) {
      _body["ref_code"] = referrerCode;
    }

    http.Response response = await HttpRequest.post("/auth/register", _body,
            enableDefaultHeaders: false)
        .catchError((err) {
      throw OtherErrors(err);
    });

     log(response.body.toString(), name: "SIGNUP");

    Map res = json.decode(response.body);

    log(res.toString(), name: "SIGNUP1");

    if (response.statusCode < 400) {
      return {
        "user": User.fromMap(res['data']['user']),
        "token": res['data']['token'],
      };
    } else {
      throw throwHttpError(res);
    }
  }

  static Future<String> resendOtp({required String token}) async {
    http.Response response = await HttpRequest.post("/auth/email/resend", {},
        enableDefaultHeaders: false,
        addHeaders: {
          "Authorization": "Bearer $token",
          "Accept": "application/json"
        }).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = {};
    try {
      res = json.decode(response.body);
    } catch (_) {}

    if (response.statusCode == 200) return throwHttpError(res);

    throw throwHttpError(res);
  }

  //
  static Future<String> verifyEmail(
      {required String code, required String token}) async {
    http.Response response = await HttpRequest.post(
      "/auth/email/verify",
      {"token": code},
      enableDefaultHeaders: false,
      addHeaders: {
        "Authorization": "Bearer $token",
        "Accept": "application/json"
      },
    ).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = {};
    try {
      res = json.decode(response.body);
    } catch (_) {}

    if (response.statusCode < 400) return throwHttpError(res);

    throw throwHttpError(res);
  }

  static SecureStorage? _prefs;
  static Future<void> _saveLoginCred({
    required LoginProvider loginProvider,
    required Map<String, dynamic> user,
    required String? user_token,
    required String? password,
    required String? email,
    required String token,
    required String? biometric_token,
  }) async {
    _prefs ??= await SecureStorage.getInstance();
    await _prefs!.setString(
      Constants.kCachedAuthKey,
      json.encode(
        {
          "loginProvider": enumToString(loginProvider),
          "user_token": user_token,
          "password": password,
          "token": token,
          "user": user,
          "email": email,
          "biometric_token": biometric_token
        },
      ),
    );
  }

  static Future<String?> getCacheBiometricToken() async {
    _prefs ??= await SecureStorage.getInstance();
    String? dt = _prefs!.getString(Constants.kCachedAuthKey);
    var authCred = json.decode(dt!);

    return authCred['biometric_token'];
  }

  static Future<void> updateBiometricToken(String biometricToken) async {
    _prefs ??= await SecureStorage.getInstance();
    String? dt = _prefs!.getString(Constants.kCachedAuthKey);
    var authCred = json.decode(dt!);
    authCred['biometric_token'] = biometricToken;
    await _prefs!.setString(Constants.kCachedAuthKey, json.encode(authCred));
  }

  static Future<User> signIn(LoginProvider loginProvider,
      {String? email, String? password, String? user_token}) async {
    try {
      String url = "/auth/login/${enumToString(loginProvider)}";

      // BODY
      Map<String, dynamic> body = {};
      if (user_token != null) body["user_token"] = user_token;
      if (email != null) body["email"] = email;
      if (password != null) body["password"] = password;

      http.Response response = await HttpRequest.post(url, body,
          enableDefaultHeaders: false,
          addHeaders: {"Accept": "application/json"}).catchError((err) {
        throw OtherErrors(err);
      });

      Map res = json.decode(response.body);

      if (response.statusCode < 400) {
        if (res["data"]["user"]["two_factor_enabled"] == false) {
          await _saveLoginCred(
            loginProvider: loginProvider,
            user_token: user_token,
            password: password,
            email: email,
            user: res["data"]["user"],
            token: res["data"]["token"],
            biometric_token: res["data"]["biometric_token"],
          );
        }

        return User.fromMap(res['data']['user']);
      }
      throw throwHttpError(res);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> routeAuthenticated(BuildContext context,
      {required User user, String? password}) async {
    String? token = await SecureStorage.getInstance().then((pref) {
      var authCred = pref.getString(Constants.kCachedAuthKey);
      return json.decode(authCred ?? "")['token'];
    }).catchError((_) {});

    // VERIFY EMAIL
    if (user.email_verified == false) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(
        context,
        RoutesManager.verifyEmail,
        arguments: VerifyEmailArg(
          emailVerificationType: EmailVerificationType.login,
          user: user,
          token: token ?? "",
        ),
      );

      return;
    }

    // // SET TXN PIN
    if (user.pin_activated == false) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, RoutesManager.setTransactionPin);
      return;
    }

    // // FOR 2FA VERIFICATION
    if (user.two_factor_enabled) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(
        context,
        RoutesManager.verifyEmail,
        arguments: VerifyEmailArg(
          emailVerificationType: EmailVerificationType.twoFA,
          user: user,
          token: token ?? "",
          password: password,
        ),
      );
      return;
    }

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    userProvider.updateUser(user);
    Navigator.pushNamedAndRemoveUntil(context, RoutesManager.dashboardWrapper,
        (Route<dynamic> route) => false);
  }

  static Future<User> setPin(String pin) async {
    http.Response response =
        await HttpRequest.post("/auth/pin/set", {"pin": pin}).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = {};
    try {
      res = json.decode(response.body);
    } catch (_) {}

    if (response.statusCode == 200) {
      return User.fromMap(res["data"]["user"]);
    } else {
      throw throwHttpError(res);
    }
  }

  static Future<void> logout(BuildContext context,
      {bool deactivateTokenAndRestart = false}) async {
    await (await SecureStorage.getInstance()).clearMemory();
    await HttpRequest.clearMemory();
    // ignore: use_build_context_synchronously
    Provider.of<UserProvider>(context, listen: false).updateUser(null);
    if (deactivateTokenAndRestart) {
      HttpRequest.post("/user/logout", {}).catchError((err) {
        throw OtherErrors(err);
      });
      // ignore: use_build_context_synchronously
      MyApp.restartApp(context);
    }
  }

  static Future<String> resendPasswordResetOtp({required String email}) async {
    http.Response response = await HttpRequest.post(
            "/auth/password/resend", {"email": email},
            enableDefaultHeaders: false)
        .catchError((err) {
      throw OtherErrors(err);
    });

    Map res = {};
    try {
      res = json.decode(response.body);
    } catch (_) {}

    if (response.statusCode == 200) return throwHttpError(res);

    throw throwHttpError(res);
  }

  static Future<String> verifyPasswordResetOtp(
      {required String email, required String token}) async {
    http.Response response = await HttpRequest.post(
            "/auth/password/verify", {"email": email, "token": token},
            enableDefaultHeaders: false)
        .catchError((err) {
      throw OtherErrors(err);
    });

    Map res = {};

    try {
      res = json.decode(response.body);
    } catch (_) {}

    if (response.statusCode == 200) return throwHttpError(res);

    throw throwHttpError(res);
  }

  static Future<String> completePasswordReset(
      {required String email,
      required String otp,
      required String password}) async {
    http.Response response = await HttpRequest.post("/auth/password/reset",
            {"email": email, "token": otp, "password": password},
            enableDefaultHeaders: false)
        .catchError((err) {
      throw OtherErrors(err);
    });

    Map res = {};
    try {
      res = json.decode(response.body);
    } catch (_) {}

    if (response.statusCode == 200) return throwHttpError(res);

    throw throwHttpError(res);
  }

  static Future<String> updateTransactionPin(
      {required String old_pin, required String new_pin}) async {
    Map<String, dynamic> body = {"pin": new_pin, "old_pin": old_pin};

    http.Response response =
        await HttpRequest.post("/auth/pin/update", body).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = {};
    try {
      res = json.decode(response.body);
    } catch (_) {}

    if (response.statusCode == 200) return throwHttpError(res);

    throw throwHttpError(res);
  }

  static Future<User> toggleBiometric(String type) async {
    http.Response response =
        await HttpRequest.post("/auth/biometric/$type", {}).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = {};
    try {
      log(response.body);
      res = json.decode(response.body);
    } catch (_) {}

    if (response.statusCode == 200) {
      if (res["data"]['biometric_token'] != null){
        log(res["data"]['biometric_token']);
      await updateBiometricToken(res["data"]['biometric_token']);
      }
      return User.fromMap(res["data"]['user']);
    } else {
      throw throwHttpError(res);
    }
  }

  static updateSavedUserDetails(User user) async {
    try {
      _prefs ??= await SecureStorage.getInstance();

      var encoded = _prefs!.getString("authCred");
      var decodedDt = json.decode(encoded!);

      decodedDt["user"] = user.toMap();
      _prefs!.setString("authCred", json.encode(decodedDt));
    } catch (_) {
      print("Error $_");
    }
  }

  static Future<String> resend2FAOtp({required String email}) async {
    http.Response response =
        await HttpRequest.post("/auth/2fa/resend", {"email": email})
            .catchError((err) {
      throw OtherErrors(err);
    });

    Map res = {};
    try {
      res = json.decode(response.body);
    } catch (_) {}

    if (response.statusCode == 200) return throwHttpError(res);
    throw throwHttpError(res);
  }

  static Future<User> completeTwoFa(
      {required String code,
      required String email,
      required String password}) async {
    http.Response response = await HttpRequest.post(
        "/auth/2fa/verify", {"email": email, "token": code}).catchError((err) {
      throw OtherErrors(err);
    });

    Map res = {};
    try {
      res = json.decode(response.body);
    } catch (_) {}

    if (response.statusCode == 200) {
      await _saveLoginCred(
        loginProvider: LoginProvider.password,
        user_token: null,
        password: password,
        email: email,
        user: res["data"]["user"],
        token: res["data"]["token"],
        biometric_token: res["data"]["biometric_token"],
      );

      return User.fromMap(res["data"]["user"]);
    } else {
      throw throwHttpError(res);
    }
  }
}
