import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/core/model/core/airtime_provider.dart';
import 'package:dataplug/core/model/core/service_txn.dart';

class AirtimeRepo {

 Future<List<AirtimeProvider>> getAirtimeProviders() async{
  return await ServicesHelper.getAirtimeProviders();
 }

  Future<ServiceTxn> buyAirtime({
     required String phone,
    required num amount,
    required String provider,
    required String pin,
    required bool isPorted,
  }) async{
    return await ServicesHelper.buyAiritme(phone: phone, amount: amount, provider: provider, pin: pin, isPorted: isPorted);
  }
}