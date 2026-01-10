

import 'package:dataplug/core/repository/transfer_repo.dart';
import 'package:dataplug/core/utils/formatters.dart';
import 'package:flutter/material.dart';

class TransferController extends ChangeNotifier{
  TransferRepo transferRepo;

  TransferController({required this.transferRepo}){
    focusNode.addListener(onFocusChanged);
  }

  final beneficiaryController = TextEditingController();
  final amountController = TextEditingController();

  FocusNode focusNode = FocusNode();
  
  String? beneficiaryErrMsg;
  String? selectedSuggestedAmount;

  bool verifyingBeneficiary = false;

  String? attachedName;


   void onAmountChanged(num amount) {
    amountController.text = formatCurrency(amount, decimal: 0);
  }

  void onSuggestedAmountSelected(String amount) {
    selectedSuggestedAmount = amount;
    onAmountChanged(num.tryParse(amount) ?? 0);
    notifyListeners();
  }
   
   void onFocusChanged(){
    if(!focusNode.hasFocus && beneficiaryController.text.isNotEmpty){
      verifyBeneficiary();
    }
   }

  Future<void> verifyBeneficiary() async{
    verifyingBeneficiary = true;
    beneficiaryErrMsg = null;
    attachedName = null;
    notifyListeners();
    try {
      final response = await transferRepo.verifyInAppTransferBeneficiaryDetails(beneficiaryController.text.trim());
       attachedName = "${response.firstname??""} ${response.lastname??""}";
       verifyingBeneficiary = false;
      notifyListeners();
    } catch (e) {
      beneficiaryErrMsg = e.toString();
      verifyingBeneficiary = false;
      notifyListeners();
    }
  }

  Future<void> transfer(String pin, {Function(String)? onError}) async{
    try {
      final response = await transferRepo.transfer(beneficiary: beneficiaryController.text, amount: amountController.text.trim(), pin: pin);
    } catch (e) {
      onError?.call(e.toString());
    }
  }
}