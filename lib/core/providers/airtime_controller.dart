

import 'package:dataplug/core/model/core/airtime_provider.dart';
import 'package:dataplug/core/model/core/service_txn.dart';
import 'package:dataplug/core/repository/airtime_repo.dart';
import 'package:dataplug/core/utils/formatters.dart';
import 'package:flutter/material.dart';

class AirtimeController extends ChangeNotifier{
  AirtimeRepo airtimeRepo;

  AirtimeController({required this.airtimeRepo});

  final phoneNumberController = TextEditingController();
  final amountController = TextEditingController();

  AirtimeProvider? selectedProvider;
  bool isPorted = false;
  bool gettingProviders = false;
  

  String? selectedSuggestedAmount;

  List<AirtimeProvider> airtimeProviders =  [];

   void onAmountChanged(num amount) {
    amountController.text = formatCurrency(amount, decimal: 0);
  }

   bool phoneError = false;

  void toggleIsPorted() {
    
      isPorted = !isPorted;
    notifyListeners();
    // _verifyPhone();
  }

  void onSelectProvider(AirtimeProvider provider, {bool isPreSelect = true}) {
    selectedProvider = provider;
    notifyListeners();
  }
 
  void onSuggestedAmountSelected(String amount) {
    selectedSuggestedAmount = amount;
    onAmountChanged(num.tryParse(amount) ?? 0);
    notifyListeners();
  }

  Future<void> getAirtimeProviders() async{
    gettingProviders = true;
    notifyListeners();
    try {
      final response = await airtimeRepo.getAirtimeProviders();
      airtimeProviders.addAll(response); 
      gettingProviders = false;
    notifyListeners();
    } catch (e) {
      gettingProviders = false;
    notifyListeners();
    }
  }

  Future<void> buyAirtime(String pin, {Function(ServiceTxn)? onSuccess, Function(String)? onError}) async{
    final amount = formatUseableAmount(amountController.text.trim());
    try {
      final res = await airtimeRepo.buyAirtime(phone: phoneNumberController.text.trim(), amount: num.tryParse(amount) ?? 0, provider: selectedProvider?.code??"", pin: pin, isPorted: isPorted);
      onSuccess?.call(res);
    } catch (e) {
      onError?.call(e.toString());
    }
  }
}