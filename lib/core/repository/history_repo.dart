import 'package:dataplug/core/enum.dart';
import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/core/model/core/service_txn.dart';

class HistoryRepo {

  Future<List<ServiceTxn>> getServiceTxnsHistory({int perPage = 30,
      int page = 1,
      Status? status,
      ServicePurpose? purpose,
      CashFlowType? cashFlowType,
      DateTime? startDate,
      DateTime? endDate}) async{
    return await ServicesHelper.getServiceTxns();
  }
}