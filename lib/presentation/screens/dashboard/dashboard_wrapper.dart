// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';

// import 'package:dataplug/core/providers/card_provider.dart';
// import 'package:dataplug/core/providers/generic_provider.dart';
// import 'package:dataplug/core/utils/utils.dart';
// import 'package:dataplug/presentation/misc/custom_components/loading.dart';
// import 'package:dataplug/presentation/misc/image_manager/image_manager.dart';
// import 'package:dataplug/presentation/misc/notification_bell.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:gap/gap.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../../../core/enum.dart';
// import '../../../core/helpers/user_helper.dart';
// import '../../../core/providers/user_provider.dart';
// import '../../../core/widgets/session_timeout_wrapper.dart';
// import '../../../gen/assets.gen.dart';
// import '../../misc/color_manager/color_manager.dart';
// import '../../misc/custom_components/custom_elements.dart';
// import '../../misc/custom_components/custom_scaffold.dart';
// import '../../misc/custom_snackbar.dart';
// import '../../misc/style_manager/styles_manager.dart';

// class DashboardWrapper extends StatefulWidget {
//   const DashboardWrapper({super.key});

//   @override
//   _DashboardWrapperState createState() => _DashboardWrapperState();
// }

// class _DashboardWrapperState extends State<DashboardWrapper> {
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       loadBasicInfo();
//       setFcmToken();
//       await _setupMessageHandlers();
//     });
//     super.initState();
//   }

//   bool fetchingBasicInfo = true;
//   Future<void> loadBasicInfo() async {
//     UserProvider userProvider =
//         Provider.of<UserProvider>(context, listen: false);
//     CardProvider cardProvider =
//         Provider.of<CardProvider>(context, listen: false);
//     await userProvider.updateUserInfo();
//     await cardProvider.getUsersCards();

//     fetchingBasicInfo = false;
//     setState(() {});
//     userProvider.updateAddedBanks().catchError((_) {});
//     userProvider.updateReferralsInfo().catchError((_) {});
//   }

//   Future<void> setFcmToken() async {
//     String deviceToken = await getDeviceToken();
//     debugPrint("###### PRINT DEVICE TOKEN TO USE FOR PUSH NOTIFCIATION ######");
//     debugPrint(deviceToken);
//     debugPrint("############################################################");

//     // listen for user to click on notification
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
//       print("adsakjdak ${remoteMessage.collapseKey}");
//     });

//     UserHelper.updateFcmToken(deviceToken).catchError((_) {});
//   }

//   final _messaging = FirebaseMessaging.instance;
//   final _localNotifications = FlutterLocalNotificationsPlugin();
//   bool _isFlutterLocalNotificationsInitialized = false;

//   Future getDeviceToken() async {
//     try {
//       FirebaseMessaging messaging = FirebaseMessaging.instance;

//       await messaging.requestPermission(
//         alert: true,
//         announcement: false,
//         badge: true,
//         carPlay: false,
//         criticalAlert: false,
//         provisional: false,
//         sound: true,
//       );

//       String? deviceToken = await messaging.getToken();
//       log(deviceToken.toString(), name: "FCM TOKEN");
//       return (deviceToken == null) ? "" : deviceToken;
//     } catch (e) {
//       print("Error $e");
//     }
//   }


//   Future<void> setupFlutterNotifications() async {
//     if (_isFlutterLocalNotificationsInitialized) {
//       return;
//     }

//     // android setup
//     const channel = AndroidNotificationChannel(
//       'high_importance_channel',
//       'High Importance Notifications',
//       enableLights: true,
//       description: 'This channel is used for important notifications.',
//       importance: Importance.high,
//     );

//     await _localNotifications
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);

//     const initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     // ios setup
//     final initializationSettingsDarwin = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestSoundPermission: true,

//       // onDidReceiveLocalNotification: (id, title, body, payload) async {
//       //   // Handle iOS foreground notification
//       // },
//     );

//     final initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsDarwin,
//     );

//     // flutter notification setup
//     await _localNotifications.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (details) {},
//     );

//     _isFlutterLocalNotificationsInitialized = true;

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//       log('Message received: ${message.messageId}');
//       log('Notification: ${notification?.title}\n${notification?.body}');
//       log('Channel ID: ${channel.id}');
//       log('Channel Name: ${channel.name}');
//       log(
//         'Channel Description: ${channel.description}',
//       );

//       if (notification != null && android != null) {
//         showNotification(message);
//       }
//     });
//   }

//   Future<void> showNotification(RemoteMessage message) async {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;
//     if (notification != null && android != null) {
//       await _localNotifications.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             'high_importance_channel',
//             'High Importance Notifications',
//             channelDescription:
//                 'This channel is used for important notifications.',
//             importance: Importance.high,
//             priority: Priority.high,
//             icon: '@mipmap/ic_launcher',
//           ),
//           iOS: const DarwinNotificationDetails(
//             presentAlert: true,
//             presentBadge: true,
//             presentSound: true,
//           ),
//         ),
//         payload: message.data.toString(),
//       );
//     }
//   }

