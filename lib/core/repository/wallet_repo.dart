import 'package:dataplug/core/helpers/generic_helper.dart';
import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/core/model/core/banner.dart';
import 'package:dataplug/core/model/core/service_txn.dart';
import 'package:dataplug/core/model/core/virtual_account_provider.dart';
import 'package:dataplug/core/model/core/virtual_bank_detail.dart';


class WalletRepo {
  
  Future<String> getWalletBalance() async{
    return await ServicesHelper.getWalletBalance();
  }

  Future<List<Banners>> getBanners() async{
    return await GenericHelper.getBanners();
  }

  Future<ServiceTxn> withdraw({
    required String bankAccountId,
    required String amount,
    required String pin,
  }) async{
    return await ServicesHelper.makeWithdrawal(bank_account_id: bankAccountId, amount: amount, pin: pin);
  }

  Future<Map<String, dynamic>> validateID({
      // required String type,
      required String number,
      required String dob,
      required String fName,
      required String lName}) async{
    return await ServicesHelper.validateBVN(number: number, dob: dob, fName: fName, lName: lName);
  }

  Future<List<VirtualBankDetail>?> getStaticAccounts() async{
    return await ServicesHelper.getVirtualAccount();
  }

  Future<List<VirtualAccountProvider>> getVirtualAccountProviders() async{
    return await ServicesHelper.getVirtualAccountProviders();
  }

  Future<Map<String, dynamic>> validateIDOTP({
      // required String type,
      required String otp,
      required String type,}) async{
    return await ServicesHelper.validateIdentificationOTP(otp: otp, type: type);
  }

  Future<bool> requestSafeHavenOtp() async{
    return await ServicesHelper.requestSafeHavenOtp();
  }

  Future<VirtualBankDetail> generateStaticAccount(String provider) async{
    return await ServicesHelper.generateVirtualAccount(provider);
  }

  Future<Map<String, dynamic>> fundWallet({
       required String provider,
      required num amount,
      required String method,}) async{
    return await ServicesHelper.fundWallet(provider: provider, amount: amount, method: method);
  }
}