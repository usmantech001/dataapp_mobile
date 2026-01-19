import 'package:dataplug/core/enum.dart';
import 'package:dataplug/core/model/core/app_notification.dart';
import 'package:dataplug/core/model/core/card_transactions.dart';
import 'package:dataplug/core/model/core/user.dart';
import 'package:dataplug/core/model/core/user_bank.dart';
import 'package:dataplug/presentation/screens/auth/password_reset/misc/password_reset_3_arg.dart';
import 'package:dataplug/presentation/screens/auth/verify_email.dart/verify_email.dart';
import 'package:dataplug/presentation/screens/dashboard/bottom_nav_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/card/card_details.dart';
import 'package:dataplug/presentation/screens/dashboard/card/card_receipt.dart';
import 'package:dataplug/presentation/screens/dashboard/card/card_transactions.dart';
import 'package:dataplug/presentation/screens/dashboard/card/cards/cards_view.dart';
import 'package:dataplug/presentation/screens/dashboard/card/create_card/arg/card_summary_arg.dart';
import 'package:dataplug/presentation/screens/dashboard/card/create_card/enter_address.dart';
import 'package:dataplug/presentation/screens/dashboard/card/create_card/usd/usd_card.dart';
import 'package:dataplug/presentation/screens/dashboard/card/fund_card/enter_amount_usd.dart';
import 'package:dataplug/presentation/screens/success/auth_successful_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/leaderboard/leaderboard_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/referrals/referral/referrals_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/services/airtime/airtime_review_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/services/betting/betting_1.dart';
import 'package:dataplug/presentation/screens/dashboard/services/betting/betting_provider_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/services/betting/fund_betting_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/services/cable_tv/cable_tv_package_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/services/cable_tv/cable_tv_providers_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/services/cable_tv/cable_tv_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/services/electricity/buy_electricity_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/services/electricity/electricity_providers_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/services/epin/buy_epin_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/services/epin/epin_products_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/services/epin/epin_provider_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/services/giftcard/all_giftcard_txn.dart';
import 'package:dataplug/presentation/screens/dashboard/services/giftcard/buy_giftcard_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/services/giftcard/giftcard_1.dart';
import 'package:dataplug/presentation/screens/dashboard/services/giftcard/giftcard_categories_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/services/giftcard/giftcard_countries_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/services/giftcard/giftcard_main.dart';
import 'package:dataplug/presentation/screens/dashboard/services/giftcard/giftcard_products_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/services/international_airtime/buy_intl_airtime_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/services/international_airtime/intl_airtime_countries_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/services/international_data/buy_intl_data_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/services/international_data/international_data_1.dart';
import 'package:dataplug/presentation/screens/dashboard/services/international_data/intl_data_countries_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/services/internet_data/buy_data_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/services/internet_data/buy_smile_data_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/services/services_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/settings/close_account_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/settings/general_settings_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/wallet/transfer/transfer_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/wallet/withdraw/withdraw_screen.dart';
import 'package:dataplug/presentation/screens/splash/splash_view.dart';
import 'package:dataplug/presentation/screens/success/transaction_successful_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/model/core/card_data.dart';
import '../../../core/model/core/faq.dart';
import '../../../core/model/core/giftcard_txn.dart';
import '../../../core/model/core/service_txn.dart';
import '../../screens/auth/password_reset/password_reset_1.dart';
import '../../screens/auth/password_reset/password_reset_3.dart';
import '../../screens/auth/signin/signin.dart';
import '../../screens/auth/verify_email.dart/misc/verify_email_arg.dart';
import '../../screens/dashboard/card/create_card/ngn/ngn_card.dart';
import '../../screens/dashboard/card/fund_card/enter_amount_ngn.dart';
import '../../screens/dashboard/card/fund_card/withdraw_ngn_card.dart';
import '../../screens/dashboard/card/fund_card/withdraw_usd_card.dart';
import '../../screens/dashboard/card/set_cardpin.dart';
import '../../screens/dashboard/dashboard_wrapper.dart';
import '../../screens/auth/onboarding/onboarding_1.dart';
import '../../screens/dashboard/history/giftcard_history.dart';
import '../../screens/dashboard/history/history_details.dart';
import '../../screens/dashboard/home/complete_registration/complete_registration.dart';
import '../../screens/dashboard/notification/all_notifications.dart';
import '../../screens/dashboard/notification/notification_detail.dart';
import '../../screens/dashboard/referrals/earning/earning_list.dart';
import '../../screens/dashboard/services/airtime/buy_airtime_1.dart';
import '../../screens/dashboard/services/cable_tv/cable_tv_1.dart';
import '../../screens/dashboard/services/cable_tv/cable_tv_2.dart';
import '../../screens/dashboard/services/cable_tv/misc/arg.dart';
import '../../screens/dashboard/services/electricity/buy_electricity_1.dart';
import '../../screens/dashboard/services/epin/buy_epin_1.dart';
import '../../screens/dashboard/services/international_airtime/international_airtime_1.dart';
import '../../screens/dashboard/services/internet_data/buy_data_1.dart';
import '../../screens/dashboard/services/internet_data/buy_data_4.dart';
import '../../screens/dashboard/services/internet_data/buy_data_2.dart';
import '../../screens/dashboard/services/internet_data/misc/buy_data_arg.dart';
import '../../screens/dashboard/settings/bank/add_bank.dart';
import '../../screens/dashboard/settings/bank/added_banks.dart';
import '../../screens/dashboard/settings/faqs/faqs.dart';
import '../../screens/dashboard/settings/faqs/faqs_detail.dart';
import '../../screens/dashboard/settings/profile_settings.dart/profile_settings.dart';
import '../../screens/dashboard/settings/security.dart/change_password/change_password.dart';
import '../../screens/dashboard/settings/security.dart/change_transaction_pin/change_transaction_pin.dart';
import '../../screens/dashboard/settings/security.dart/security.dart';
import '../../screens/dashboard/settings/security.dart/set_transaction_pin/set_transaction_pin.dart';
import '../../screens/dashboard/settings/support/support.dart';
import '../../screens/dashboard/wallet/deposit/bank_transfer/bank_transfer_details.dart';
import '../../screens/dashboard/wallet/deposit/deposit_1.dart';
import '../../screens/dashboard/wallet/deposit/deposit_2.dart';
import '../../screens/dashboard/wallet/deposit/deposit_3.dart';
import '../../screens/dashboard/wallet/deposit/manual/manual_funding_detail.dart';
import '../../screens/dashboard/wallet/deposit/opay_wallet/opay_wallet_details.dart';
import '../../screens/dashboard/wallet/transfer/transfer_1.dart';
import '../../screens/dashboard/wallet/transfer/transfer_2.dart';
import '../../screens/dashboard/wallet/withdraw/withdraw_1.dart';
import '../../screens/dashboard/wallet/withdraw/withdraw_2.dart';
import '../../screens/version_update/version_update.dart';
import '../transaction_status/giftcard_transaction_status.dart';
import '../transaction_status/transaction_status.dart';

