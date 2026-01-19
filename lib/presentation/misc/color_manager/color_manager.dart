import 'package:flutter/material.dart';
import '../../../core/enum.dart';

class ColorManager {
  // Main
  // static Color kPrimary = HexColor.fromHex("#B700AA");
  static Color kPrimary = HexColor.fromHex("#11CEC7");

  // static Color kPrimaryFade = HexColor.fromHex("#7C59A4").withOpacity(.5);
  static Color kPrimaryLight = HexColor.fromHex("#F4F4F4");

  static Color kError = HexColor.fromHex("#FB6464");
  static Color kErrorEB = HexColor.fromHex("#EB5757");
  static Color kSuccess = HexColor.fromHex("#10BD40");
  static Color kSuccessAlt = HexColor.fromHex("#DCFFE4");
  static Color kBarColor = HexColor.fromHex("#C8CED7");
  static Color kBar2Color = HexColor.fromHex("#EEEEEE");
  static Color kSlideBgColor = HexColor.fromHex("#F7F7F7");
  static Color k267E9B = HexColor.fromHex("#267E9B");
  static Color kD9E9EE = HexColor.fromHex("#D9E9EE");
  static Color kD1D3D9 = HexColor.fromHex("#D1D3D9");
    static Color kTab = HexColor.fromHex("#11CEC7");
  static Color kNotificationUnread =
      HexColor.fromHex("#F0FBFF").withOpacity(.67);

  // GENERIC
  static Color kWhite = HexColor.fromHex("#FFFFFF");
  static Color kBlack = HexColor.fromHex("#000000");
  static Color kDeepGreen = HexColor.fromHex("#0DA1A5");

  // TEXT
  static Color kTextDark = HexColor.fromHex("##313146");
  static Color kTextDark7 = ColorManager.kTextDark.withOpacity(.7);
  static Color kSmallText = HexColor.fromHex("#6C7D98");
  static Color kTextColor = HexColor.fromHex("#1C1C1C");
  static Color kFadedTextColor = HexColor.fromHex("#333333");
  

  // FORM
  static Color kFormBg = HexColor.fromHex("#FAFAFA");
  static Color kFormInactiveBorder = HexColor.fromHex("#F2F2F2");
  static Color kFormHintText = HexColor.fromHex("#AFAFAF");
  static Color kGreyColor = HexColor.fromHex("#01100F");

  //OTHERS
  static const kGreyF5 = Color(0xFFF5F5F5);
  static const kGreyE5 = Color(0xFFE5F4F4);
  static const kGreyE8 = Color(0xFFE8E8EB);
  static const kGreyF8 = Color(0xFFF8F9FA);
  static const kGreyE2 = Color(0xFFE2E8F0);
  static const kGreyEB = Color(0xFFEBECEC);
  static Color kDividerColor = HexColor.fromHex("#C8CED7").withOpacity(.49);
  static const Color kYellow = Color(0xFFFEE685);
  static const Color kLightYellow = Color(0xFFFEF3C6);
  static const Color kYellowLight = Color(0xFFFEF3C6);
  static const Color kGreen = Color(0xFF0AAB62);
  static const Color kDeepgreen = Color(0xFF007A55);
  static const Color kLightGreen = Color(0xFFEFFDF8);
  static const Color kLightGreenD0 = Color(0xFFD0FAE5);
  static const Color kDeepOrange = Color(0xFFBB4D00);
  

  // NOTIFICATION
  static Color kNotificationSuccess = HexColor.fromHex("#25D366");
  static Color kNotificationSuccessBg = HexColor.fromHex("#E3FEE5");

  static Color kNotificationError = HexColor.fromHex("#F16E6E");
  static Color kNotificationErrorBg = HexColor.fromHex("#FFF3F3");
  static Color kNotificationErrorBorder = HexColor.fromHex("#FFCECE");

  static Color getStatusTextColor(Status status) {
    switch (status) {
      case Status.successful:
        return kSuccess;
      case Status.pending:
        return Colors.orangeAccent.shade200;
      case Status.failed:
        return kError;
      case Status.reversed:
        return kTextDark7;

      default:
        return kTextDark;
    }
  }

    static Color getGiftcardAndCryptoStatusTextColor(GiftcardAndCryptoTxnStatus status) {
    switch (status) {
      case GiftcardAndCryptoTxnStatus.approved:
        return kSuccess;
      case GiftcardAndCryptoTxnStatus.pending || GiftcardAndCryptoTxnStatus.partially_approved:
        return Colors.orangeAccent.shade200;
      case GiftcardAndCryptoTxnStatus.declined:
        return kError;
      case GiftcardAndCryptoTxnStatus.transferred:
        return kTextDark7;
      default:
        return kTextDark;
    }
  }
}




extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF$hexColorString"; // 8 char with opacity 100%
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
