import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/core/model/core/country.dart';
import 'package:dataplug/core/model/core/operator_provider.dart';
import 'package:dataplug/core/model/core/service_txn.dart';

class IntlAirtimeRepo {
  Future<List<Country>> getIntlAirtimeCountries() async {
    return await ServicesHelper.getIntlBillCountries(type: 'airtime');
  }

  Future<List<OperatorProvider>> getIntlAirtimeOperator(String iso2) async{
    return await ServicesHelper.getInternationalAirtimeProviders(iso2: iso2);
  }
  Future<ServiceTxn> buyIntlAirtime({
    required String amount,
    required String phone,
    required String provider,
    required String pin,
  }) async {
    return await ServicesHelper.buyInternationalAirtime(
        amount: amount, phone: phone, provider: provider, pin: pin);
  }

}
