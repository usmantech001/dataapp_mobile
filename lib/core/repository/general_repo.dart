import 'package:dataplug/core/helpers/generic_helper.dart';
import 'package:dataplug/core/model/core/service_charge.dart';

class GeneralRepo {

  Future<ServiceCharge> getServicesCharge() async{
    return await GenericHelper.serviceCharge();
  }
}