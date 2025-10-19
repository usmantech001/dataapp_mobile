import 'dart:io';

import 'package:dataplug/presentation/screens/dashboard/history/history_tab.dart';
import 'package:dataplug/presentation/screens/dashboard/home/home_tab.dart';
import 'package:dataplug/presentation/screens/dashboard/referrals/referral_tab.dart';
import 'package:dataplug/presentation/screens/dashboard/services/services_tab.dart';
import 'package:dataplug/presentation/screens/dashboard/settings/settings_tab.dart';
import 'package:flutter/material.dart';

import '../../presentation/misc/color_manager/color_manager.dart';
import '../../presentation/misc/image_manager/image_manager.dart';
import '../../presentation/misc/style_manager/styles_manager.dart';
import '../../presentation/screens/dashboard/card/card_tab.dart';
import '../enum.dart';
import '../utils/utils.dart';

class DashboardTabsItems {
  final String name;
  final String inactiveUrl;
  final double height;
  final double width;
  final DashboardTabs dashboardTabs;

  DashboardTabsItems(
      {required this.name,
      required this.inactiveUrl,
      required this.height,
      required this.width,
      required this.dashboardTabs});

  static List<DashboardTabsItems> data = [
    DashboardTabsItems(
      name: "Home",
      inactiveUrl: ImageManager.kHomeTab,
      width: 24,
      height: 24,
      dashboardTabs: DashboardTabs.home,
    ),
    DashboardTabsItems(
      name: "Services",
      inactiveUrl: ImageManager.kServiceTab,
      width: 24,
      height: 24,
      dashboardTabs: DashboardTabs.services,
    ),
    DashboardTabsItems(
      name: "Cards",
      inactiveUrl: ImageManager.kCardTab,
      width: 24,
      height: 24,
      dashboardTabs: DashboardTabs.cards,
    ),
    DashboardTabsItems(
      name: "Referrals",
      inactiveUrl: ImageManager.kReferralTab,
      width: 24,
      height: 24,
      dashboardTabs: DashboardTabs.referrals,
    ),
    DashboardTabsItems(
      name: "Settings",
      inactiveUrl: ImageManager.kSettingsTab,
      width: 24,
      height: 24,
      dashboardTabs: DashboardTabs.settings,
    ),
  ];

  static Widget renderCurrentPage(DashboardTabs tabs) {
    switch (tabs) {
      case DashboardTabs.home:
        return const HomeTab();
      case DashboardTabs.services:
        return const ServiceTab();
      case DashboardTabs.cards:
        return const CardTab();
      case DashboardTabs.referrals:
        return const ReferralTab();
      case DashboardTabs.settings:
        return const SettingsTab();
      default:
        return const SizedBox();
    }
  }

  //
  static Widget renderCurrentHeader(BuildContext context,
      {required DashboardTabs tabs}) {
    Widget title = Padding(
      padding: const EdgeInsets.only(bottom: 25, top: 21),
      child: Text(
        capitalizeFirstString(enumToString(tabs)),
        style: get20TextStyle().copyWith(color: ColorManager.kWhite),
      ),
    );

    //
    switch (tabs) {
      case DashboardTabs.home:
        return HomeTab.buildHeader(context);
      case DashboardTabs.services:
        return title;
      case DashboardTabs.history:
        // return title;
        return HistoryTab.buildHeader(context, tabs: tabs);
      case DashboardTabs.referrals:
        return title;
         case DashboardTabs.cards:
        return title;
      case DashboardTabs.settings:
        return title;
      default:
        return const SizedBox();
    }
  }

  static Color getBottomBarColor(DashboardTabs tabs) {
    // switch (tabs) {
    //   case DashboardTabs.eCurrency:
    //   case DashboardTabs.giftcard:
    //   case DashboardTabs.referrals:
    //   case DashboardTabs.dashboard:
    //     return ColorManager.kFormBg;
    //   default:
    return ColorManager.kWhite;
    // }
  }

  static double getBottomSheetHieght(BuildContext context) =>
      (Platform.isIOS && MediaQuery.of(context).size.height <= 740) ? 58 : 78;
  static double getDasboardTabTopPadding = 20;
}
