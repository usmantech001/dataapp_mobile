import 'package:dataplug/core/helpers/generic_helper.dart';
import 'package:dataplug/core/model/core/discount.dart';
import 'package:dataplug/core/model/core/service_charge.dart';

class GeneralRepo {

  Future<ServiceCharge> getServicesCharge() async{
    return await GenericHelper.serviceCharge();
  }

   Future<Discount> getDiscount({
    required String type,
    required String provider,
     String? amount,
     String? code,
   }) async{
    return await GenericHelper.getDiscount(type,provider, amount, code);
  }
}