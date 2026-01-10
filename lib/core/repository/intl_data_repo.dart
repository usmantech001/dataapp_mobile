import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/core/model/core/country.dart';
import 'package:dataplug/core/model/core/operator_provider.dart';
import 'package:dataplug/core/model/core/operator_type_provider.dart';
import 'package:dataplug/core/model/core/service_txn.dart';

class IntlDataRepo {
  
   Future<List<Country>> getIntlDataCountries() async {
    return await ServicesHelper.getIntlBillCountries(type: 'data');
  }

  Future<List<OperatorProvider>> getIntlDataOperator(String iso2) async{
    return await ServicesHelper.getInternationalDataProviders(iso2: iso2);
  }

  Future<List<OperatorTypeProvider>> getIntlDataPlans(String providerId) async{
    return await ServicesHelper.getInternationalDataPlans(providerId: providerId);
  }


  Future<ServiceTxn> buyIntlData({
    required String code,
    required String phone,
    required String provider,
    required String pin,
  }) async {
    return await ServicesHelper.buyInternationalData(
        code: code, phone: phone, provider: provider, pin: pin);
  }

}