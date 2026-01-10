import 'package:dataplug/core/enum.dart';
import 'package:dataplug/core/model/core/referral.dart';
import 'package:dataplug/core/repository/rewards_repo.dart';
import 'package:flutter/material.dart';

class RewardsController extends ChangeNotifier {
  RewardsRepo rewardsRepo;

  RewardsController({required this.rewardsRepo});

  int leaderboardCurrentIndex = 0;
  ReferralInfo? referralInfo;

  void onTabChange(int index){
    leaderboardCurrentIndex = index;
    notifyListeners();
  }

  Future<void> getReferrals() async{
    try {
      final res = rewardsRepo.getReferrals(ReferralStatus.all);
    } catch (e) {
      
    }
  }

  Future<void> getReferralInfo() async{
    try {
      final res = await rewardsRepo.getReferralInfo();
      referralInfo = res;
      notifyListeners();
      print('...the referral info are $referralInfo');
    } catch (e) {
      
    }
  }

}