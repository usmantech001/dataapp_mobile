import 'package:collection/collection.dart';
import 'package:dataplug/core/enum.dart';
import 'package:dataplug/core/model/core/data_plans.dart';
import 'package:dataplug/core/model/core/data_provider.dart';
import 'package:dataplug/core/model/core/service_txn.dart';
import 'package:dataplug/core/repository/data_repo.dart';
import 'package:flutter/material.dart';

class DataController extends ChangeNotifier {
  DataRepo dataRepo;

  DataController({required this.dataRepo});

  List<String> dataTypes = ['Cheap', 'Direct'];

  List<DataProvider> providers = [];
  List<DataPlan> allPlans = [];
  List<DataPlan> durationPlans = [];

  DataProvider? selectedProvider;
  DataPlan? selectedPlan;
  //String selectedDataType ='Direct';

  bool gettingProviders = false;
  bool gettingPlans = false;
  bool isPorted = false;

  //,, String selectedType = 'Direct';
  String selectedDuration = 'All';

  final phoneNumberController = TextEditingController();

  Map<String, List<DataPlan>> plansByDays = {};

  int selectedTypeIndex = 0;

  List<String> dataPlanTypes = [];

  String? type;

  String get getDataType {
    switch (selectedTypeIndex) {
      case 0:
        return type ?? "";
      case 1:
        return 'direct';
      default:
        return 'direct';
    }
  }

  void onSelectDataType(int index) {
    // selectedDataType = type;
    selectedTypeIndex = index;
    if (selectedTypeIndex == 0) {
      getDataPlanTypes();
    } else {
      getDataPlans();
    }
    notifyListeners();
  }

  void onSelectProvider(DataProvider provider, {bool isPreSelect = true}) {
    selectedProvider = provider;
    selectedDuration = 'All';
    if (!isPreSelect) {
      if (getDataType == 'direct') {
        getDataPlans();
      } else {
        getDataPlanTypes();
      }
    }
    notifyListeners();
  }

  void onPlanSelected(DataPlan plan) {
    selectedPlan = plan;
  }

  void groupPlansByDays(List<DataPlan> plans) {
    plansByDays = {};

    plansByDays.putIfAbsent('All', () => plans);
    final res = groupBy(plans, (DataPlan e) => e.duration);

    plansByDays.addAll(res);
    //filterAllPlansByDuration(selectedDuration);

    notifyListeners();
  }

  void filterAllPlansByDuration(String duration) {
    durationPlans =
        allPlans.where((plan) => plan.duration == duration).toList();
    notifyListeners();
  }

  void onDurationChanged(String duration) {
    selectedDuration = duration;
    filterAllPlansByDuration(duration);
    notifyListeners();
  }

  void onSelectPlanType(String selectedType) {
    type = selectedType;
    getDataPlans();
    notifyListeners();
  }

  Future<void> getDataProviders({String? id, String? code}) async {
    gettingProviders = true;
    notifyListeners();
    try {
      final res = await dataRepo.getDataProviders();
      final providerList = res
          .where((service) =>
              service.code != 'smile' && service.code != 'spectranet')
          .toList();
      providers = [];
      providers.addAll(providerList);
      if (code != null) {
        final provider =
            res.where((service) => service.code == code).toList().first;
        onSelectProvider(provider);
        getDataPlans(dataType: 'direct');
      } else {
        onSelectProvider(res.first);
        getDataPlanTypes();
      }

      gettingProviders = false;

      notifyListeners();
    } catch (e) {
      gettingProviders = false;
      notifyListeners();
    }
  }

  Future<void> getDataPlans({String? dataType}) async {
    gettingPlans = true;
    //getDataPlanTypes();
    allPlans = [];
    print('...the data type is $dataType');
    notifyListeners();
    try {
      final res = await dataRepo.getDataPlans(
          provider: selectedProvider?.id ?? "", type: dataType ?? getDataType);

      allPlans.addAll(res);

      gettingPlans = false;
      groupPlansByDays(allPlans);
      notifyListeners();
    } catch (e) {
      gettingPlans = false;
      notifyListeners();
    }
  }

  Future<void> getDataPlanTypes() async {
    try {
      final response =
          await dataRepo.getDataPlanTypes(selectedProvider?.code ?? "");
      dataPlanTypes = response.reversed.toList();
      String type = dataPlanTypes.first.split(" ").last.toLowerCase();
      onSelectPlanType(type);
      getDataPlans();
      notifyListeners();
    } catch (e) {}
  }

  Future<void> buyData(String pin,
      {Function(ServiceTxn)? onSuccess, Function(String)? onError}) async {
    try {
      final response = await dataRepo.buyData(
          phone: phoneNumberController.text.trim(),
          code: selectedPlan?.code ?? "",
          provider: selectedProvider!.code,
          pin: pin,
          isPorted: isPorted,
          dataPurchaseType: getDataType);
      onSuccess?.call(response);
    } catch (e) {
      onError?.call(e.toString());
    }
  }
}
