import 'package:dataplug/core/enum.dart';
import 'package:dataplug/core/helpers/user_helper.dart';
import 'package:dataplug/core/model/core/referral.dart';

class RewardsRepo {

  Future<List<Referral>> getReferrals(ReferralStatus referalStatus) async{
    return await UserHelper.getReferrals('20', status: referalStatus);
  }

  Future<ReferralInfo> getReferralInfo() async{
    return await UserHelper.getReferralInfo();
  }
}