class RoutesManager {
  static const String versionUpdate = "/versionUpdate";

  static const String splash = "/splash";
  static const String signIn = "/signIn";
  static const String passwordReset1 = "/passwordReset1";
  static const String passwordReset3 = "/passwordReset3";
  static const String onboarding1 = "/onboarding1";
  static const String verifyEmail = "/verifyEmail";

  static const String dashboardWrapper = "/dashboardWrapper";
  static const String bottomNav = "/bottomNav";

  //static const String home = "/homeTa";

  static const String profileSettings = "/profileSettings";
  static const String security = "/security";
  static const String setTransactionPin = "/setTransactionPin";
  static const String changeTransactionPin = "/changeTransactionPin";
  static const String changePassword = "/changePassword";
  // static const String activate2FA = "/activate2FA";
  static const String support = "/support";
  static const String faqs = "/faqs";
  static const String faqDetails = "/faqDetails";
  static const String addedBanks = "/addedBanks";
  static const String addBank = "/addBank";
  static const String earningList = "/earningList";
  static const String completeRegistration = "/completeRegistration";
  static const String historyDetails = "/historyDetails";
  static const String allNotifications = "/allNotifications";
  static const String notificationDetail = "/notificationDetail";

  static const String buyAirtime1 = "/buyAirtime1";
  static const String transactionStatus = "/transactionStatus";
  static const String buyElectricity1 = "/buyElectricity1";
  static const String buyElectricity = "/buyElectricity";
  static const String electricityProviders = "/electricityProviders";
  static const String cableTvProviders = "/cableTvProviders";
  static const String cableTvPackages = "/cableTvPackages";
  static const String cableTv = "/cableTv";
  static const String buyUnit = "/buyUnit";
  static const String buyEPin1 = "/buyEPin1";
  static const String cableTv1 = "/cableTv1";
  static const String cableTv2 = "/cableTv2";
  static const String betting1 = "/betting1";
  static const String betting2 = "/betting2";
  static const String giftcardMain = "/giftcardMain";
  static const String giftcard1 = "/giftcard1";
  static const String giftcard2 = "/giftcard2";
  static const String allGiftcardTransactions = "/allGiftcardTransactions";
  static const String internationalData1 = "/internationalData1";
  static const String internationalData2 = "/internationalData2";
  static const String internationalAirtime1 = "/internationalAirtime1";
  static const String internationalAirtime2 = "/internationalAirtime2";
  static const String buyData1 = "/buyData1";
  static const String buyData2 = "/buyData2";
  static const String buyData4 = "/buyData4å";
  static const String transfer1 = "/transfer1";
  static const String transfer2 = "/transfer2";

