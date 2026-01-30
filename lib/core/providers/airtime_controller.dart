

import 'package:dataplug/core/model/core/airtime_provider.dart';
import 'package:dataplug/core/model/core/service_txn.dart';
import 'package:dataplug/core/repository/airtime_repo.dart';
import 'package:dataplug/core/utils/formatters.dart' as f;
import 'package:dataplug/core/utils/utils.dart';
import 'package:flutter/material.dart';

class AirtimeController extends ChangeNotifier{
  AirtimeRepo airtimeRepo;

  AirtimeController({required this.airtimeRepo});

  final phoneNumberController = TextEditingController();
  final amountController = TextEditingController();

  AirtimeProvider? selectedProvider;
  bool isPorted = false;
  bool gettingProviders = false;

  String? providerErrMsg;
  

  String? selectedSuggestedAmount;

  List<AirtimeProvider> airtimeProviders =  [];
 
 void clearData(){
  phoneNumberController.clear();
  amountController.clear();
  phoneError = false;
 }

   void onAmountChanged(num amount) {
    amountController.text = f.formatCurrency(amount, decimal: 0);
  }

   bool phoneError = false;

 void validatePhoneNumber(){
  print('...validating');
  phoneError = false;
  bool isValid = phoneNumberController.text.length>=4? isValidNetwork(phoneNumberController.text, selectedProvider!.code) : true;
  print('..is number valid $isValid');
  if(!isValid && !isPorted){
    phoneError = true;
    
  }
  notifyListeners();
 }


  void toggleIsPorted() {
    print('...isPorted $isPorted');
    if(!isPorted){
      phoneError = false;
      isPorted = !isPorted;
    }else{
      isPorted = !isPorted;
       validatePhoneNumber();
    }
    
    notifyListeners();
  }

  void onSelectProvider(AirtimeProvider provider) {
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
    providerErrMsg = null;
    notifyListeners();
    try {
      airtimeProviders = [];
      final response = await airtimeRepo.getAirtimeProviders();
      airtimeProviders.addAll(response); 
      onSelectProvider(airtimeProviders[0]);
      gettingProviders = false;
    notifyListeners();
    } catch (e) {
      providerErrMsg = e.toString();
      gettingProviders = false;
    notifyListeners();
    }
  }

  Future<void> buyAirtime(String pin, {Function(ServiceTxn)? onSuccess, Function(String)? onError}) async{
    final amount = f.formatUseableAmount(amountController.text.trim());
    try {
      final res = await airtimeRepo.buyAirtime(phone: phoneNumberController.text.trim(), amount: num.tryParse(amount) ?? 0, provider: selectedProvider?.code??"", pin: pin, isPorted: isPorted);
      onSuccess?.call(res);
    } catch (e) {
      onError?.call(e.toString());
    }
  }
}