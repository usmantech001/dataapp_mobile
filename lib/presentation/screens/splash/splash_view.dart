import 'dart:convert';
import 'dart:io';

// import 'package:fabspay/presentation/authentication/login/login_view.dart';
import 'package:dataplug/core/constants.dart';
import 'package:dataplug/presentation/screens/dashboard/bottom_nav_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/history/history_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/home/home_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/leaderboard/leaderboard_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/referrals/referral/referrals_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/services/giftcard/buy_giftcard_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/services/internet_data/buy_data_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/services/services_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/settings/bank/virtual_accounts_screen.dart';
import 'package:dataplug/presentation/screens/kyc/generate_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/model/core/user.dart';
import '../../../core/providers/generic_provider.dart';
import '../../../core/services/secure_storage.dart';
// import '../../core/model/core/user.dart';
// import '../../core/providers/user_provider.dart';
// import '../../core/services/secure_storage.dart';
import '../../../gen/assets.gen.dart';
import '../../misc/color_manager/color_manager.dart';
import '../../misc/image_manager/image_manager.dart';
import '../../misc/route_manager/routes_manager.dart';
// import '../../misc/image_manager/image_manager.dart';
// import '../authentication/login/login_wrapper.dart';
// import '../misc/color_manager/color_manager.dart';
// import '../misc/custom_components/custom_bottom_sheet.dart';
// import '../misc/image_manager/image_manager.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    context.read<GenericProvider>().getServiceCharge();
    context.read<GenericProvider>().getServiceStatus();
    Future.delayed(const Duration(milliseconds: 1800), () {
      checkAuth();
    });
    super.initState();
  }

  Future<void> checkAuth() async {
    // var platform = "";
    // if (Platform.isAndroid) {
    //   platform = "ANDVU";
    // } else if (Platform.isIOS) {
    //   platform = "IOSVU";
    // }

    // String? updateVersion =
    //     await GenericHelper.getCurrentAppVersion(platform: platform)
    //         .catchError((_) => null);

    // if (updateVersion != null) {
    //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
    //   if (!isLatestVersion(packageInfo.version, updateVersion)) {
    //     await Navigator.pushNamed(context, RoutesManager.appUpdateView);
    //   }
    // }
    //  var _pref = await SecureStorage.getInstance();
    // await _pref.remove(Constants.kCachedAuthKey);

    var authCred = await SecureStorage.getInstance()
        .then((pref) => pref.getString(Constants.kCachedAuthKey))
        .catchError((_) => null);

    if (authCred != null) {
      // print('...the auth cred is $authCred');
      User user = User.fromMap(json.decode(authCred)['user']);
      //  Navigator.push(context,
      //      MaterialPageRoute(builder: (context) => LeaderboardScreen()));
      Navigator.pushNamed(context, RoutesManager.signIn, arguments: user);
      // Navigator.pushNamed(context, RoutesManager.successful);
      return;
    }
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => BottomNavScreen()));
     Navigator.pushNamed(context, RoutesManager.signIn);
    //Navigator.pushNamed(context, RoutesManager.dashboardWrapper);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 0),
      color: ColorManager.kPrimary,
      child: Center(
        child: Image.asset(
          Assets.images.dataplugIcon.path,
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