  static const String withdraw1 = "/withdraw1";
  static const String withdraw2 = "/withdraw2";

  static const String deposit1 = "/deposit1";
  static const String deposit2 = "/deposit2";
  static const String deposit3 = "/deposit3";
  static const String manualDepositDetail = "/manualDepositDetail";
  static const String bankTransferDetails = "/bankTransferDetails";
  static const String opayWalletDetails = "/opayWalletDetails";

  //cards
  static const String createDollarCard = "/createDollarCard";
  static const String createNairaCard = "/createNairaCard";
  static const String enterCardAddressRoute = "/enterCardAddressRoute";
  static const String cardsRoute = "/cardsRoute";
  static const String cardTransactions = "/cardTransactions";
  static const String cardDetails = "/cardDetails";
  static const String cardHistoryDetails = "/cardHistoryDetails";

  static const String setCardpin = "/setCardpin";

  static const String fundNairaCard = "/fundNairaCard";
  static const String fundDollarCard = "/fundDollarCard";
  static const String withdrawNairaCard = "/withdrawNairaCard";
  static const String withdrawDollarCard = "/withdrawDollarCard";
  static const String blockCard = "/blockCard";

  static const String giftcardTransactionStatus = "/giftcardTransactionStatus";

  static const String giftcardCategory = "/giftcardCategory";
  static const String giftcardCountries = "/giftcardCountries";
  static const String giftcardProducts = "/giftcardProducts";
  static const String buyGiftCard = "/buyGiftCard";
  static const String bettingProviders = "/bettingProviders";
  static const String fundBetting = "/fundBetting";
  static const String intlAirtimeCountries = "/intlAirtimeCountries";
  static const String buyIntlAirtime = "/buyIntlAirtime";

  static const String giftcardHistoryDetailsView =
      "/giftcardHistoryDetailsView";
  static const String reviewDetails = "/reviewDetails";

  static const String transfer = "/transfer";
  static const String successful = "/successful";
  static const String authSuccessful = "/authSuccessful";
  static const String buyData = "/buyData";
  static const String services = "/services";
  static const String intlDataCountries = "/intlDataCountries";
  static const String buyIntlData = "/buyIntlData";
  static const String leaderboard = "/leaderboard";
  static const String referrals = "/referrals";
  static const String generalSettings = "/generalSettings";
  static const String closeAccount = "/closeAccount";
  static const String withdraw = "/withdraw";
  static const String epinProviders = "/epinProviders";
  static const String epinProducts = "/epinProducts";
  static const String purchaseEPin = "/purchaseEPin";
  static const String buyOtherData = "/buyOtherData";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesManager.splash:
        return MaterialPageRoute(builder: (_) => const SplashView(), settings: settings);
      case RoutesManager.versionUpdate:
        return MaterialPageRoute(builder: (_) => const VersionUpdate(), settings: settings);

      case RoutesManager.passwordReset1:
        return MaterialPageRoute(builder: (_) => const PasswordReset1(), settings: settings);

      case RoutesManager.passwordReset3:
        return MaterialPageRoute(
            builder: (_) =>
                PasswordReset3(param: settings.arguments as PasswordReset3Arg), settings: settings);

