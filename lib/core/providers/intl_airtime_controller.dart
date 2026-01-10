import 'package:dataplug/core/model/core/country.dart';
import 'package:dataplug/core/model/core/operator_provider.dart';
import 'package:dataplug/core/model/core/service_txn.dart';
import 'package:dataplug/core/repository/intl_airtime_repo.dart';
import 'package:flutter/material.dart';

class IntlAirtimeController extends ChangeNotifier{
  IntlAirtimeRepo intlAirtimeRepo;

  IntlAirtimeController({required this.intlAirtimeRepo});

  List<Country> intlAirtimeCountries = [];
   List<OperatorProvider> intlAirtimeOperators = [];

  bool gettingCountries = false;
  bool gettingOperators = false;

  final amountController = TextEditingController();
  final phoneController = TextEditingController();

  OperatorProvider? selectedOperator;
  Country? selectedCountry;

  num rate = 0;
  num amountInNaira = 0;

  void clearData() {
    selectedOperator = null;
    amountInNaira = 0;
    amountController.clear();
    phoneController.clear();
    notifyListeners();
  }
 
  void onAmountChanged(){
    print('...onchanged');
    num amount = num.tryParse(amountController.text)??0;
    amountInNaira = rate * amount;

    notifyListeners();
  }

  void onSelectCountry(Country country){
    selectedCountry = country;
  }

  void onSelectOperator(OperatorProvider operator){
    selectedOperator = operator;
    rate = operator.rate;
    onAmountChanged();
    notifyListeners();
  }

  Future<void> getIntlAirtimeCountries() async {
    gettingCountries = true;
    intlAirtimeCountries = [];
    notifyListeners();
    
    try {
      final response = await intlAirtimeRepo.getIntlAirtimeCountries();
      intlAirtimeCountries.addAll(response);
      gettingCountries = false;
      notifyListeners();
    } catch (e) {
      gettingCountries = false;
      notifyListeners();
    }
  }

  Future<void> getIntlAirtimeOperators() async{
    gettingOperators = true;
    intlAirtimeOperators = [];
    notifyListeners();
    try {
      final response = await intlAirtimeRepo.getIntlAirtimeOperator(selectedCountry?.iso2??"");
      intlAirtimeOperators.addAll(response);
      gettingOperators = false;
      notifyListeners();
    } catch (e) {
      gettingOperators = false;
      notifyListeners();
    }
  }

  Future<void> buyInternationalAirtime(String pin, {Function(ServiceTxn)? onSuccess, Function(String)? onError}) async{
    try {
      final response = await intlAirtimeRepo.buyIntlAirtime(amount: amountController.text.trim(), phone: phoneController.text, provider: selectedOperator!.code, pin: pin);
      onSuccess?.call(response);
    } catch (e) {
      onError?.call(e.toString());
    }
  }
}