//   Future<void> _setupMessageHandlers() async {
//     //foreground message
//     FirebaseMessaging.onMessage.listen((message) {
//       showNotification(message);
//     });

//     // background message
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

//     // opened app
//     final initialMessage = await _messaging.getInitialMessage();
//     if (initialMessage != null) {
//       _handleBackgroundMessage(initialMessage);
//     }
//   }

//   void _handleBackgroundMessage(RemoteMessage message) {
//     log(message.data.toString());
//     if (message.data['type'] == 'chat') {
//       // open chat screen
//     }
//   }


//   // Replace with the WhatsApp number you want to open
//   final String phoneNumber = "+2348038341444";
//   final String message = "Hello!";

//   Future<void> _openWhatsApp() async {
//     final Uri whatsappUrl = Uri.parse(
//       "https://wa.me/${phoneNumber.replaceAll('+', '')}?text=${Uri.encodeComponent(message)}",
//     );

//     if (await canLaunchUrl(whatsappUrl)) {
//       await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
//     } else {
//       throw "Could not launch WhatsApp.";
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     UserProvider userProvider = Provider.of<UserProvider>(context);
//     GenericProvider genericProvider = Provider.of<GenericProvider>(context);

//     return SessionTimeoutWrapper(
//         child: CustomScaffold(
//       backgroundColor: ColorManager.kWhite,

//       body: SafeArea(
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 Container(
//                   color: ColorManager.kWhite,
//                   padding: const EdgeInsets.only(top: 10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       genericProvider.currentPage == DashboardTabs.home
//                           ? Row(
//                               children: [
//                                 const SizedBox(width: 11),
//                                 Assets.images.dataplugLogoText
//                                     .image(width: 118, height: 22),
//                                 const Spacer(),
//                                 const CustomNotificationBell()
//                               ],
//                             )
//                           : Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 10.0),
//                               child: Row(
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       SizedBox(
//                                         height: 28,
//                                         width: 28,
//                                         child: loadNetworkImage(
//                                           userProvider.user.avatar ?? "",
//                                           errorDefaultImage:
//                                               ImageManager.kProfilePlaceholderIcon,
//                                           height: 28,
//                                           width: 28,
//                                           fit: BoxFit.cover,
//                                           borderRadius:
//                                               BorderRadius.circular(30),
//                                         ),
//                                       ),
//                                       Gap(16),
//                                       // Text(
//                                       //   "Hi, ${userProvider.user.firstname}",
//                                       //   style: get14TextStyle().copyWith(
//                                       //     color: ColorManager.kBlack,
//                                       //     fontWeight: FontWeight.w500,
//                                       //   ),
//                                       // ),
//                                     ],
//                                   ),
//                                   const Spacer(),
//                                   const CustomNotificationBell()
//                                 ],
//                               ),
//                             ),
//                       Gap(16)

//                       //  HomeTab()
//                       //
//                       // DashboardTabsItems.renderCurrentHeader(context,
//                       //     tabs: genericProvider.currentPage),
//                     ],
//                   ),
//                 ),
//                 // Expanded(
//                 //   child: AnimatedContainer(
//                 //     color: Colors.white,
//                 //     duration: const Duration(milliseconds: 850),
//                 //     child: fetchingBasicInfo
//                 //         ? buildLoading(
//                 //             wrapWithExpanded: false,
//                 //             padding: const EdgeInsets.all(16))
//                 //         : DashboardTabsItems.renderCurrentPage(
//                 //             genericProvider.currentPage),
//                 //   ),
//                 // ),
//               ],
//             ),
//             Positioned(
//               right: 20,
//               bottom: 80,
//               child: GestureDetector(
//                 onTap: () => _openWhatsApp(),
//                 child: Container(
//                   width: 55,
//                   height: 55,
//                   alignment: Alignment.center,
//                   // padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                       border: Border.all(color: Colors.white),
//                       color: ColorManager.kPrimary,
//                       shape: BoxShape.circle),
//                   // child: Assets.images.tablerHangerActive.image(),
//                   child: Assets.icons.customerService.svg(
//                       // Icons.add_rounded,
//                       // color: Colors.white,
//                       // size: 40,
//                       ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomSheet: Container(
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           // color: DashboardTabsItems.getBottomBarColor(
//           //   genericProvider.currentPage,
//           // ),
//           border: Border(
//             top: BorderSide(
//                 width: 1, color: ColorManager.kBarColor.withOpacity(.2)),
//           ),
//         ),
//         padding: EdgeInsets.only(
//             left: 15,
//             right: 15,
//             bottom:
//                 (Platform.isIOS && MediaQuery.of(context).size.height <= 740)
//                     ? 3
//                     : 13,
//             top: 0),
//        // height: DashboardTabsItems.getBottomSheetHieght(context),
//         margin: const EdgeInsets.only(bottom: 6, top: 0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           crossAxisAlignment: CrossAxisAlignment.center,
          
//         ),
//       ),
//     ));
//   }

//   Future<void> checkNotification() async {
//     Provider.of<UserProvider>(context, listen: false)
//         .checkUnreadNotification()
//         .catchError((_) {});
//   }
// }
