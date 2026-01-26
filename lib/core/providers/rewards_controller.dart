import 'package:dataplug/core/enum.dart';
import 'package:dataplug/core/model/core/leaderboard.dart';
import 'package:dataplug/core/model/core/referral.dart';
import 'package:dataplug/core/repository/rewards_repo.dart';
import 'package:flutter/material.dart';

class RewardsController extends ChangeNotifier {
  RewardsRepo rewardsRepo;

  RewardsController({required this.rewardsRepo});

  int leaderboardCurrentIndex = 0;
  ReferralInfo? referralInfo;

  List<Referral> referrals = [];
  List<LeaderboardItem> leaderBoardItems = [];

  bool gettingLeaderBoards = false;

  void onTabChange(int index){
    leaderboardCurrentIndex = index;
    getLeaderboard();
    notifyListeners();
  }

  Future<void> getReferrals() async{
    try {
      final res = rewardsRepo.getReferralInfo();
    } catch (e) {
      
    }
  }

  Future<void> getReferralInfo() async{
    try {
      final res = await rewardsRepo.getReferralInfo();
      referralInfo = res;
      
      //referrals.addAll(res.)
      notifyListeners();
      print('...the referral info are $referralInfo');
    } catch (e) {
      
    }
  }

  Future<void> getLeaderboard() async{
    gettingLeaderBoards = true;
    notifyListeners();
    final filter = leaderboardCurrentIndex==0? 'referrals' : 'amount';
    try {
      
      final res = await rewardsRepo.getLeaderboards(filter);
      leaderBoardItems = [];
      leaderBoardItems.addAll(res);
      gettingLeaderBoards = false;
      notifyListeners();
      print('...the referral info are $referralInfo');
    } catch (e) {
      gettingLeaderBoards = false;
      notifyListeners();
    }
  }

}