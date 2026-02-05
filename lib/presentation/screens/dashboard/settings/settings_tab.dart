import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../misc/custom_components/custom_bottom_sheet.dart';
import 'logout_confirmation/logout_confirmation.dart';
import 'misc/settings_icon_tab.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Settings', canPop: false,),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 24.h),
        child: Column(
          spacing: 8.h,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            //
            SettingsIconTab(
                onTap: () {
                  Navigator.pushNamed(context, RoutesManager.generalSettings);
                },
                text: "General Settings",
                shortDesc: 'Profile, Account Closure ',
                img: 'user'),
            
            SettingsIconTab(
                onTap: () {
                  Navigator.pushNamed(context, RoutesManager.security);
                },
                text: "Security",
                shortDesc: 'Password, PIN, Two-Factor',
                img: 'security-icon'),
           
            
            SettingsIconTab(
                onTap: () {
                  //
                  Navigator.pushNamed(context, RoutesManager.support);
                },
                text: "Support",
                shortDesc: "Call us, Email, WhatsApp",
                img: 'support-icon'),
            
            SettingsIconTab(
                onTap: () {
                  Navigator.pushNamed(context, RoutesManager.rewards);
                },
                text: "Invite a Friend",
                shortDesc: "Invite friends and earn rewards",
                img: 'profile-icon'),
           
            SettingsIconTab(
                onTap: () {
                  Navigator.pushNamed(context, RoutesManager.pushNotification);
                },
                text: "Notifications",
                shortDesc: "Notifications settings",
                img: 'notification'),

              SettingsIconTab(
                onTap: () {
                  Navigator.pushNamed(context, RoutesManager.addedBanks);
                },
                text: "Bank Account",
                shortDesc: "Transfers, Cards, Withdraw",
                img: 'bank-icon'),
          SettingsIconTab(
                onTap: () {
                  Navigator.pushNamed(context, RoutesManager.faqs);
                },
                text: "FAQs",
                shortDesc: "FAQs",
                img: 'help'),
            
          
            SettingsIconTab(
                onTap: () {
                  showCustomBottomSheet(
                    context: context,
                    
                    screen: const LogoutConfirmation(),
                    isDismissible: true,
                  );
                },
                text: "Log Out",
                shortDesc: "Log Out from this account",
                hasNavIcon: false,
                img: 'log-out'),

                Center(child: Text('App version 2.0.0', style: get12TextStyle().copyWith(color: ColorManager.kGreyColor.withValues(alpha: .7)),)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 2,
                        children: [
                          Text('Bank-Level Security',style: get12TextStyle().copyWith(color: ColorManager.kGreyColor.withValues(alpha: .7)),),
                          Icon(Icons.verified_user, size: 12.sp, color: ColorManager.kDeepgreen,)
                        ],
                      )
    
          ],
        ),
      ),
    );
  }
}
