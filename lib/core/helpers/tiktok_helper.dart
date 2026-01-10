import 'package:flutter/foundation.dart';
import 'package:tiktok_events_sdk/tiktok_events_sdk.dart';

class TiktokHelper {
  void initializeSdk() async {
    final iosOptions = TikTokIosOptions(
      disableTracking: false, // true would disable ALL tracking
      disableAutomaticTracking: false,
      disableSKAdNetworkSupport: false,
    );

// Android options example
    final androidOptions = TikTokAndroidOptions(
      disableAutoStart: false,
      enableAutoIapTrack: false, // enable IAP tracking
      disableAdvertiserIDCollection: false,
    );
    try {
      await TikTokEventsSdk.initSdk(
        androidAppId: 'com.dataappng',
        tikTokAndroidId: '7565958292443283463',
        iosAppId: '6741076658',
        tiktokIosId: '7565920773567758354',
        isDebugMode: false,
        logLevel: kDebugMode ? TikTokLogLevel.debug : TikTokLogLevel.info,
        androidOptions: androidOptions,
        iosOptions: iosOptions,
      );
      

      print('.....successfully initialised sdk');
    } catch (e) {
      print('.....failed to initialize tiktok sdk ${e.toString()}');
    }
  }

  void logIdentification() async {
    await TikTokEventsSdk.identify(
      identifier: TikTokIdentifier(
        externalId: '12345',
        externalUserName: 'john_doe',
        phoneNumber: '+1234567890',
        email: 'john.doe@example.com',
      ),
    );
  }

  void logEvent(String eventName, Map<String, dynamic> eventProperties) async {
    try {
      await TikTokEventsSdk.logEvent(
        event: TikTokEvent(eventName: eventName, properties: EventProperties(
          customProperties: eventProperties
        )),
      );
      print('...event logged successful event name $eventName');
    } catch (e) {
      print('...failed to log event ${e.toString()}');
    }
  }
}
