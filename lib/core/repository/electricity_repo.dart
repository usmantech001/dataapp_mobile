import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/core/model/core/electricity_provider.dart';
import 'package:dataplug/core/model/core/service_txn.dart';
import 'package:dataplug/core/model/electricity_customer.dart';

class ElectricityRepo {
  ServicesHelper servicesHelper;
  ElectricityRepo({required this.servicesHelper});

  Future<List<ElectricityProvider>> getProviders() async {
    return await ServicesHelper.getElectricityProvider();
  }

  Future<ElectricityCustomer> verifyMeterNumber({
    required String provider,
    required bool isPrepaid,
    required String number,
  }) async {
    return await ServicesHelper.verifyElectricityDetails(
        provider: provider, isPrepaid: isPrepaid, number: number);
  }

  Future<ServiceTxn> buyUnit(
      {required String provider,
      required String type,
      required String phone,
      required String number,
      required num amount,
      required String pin}) async {
    return await ServicesHelper.buyUnit(
        provider: provider,
        type: type,
        number: number,
        phone: phone,
        amount: amount,
        pin: pin);
  }
}
