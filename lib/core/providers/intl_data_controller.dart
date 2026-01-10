import 'package:dataplug/core/model/core/data_plans.dart';
import 'package:dataplug/core/model/core/operator_type_provider.dart';
import 'package:dataplug/core/model/core/service_txn.dart';
import 'package:dataplug/core/repository/intl_data_repo.dart';
import 'package:flutter/material.dart';
import 'package:dataplug/core/model/core/country.dart';
import 'package:dataplug/core/model/core/operator_provider.dart';

class IntlDataController extends ChangeNotifier {
  IntlDataRepo intlDataRepo;
  IntlDataController({required this.intlDataRepo});

  List<Country> intlDataCountries = [];
  List<OperatorProvider> intlDataOperators = [];
  List<OperatorTypeProvider> allPlans = [];
  List<OperatorTypeProvider> durationPlans = [];

  bool gettingCountries = false;
  bool gettingOperators = false;

  final amountController = TextEditingController();
  final phoneController = TextEditingController();

  OperatorProvider? selectedOperator;
  Country? selectedCountry;
  OperatorTypeProvider? selectedPlan;
  //DataPlan? selectedPlan;

  bool gettingPlans = false;
  bool isPorted = false;

  //,, String selectedType = 'Direct';
  String selectedDuration = 'All';

  num rate = 0;
  num amountInNaira = 0;

  void clearData() {
    selectedOperator = null;
    amountInNaira = 0;
    amountController.clear();
    phoneController.clear();
    notifyListeners();
  }

  void onAmountChanged() {
    print('...onchanged');
    num amount = num.tryParse(amountController.text) ?? 0;
    amountInNaira = rate * amount;

    notifyListeners();
  }

  void onSelectCountry(Country country) {
    selectedCountry = country;
  }

  void onSelectOperator(OperatorProvider operator) {
    selectedOperator = operator;
    rate = operator.rate;
    onAmountChanged();
    getDataPlans();
    notifyListeners();
  }

  void onSelectPlan(OperatorTypeProvider plan){
    selectedPlan = plan;
    notifyListeners();
  }

  Future<void> getIntlDataCountries() async {
    gettingCountries = true;
    intlDataCountries = [];
    notifyListeners();

    try {
      final response = await intlDataRepo.getIntlDataCountries();
      intlDataCountries.addAll(response);
      gettingCountries = false;
      notifyListeners();
    } catch (e) {
      gettingCountries = false;
      notifyListeners();
    }
  }

  Future<void> getIntlDataOperators() async {
    gettingOperators = true;
    intlDataOperators = [];
    notifyListeners();
    try {
      final response =
          await intlDataRepo.getIntlDataOperator(selectedCountry?.iso2 ?? "");
      intlDataOperators.addAll(response);
      gettingOperators = false;
      notifyListeners();
    } catch (e) {
      gettingOperators = false;
      notifyListeners();
    }
  }

  Future<void> getDataPlans() async {
    gettingPlans = true;

    notifyListeners();
    try {
      final res = await intlDataRepo.getIntlDataPlans(
        selectedOperator?.id ?? "",
      );
      allPlans = [];
      allPlans.addAll(res);

      gettingPlans = false;
      //groupPlansByDays(allPlans);
      notifyListeners();
    } catch (e) {
      gettingPlans = false;
      notifyListeners();
    }
  }

  Future<void> buyInternationalData(String pin,
      {Function(ServiceTxn)? onSuccess, Function(String)? onError}) async {
    try {
      final response = await intlDataRepo.buyIntlData(
          code: selectedPlan?.code??"",
          phone: phoneController.text,
          provider: selectedOperator!.code,
          pin: pin);
      onSuccess?.call(response);
    } catch (e) {
      onError?.call(e.toString());
    }
  }
}
