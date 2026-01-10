import 'package:dataplug/core/helpers/generic_helper.dart';
import 'package:dataplug/core/helpers/user_helper.dart';
import 'package:dataplug/core/model/core/bank.dart';

class BankRepo {

  Future<List<Bank>> getBanks() async{
    return await GenericHelper.getBankList();
  }

  Future<String> verifyBankInfo({
    required String bankId,
    required String accountNumber,
  }) async{
    return await UserHelper.verifyBankInfo(bank_id: bankId, account_number: accountNumber);
  }

  Future<String> saveBankInfo({
    required String bankId,
    required String accountNumber,
    required String accountName,
  }) async{
    return await UserHelper.saveBankInfo(bank_id: bankId, account_number: accountNumber, account_name: accountName);
  }
}