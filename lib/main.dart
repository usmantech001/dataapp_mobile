import 'package:dataplug/core/helpers/facebook_event_helper.dart';
import 'package:dataplug/core/helpers/tiktok_helper.dart';
import 'package:dataplug/core/services/PushNotificationService/push_notification_service.dart';
import 'package:dataplug/dep/locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'app/app.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  PushNotificationService notificationService = PushNotificationService();
  notificationService.initializeLocalNotification();
  notificationService.showNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // initialize firebase from firebase core plugin
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {}

   TiktokHelper().initializeSdk();
   setUpLocator();
   PushNotificationService notificationService = PushNotificationService();
   notificationService.initializeLocalNotification();
  notificationService.requestPermission();
 notificationService.getToken();
 
 FirebaseMessaging.onMessage.listen((RemoteMessage message){
  print('.....firebase message ${message.notification?.title}');
  notificationService.showNotification(message);
 });

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
