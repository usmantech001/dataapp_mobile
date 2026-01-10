import 'dart:io';

import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';

import '../core/providers/index.dart';
import '../presentation/misc/route_manager/routes_manager.dart';


// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  static void restartApp(BuildContext context) {
    try {
      // context.findAncestorStateOfType<_MyAppState>()?.restartApp();
    } catch (e) {
      // manualReportCrash(error: e);
    }
  }

  MyApp._internal(); // private named constructor
  int appState = 0;
  static final MyApp instance =
      MyApp._internal(); // single instance -- singleton

  factory MyApp() => instance; // factory for the class instance

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key _key = UniqueKey();
  // void restartApp() {
  //   if (mounted) setState(() => _key = UniqueKey());
  // }

  @override
  void initState() {
    if (Platform.isAndroid && !kDebugMode) {
      InAppUpdate.checkForUpdate().then((value) {
        if (value.updateAvailability != UpdateAvailability.updateAvailable) {
          return;
        }
        InAppUpdate.performImmediateUpdate();
      }).catchError((_) {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, /* DeviceOrientation.portraitDown */
    ]);

    return MultiProvider(
      key: _key,
      providers: ProviderIndex.multiProviders(),
      child: InAppNotification(
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          ensureScreenSize: true,
          minTextAdapt: true,
          useInheritedMediaQuery: true,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: RouteGenerator.getRoute,
            initialRoute: RoutesManager.splash,
            navigatorKey: navigatorKey,
            theme: ThemeData(
              scaffoldBackgroundColor: ColorManager.kGreyF5,
              primaryColor: ColorManager.kPrimary,
               splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
              appBarTheme: const AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarIconBrightness: Brightness.dark,
                  statusBarBrightness: Brightness.light,
                ),
              ),
            ),
            locale: const Locale('en', 'NG'),
            supportedLocales: const [
              Locale('en', 'NG'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            // home: const SplashView(),
          ),
        ),
      ),
    );
  }
}
