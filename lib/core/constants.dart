// ignore_for_file: constant_identifier_names

import 'package:dataplug/core/utils/utils.dart';
import 'package:flutter/material.dart';

class Constants {
  static const String kBaseurl = 
  // kReleaseMode
       //?
       'https://api.dataapp.ng';
      // :

      // 'https://staging-api.dataapp.ng';

  static const String kBiometricDateStorageKey = "last_biometric_date_shown";
  static const String kBalanceVisibilityKey = "lalanceVisibility";
  static const String kBiometricLoginKey = "login";
  static const String kBiometricTransactionKey = "transaction";
  static const String kCachedAuthKey = "authCred";
   static const String kGlobalLoginKey = "globalLogin";
   static const String kAlreadyUsedAppKey = "AlreadyUsedApp";

  static const String serverError = "A server error occured, please try again.";
  static const kConnectionError =
      "Connection could not be established. Please check internet connection";

  static const kServiceUnavailable =
      "Service currently unavailable. Please try again later";
  static const kReferralTerm =
      """Lorem ipsum dolor sit amet consectetur. Est consectetur cras tempus eu pulvinar tellus mauris ultricies. Tortor sed nullam proin morbi. Volutpat dui ultricies pellentesque faucibus ut. Vitae in nisl vitae neque. Purus eleifend dolor et turpis tristique.

In imperdiet pharetra sapien adipiscing libero sapien. Suscipit malesuada turpis sem diam id commodo sapien mauris ultricies. Tellus adipiscing adipiscing aliquet vulputate sit viverra turpis non. Aliquet ac sagittis nulla arcu fermentum tincidunt. Proin eu nisi enim scelerisque est purus. Urna fames nec ullamcorper phasellus consequat facilisi aliquam urna. Id inte+

 """;
  static const kCLOUDINARY_CLOUD_NAME = "soft-web-digital";
  static const kCLOUDINARY_UPLOAD_PRESET = "n4d_preset";
  static const IMAGEKIT_PUBLIC_KEY = "public_M9/MR8TmDOfaVrZ3//xFSVc3onM=";
  static const IMAGEKIT_URL_ENDPOINT = "https://ik.imagekit.io/r2s9tkueu";
  static const IMAGEKIT_SIGNATURE =
      "https://api.billpadi.com/imagekit-signature";

  static const kUSDCurrencyCode = "USD";

  static const Duration kDefaultToatDelay = Duration(milliseconds: 1000);

  // static double get650ModalHeight(BuildContext context) =>
  //     isSmallScreen(context) ? 450 : 650;

  static const double kSmallScreenHeight = 700;
  static const double kHorizontalScreenPadding = 15;
  static double get650ModalHeight(BuildContext context) =>
      isSmallScreen(context) ? 450 : 650;
}
  

class Responsive {
  static double w(BuildContext context, double value) {
    // value is a design width reference (e.g., from Figma on 390px base)
    final screenWidth = MediaQuery.of(context).size.width;
    return (value / 390.0) * screenWidth;
  }

  static double h(BuildContext context, double value) {
    final screenHeight = MediaQuery.of(context).size.height;
    return (value / 844.0) * screenHeight; // assuming 844 design height (iPhone 12)
  }
}