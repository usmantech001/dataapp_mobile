import 'dart:convert';
import 'dart:io';

// import 'package:fabspay/presentation/authentication/login/login_view.dart';
import 'package:dataplug/core/constants.dart';
import 'package:dataplug/core/utils/nav.dart';
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

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
   final scale = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).chain(CurveTween(curve: Curves.easeInOut));
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    controller.forward();
    
    Future.delayed(const Duration(milliseconds: 1800), () {
      checkAuth();
    });
    super.initState();
  }

  Future<void> checkAuth() async {


    var authCred = await SecureStorage.getInstance()
        .then((pref) => pref.getString(Constants.kCachedAuthKey))
        .catchError((_) => null);

    if (authCred != null) {
      // print('...the auth cred is $authCred');
      User user = User.fromMap(json.decode(authCred)['user']);
      //  Navigator.push(context,
      //      MaterialPageRoute(builder: (context) => LeaderboardScreen()));
       popAndPushScreen( RoutesManager.signIn, arguments: user);
      // Navigator.pushNamed(context, RoutesManager.successful);
      return;
    }
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => BottomNavScreen()));
     popAndPushScreen(RoutesManager.signIn);
    //Navigator.pushNamed(context, RoutesManager.dashboardWrapper);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 0),
      color: ColorManager.kPrimary,
      child: Center(
        child: ScaleTransition(
          scale: scale.animate(controller),
          child: Image.asset(
            Assets.images.dataplugIcon.path,
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
