import 'package:dataplug/core/providers/airtime_controller.dart';
import 'package:dataplug/core/providers/auth_controller.dart';
import 'package:dataplug/core/providers/bank_controller.dart';
import 'package:dataplug/core/providers/betting_controller.dart';
import 'package:dataplug/core/providers/cable_tv_controller.dart';
import 'package:dataplug/core/providers/data_controller.dart';
import 'package:dataplug/core/providers/electricity_controller.dart';
import 'package:dataplug/core/providers/epin_controller.dart';
import 'package:dataplug/core/providers/general_controller.dart';
import 'package:dataplug/core/providers/giftcard_controller.dart';
import 'package:dataplug/core/providers/history_controller.dart';
import 'package:dataplug/core/providers/intl_airtime_controller.dart';
import 'package:dataplug/core/providers/intl_data_controller.dart';
import 'package:dataplug/core/providers/keypad_provider.dart';
import 'package:dataplug/core/providers/rewards_controller.dart';
import 'package:dataplug/core/providers/transfer_controller.dart';
import 'package:dataplug/core/providers/wallet_controller.dart';
import 'package:dataplug/dep/locator.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'card_provider.dart';
import 'generic_provider.dart';
import 'user_provider.dart';

class ProviderIndex {
  static List<SingleChildWidget> multiProviders() {
    return [
      ChangeNotifierProvider(create: (_) => GenericProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => CardProvider()),
       ChangeNotifierProvider(create: (_) => KeypadProvider()),
      ChangeNotifierProvider(create: (_) => getIt<ElectricityController>()),
      ChangeNotifierProvider(create: (_) => getIt<CableTvController>()),
       ChangeNotifierProvider(create: (_) => getIt<BettingController>()),
      ChangeNotifierProvider(create: (_) => getIt<GiftcardController>()),
      ChangeNotifierProvider(create: (_) => getIt<IntlAirtimeController>()),
      ChangeNotifierProvider(create: (_) => getIt<TransferController>()),
      ChangeNotifierProvider(create: (_) => getIt<AirtimeController>()),  
      ChangeNotifierProvider(create: (_) => getIt<HistoryController>()), 
      ChangeNotifierProvider(create: (_) => getIt<DataController>()),
      ChangeNotifierProvider(create: (_) => getIt<WalletController>()),
      ChangeNotifierProvider(create: (_) => getIt<RewardsController>()),
      ChangeNotifierProvider(create: (_) => getIt<IntlDataController>()),
      ChangeNotifierProvider(create: (_) => getIt<BankController>()),
      ChangeNotifierProvider(create: (_) => getIt<EpinController>()),
      ChangeNotifierProvider(create: (_) => getIt<GeneralController>()),
      ChangeNotifierProvider(create: (_) => getIt<AuthController>()),
    ];
  }
}
