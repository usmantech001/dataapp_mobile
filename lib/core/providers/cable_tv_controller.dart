import 'package:dataplug/core/model/core/cable_tv_plan.dart';
import 'package:dataplug/core/model/core/cable_tv_provider.dart';
import 'package:dataplug/core/model/core/service_txn.dart';
import 'package:dataplug/core/repository/cable_tv_repo.dart';
import 'package:flutter/material.dart';

class CableTvController extends ChangeNotifier {
  CableTvRepo cableTvRepo;
  CableTvController({required this.cableTvRepo}){
    focusNode.addListener(onFocusChanged);
  }
 
 final List<String> cableTvTypes = ['Renew', 'Change'];

  FocusNode focusNode = FocusNode();

  List<CableTvProvider> tvServiceProviders = [];
  List<CableTvPlan> tvPlans = [];

  bool gettingProviders = false;
  bool gettingPlans = false;
  bool verifyingDecoderNumber = false;

  String? providersErrMsg;
  String? plansErrMsg;
  String? decoderNumberErrMsg;
  CableTvProvider? selectedProvider;
  CableTvPlan? selectedPlan;

  TextEditingController decoderNumberController = TextEditingController();
  int currentTabIndex = 0;

  void onFocusChanged(){
    if(!focusNode.hasFocus && decoderNumberController.text.isNotEmpty){
      verifyDecoderNumber();
    }
  }

  void onCableTvTypeChange(index) {
    currentTabIndex = index;
    notifyListeners();
  }
  
  void onSelectProvider(CableTvProvider provider){
    selectedProvider = provider;
    notifyListeners();
  }

  void onSelectPlan(CableTvPlan plan){
    selectedPlan = plan;
    notifyListeners();
  }

  void clearData(){
    decoderNumberController.clear();
    decoderNumberErrMsg = null;
    notifyListeners();
  }

  Future<void> getCableTvProviders() async {
    gettingProviders = true;
    tvServiceProviders = [];
    notifyListeners();
    try {
      final providers = await cableTvRepo.getCableTvProviders();
      tvServiceProviders.addAll(providers);
      gettingProviders = false;
      notifyListeners();
    } catch (e) {
      providersErrMsg = e.toString();
      gettingProviders = false;

      notifyListeners();
      print('...failed to get tv providers ${e.toString()}');
    }
  }

  Future<void> getCableTvPlans() async {
    gettingPlans = true;
    tvPlans = [];
    notifyListeners();
    try {
      final plans = await cableTvRepo.getTvPlans(selectedProvider!.id);
      tvPlans.addAll(plans);
      gettingPlans = false;
      notifyListeners();
    } catch (e) {
      plansErrMsg = e.toString();
      gettingPlans = false;

      notifyListeners();
      print('...failed to get tv providers ${e.toString()}');
    }
  }

  Future<void> verifyDecoderNumber() async {
    verifyingDecoderNumber = true;
    decoderNumberErrMsg = null;
    print('...verifying decoder number......');
    notifyListeners();
    try {
      await cableTvRepo.verifyDecoderNumber(
          provider: selectedProvider!.code,
          decoderNumber: decoderNumberController.text.trim());
      verifyingDecoderNumber = false;
      notifyListeners();
    } catch (e) {
      decoderNumberErrMsg = e.toString();
      verifyingDecoderNumber = false;
      notifyListeners();
    }
  }

  Future<void> purchaseCableTv(String pin, {Function(ServiceTxn)? onSuccess,  Function(String)? onError}) async{
    try {
      final response = await cableTvRepo.purchaseCableTv(provider: selectedProvider!.code, number: decoderNumberController.text, pin: pin, code: selectedPlan!.code, type: cableTvTypes[currentTabIndex].toLowerCase());
    } catch (e) {
      onError?.call(e.toString());
      print('....failed to purchase tv');
    }
  }
}
