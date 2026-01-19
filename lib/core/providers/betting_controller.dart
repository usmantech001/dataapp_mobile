import 'package:dataplug/core/model/core/betting_provider.dart';
import 'package:dataplug/core/model/core/service_txn.dart';
import 'package:dataplug/core/repository/betting_repo.dart';
import 'package:dataplug/core/utils/formatters.dart';
import 'package:flutter/material.dart';

class BettingController extends ChangeNotifier{
  BettingRepo bettingRepo;

  BettingController({required this.bettingRepo}){
    focusNode.addListener(onFocusChanged);
  }

  List<BettingProvider> bettingProviders = [];
  List<BettingProvider> filteredbettingProviders = [];

  bool gettingProviders = false;
  bool verifyingBettingNo = false;
  BettingProvider? selectedProvider;
  String? selectedSuggestedAmount;

  //Text editing controllers
  TextEditingController bettingNumberController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  String? bettingNoErrMsg;
  String? attachedName;
  
  final focusNode = FocusNode();

  void clearValues() {
    bettingNoErrMsg = null;
    attachedName = null;
    selectedSuggestedAmount = null;
    bettingNumberController.clear();
    amountController.clear();
    notifyListeners();
  }

   void filterProviders(String query){
    filteredbettingProviders = [];
    for (BettingProvider provider in bettingProviders) {
        if ((provider.name.toLowerCase()).contains(query.toLowerCase())) {
          filteredbettingProviders.add(provider);
          notifyListeners();
        }
      }
      
  }


  void onFocusChanged() {
    if (!focusNode.hasFocus && bettingNumberController.text.isNotEmpty) {
      verifyBettingNumber();
    }
  }

   void onAmountChanged(num amount) {
    amountController.text = formatCurrency(amount, decimal: 0);
  }

  void onSuggestedAmountSelected(String amount) {
    selectedSuggestedAmount = amount;
    onAmountChanged(num.tryParse(amount) ?? 0);
    notifyListeners();
  }
   

    void onSelectProvider(BettingProvider provider) {
    selectedProvider = provider;
    //notifyListeners();
  }

   Future<void> getBettingProviders() async {
    gettingProviders = true;
    bettingProviders = [];
    searchController.clear();
    notifyListeners();
    await bettingRepo.getProviders().then((value) {
      if (value.isNotEmpty) {
        bettingProviders.addAll(value);
        notifyListeners();
      }
    }).catchError((err) {
      print('..faled to get betting providers ${err.toString()}');
    });
    gettingProviders = false;
    notifyListeners();
  }

    Future<void> verifyBettingNumber() async {
    verifyingBettingNo = true;
    bettingNoErrMsg = null;
    notifyListeners();
    try {
      final customerName = await bettingRepo.verifyBettingNumber(
          provider: selectedProvider!.code,
          number: bettingNumberController.text.trim());
      attachedName = customerName;
      verifyingBettingNo = false;
      notifyListeners();
    } catch (e) {
      bettingNoErrMsg = e.toString();
      verifyingBettingNo = false;
      notifyListeners();
      print('...failed to verify betting number ${e.toString()}');
    }
  }

  Future<void> fundBetting(String pin,  {Function(ServiceTxn)? onSuccess, Function(String)? onError}) async {
    final amount =
        num.tryParse(formatUseableAmount(amountController.text)) ?? 0;
    try {
      final transData = await bettingRepo.fundBetting(
          provider: selectedProvider!.code,
          number: bettingNumberController.text.trim(),
          amount: amount.toString(),
          pin: pin);
          onSuccess?.call(transData);
    } catch (e) {
      onError?.call(e.toString());
      print('..failed to buy unit ${e.toString()}');
    }
  }
}