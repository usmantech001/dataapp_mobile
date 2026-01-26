import 'package:dataplug/core/model/core/service_txn.dart';
import 'package:dataplug/core/model/core/spending_analysis_response.dart';
import 'package:dataplug/core/repository/history_repo.dart';
import 'package:flutter/material.dart';

class HistoryController extends ChangeNotifier {
  HistoryRepo historyRepo;

  HistoryController({required this.historyRepo});

  List<ServiceTxn> transactionsHistory = [];

  bool gettingHistory = false;
  bool gettingAnalysis = false;

  String? errMsg;

  int currentTabIndex = 0;
  int selectedCategoryIndex = 0;
  int selectedStatusIndex = 0;
  int selectedPeriodIndex = 0;

  String? analysisError;

  SpendingAnalysisData? weeklyAnalysis;
  SpendingAnalysisData? monthlyAnalysis;

  List<String> categoryFilterList = [
    'All',
    'Airtime',
    'Data',
    'Electricity',
    'Education',
    'Tv-Subscription',
  ];

  List<String> statusFilterList = [
    'All',
    'Successful',
    'Pending',
    'Failed',
    'Reversed',
  ];

  void onChangedTab(int newIndex) {
    if(newIndex == 1){
      Future.wait([
        getSpendingAnalysis('weekly'),
        getSpendingAnalysis('montly')
      ]);
    }
    currentTabIndex = newIndex;
    notifyListeners();
  }
 void onPeriodTabChanged(int newIndex){
  selectedPeriodIndex = newIndex;
  notifyListeners();
 }

  void onFilterChanged(int index, {bool isStatus = false}) {
    if (isStatus) {
      selectedStatusIndex = index;
      notifyListeners();
    } else {
      selectedCategoryIndex = index;
      notifyListeners();
    }
    //notifyListeners();
  }

  Future<void> getServiceTxnsHistory() async {
    gettingHistory = true;
    errMsg = null;
    transactionsHistory = [];
    notifyListeners();
    try {
      String? status;
      String? purpose;

      if (selectedCategoryIndex != 0) {
        purpose = categoryFilterList[selectedCategoryIndex].toLowerCase();
      }
      if (selectedStatusIndex != 0) {
        status = statusFilterList[selectedStatusIndex].toLowerCase();
      }
      final response = await historyRepo.getServiceTxnsHistory(
          status: status, purpose: purpose);
      transactionsHistory.addAll(response);
      gettingHistory = false;
      notifyListeners();
    } catch (e) {
      errMsg = e.toString();
      gettingHistory = false;
      notifyListeners();
    }
  }

  Future<void> getSpendingAnalysis(String period) async{
    gettingAnalysis = true;
    analysisError = null;
    notifyListeners();
    try {
    final data = await historyRepo.getSpendingAnalysis(period);
    if(period == 'weekly'){
      weeklyAnalysis = data;
      notifyListeners();
    }else{
      monthlyAnalysis = data;
      notifyListeners();
    }
    gettingAnalysis = false;
    notifyListeners();
    } catch (e) {
       print('...failed to get analysis ${e.toString()}');
       gettingAnalysis = false;
       analysisError = e.toString();
    notifyListeners();
      rethrow; 
     
    }
  }


  
}
