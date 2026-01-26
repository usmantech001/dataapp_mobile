import 'package:dataplug/core/enum.dart';
import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/core/model/core/service_txn.dart';
import 'package:dataplug/core/model/core/spending_analysis_response.dart';

class HistoryRepo {

  Future<List<ServiceTxn>> getServiceTxnsHistory({int perPage = 30,
      int page = 1,
      String? status,
      String? purpose,
      CashFlowType? cashFlowType,
      DateTime? startDate,
      DateTime? endDate}) async{
    return await ServicesHelper.getServiceTxns(status: status, purpose: purpose);
  }

Future<SpendingAnalysisData> getSpendingAnalysis(String period) async{
  final data = await ServicesHelper.getSpendingAnalysis(period: period);
  print('...data at repo $data');
  return data;
}

}