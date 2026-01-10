import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/core/model/core/cable_tv_plan.dart';
import 'package:dataplug/core/model/core/cable_tv_provider.dart';
import 'package:dataplug/core/model/core/service_txn.dart';

class CableTvRepo {

  CableTvRepo();

  Future<List<CableTvProvider>> getCableTvProviders() async{
    return await ServicesHelper.getTVServiceProviders();
  }

  Future<String> verifyDecoderNumber({required String provider, required String decoderNumber}) async {
    return await ServicesHelper.verifyTvDetails(provider: provider, number: decoderNumber);
  }

  Future<List<CableTvPlan>> getTvPlans(String provider) async{
    return await ServicesHelper.getTvPlans(provider);
  }

  Future<ServiceTxn> purchaseCableTv({
    required String provider,
    required String number,
    required String pin,
    required String code,
    required String type,
  }) async{
    return await ServicesHelper.purchaseCableTv(provider: provider, number: number, pin: pin, code: code, type: type);
  }
}