      case RoutesManager.signIn:
        return MaterialPageRoute(
            builder: (_) => SignIn(user: settings.arguments as User?), settings: settings);
      case RoutesManager.onboarding1:
        return MaterialPageRoute(builder: (_) => const Onboarding1(), settings: settings);
      case RoutesManager.verifyEmail:
        return MaterialPageRoute(
          builder: (_) =>
              VerifyEmail(param: settings.arguments as VerifyEmailArg),
        );

      case RoutesManager.dashboardWrapper:
        return MaterialPageRoute(builder: (_) => const DashboardWrapper(), settings: settings);

      case RoutesManager.profileSettings:
        return MaterialPageRoute(builder: (_) => const ProfileSettings(), settings: settings);
      case RoutesManager.security:
        return MaterialPageRoute(builder: (_) => const Security(), settings: settings);
      case RoutesManager.setTransactionPin:
        return MaterialPageRoute(builder: (_) => const SetTransactionPin(), settings: settings);
      case RoutesManager.changeTransactionPin:
        return MaterialPageRoute(builder: (_) => const ChangeTransactionPin(), settings: settings);
      case RoutesManager.changePassword:
        return MaterialPageRoute(builder: (_) => const ChangePassword(), settings: settings);
      // case RoutesManager.activate2FA:
      //   return MaterialPageRoute(builder: (_) => const Activate2FA());
      case RoutesManager.support:
        return MaterialPageRoute(builder: (_) => const Support(), settings: settings);
      case RoutesManager.faqs:
        return MaterialPageRoute(builder: (_) => const Faqs(), settings: settings);
      case RoutesManager.faqDetails:
        return MaterialPageRoute(
            builder: (_) => FaqDetails(param: settings.arguments as FaqData), settings: settings);
      case RoutesManager.addedBanks:
        return MaterialPageRoute(builder: (_) => const AddedBanks());
      case RoutesManager.addBank:
        return MaterialPageRoute(builder: (_) => const AddBank());

      //
      case RoutesManager.earningList:
        return MaterialPageRoute(
          builder: (_) =>
              EarningList(param: settings.arguments as ReferralStatus),
        );
      case RoutesManager.completeRegistration:
        return MaterialPageRoute(builder: (_) => const CompleteRegistration());

      case RoutesManager.historyDetails:
        return MaterialPageRoute(
            builder: (_) =>
                HistoryDetails(param: settings.arguments as ServiceTxn));
      case RoutesManager.allNotifications:
        return MaterialPageRoute(builder: (_) => const AllNotifications());
      case RoutesManager.notificationDetail:
        return MaterialPageRoute(
            builder: (_) => NotificationDetail(
                param: settings.arguments as AppNotification));

      //
      case RoutesManager.giftcardTransactionStatus:
        return MaterialPageRoute(
            builder: (_) => GiftcardTransactionStatus(
                param: settings.arguments as GiftcardTxn));
      case RoutesManager.buyAirtime1:
        return MaterialPageRoute(builder: (_) => const BuyAirtime1());
      case RoutesManager.buyElectricity1:
        return MaterialPageRoute(builder: (_) => const BuyElectricity1());
      case RoutesManager.buyEPin1:
        return MaterialPageRoute(builder: (_) => const BuyEPin1());
      case RoutesManager.cableTv1:
        return MaterialPageRoute(builder: (_) => const CableTv1());
      case RoutesManager.cableTv2:
        return MaterialPageRoute(
            builder: (_) => CableTv2(param: settings.arguments as CableTvArg));
      case RoutesManager.betting1:
        return MaterialPageRoute(builder: (_) => const Betting1());
      case RoutesManager.bettingProviders:
        return MaterialPageRoute(
            builder: (_) => const BettingProvidersScreen(), settings: settings);
      case RoutesManager.fundBetting:
        return MaterialPageRoute(
            builder: (_) => const FundBettingScreen(), settings: settings);
      case RoutesManager.giftcardMain:
        return MaterialPageRoute(
            builder: (_) => GiftCardMain(
                  activeTab: settings.arguments as int,
                ));
      case RoutesManager.giftcard1:
        return MaterialPageRoute(builder: (_) => const Giftcard1());
      case RoutesManager.giftcardCategory:
        return MaterialPageRoute(
            builder: (_) => const GiftcardCategoriesScreen(),
            settings: settings);
      case RoutesManager.giftcardCountries:
        return MaterialPageRoute(
            builder: (_) => const GiftcardCountriesScreen(),
            settings: settings);
      case RoutesManager.giftcardProducts:
        return MaterialPageRoute(
            builder: (_) => const GiftcardProductsScreen(), settings: settings);
      case RoutesManager.buyGiftCard:
        return MaterialPageRoute(
            builder: (_) => const BuyGiftcardScreen(), settings: settings);
      case RoutesManager.allGiftcardTransactions:
        return MaterialPageRoute(
            builder: (_) => const AllGiftCardTransactions());
      case RoutesManager.internationalData1:
        return MaterialPageRoute(builder: (_) => const InternationalData1());
      case RoutesManager.internationalAirtime1:
        return MaterialPageRoute(builder: (_) => const InternationalAirtime1());
      case RoutesManager.transactionStatus:
        return MaterialPageRoute(
            builder: (_) =>
                TransactionStatus(param: settings.arguments as ServiceTxn));
      case RoutesManager.buyData1:
        return MaterialPageRoute(
            builder: (_) =>
                BuyData1(param: settings.arguments as DataPurchaseType));

