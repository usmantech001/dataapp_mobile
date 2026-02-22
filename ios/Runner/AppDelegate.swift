// import UIKit
// import Flutter
// import Firebase

// @main
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     FirebaseApp.configure()
//     if #available(iOS 10.0, *) {
//       UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
//      }
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }


import UIKit
import Flutter
import Firebase
import AppTrackingTransparency
import AdSupport

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    
    GeneratedPluginRegistrant.register(with: self)
    
    // Request App Tracking Transparency permission
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      self.requestTrackingPermission()
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  func requestTrackingPermission() {
    if #available(iOS 14, *) {
      ATTrackingManager.requestTrackingAuthorization { status in
        switch status {
        case .authorized:
          // Tracking authorized - Facebook and TikTok SDKs will automatically use this
          print("✅ Tracking authorized")
        case .denied:
          print("❌ Tracking denied")
        case .restricted:
          print("⚠️ Tracking restricted")
        case .notDetermined:
          print("❓ Tracking not determined")
        @unknown default:
          break
        }
      }
    }
  }
}