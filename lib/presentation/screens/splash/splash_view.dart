import 'dart:convert';
import 'package:dataplug/core/constants.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:flutter/material.dart';

import '../../../core/model/core/user.dart';
import '../../../core/services/secure_storage.dart';
import '../../../gen/assets.gen.dart';
import '../../misc/color_manager/color_manager.dart';
import '../../misc/route_manager/routes_manager.dart';

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
    // pushNamed(RoutesManager.setTransactionPin);
    });
    super.initState();
  }

  Future<void> checkAuth() async {
    var authCred = await SecureStorage.getInstance()
        .then((pref) => pref.getString(Constants.kCachedAuthKey))
        .catchError((_) => null);
         var alreadyUsedApp = await SecureStorage.getInstance()
        .then((pref) => pref.getBool(Constants.kAlreadyUsedAppKey))
        .catchError((_) => null);

       
   if(alreadyUsedApp!=null){
    if (authCred != null) {
      User user = User.fromMap(json.decode(authCred)['user']);
       removeAllAndPushScreen( RoutesManager.signIn, arguments: user);
      return;
    }
     removeAllAndPushScreen(RoutesManager.signIn);
   }else{
    removeAllAndPushScreen(RoutesManager.onboarding);
   }
    
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
