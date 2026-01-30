import 'package:dataplug/core/enum.dart';
import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../helpers/user_helper.dart';
import '../model/core/service_txn.dart';
import '../model/core/user.dart';
import '../model/core/user_bank.dart';
import '../services/secure_storage.dart';

class UserProvider with ChangeNotifier {
  UserProvider() {
    setBalanceVisibility();
  }

  User? _user;
  User get user => _user!;
  void updateUser(User? el) {
    _user = el;
    notifyListeners();
  }

  Future<void> updateUserInfo() async {
    try {
      // await Future.wait([updateServiceTxn(), updateRecentTxns()])
      //     .catchError((_) {});
      User res = await UserHelper.getProfileInfo();
      _user = res;
      notifyListeners();
    } catch (e) {
      debugPrint("An error occured ::$e");
    }
  }

  // Saved Banks
  List<UserBank> _savedBanks = [];
  List<UserBank> get savedBanks => _savedBanks;
  Future<void> updateAddedBanks() async {
    await UserHelper.getUsersBank().then((value) {
      _savedBanks = value;
      notifyListeners();
    }).catchError((_) {});
  }

  // Notification
  bool _unreadNotificationAvailable = false;
  bool get unreadNotificationAvailable => _unreadNotificationAvailable;
  Future<void> checkUnreadNotification() async {
    String query = "&page=1&filter[read]=0";
    await UserHelper.getNotification("1", filter: query).then((value) {
      if (value.isNotEmpty) {
        _unreadNotificationAvailable = true;
      } else {
        _unreadNotificationAvailable = false;
      }
      notifyListeners();
    }).catchError((_) {});
  }

  //

  //REFERRAL
  num? _inactiveReferrals;
  num? get inactiveReferrals => _inactiveReferrals;

  num? _activeReferrals;
  num? get activeReferrals => _activeReferrals;

  num? _totalReferrals;
  num? get totalReferrals => _totalReferrals;

  num? _totalReferralsEarnings;
  num? get totalReferralsEarnings => _totalReferralsEarnings;

  Future<void> updateReferralsInfo() async {
    await UserHelper.getReferralInfo().then((val) {
      _inactiveReferrals = 0;
      _activeReferrals = 0;
      _totalReferrals = num.tryParse(val.totalReferrals) ?? 0;
      _totalReferralsEarnings =
          num.tryParse(val.totalEarnings) ?? 0;

      notifyListeners();
    }).catchError((e) {});
  }

  // BALANCE VISIBILITY
  bool balanceVisible = true;
  Future<void> toggleBalanceVisibility() async {
    balanceVisible = !balanceVisible;
    notifyListeners();
    SecureStorage sS = await SecureStorage.getInstance();
    sS.setBool(Constants.kBalanceVisibilityKey, balanceVisible);
  }

  Future<void> setBalanceVisibility() async {
    SecureStorage sS = await SecureStorage.getInstance();
    balanceVisible = sS.getBool(Constants.kBalanceVisibilityKey) ?? true;
    notifyListeners();
  }

  ////////////////////////////////////// TRANSACTION HISTORY MNGT. ////////////////////////////////////////////////////////////////
  List<ServiceTxn> _recentTxns = [];
  List<ServiceTxn> get recentTxns => _recentTxns;
  

  //
  int _serviceTxnPage = 1;
  bool _txnPaginating = false;
  bool get txnPaginating => _txnPaginating;
  List<ServiceTxn> _serviceTxn = [];
  List<ServiceTxn> get serviceTxn => _serviceTxn;

  // Future<void> updateServiceTxn({bool forceRefresh = true}) async {
  //   if (txnPaginating) return;

  //   if (!forceRefresh) {
  //     _txnPaginating = true;
  //     await Future.delayed(const Duration(milliseconds: 10));
  //     notifyListeners();
  //   }

  //   await ServicesHelper.getServiceTxns(
  //           page: (forceRefresh) ? 1 : _serviceTxnPage, perPage: 10)
  //       .then((dt) {
  //     if (forceRefresh) {
  //       _serviceTxnPage = 2;
  //       _serviceTxn = dt;
  //     } else {
  //       _serviceTxn.addAll(dt);
  //       if (dt.isNotEmpty) _serviceTxnPage = _serviceTxnPage + 1;
  //     }
  //   }).catchError((_) {});

