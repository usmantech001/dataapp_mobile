import 'dart:developer';

import 'package:dataplug/gen/assets.gen.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/screens/dashboard/settings/misc/settings_icon_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants.dart';
import '../../../../../core/enum.dart';
import '../../../../../core/helpers/auth_helper.dart';
import '../../../../../core/helpers/user_helper.dart';
import '../../../../../core/model/core/user.dart';
import '../../../../../core/providers/user_provider.dart';
import '../../../../misc/custom_snackbar.dart';

class Security extends StatefulWidget {
  const Security({super.key});

  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: CustomAppbar(title: 'Security'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 24.h),
        child: Column(
          spacing: 8.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsIconTab(
                onTap: () {
                  Navigator.pushNamed(
                      context, RoutesManager.changeTransactionPin);
                },
                text: "Change Transaction PIN",
                shortDesc: 'Update your transaction PIN',
                img: 'lock-icon'),
            SettingsIconTab(
                onTap: () {
                  Navigator.pushNamed(context, RoutesManager.changePassword);
                },
                text: "Change Password",
                shortDesc: 'Update your Password',
                img: 'key'),
            SettingsIconTab(
              onTap: () {
                //
                // Navigator.pushNamed(context, RoutesManager.support);
              },
              text: "Face ID/Touch ID",
              shortDesc: "Enable Face ID/Touch ID",
              img: 'face-id',
              suffix: Transform.scale(
                transformHitTests: false,
                scale: .65,
                child: CupertinoSwitch(
                  activeColor: ColorManager.kPrimary,
                  value: userProvider.user.login_biometric_activated,
                  onChanged: (value) async {
                    print('..clicked');
                    await activateBiometric().catchError((_) {
                      showCustomToast(
                          context: context, description: _.toString());
                    });
                    if (mounted) setState(() {});
                  },
                ),
              ),
            ),
            SettingsIconTab(
              onTap: () {
                //Navigator.pushNamed(context, RoutesManager.addedBanks);
              },
              text: "Activate Login 2FA",
              shortDesc: "Activate 2FA to secure your account",
              img: 'security',
              suffix: Transform.scale(
                transformHitTests: false,
                scale: .65,
                child: CupertinoSwitch(
                  activeColor: ColorManager.kPrimary,
                  value: userProvider.user!.two_factor_enabled,
                  onChanged: (_) async {
                    try {
                      User user = await UserHelper.toggleTwoFAStatus();
                      userProvider.updateUser(user);
                      showCustomToast(
                        context: context,
                        description: "2FA toggled successfully",
                        type: ToastType.success,
                      );
                    } catch (err) {
                      showCustomToast(
                          context: context, description: err.toString());
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool activating = false;
  Future<void> activateBiometric() async {
    if (activating) return;

    setState(() => activating = true);
    await AuthHelper.toggleBiometric(Constants.kBiometricLoginKey).then((usr) {
      log(usr.transaction_biometric_activated.toString(),
          name: "Check is Transaction Biometric is enabled");
      Provider.of<UserProvider>(context, listen: false).updateUser(usr);

      AuthHelper.updateSavedUserDetails(usr);
    }).catchError((_) {
      showCustomToast(
          context: context, description: "$_", type: ToastType.error);
    });

    if (mounted) setState(() => activating = false);
  }
}
