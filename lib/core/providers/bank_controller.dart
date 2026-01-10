import 'package:dataplug/core/model/core/bank.dart';
import 'package:dataplug/core/repository/bank_repo.dart';
import 'package:flutter/material.dart';

class BankController extends ChangeNotifier {
  BankRepo bankRepo;

  BankController({required this.bankRepo}){
    focusNode.addListener((){
      if(!focusNode.hasFocus && accountNumberController.text.isNotEmpty && attachedBankName == null){
        verifyBankInfo();
      }
    });
  }

  List<Bank> bankList = [];
  List<Bank> filteredBanks = [];

   bool fetchingBanks = false;
  bool verifyingBankInfo = false;

  Bank? selectedBank;

  String? attachedBankName;
  String? bankInfoErrMsg;
  
  final searchController = TextEditingController();
  final accountNumberController = TextEditingController();

  FocusNode focusNode = FocusNode();

  void onBankSelected(Bank bank){
    selectedBank = bank;
    notifyListeners();
  }

  void clearData(){
    selectedBank = null;
    bankInfoErrMsg =null;
    accountNumberController.clear();
    attachedBankName = null;
    
    notifyListeners();
  }
  
  void clearSearchController(){
    searchController.clear();
    notifyListeners();
  }

  void filterBanks(String bankQuery){
    filteredBanks = [];
    for (Bank bank in bankList) {
        if ((bank.name.toLowerCase()).contains(bankQuery.toLowerCase())) {
          filteredBanks.add(bank);
          notifyListeners();
        }
      }
      
  }

  Future<void> getBankList() async{ 
    fetchingBanks = true;    
    notifyListeners();
    try {
      final response = await bankRepo.getBanks();
      bankList = [];
      fetchingBanks = false;
      bankList.addAll(response);
      notifyListeners();
    } catch (e) {

      fetchingBanks = false;
      notifyListeners();
    }
  }

  Future<void> verifyBankInfo() async{
     attachedBankName = null;
    verifyingBankInfo = true;
    bankInfoErrMsg = null;
   
    notifyListeners();

    try {
      final response = await bankRepo.verifyBankInfo(bankId: selectedBank?.id??"", accountNumber: accountNumberController.text);
      attachedBankName = response;

      verifyingBankInfo = false;
      notifyListeners();
    } catch (e) {
      bankInfoErrMsg = e.toString();
      verifyingBankInfo = false;
      notifyListeners();
    }
  }

  Future<void> saveBankInfo({Function(String)? onSuccess, Function(String)? onError}) async{
    try {
      final response = await bankRepo.saveBankInfo(bankId: selectedBank?.id??"", accountNumber: accountNumberController.text, accountName: attachedBankName??"");
      onSuccess?.call(response);
    } catch (e) {
      onError?.call(e.toString());
    }
  }
}