      case RoutesManager.buyData2:
        return MaterialPageRoute(
          builder: (_) => BuyData2(param: settings.arguments as BuyDataArg),
        );

      case RoutesManager.buyData4:
        return MaterialPageRoute(
          builder: (_) => BuyData4(),
        );
      case RoutesManager.transfer1:
        return MaterialPageRoute(builder: (_) => const Transfer1());
      case RoutesManager.transfer2:
        return MaterialPageRoute(
            builder: (_) => Transfer2(param: settings.arguments as User));

      case RoutesManager.withdraw1:
        return MaterialPageRoute(builder: (_) => const Withdraw1());
      case RoutesManager.withdraw2:
        return MaterialPageRoute(
            builder: (_) => Withdraw2(param: settings.arguments as UserBank));

      case RoutesManager.deposit1:
        return MaterialPageRoute(builder: (_) => const Deposit1());
      case RoutesManager.deposit2:
        return MaterialPageRoute(
            builder: (_) => Deposit2(param: settings.arguments as Deposit2Arg));
      case RoutesManager.deposit3:
        return MaterialPageRoute(
            builder: (_) => Deposit3(param: settings.arguments as Deposit3Arg));
      case RoutesManager.manualDepositDetail:
        return MaterialPageRoute(
            builder: (_) =>
                ManualDepositDetail(param: settings.arguments as num));
      case RoutesManager.bankTransferDetails:
        return MaterialPageRoute(
          builder: (_) => BankTransferDetails(
              param: settings.arguments as BankTransferDetailsArg),
        );
      case RoutesManager.opayWalletDetails:
        return MaterialPageRoute(
            builder: (_) => OpayWalletDetails(
                param: settings.arguments as OpayWalletDetailsArg));

      case RoutesManager.giftcardHistoryDetailsView:
        return MaterialPageRoute(
          builder: (_) =>
              GiftcardHistoryDetails(param: settings.arguments as GiftcardTxn),
        );
      //cards
      case RoutesManager.createDollarCard:
        return MaterialPageRoute(builder: (_) => CreateUsdCard());
      case RoutesManager.enterCardAddressRoute:
        return MaterialPageRoute(
            builder: (_) => EnterCardAddress(
                  param: settings.arguments as CardSummaryArg,
                ));
      case RoutesManager.createNairaCard:
        return MaterialPageRoute(builder: (_) => CreateNgnCard());
      case RoutesManager.cardsRoute:
        return MaterialPageRoute(
            builder: (_) => CardsView(
                  cardList: settings.arguments as List<CardData>,
                ));
      case RoutesManager.cardTransactions:
        return MaterialPageRoute(
            builder: (_) => CardTransactions(
                  cardId: settings.arguments as String,
                ));
      case RoutesManager.cardDetails:
        return MaterialPageRoute(
            builder: (_) => CardDetails(
                  cardData: settings.arguments as CardData,
                ));
      case RoutesManager.cardHistoryDetails:
        return MaterialPageRoute(
            builder: (_) => CardHistoryDetails(
                  param: settings.arguments as CardTransaction,
                ));
      case RoutesManager.setCardpin:
        return MaterialPageRoute(builder: (_) => const SetCardPin());
      case RoutesManager.fundDollarCard:
        return MaterialPageRoute(
            builder: (_) => FundUsdCard(id: settings.arguments as String));
      case RoutesManager.fundNairaCard:
        return MaterialPageRoute(
            builder: (_) => FundNgnCard(id: settings.arguments as String));
      case RoutesManager.withdrawNairaCard:
        return MaterialPageRoute(
            builder: (_) => WithdrawNgnCard(id: settings.arguments as String));
      case RoutesManager.withdrawDollarCard:
        return MaterialPageRoute(
            builder: (_) => WithdrawUsdCard(id: settings.arguments as String));
      case RoutesManager.reviewDetails:
        return MaterialPageRoute(
            builder: (_) => AirtimeReviewScreen(), settings: settings);
      case RoutesManager.electricityProviders:
        return MaterialPageRoute(
            builder: (_) => ElectricityProvidersScreen(), settings: settings);
      case RoutesManager.buyElectricity:
        return MaterialPageRoute(
            builder: (_) => BuyElectricityScreen(), settings: settings);
      case RoutesManager.cableTvProviders:
        return MaterialPageRoute(
            builder: (_) => CableTvProvidersScreen(), settings: settings);
      case RoutesManager.cableTvPackages:
        return MaterialPageRoute(
            builder: (_) => CableTvPackageScreen(), settings: settings);