  //   _txnPaginating = false;
  //   notifyListeners();
  // }

  ////////////////////// TXN FILTERS //////////////////////
  CashFlowType? _filterCashFlowType;
  CashFlowType? get filterCashFlowType => _filterCashFlowType;
  ServicePurpose? _filterPurpose;
  ServicePurpose? get filterPurpose => _filterPurpose;
  Status? _filterStatus;
  Status? get filterStatus => _filterStatus;
  DateTime? _filterStartDate;
  DateTime? get filterStartDate => _filterStartDate;
  DateTime? _filterEndDate;
  DateTime? get filterEndDate => _filterEndDate;

  bool _txnFilterActive = false;
  bool get txnFilterActive => _txnFilterActive;
  bool _historyPageLoading = false;
  bool get historyPageLoading => _historyPageLoading;

  List<ServiceTxn> get serviceTxnBasedOnActiveOrInActiveFilter =>
      txnFilterActive ? _filteredServiceTxn : _serviceTxn;

  int _filterTxnPage = 1;
  List<ServiceTxn> _filteredServiceTxn = [];
  List<ServiceTxn> get filteredServiceTxn => _filteredServiceTxn;


/*
  Future<void> fetchFilteredServiceTxn({
    bool forceRefresh = true,
    bool showLoader = false,
    Status? status,
    ServicePurpose? purpose,
    CashFlowType? cashFlowType,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    //

    if (txnPaginating) return;

    if (cashFlowType == null &&
        purpose == null &&
        status == null &&
        startDate == null &&
        endDate == null) return;

    if (!forceRefresh) {
      _txnPaginating = true;
      await Future.delayed(const Duration(milliseconds: 5));
      notifyListeners();
    }

    if (showLoader) {
      _historyPageLoading = true;
      await Future.delayed(const Duration(milliseconds: 5));
      notifyListeners();
    }

    //
    await ServicesHelper.getServiceTxns(
      page: (forceRefresh) ? 1 : _filterTxnPage,
      cashFlowType: cashFlowType,
      //status: status,
      //purpose: purpose,
      startDate: startDate,
      endDate: endDate,
    ).then((dt) {
      //

      if (forceRefresh) {
        _filterTxnPage = 2;
        _filteredServiceTxn = dt;
      } else {
        _filteredServiceTxn.addAll(dt);
        if (dt.isNotEmpty) _filterTxnPage = _filterTxnPage + 1;
      }

      _filterStatus = status;
      _filterPurpose = purpose;
      _filterCashFlowType = cashFlowType;
      _filterStartDate = startDate;
      _filterEndDate = endDate;
      _txnFilterActive = true;
      //
      //
    }).catchError((_) {
      print("Error $_");
    });

    _txnPaginating = false;
    _historyPageLoading = false;
    notifyListeners();
  }
  */

  resetTxnFilter({
    required Status? status,
    required ServicePurpose? purpose,
    required CashFlowType? cashFlowType,
    required DateTime? startDate,
    required DateTime? endDate,
    bool preventRefresh = false,
  }) {
    _filterStatus = status;
    _filterPurpose = purpose;
    _filterCashFlowType = cashFlowType;

    if (startDate == null || endDate == null) {
      _filterStartDate = startDate;
      _filterEndDate = endDate;
    }

    if (filterCashFlowType == null &&
        filterPurpose == null &&
        filterStatus == null &&
        filterStartDate == null &&
        filterEndDate == null) {
      clearTxnFilter();
    } else {
      if (preventRefresh) return;
      // fetchFilteredServiceTxn(
      //   forceRefresh: true,
      //   showLoader: true,
      //   cashFlowType: filterCashFlowType,
      //   status: filterStatus,
      //   purpose: filterPurpose,
      //   startDate: filterStartDate,
      //   endDate: filterEndDate,
      // );
    }
  }

  void clearTxnFilter() {
    _filterTxnPage = 1;
    _filteredServiceTxn = [];
    _txnFilterActive = false;

    _filterCashFlowType = null;
    _filterPurpose = null;
    _filterStatus = null;
    _filterStartDate = null;
    _filterEndDate = null;

    notifyListeners();
  }
}
