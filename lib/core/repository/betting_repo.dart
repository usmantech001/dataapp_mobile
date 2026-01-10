import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/core/model/core/betting_provider.dart';
import 'package:dataplug/core/model/core/electricity_provider.dart';
import 'package:dataplug/core/model/core/service_txn.dart';
import 'package:dataplug/core/model/electricity_customer.dart';

class BettingRepo {
  
  BettingRepo();

  Future<List<BettingProvider>> getProviders() async {
    return await ServicesHelper.getBettingProviders();
  }

  Future<String> verifyBettingNumber({
    required String provider,
    required String number,
  }) async {
    return await ServicesHelper.verifyBettingDetails(
        provider: provider, number: number);
  }

  Future<ServiceTxn> fundBetting(
      {required String provider,
      required String number,
      required String amount,
      required String pin}) async {
    return await ServicesHelper.fundBetting(
        provider: provider,
        number: number,
        amount: amount,
        pin: pin);
  }
}
