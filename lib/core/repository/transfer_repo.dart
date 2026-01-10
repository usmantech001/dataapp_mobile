import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/core/model/core/service_txn.dart';
import 'package:dataplug/core/model/core/user.dart';

class TransferRepo {
  

  Future<User> verifyInAppTransferBeneficiaryDetails(String beneficiary) async{
    return await ServicesHelper.verifyInAppTransferBeneficiaryDetails(beneficiary);
  }

  Future<ServiceTxn> transfer({
    required String beneficiary,
    required String amount,
    required String pin,
  }) async{
    return await ServicesHelper.inAppTransfer(beneficiary: beneficiary, amount: amount, pin: pin);
  }
}