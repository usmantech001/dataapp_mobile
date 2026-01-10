import 'package:dataplug/core/providers/wallet_controller.dart';
import 'package:dataplug/core/utils/custom_image.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:dataplug/presentation/screens/dashboard/history/history_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/home/home_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/rewards/rewards_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/services/services_screen.dart';
import 'package:dataplug/presentation/screens/dashboard/settings/settings_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  final List<Widget> screens = const [
    HomeScreen(),
     ServicesScreen(),
    HistoryScreen(),
   RewardsScreen(),
    SettingsTab()
  ];
  int currentIndex = 0;

  changeIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
       final walletController = context.read<WalletController>();
      // final serviceController = context.read<ServiceController>();
      Future.wait([
        walletController.getWalletBalance(),
         walletController.getBanners(),
        // serviceController.getServicesStatus()
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        //height: 80.h,
        child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (value) => changeIndex(value),
            type: BottomNavigationBarType.fixed,
            backgroundColor: ColorManager.kWhite,
            selectedItemColor: ColorManager.kPrimary,
            unselectedItemColor: ColorManager.kGreyColor.withValues(alpha: .45),
            enableFeedback: false,
            elevation: 0.0,
            selectedLabelStyle: get12TextStyle(),
            items: [
              BottomNavigationBarItem(
                  //icon: Icon(Icons.home),
                icon:   svgImage(
                      imgPath: 'assets/icons/inactive-home-icon.svg',),
                           activeIcon:   svgImage(
                      imgPath: 'assets/icons/active-home-icon.svg',),
                  label: 'Home'),
              BottomNavigationBarItem(
                  icon:   svgImage(
                      imgPath: 'assets/icons/inactive-services-icon.svg',),
                           activeIcon:   svgImage(
                      imgPath: 'assets/icons/active-services-icon.svg',),
                  label: 'Services'),
              BottomNavigationBarItem(
                  icon:   svgImage(
                      imgPath: 'assets/icons/inactive-history-icon.svg',),
                           activeIcon:   svgImage(
                      imgPath: 'assets/icons/active-history-icon.svg',),
                  label: 'History'),
              BottomNavigationBarItem(
                  icon:   svgImage(
                      imgPath: 'assets/icons/inactive-rewards-icon.svg',),
                           activeIcon:   svgImage(
                      imgPath: 'assets/icons/active-rewards-icon.svg',),
                  label: 'Rewards'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  // svgImage(
                  //     imgPath: AppImages.settingIcon,
                  //     color: currentIndex == 4
                  //         ? AppColors.kPrimaryColor
                  //         : AppColors.kGrey66),
                  label: 'Settings'),
            ]),
      ),
      body: screens[currentIndex],
    );
  }
}
