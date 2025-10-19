import 'dart:developer';

import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_container.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_scaffold.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants.dart';
import '../../../../../core/enum.dart';
import '../../../../../core/helpers/auth_helper.dart';
import '../../../../../core/helpers/user_helper.dart';
import '../../../../../core/model/core/user.dart';
import '../../../../../core/providers/user_provider.dart';
import '../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../misc/custom_snackbar.dart';
import '../../../../misc/image_manager/image_manager.dart';
import '../misc/settings_icon_tab.dart';

class Security extends StatefulWidget {
  const Security({super.key});

  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  final spacer = const SizedBox(height: 30);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return CustomScaffold(
      backgroundColor: ColorManager.kPrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: ColorManager.kWhite,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.only(left: 15),
                            alignment: Alignment.centerLeft,
                            child: const BackIcon(),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    color: ColorManager.kPrimaryLight,
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                        image: AssetImage(
                                            ImageManager.kSecurityIcon))),
                              ),
                              //
                              Text(
                                "Security",
                                textAlign: TextAlign.center,
                                style: get18TextStyle(),
                              ),
                            ],
                          ),
                        ),
                        const Expanded(flex: 1, child: SizedBox()),
                      ],
                    ),

                    //

                    //
                    customDivider(
                      height: 1,
                      margin: const EdgeInsets.only(top: 16, bottom: 26),
                      color: ColorManager.kBar2Color,
                    ),

                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        children: [
                          //
                          CustomContainer(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RoutesManager.changeTransactionPin);
                            },
                            footer: const SizedBox(height: 20, width: 133),
                            padding: const EdgeInsets.all(20),
                            borderRadiusSize: 32,
                            child: Row(
                              children: [
                                //
                                Image.asset(ImageManager.kTxnPinIcon,
                                    width: 44),
                                const SizedBox(width: 11),

                                //
                                Text("Change Transaction PIN",
                                    style: get14TextStyle()
                                        .copyWith(fontWeight: FontWeight.w500)),
                                const Spacer(),
                                Icon(Icons.chevron_right,
                                    color: ColorManager.kBarColor)
                              ],
                            ),
                          ),

                          CustomContainer(
                            onTap: () {
                              // Navigator.pushNamed(
                              //     context, RoutesManager.changeTransactionPin);
                              Navigator.pushNamed(
                                  context, RoutesManager.changePassword);
                            },
                            footer: const SizedBox(height: 20, width: 133),
                            header: const SizedBox(height: 20, width: 133),
                            padding: const EdgeInsets.all(20),
                            borderRadiusSize: 32,
                            child: Row(
                              children: [
                                //
                                Image.asset(ImageManager.kChangePassword,
                                    width: 44),
                                const SizedBox(width: 11),

                                //
                                Text("Change Password",
                                    style: get14TextStyle()
                                        .copyWith(fontWeight: FontWeight.w500)),
                                const Spacer(),
                                Icon(Icons.chevron_right,
                                    color: ColorManager.kBarColor)
                              ],
                            ),
                          ),

                          CustomContainer(
                            footer: const SizedBox(height: 20, width: 133),
                            header: const SizedBox(height: 20, width: 133),
                            padding: const EdgeInsets.all(20),
                            borderRadiusSize: 32,
                            child: Row(
                              children: [
                                //
                                Image.asset(ImageManager.kFaceID, width: 44),
                                const SizedBox(width: 11),

                                //
                                Text("Face ID/Touch ID",
                                    style: get14TextStyle()
                                        .copyWith(fontWeight: FontWeight.w500)),
                                const Spacer(),
                                Transform.scale(
                                  transformHitTests: false,
                                  scale: .65,
                                  child: CupertinoSwitch(
                                    activeColor: ColorManager.kPrimary,
                                    value: userProvider
                                        .user.transaction_biometric_activated,
                                    onChanged: (value) async {
                                      await activateBiometric().catchError((_) {
                                        showCustomToast(
                                            context: context,
                                            description: _.toString());
                                      });
                                      if (mounted) setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          CustomContainer(
                            header: const SizedBox(height: 20, width: 133),
                            padding: const EdgeInsets.all(20),
                            borderRadiusSize: 32,
                            child: Row(
                              children: [
                                //
                                Image.asset(ImageManager.kActivateLogin2FA,
                                    width: 44),
                                const SizedBox(width: 11),

                                //
                                Text("Activate Login 2FA",
                                    style: get14TextStyle()
                                        .copyWith(fontWeight: FontWeight.w500)),
                                const Spacer(),

                                Transform.scale(
                                  transformHitTests: false,
                                  scale: .65,
                                  child: CupertinoSwitch(
                                    activeColor: ColorManager.kPrimary,
                                    value:
                                        userProvider.user!.two_factor_enabled,
                                    onChanged: (_) async {
                                      try {
                                        User user = await UserHelper
                                            .toggleTwoFAStatus();
                                        userProvider.updateUser(user);
                                        showCustomToast(
                                          context: context,
                                          description:
                                              "2FA toggled successfully",
                                          type: ToastType.success,
                                        );
                                      } catch (err) {
                                        showCustomToast(
                                            context: context,
                                            description: err.toString());
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ],
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
    await AuthHelper.toggleBiometric(Constants.kBiometricTransactionKey)
        .then((usr) {
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
