import 'package:dataplug/core/model/core/service_txn.dart';
import 'package:dataplug/core/repository/history_repo.dart';
import 'package:flutter/material.dart';

class HistoryController extends ChangeNotifier{
  HistoryRepo historyRepo;

  HistoryController({required this.historyRepo});

  List<ServiceTxn> transactionsHistory = [];

  bool gettingHistory = false;

  String? errMsg;

  int currentTabIndex = 0;

  void onChangedTab(int newIndex){
    currentTabIndex = newIndex;
    notifyListeners();
  }

  Future<void> getServiceTxnsHistory() async{
    gettingHistory = true;
    errMsg = null;
    transactionsHistory = [];
      notifyListeners();
    try {
      final response = await historyRepo.getServiceTxnsHistory();
      transactionsHistory.addAll(response);
      gettingHistory = false;
      notifyListeners();
    } catch (e) {
      errMsg = e.toString();
      gettingHistory = false;
      notifyListeners();
    }
  }
}