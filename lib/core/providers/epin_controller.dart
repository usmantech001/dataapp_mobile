
import 'package:dataplug/core/model/core/e_pin_product.dart';
import 'package:dataplug/core/model/core/e_pin_provider.dart';
import 'package:dataplug/core/model/core/service_txn.dart';
import 'package:dataplug/core/repository/epin_repo.dart';
import 'package:flutter/material.dart';

class EpinController extends ChangeNotifier{
  EpinRepo epinRepo;

  EpinController({required this.epinRepo}){
    focusNode.addListener((){
      if(!focusNode.hasFocus && numberController.text.isNotEmpty ){
        verifyNumber();
      }
    });
  }

  List<EPinProvider> ePinProviders = [];
  List<EPinProduct> ePinProducts = [];
  
  String? customerName;

  bool gettingProviders = false;
  bool gettingProducts = false;
  bool verifyingNumber = false;

  String? numberErrMsg;

  FocusNode focusNode = FocusNode();

  final numberController = TextEditingController();

  EPinProvider? selectedProvider;
  EPinProduct? selectedProduct;

  bool isUtme = true;

  void toggleJambType(){
    isUtme= !isUtme;
    notifyListeners();
  }

  void onSelectProvider(EPinProvider provider){
    selectedProvider = provider;
    
  }

  void onSelectProduct(EPinProduct product){
    selectedProduct = product;
    
  }

  void verifyNumber() async{
    verifyingNumber = true;
    numberErrMsg = null;
    notifyListeners();
    try {
      final response = await epinRepo.verifyjambNumber(type: isUtme? 'utme' : 'de', number: numberController.text.trim());
      customerName = response;
      verifyingNumber = false;
      notifyListeners();
    } catch (e) {
      numberErrMsg = e.toString();
      verifyingNumber = false;
      notifyListeners();
    }
  }

  Future<void> getEPinProviders() async{
    gettingProviders = true;
    notifyListeners();
    try {
      final response = await epinRepo.getEPinProviders();
      ePinProviders = [];
      ePinProviders.addAll(response);
      gettingProviders = false;
      notifyListeners();
    } catch (e) {
      gettingProviders = false;
      notifyListeners();
    }
  }

  Future<void> getEPinProducts() async{
    gettingProducts = true;
    notifyListeners();
    try {
      final response = await epinRepo.getEPinProducts(selectedProvider?.id??"");
      ePinProducts= [];
      ePinProducts.addAll(response);
      gettingProducts = false;
      notifyListeners();
    } catch (e) {
      gettingProducts = false;
      notifyListeners();
    }
  }

  Future<void> purchaseEPin(String pin, {Function(ServiceTxn)? onSuccess, Function(String)? onError}) async{
    try {
      final response = await epinRepo.purchaseEPin(product: selectedProduct?.id??"", number: numberController.text.trim(), pin: pin);
      onSuccess?.call(response);
    } catch (e) {
      onError?.call(e.toString());
    }
  }
}