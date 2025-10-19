import 'dart:developer';

import 'package:dataplug/presentation/misc/custom_components/custom_container.dart';
import 'package:dataplug/presentation/screens/dashboard/wallet/deposit/deposit_3.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/helpers/generic_helper.dart';
import '../../../../../core/model/core/system_bank.dart';
import '../../../../../core/model/core/virtual_account_provider.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../misc/custom_components/custom_elements.dart';
import '../../../../misc/custom_components/custom_scaffold.dart';
import '../../../../misc/custom_snackbar.dart';
import '../../../../misc/route_manager/routes_manager.dart';
import '../../../../misc/style_manager/styles_manager.dart';
import 'misc/deposit_method_card.dart';

class Deposit2 extends StatefulWidget {
  final Deposit2Arg param;
  const Deposit2({super.key, required this.param});

  @override
  State<Deposit2> createState() => _Deposit2State();
}

class _Deposit2State extends State<Deposit2> {
  final spacer = const SizedBox(height: 40);

  List<SystemBank> systemBanks = [];

  skipScreen() {
    log(widget.param.providers.length.toString(), name: "Provider's Length");
    if (widget.param.providers.length == 1) {
      Navigator.pushNamed(context, RoutesManager.deposit3,
          arguments: Deposit3Arg(
            provider: widget.param.providers.first,
            amount: widget.param.amount,
          ));
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchSystemBank();
      skipScreen();
    });
    super.initState();
  }

  Future<void> fetchSystemBank() async {
    await GenericHelper.getSystemBankList().catchError((err) {
      showCustomToast(context: context, description: err.toString());
    }).then((value) {
      if (value.isNotEmpty) systemBanks = value;
      log(value.toList().toString(), name: "");
    });
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: ColorManager.kPrimary,
      body: SafeArea(
        bottom: false,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.only(left: 15),
                      alignment: Alignment.topLeft,
                      child: const BackIcon(),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        "Top Up",
                        textAlign: TextAlign.center,
                        style: get18TextStyle(),
                      ),
                    ),
                  ),
                  const Expanded(flex: 1, child: SizedBox()),
                ],
              ),

              //

              //
              customDivider(
                height: 1,
                margin: const EdgeInsets.only(top: 16, bottom: 30),
                color: ColorManager.kBar2Color,
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  children: [
                    //
                    Text(
                      "Kindly select top up method",
                      style: get14TextStyle()
                          .copyWith(color: ColorManager.kTextDark7),
                    ),

                    const SizedBox(height: 20),
                    for (int i = 0; i < widget.param.providers.length; i++)
                      DepositMethodCard(
                        header: (i == 0)
                            ? null
                            : const SizedBox(width: 100, height: 10),
                        footer: const SizedBox(width: 100, height: 10),
                        showNextArrow: true,
                        showBankIcon: true,
                        onTap: () {
                          Navigator.pushNamed(context, RoutesManager.deposit3,
                              arguments: Deposit3Arg(
                                provider: widget.param.providers[i],
                                amount: widget.param.amount,
                              ));
                        },
                        provider: widget.param.providers[i],
                      ),

                    if (systemBanks.isNotEmpty) ...[
                      //
                      CustomContainer(
                        header: const SizedBox(width: 100, height: 10),
                        onTap: () {
                          Navigator.pushNamed(
                              context, RoutesManager.manualDepositDetail,
                              arguments: widget.param.amount);
                        },
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, top: 15, bottom: 14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(right: 4, bottom: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: ColorManager.kPrimaryLight,
                              ),
                              padding: const EdgeInsets.all(15),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: ColorManager.kPrimary,
                                    borderRadius: BorderRadius.circular(50)),
                                padding: const EdgeInsets.all(1),
                                child: const Icon(LucideIcons.plus,
                                    color: Colors.white, size: 16),
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Manual Funding",
                                        style: get14TextStyle().copyWith(
                                            fontWeight: FontWeight.w600),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1),
                                    const SizedBox(height: 3),
                                    Text(
                                      "Fund via manual admin",
                                      style: get12TextStyle(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //

                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 3, bottom: 12),
                              child: Icon(Icons.keyboard_arrow_right_sharp,
                                  color: ColorManager.kBarColor),
                            )
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 95),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Deposit2Arg {
  final List<VirtualAccountProvider> providers;
  final num amount;

  Deposit2Arg({required this.providers, required this.amount});
}
