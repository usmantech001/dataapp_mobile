import 'package:dataplug/core/helpers/generic_helper.dart';
import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/core/model/core/banner.dart';
import 'package:dataplug/core/model/core/service_txn.dart';


class WalletRepo {
  
  Future<String> getWalletBalance() async{
    return await ServicesHelper.getWalletBalance();
  }

  Future<List<Banners>> getBanners() async{
    return await GenericHelper.getBanners();
  }

  Future<ServiceTxn> withdraw({
    required String bankAccountId,
    required String amount,
    required String pin,
  }) async{
    return await ServicesHelper.makeWithdrawal(bank_account_id: bankAccountId, amount: amount, pin: pin);
  }
}