import 'package:dataplug/core/helpers/tiktok_helper.dart';
import 'package:dataplug/dep/locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'app/app.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // initialize firebase from firebase core plugin
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {}

   TiktokHelper().initializeSdk();
   setUpLocator();
  // TiktokHelper().logIdentification();
  // TiktokHelper().logEvent('Registration', {
  //   'name' : 'usman',
  //   'email' : 'akanjiusman67@gmail.com',
  // });
  runApp(
    DevicePreview(
      enabled: false,
      //enabled: !kReleaseMode, // enable only in debug / profile
      builder: (context) =>  MyApp(),
    ),
  );
}
