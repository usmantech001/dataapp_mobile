import 'dart:io';

import 'package:dataplug/core/helpers/user_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  String? fcmToken;
  

  initializeLocalNotification() async {
    var androidInitialization =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitialization = const DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true);
    var initializationSettings = InitializationSettings(
      android: androidInitialization,
      iOS: iosInitialization,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    ).then((isInitialized){
      print('notification initialized $isInitialized');
    });
    //   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );
  }

 Future<void> requestPermission() async {
    if (Platform.isAndroid) {
      print('...its android');
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission().then((enabled){
            print('...notification enabled for android $enabled');
          });
    } else if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ).then((result){
            print(result);
          });
    }
  }

  Future<String?> getToken() async {
    print('...getting token');
    try {
      fcmToken = await FirebaseMessaging.instance.getToken();
      print('...token $fcmToken');
      return fcmToken;
    } catch (e) {
      print('failed to get token $e');
      //showCustomErrorToast('failed to get token $e');
      return null;
    }
  }

  Future<void> setFcmToken() async {
    String? deviceToken = await getToken();
    if(deviceToken!=null){
       UserHelper.updateFcmToken(deviceToken).catchError((_) {});
    }
  }


  void showNotification(RemoteMessage? message) async {
    String title = message?.notification?.title ?? "Notification Testing";
    String body = message?.notification?.body ?? "This is a test for push notification on ios";
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
      playSound: true,
      priority: Priority.high,
      showWhen: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: const DarwinNotificationDetails(
           presentAlert: true,
            presentBadge: true,
            presentSound: true,
          
        ));
    await flutterLocalNotificationsPlugin.show(
      message?.notification?.hashCode ?? 0,
      title,
      body,
      notificationDetails,
    );
  }
}