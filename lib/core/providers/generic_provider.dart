import 'package:flutter/material.dart';
import '../../presentation/misc/custom_snackbar.dart';
import '../model/core/referral_term.dart';

import '../enum.dart';
import '../helpers/generic_helper.dart';
import '../model/core/bank.dart';
import '../model/core/banner.dart';
import '../model/core/country.dart';
import '../model/core/service_charge.dart';
import '../model/core/service_status.dart';
import '../model/core/state.dart';

class GenericProvider with ChangeNotifier {
  List<Bank> _banks = [];
  List<Bank> get banks => _banks;
  Future<void> updateBankList() async {
    await GenericHelper.getBankList().then((value) {
      if (value.isEmpty) return;
      _banks = value;
      notifyListeners();
    }).catchError((e) {/*  recordError(); */});
  }

  //SUPPORT
  String? _supportPhone;
  String? get supportPhone => _supportPhone;

  String? _supportWhatsapp;
  String? get supportWhatsapp => _supportWhatsapp;

  String? _supportEmail;
  String? get supportEmail => _supportEmail;

  Future<void> updateSupportInfo() async {
    await GenericHelper.getSupportInfo().then((value) {
      _supportPhone = value["phone"];
      _supportWhatsapp = value["whatsapp"];
      _supportEmail = value["email"];
      notifyListeners();
    }).catchError((e) {
      debugPrint("error $e");
    });
  }

  // Countries
  List<Country> _countries = [];
  List<Country> get countries => _countries;
  Future<List<Country>> updateCountries() async {
    return await GenericHelper.getCountries().then((value) {
      _countries = value;
      notifyListeners();
      return _countries;
    }).catchError((e) {
      return ([] as List<Country>);
    });
  }

  List<AppState> _state = [];
  List<AppState> get state => _state;
  Future<void> updateState(String id) async {
    await GenericHelper.getState(id).then((value) {
      _state = value;
    }).catchError((e) {
      _state = [];
    });
    notifyListeners();
  }

  List<Banners> _banners = [];
  List<Banners> get banners => _banners;
  Future<List<Banners>> updateBanners() async {
    return await GenericHelper.getBanners().then((value) {
      _banners = value;
      notifyListeners();
      return _banners;
    }).catchError((e) {
      return ([] as List<Banners>);
    });
  }

  ReferralTerm? _refTerm;
  ReferralTerm? get refTerm => _refTerm;

  Future<ReferralTerm?> getRefTerm() async {
    try {
      final result = await GenericHelper.getReferralTerm();
      _refTerm = result;
      notifyListeners();
      return _refTerm;
    } catch (e) {
      // Optionally log the error
      print("Error fetching referral term: $e");
      return null;
    }
  }

  DashboardTabs _currentPage = DashboardTabs.home;
  DashboardTabs get currentPage => _currentPage;
  void updatePage(DashboardTabs e) {

      _currentPage = e;
      notifyListeners();
    
  }

  ServiceCharge? _serviceCharge;
  ServiceCharge? get serviceCharge => _serviceCharge;
  Future<ServiceCharge?> getServiceCharge() async {
    return await GenericHelper.serviceCharge().then((value) {
      _serviceCharge = value;
      notifyListeners();

      return _serviceCharge;
    }).catchError((e) {
      return (ServiceCharge());
    });
  }

  ServiceStatus? _serviceStatus;
  ServiceStatus? get serviceStatus => _serviceStatus;
  Future<ServiceStatus?> getServiceStatus() async {
    return await GenericHelper.serviceStatus().then((value) {
      _serviceStatus = value;
      notifyListeners();
      return _serviceStatus;
    }).catchError((e) {
      return (ServiceStatus());
    });
  }
}
