import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/core/model/core/e_pin_product.dart';
import 'package:dataplug/core/model/core/e_pin_provider.dart';
import 'package:dataplug/core/model/core/service_txn.dart';

class EpinRepo {

  Future<List<EPinProvider>> getEPinProviders() async{
    return await ServicesHelper.getEPinProviders();
  }

   Future<List<EPinProduct>> getEPinProducts(String provider) async{
    return await ServicesHelper.getEPinProducts(provider);
  }

  Future<String> verifyjambNumber({
    required String type,
    required String number
  }) async{
    return await ServicesHelper.verifyEpinDetails(type: type, number: number);
  }

  Future<ServiceTxn> purchaseEPin({
    required String product,
    required String number,
    required String pin,
  }) async{
    return await ServicesHelper.purchaseEPin(product: product, number: number, pin: pin);
  }
}