import 'package:dataplug/core/model/core/banner.dart';
import 'package:dataplug/core/model/core/service_txn.dart';
import 'package:dataplug/core/repository/wallet_repo.dart';
import 'package:dataplug/core/utils/formatters.dart';
import 'package:flutter/widgets.dart';

class WalletController extends ChangeNotifier {
  WalletRepo walletRepo;

  WalletController({required this.walletRepo});

  String balance = '0';

  String? balanceErrMsg;
  String? bannersErrMsg;

  bool gettingBalance = false;
  bool isBalanceVisible = true;
  bool gettingBanners = false;

  List<Banners> banners = [];

  final amountController = TextEditingController();

  void clearData(){
    amountController.clear();
    selectedSuggestedAmount = null;
    notifyListeners();
  }

  String? selectedSuggestedAmount;
  void onAmountChanged(num amount) {
    amountController.text = formatCurrency(amount, decimal: 0);
  }

  void onSuggestedAmountSelected(String amount) {
    selectedSuggestedAmount = amount;
    onAmountChanged(num.tryParse(amount) ?? 0);
    notifyListeners();
  }

  void toggleBalanceVisibility() {
    isBalanceVisible = !isBalanceVisible;
    notifyListeners();
  }

  Future<void> getWalletBalance() async {
    balanceErrMsg = null;
    gettingBalance = false;
    notifyListeners();
    try {
      final res = await walletRepo.getWalletBalance();
      balance = res;
      gettingBalance = false;
      notifyListeners();
    } catch (e) {
      balanceErrMsg = e.toString();
      gettingBalance = false;
      notifyListeners();
    }
  }

  Future<void> getBanners() async {
    gettingBanners = true;
    bannersErrMsg = null;
    notifyListeners();
    try {
      final res = await walletRepo.getBanners();
      banners.addAll(res);
      gettingBanners = false;
      notifyListeners();
    } catch (e) {
      balanceErrMsg = e.toString();
      gettingBanners = false;
      notifyListeners();
    }
  }

  Future<void> withdraw(String pin,
      {Function(ServiceTxn)? onSuccess, Function(String)? onError}) async {
    try {
      final response = await walletRepo.withdraw(
          bankAccountId: '', amount: amountController.text.trim(), pin: pin);
      onSuccess?.call(response);
    } catch (e) {
      onError?.call(e.toString());
    }
  }
}
