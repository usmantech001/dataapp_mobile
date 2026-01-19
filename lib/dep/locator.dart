import 'package:dataplug/core/helpers/service_helper.dart';
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
import 'package:dataplug/core/providers/rewards_controller.dart';
import 'package:dataplug/core/providers/transfer_controller.dart';
import 'package:dataplug/core/providers/wallet_controller.dart';
import 'package:dataplug/core/repository/airtime_repo.dart';
import 'package:dataplug/core/repository/auth_repo.dart';
import 'package:dataplug/core/repository/bank_repo.dart';
import 'package:dataplug/core/repository/betting_repo.dart';
import 'package:dataplug/core/repository/cable_tv_repo.dart';
import 'package:dataplug/core/repository/data_repo.dart';
import 'package:dataplug/core/repository/electricity_repo.dart';
import 'package:dataplug/core/repository/epin_repo.dart';
import 'package:dataplug/core/repository/general_repo.dart';
import 'package:dataplug/core/repository/giftcard_repo.dart';
import 'package:dataplug/core/repository/history_repo.dart';
import 'package:dataplug/core/repository/intl_airtime_repo.dart';
import 'package:dataplug/core/repository/intl_data_repo.dart';
import 'package:dataplug/core/repository/rewards_repo.dart';
import 'package:dataplug/core/repository/transfer_repo.dart';
import 'package:dataplug/core/repository/wallet_repo.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setUpLocator() async {
  getIt.registerLazySingleton(() => ServicesHelper());

  getIt.registerLazySingleton(
      () => ElectricityRepo(servicesHelper: getIt<ServicesHelper>()));
  getIt.registerLazySingleton(() => CableTvRepo());
  getIt.registerLazySingleton(() => BettingRepo());
  getIt.registerLazySingleton(() => GiftcardRepo());
  getIt.registerLazySingleton(() => IntlAirtimeRepo());
  getIt.registerLazySingleton(() => TransferRepo());
  getIt.registerLazySingleton(() => AirtimeRepo());
  getIt.registerLazySingleton(() => HistoryRepo());
  getIt.registerLazySingleton(() => DataRepo());
  getIt.registerLazySingleton(() => WalletRepo());
  getIt.registerLazySingleton(() => RewardsRepo());
  getIt.registerLazySingleton(() => IntlDataRepo());
  getIt.registerLazySingleton(() => BankRepo());
  getIt.registerLazySingleton(() => EpinRepo());
  getIt.registerLazySingleton(() => GeneralRepo());
  getIt.registerLazySingleton(() => AuthRepo());
  //injection of controllers

  getIt.registerLazySingleton(
      () => ElectricityController(electricityRepo: getIt<ElectricityRepo>()));

  getIt.registerLazySingleton(
      () => CableTvController(cableTvRepo: getIt<CableTvRepo>()));
  getIt.registerLazySingleton(
      () => BettingController(bettingRepo: getIt<BettingRepo>()));
  getIt.registerLazySingleton(
      () => GiftcardController(giftcardRepo: getIt<GiftcardRepo>()));
      getIt.registerLazySingleton(
      () => IntlAirtimeController(intlAirtimeRepo: getIt<IntlAirtimeRepo>()));
   getIt.registerLazySingleton(
      () => TransferController(transferRepo: getIt<TransferRepo>()));   
     getIt.registerLazySingleton(
      () => HistoryController(historyRepo: getIt<HistoryRepo>()));  
       getIt.registerLazySingleton(
      () => AirtimeController(airtimeRepo: getIt<AirtimeRepo>()));
     getIt.registerLazySingleton(
      () => DataController(dataRepo: getIt<DataRepo>()));    
     getIt.registerLazySingleton(
      () => WalletController(walletRepo: getIt<WalletRepo>()));          
       getIt.registerLazySingleton(
      () => RewardsController(rewardsRepo: getIt<RewardsRepo>()));  
    getIt.registerLazySingleton(
      () => IntlDataController(intlDataRepo: getIt<IntlDataRepo>()));    
   getIt.registerLazySingleton(
      () => BankController(bankRepo: getIt<BankRepo>()));  
    getIt.registerLazySingleton(
      () => EpinController(epinRepo: getIt<EpinRepo>())); 

     getIt.registerLazySingleton(
      () => GeneralController(generalRepo: getIt<GeneralRepo>()));   
  getIt.registerLazySingleton(
      () => AuthController(authRepo: getIt<AuthRepo>()));                        
}