      case RoutesManager.cableTv:
        return MaterialPageRoute(
            builder: (_) => CableTvScreen(), settings: settings);
      case RoutesManager.intlAirtimeCountries:
        return MaterialPageRoute(
            builder: (_) => IntlAirtimeCountriesScreen(), settings: settings);
      case RoutesManager.buyIntlAirtime:
        return MaterialPageRoute(
            builder: (_) => BuyIntlAirtimeScreen(), settings: settings);
      case RoutesManager.transfer:
        return MaterialPageRoute(
            builder: (_) => TransferScreen(), settings: settings);

      case RoutesManager.bottomNav:
        return MaterialPageRoute(
            builder: (_) => BottomNavScreen(), settings: settings);
      case RoutesManager.successful:
        return MaterialPageRoute(
            builder: (_) => TransactionSuccessfulScreen(), settings: settings);
       case RoutesManager.authSuccessful:
        return MaterialPageRoute(
            builder: (_) => AuthSuccessfulScreen(), settings: settings);      
      case RoutesManager.buyData:
        return MaterialPageRoute(
            builder: (_) => BuyDataScreen(), settings: settings);
       case RoutesManager.buyOtherData:
        return MaterialPageRoute(
            builder: (_) => BuyOtherDataScreen(), settings: settings);      
      case RoutesManager.services:
        return MaterialPageRoute(
            builder: (_) => ServicesScreen(), settings: settings);
      case RoutesManager.intlDataCountries:
        return MaterialPageRoute(
            builder: (_) => IntlDataCountriesScreen(), settings: settings);
      case RoutesManager.buyIntlData:
        return MaterialPageRoute(
            builder: (_) => BuyIntlDataScreen(), settings: settings);
      case RoutesManager.leaderboard:
        return MaterialPageRoute(
            builder: (_) => LeaderboardScreen(), settings: settings);
      case RoutesManager.referrals:
        return MaterialPageRoute(
            builder: (_) => ReferralsScreen(), settings: settings);
    case RoutesManager.generalSettings:
        return MaterialPageRoute(
            builder: (_) => GeneralSettingsScreen(), settings: settings); 
   case RoutesManager.closeAccount:
        return MaterialPageRoute(
            builder: (_) => CloseAccountScreen(), settings: settings);       
  case RoutesManager.withdraw:
        return MaterialPageRoute(
            builder: (_) => WithdrawScreen(), settings: settings);  
    case RoutesManager.epinProviders:
        return MaterialPageRoute(
            builder: (_) => EpinProvidersScreen(), settings: settings); 
   case RoutesManager.epinProducts:
        return MaterialPageRoute(
            builder: (_) => EpinProductsScreen(), settings: settings);   
                
  case RoutesManager.purchaseEPin:
        return MaterialPageRoute(
            builder: (_) => BuyEpinScreen(), settings: settings);                             
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text("404")),
        body: const Center(
          child: Text("404 Page Not Found"),
        ),
      ),
    );
  }
}
