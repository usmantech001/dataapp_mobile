import 'dart:async';
import 'dart:convert';
import 'package:dataplug/core/constants.dart';
import 'package:dataplug/core/model/core/user.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:flutter/material.dart';
import '../services/secure_storage.dart';
import 'auth_helper.dart';

class SessionTimeoutHelper {
  static Timer? _inactivityTimer;
  static const Duration _timeoutDuration = Duration(minutes: 5);

  static void startInactivityTimer(BuildContext context) {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(_timeoutDuration, () {
      _handleTimeout(context);
    });
  }

  static void resetInactivityTimer(BuildContext context) {
    _inactivityTimer?.cancel();
    startInactivityTimer(context);
  }

  static void _handleTimeout(BuildContext context) async {
    var authCred = await SecureStorage.getInstance()
        .then((pref) => pref.getString(Constants.kCachedAuthKey))
        .catchError((_) => null);
    if (authCred != null) {
      User user = User.fromMap(json.decode(authCred)['user']);
      Navigator.pushNamed(context, RoutesManager.signIn, arguments: user);
    } else {
      // Logout user and redirect to sign-in
      AuthHelper.logout(context).then((_) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesManager.signIn,
          (Route<dynamic> route) => false,
        );
      });
    }
  }

  static void dispose() {
    _inactivityTimer?.cancel();
  }
}
