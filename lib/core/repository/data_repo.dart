
import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/core/model/core/data_plans.dart';
import 'package:dataplug/core/model/core/data_provider.dart';
import 'package:dataplug/core/model/core/service_txn.dart';

class DataRepo {

  Future<List<DataProvider>> getDataProviders() async{
    return await ServicesHelper.getDataProvider();
  }

  Future<List<DataPlan>> getDataPlans({
   required String provider, required String type
  }) async{
    return await ServicesHelper.getDataPlan(provider, type);
  }

Future<List<String>> getDataPlanTypes(String provider) async{
  return await ServicesHelper.getDataPlanTypes(provider);
}


  Future<ServiceTxn> buyData({required String phone,
      required String code,
      required String provider,
      required String pin,
      required bool isPorted,
      required String dataPurchaseType}) async{
      return await ServicesHelper.buyData(phone: phone, code: code, provider: provider, pin: pin, isPorted: isPorted, dataPurchaseType: dataPurchaseType);
  }
}