
import 'package:dataplug/core/helpers/auth_helper.dart';
import 'package:dataplug/core/model/core/banner.dart';
import 'package:dataplug/core/model/core/service_txn.dart';
import 'package:dataplug/core/model/core/user.dart';
import 'package:dataplug/core/model/core/virtual_account_provider.dart';
import 'package:dataplug/core/model/core/virtual_bank_detail.dart';
import 'package:dataplug/core/repository/wallet_repo.dart';
import 'package:dataplug/core/utils/formatters.dart';
import 'package:flutter/widgets.dart';

class WalletController extends ChangeNotifier {
  WalletRepo walletRepo;

  WalletController({required this.walletRepo});

  String balance = '0';

  String? balanceErrMsg;
  String? bannersErrMsg;
  String? virtualAccProviderErrMsg;

  bool gettingBalance = false;
  bool isBalanceVisible = true;
  bool gettingBanners = false;
  bool gettingVirtualAccs = false;
  bool gettingVirtualAccsProvider = false;

  int selectedFundingMethodIndex = 0;

  List<Banners> banners = [];

  List<VirtualBankDetail> virtualAccounts = [];
  List<VirtualAccountProvider> virtualAccProviders = [];

  final amountController = TextEditingController();

  // bvn validation details
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final bvnController = TextEditingController();
  final dobController = TextEditingController();

  String? staticAccProvider;

  void onStaticProviderSelected(String value){
    print('..provider $value');
    staticAccProvider = value;
  }

  void onSelectFundingMethod(int index){
    selectedFundingMethodIndex =index;
  }

  void clearData() {
    amountController.clear();
    selectedSuggestedAmount = null;
    notifyListeners();
  }

  void onSelectDOB(String dob) {
    dobController.text = dob;
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

  Future<void> validateID({Function? onSuccess, Function(String)? onError}) async {
    try {
      await walletRepo.validateID(
          number: bvnController.text.trim(),
          dob: dobController.text,
          fName: firstNameController.text.trim(),
          lName: lastNameController.text.trim());
          onSuccess?.call();
    } catch (e) {
      onError?.call(e.toString());

    }
  }

  Future<void> validateIDOTP(String otp, {Function? onSuccess, Function(String)? onError}) async{
    try {
      final response = await walletRepo.validateIDOTP(otp: otp, type: 'bvn');
      User user = User.fromMap(response);
      AuthHelper.updateSavedUserDetails(user);
      onSuccess?.call();
    } catch (e) {
      onError?.call(e.toString());
    }
  }

   Future<void> generateStaticAccount({Function? onSuccess, Function(String)? onError}) async{
    try {
      final response = await walletRepo.generateStaticAccount(staticAccProvider??"");
      onSuccess?.call();
    } catch (e) {
      onError?.call(e.toString());
    }
  }

  Future<void> getStaticAccounts() async {
    gettingVirtualAccs = true;
    notifyListeners();
    try {
      final response = await walletRepo.getStaticAccounts();
      if(response!=null){
        print('..virtual accounts is $response');
        virtualAccounts.addAll(response);
        
      }
      gettingVirtualAccs = false;
    notifyListeners();
    } catch (e) {
      gettingVirtualAccs = false;
    notifyListeners();
     
    }
  }

  Future<void> getVirtualAccountProviders() async {
    gettingVirtualAccsProvider = true;
    notifyListeners();
    try {
      virtualAccProviders = [];
      final response = await walletRepo.getVirtualAccountProviders();
      virtualAccProviders.addAll(response);
      gettingVirtualAccsProvider = false;
    notifyListeners();
    } catch (e) {
      gettingVirtualAccsProvider = false;
    notifyListeners();

    }
  }

  Future<void> fundWallet({Function(VirtualAccountDetails)? onSuccess, Function(String)? onError}) async{
    try {
      num amount = num.tryParse(formatUseableAmount(amountController.text.trim()))??0;
      final res = await walletRepo.fundWallet(provider: virtualAccProviders[selectedFundingMethodIndex].name, amount: amount, method: 'bank_transfer');
      print('...funding details $res');
      final details = VirtualAccountDetails.fromJson(res);
      onSuccess?.call(details);
    } catch (e) {
      onError?.call(e.toString());
    }
  }
}
