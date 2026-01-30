import 'package:dataplug/core/model/core/electricity_provider.dart';
import 'package:dataplug/core/model/core/service_txn.dart';
import 'package:dataplug/core/repository/electricity_repo.dart';
import 'package:dataplug/core/utils/formatters.dart';
import 'package:flutter/material.dart';

class ElectricityController extends ChangeNotifier {
  ElectricityRepo electricityRepo;

  ElectricityController({required this.electricityRepo}) {
    focusNode.addListener(onFocusChanged);
  }

  List<ElectricityProvider> electricityProviders = [];
  List<ElectricityProvider> filteredElectricityProviders = [];
  bool gettingProviders = false;
  bool verifyingMeterNo = false;
  ElectricityProvider? selectedProvider;
  String? selectesSuggestedAmount;

  //Text editing controllers
  TextEditingController meterNumberController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  String? meterNoErrMsg;
  String? attachedMeterName;
  String? providerErrMsg;

  bool isPrepaid = true;
  final focusNode = FocusNode();

  void clearValues() {
    meterNoErrMsg = null;
    attachedMeterName = null;
    selectesSuggestedAmount = null;
    meterNumberController.clear();
    amountController.clear();
    notifyListeners();
  }

   void filterProviders(String query){
    filteredElectricityProviders = [];
    for (ElectricityProvider provider in electricityProviders) {
        if ((provider.name.toLowerCase()).contains(query.toLowerCase())) {
          filteredElectricityProviders.add(provider);
          notifyListeners();
        }
      }
      
  }

  void onFocusChanged() {
    if (!focusNode.hasFocus && meterNumberController.text.isNotEmpty) {
      verifyMeterNumber();
    }
  }

  void onAmountChanged(num amount) {
    amountController.text = formatCurrency(amount, decimal: 0);
  }

  void toggleMeterType(MeterType meterType) {
    if (meterType == MeterType.prepaid && !isPrepaid) {
      isPrepaid = true;
      notifyListeners();
    } else if (meterType == MeterType.postpaid && isPrepaid) {
      isPrepaid = false;
      notifyListeners();
    }
  }

  void onSuggestedAmountSelected(String amount) {
    selectesSuggestedAmount = amount;
    onAmountChanged(num.tryParse(amount) ?? 0);
    notifyListeners();
  }

  Future<void> getElectricityProviders() async {
    gettingProviders = true;
    electricityProviders = [];
    searchController.clear();
    providerErrMsg = null;
    notifyListeners();
    await electricityRepo.getProviders().then((value) {
      if (value.isNotEmpty) {
        electricityProviders.addAll(value);
        notifyListeners();
      }
    }).catchError((err) {
      providerErrMsg = err.toString();
      
      print('..faled to get electricity providers ${err.toString()}');
    });
    gettingProviders = false;
    notifyListeners();
    
  }

  void onSelectProvider(ElectricityProvider provider) {
    selectedProvider = provider;
    //notifyListeners();
  }

  Future<void> verifyMeterNumber() async {
    verifyingMeterNo = true;
    meterNoErrMsg = null;
    attachedMeterName = null;
    notifyListeners();
    try {
      final customerInfo = await electricityRepo.verifyMeterNumber(
          provider: selectedProvider!.code,
          isPrepaid: isPrepaid,
          number: meterNumberController.text.trim());
      attachedMeterName = customerInfo.customerName;
      verifyingMeterNo = false;
      notifyListeners();
    } catch (e) {
      meterNoErrMsg = e.toString();
      verifyingMeterNo = false;
      notifyListeners();
      print('...failed to verify meter number ${e.toString()}');
    }
  }

  Future<void> buyUnit(String pin, {Function(ServiceTxn)? onSuccess, Function(String)? onError}) async {
    final amount =
        num.tryParse(formatUseableAmount(amountController.text)) ?? 0;
    try {
      final transData = await electricityRepo.buyUnit(
          provider: selectedProvider!.code,
          type: isPrepaid ? "prepaid" : "postpaid",
          phone: phoneController.text.trim(),
          number: meterNumberController.text.trim(),
          amount: amount,
          pin: pin);

          onSuccess?.call(transData);
    } catch (e) {
      onError?.call(e.toString());
      print('..failed to buy unit ${e.toString()}');
    }
  }
}

enum MeterType { prepaid, postpaid }
