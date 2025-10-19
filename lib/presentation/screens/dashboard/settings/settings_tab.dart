import 'package:dataplug/core/constants.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_container.dart';
import 'package:dataplug/presentation/misc/image_manager/image_manager.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/helpers/auth_helper.dart';
import '../../../../gen/assets.gen.dart';
import '../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../misc/style_manager/styles_manager.dart';
import 'delete_account_confirmation/delete_account.dart';
import 'logout_confirmation/logout_confirmation.dart';
import 'misc/settings_icon_tab.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.kHorizontalScreenPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                "Settings",
                style: get14TextStyle().copyWith(
                  fontSize: 20,
                  color: ColorManager.kBlack,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Gap(16),
            //
            SettingsIconTab(
                onTap: () {
                  Navigator.pushNamed(context, RoutesManager.profileSettings);
                },
                text: "Profile",
                img: Assets.images.profileIcon.path),
            Divider(
              thickness: .4,
            ),
            Gap(10),
            SettingsIconTab(
                onTap: () {
                  Navigator.pushNamed(context, RoutesManager.security);
                },
                text: "Security",
                img: Assets.images.securityMenuIcon.path),
            Divider(
              thickness: .4,
            ),
            Gap(10),
            SettingsIconTab(
                onTap: () {
                  //
                  Navigator.pushNamed(context, RoutesManager.support);
                },
                text: "Support",
                img: Assets.images.supportMenu.path),
            Divider(
              thickness: .4,
            ),
            Gap(10),
            SettingsIconTab(
                onTap: () {
                  Navigator.pushNamed(context, RoutesManager.addedBanks);
                },
                text: "Bank Info",
                img: Assets.images.bankMenuIcon.path),

            Divider(
              thickness: .4,
            ),
            Gap(10),
            SettingsIconTab(
                onTap: () {
                  Navigator.pushNamed(context, RoutesManager.faqs);
                },
                text: "FAQs",
                img: Assets.images.fAQsMenuIcon.path),

            Divider(
              thickness: .4,
            ),
            Gap(10),
            SettingsIconTab(
                onTap: () {
                  showCustomBottomSheet(
                    context: context,
                    screen: const LogoutConfirmation(),
                    isDismissible: true,
                  );
                },
                text: "Log Out from this account",
                img: Assets.images.logoutIcon.path),

            const SizedBox(height: 30),

            const SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                showCustomBottomSheet(
                  context: context,
                  screen: const DeleteAccount(),
                  isDismissible: true,
                );
              },
              child: Container(
                alignment: Alignment.center,
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Color(0xffFFE1E1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Assets.icons.trash.svg(),
                    Gap(10),
                    Text(
                      "Delete Account",
                      style: get14TextStyle().copyWith(
                        fontSize: 14,
                        color: ColorManager.kError,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //
          ],
        ),
      ),
    );
  }
}
