import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'misc/settings_icon_tab.dart';

class GeneralSettingsScreen extends StatelessWidget {
  const GeneralSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'General Settings',),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 24.h),
        child: Column(
          spacing: 8.h,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            //
            SettingsIconTab(
                onTap: () {
                  Navigator.pushNamed(context, RoutesManager.profileSettings);
                },
                text: "Profile Settings",
                shortDesc: 'Name, Email, Address ',
                img: 'user'),
            
            SettingsIconTab(
                onTap: () {
                  Navigator.pushNamed(context, RoutesManager.closeAccount);
                },
                text: "Close Account",
                shortDesc: 'Delete your account and data',
                img: 'delete-icon'),
           
          
          ],
        ),
      ),
    );
  }
}
