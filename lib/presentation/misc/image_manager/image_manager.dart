import 'package:flutter/material.dart';

import '../../../core/enum.dart';
import '../color_manager/color_manager.dart';

const String IMAGE_PATH = "assets/images";

class ImageManager {
  static const String kAPPTIVESplashImage =
      "$IMAGE_PATH/kAPPTIVESplashImage.png";
  static const String kGoogleIcon = "$IMAGE_PATH/kGoogleIcon.png";
  static const String kAppleIcon = "$IMAGE_PATH/kAppleIcon.png";
  static const String kArrowLeft = "$IMAGE_PATH/kArrowLeft.png";

  static const String kAppUpdateIcon = "$IMAGE_PATH/kAppUpdateIcon.png";

  static const String kProfileIcon = "$IMAGE_PATH/kProfileIcon.png";
  static const String kProfilePlaceholderIcon = "$IMAGE_PATH/profile-icon.png";
  static const String kSecurityIcon = "$IMAGE_PATH/kSecurityIcon.png";
  static const String kSupportIcon = "$IMAGE_PATH/kSupportIcon.png";

  static const String kBankIcon = "$IMAGE_PATH/kBankIcon.png";
  static const String kFAQsIcon = "$IMAGE_PATH/kFAQsIcon.png";
  static const String kLogOutIcon = "$IMAGE_PATH/kLogOutIcon.png";
  static const String kTransferIcon = "$IMAGE_PATH/kTransferIcon.png";

  static const String kTxnPinIcon = "$IMAGE_PATH/kTxnPinIcon.png";
  static const String kChangePassword = "$IMAGE_PATH/kChangePassword.png";
  static const String kFaceID = "$IMAGE_PATH/kFaceID.png";
  static const String kActivateLogin2FA = "$IMAGE_PATH/kActivateLogin2FA.png";
  static const String kTxnReceiptIcon = "$IMAGE_PATH/kTxnReceiptIcon.png";

  static const String kCallUs = "$IMAGE_PATH/kCallUs.png";
  static const String kSendUsMail = "$IMAGE_PATH/kSendUsMail.png";
  static const String kChatWithUsOnWhatsapp =
      "$IMAGE_PATH/kChatWithUsOnWhatsapp.png";

  // TODO: update this.
  static const String kNetworkImageFallBack =
      "$IMAGE_PATH/kNetworkImageFallBack.png";
  //
  static const String kHomeTab = "$IMAGE_PATH/kHomeTab.png";
  static const String kServiceTab = "$IMAGE_PATH/kServiceTab.png";
  static const String kWalletTab = "$IMAGE_PATH/WalletTab.png";
  static const String kHistoryTab = "$IMAGE_PATH/kHistoryTab.png";
  static const String kCardTab = "$IMAGE_PATH/kCardTab.png";
  static const String kReferralTab = "$IMAGE_PATH/kReferralTab.png";
  static const String kSettingsTab = "$IMAGE_PATH/kSettingsTab.png";
  // static const String kProfileFallBack = "$IMAGE_PATH/kProfileFallBack.png";
  static const String kProfileFallBack = kProfilePlaceholderIcon;

  static const String kEmptyState = "$IMAGE_PATH/kEmptyState.png";
  static const String kDeleteIcon = "$IMAGE_PATH/kDeleteIcon.png";

  static const String kGiftIcon = "$IMAGE_PATH/kGiftIcon.png";
  static const String kGiftCardIcon = "$IMAGE_PATH/kGiftcardIcon.png";
  static const String kBuyAirtime = "$IMAGE_PATH/kBuyAirtime.png";
  static const String kBuyAirtime2 = "$IMAGE_PATH/kBuyAirtime2.png";
  static const String kElectricityIcon = "$IMAGE_PATH/kElectricityIcon.png";
  static const String kElectricityIcon2 = "$IMAGE_PATH/kElectricityIcon2.png";
  static const String kBuyData = "$IMAGE_PATH/kBuyData.png";
  static const String kBuyData2 = "$IMAGE_PATH/kBuyData2.png";
  static const String kCableTvIcon = "$IMAGE_PATH/kCableTvIcon.png";
  static const String kBettingIcon = "$IMAGE_PATH/kBettingIcon.png";

  static const String kPinIcon = "$IMAGE_PATH/kPinIcon.png";
  static const String kExclamationIcon = "$IMAGE_PATH/kExclamationIcon.png";

  static const String kMtnLogo = "$IMAGE_PATH/kMtnLogo.png";
  static const String kInterTwainIcon = "$IMAGE_PATH/kInterTwainIcon.png";
  static const String kFaceIcon = "$IMAGE_PATH/kFaceIcon.png";
  static const String kBigSuccessIcon = "$IMAGE_PATH/kBigSuccessIcon.png";

  static String getServiceImage(ServicePurpose purpose) {
    switch (purpose) {
      case ServicePurpose.airtime:
      case ServicePurpose.internationalAirtime:
        return kBuyAirtime2;
      case ServicePurpose.electricity:
        return kElectricityIcon2;
      case ServicePurpose.data:
      case ServicePurpose.internationalData:
        return kBuyData2;
      case ServicePurpose.tvSubscription:
        return kCableTvIcon;
      case ServicePurpose.education:
        return kElectricityIcon2;
      case ServicePurpose.betting:
        return kBettingIcon;
      default:
        return kServiceTab;
    }
  }

  static Widget getWalletIcon(ServicePurpose purpose,
      {required CashFlowType cashFlowType}) {
    switch (purpose) {
      case ServicePurpose.deposit:
        return Icon(Icons.add_circle, size: 25, color: ColorManager.kPrimary);
      case ServicePurpose.virtualCard:
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(ImageManager.kCardTab,
              width: 25, color: ColorManager.kPrimary),
        );
      case ServicePurpose.withdrawal:
        return Icon(Icons.remove_circle,
            size: 25, color: ColorManager.kPrimary);
      case ServicePurpose.transfer:
        return Center(
          child: cashFlowType == CashFlowType.credit
              ? Icon(Icons.add_circle, size: 25, color: ColorManager.kPrimary)
              : Image.asset(ImageManager.kTransferIcon,
                  width: 25, color: ColorManager.kPrimary),
        );
      default:
        return const SizedBox();
    }
  }
}
