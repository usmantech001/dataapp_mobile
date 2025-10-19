import 'package:dataplug/core/utils/utils.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/screens/dashboard/wallet/deposit/bank_transfer/bank_transfer_details.dart';
import 'package:dataplug/presentation/screens/dashboard/wallet/deposit/misc/card_prep_loader.dart';
import 'package:flutter/material.dart';

import '../../../../../core/model/core/virtual_account_provider.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../../misc/custom_components/custom_elements.dart';
import '../../../../misc/custom_components/custom_scaffold.dart';
import '../../../../misc/image_manager/image_manager.dart';
import '../../../../misc/style_manager/styles_manager.dart';
import 'misc/payment_options_card.dart';
import 'opay_wallet/opay_wallet_details.dart';

class Deposit3 extends StatefulWidget {
  final Deposit3Arg param;
  const Deposit3({super.key, required this.param});

  @override
  State<Deposit3> createState() => _Deposit3State();
}

class _Deposit3State extends State<Deposit3> {
  final spacer = const SizedBox(height: 40);
  ScrollController controller = ScrollController();

  skipScreen() {
    if (widget.param.provider.payment_options.length == 1) {
      VirtualAccProviderPaymentOptions providerOption =
          widget.param.provider.payment_options.first;

      if (providerOption.code.contains("bank")) {
        Navigator.pushNamed(
          context,
          RoutesManager.bankTransferDetails,
          arguments: BankTransferDetailsArg(
            deposit3Arg: widget.param,
            providerOption: providerOption,
          ),
        );
        return;
      }

      if (providerOption.code.contains("card")) {
        // showCustomBottomSheet(
        //   context: context,
        //   isDismissible: true,
        //   screen: CardPrepLoader(
        //     deposit3Arg: widget.param,
        //     providerOption: providerOption,
        //   ),
        // );
        return;
      }

      if (providerOption.code.contains("wallet")) {
        Navigator.pushNamed(
          context,
          RoutesManager.opayWalletDetails,
          arguments: OpayWalletDetailsArg(
            deposit3Arg: widget.param,
            providerOption: providerOption,
          ),
        );
        return;
      }
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {

      skipScreen();
    });
    super.initState();
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
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(right: 4, bottom: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: ColorManager.kPrimaryLight,
                                ),
                                padding: const EdgeInsets.all(15),
                                child: Image.asset(ImageManager.kBankIcon,
                                    width: 16),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(35),
                                      color: Colors.white),
                                  child: loadNetworkImage(
                                    widget.param.provider.logo,
                                    borderRadius: BorderRadius.circular(35),
                                    width: 18,
                                  ),
                                ),
                              )
                            ],
                          ),

                          //

                          //
                          Text(
                            capitalize(widget.param.provider.name),
                            textAlign: TextAlign.center,
                            style: get18TextStyle(),
                          ),
                        ],
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
                margin: const EdgeInsets.only(top: 16, bottom: 20),
                color: ColorManager.kBar2Color,
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  controller: controller,
                  children: [
                    //
                    Text(
                      "Kindly select your preferred ${widget.param.provider.name.toLowerCase()} funding process",
                      style: get14TextStyle()
                          .copyWith(color: ColorManager.kTextDark7),
                    ),

                    const SizedBox(height: 42),

                    for (int i = 0;
                        i < widget.param.provider.payment_options.length;
                        i++)
                      PaymentOptionsCard(
                        header: (i == 0)
                            ? null
                            : const SizedBox(width: 100, height: 10),
                        footer: (i ==
                                widget.param.provider.payment_options.length -
                                    1)
                            ? null
                            : const SizedBox(width: 100, height: 10),
                        onTap: () async {
                          VirtualAccProviderPaymentOptions providerOption =
                              widget.param.provider.payment_options[i];

                          if (providerOption.code.contains("bank")) {
                            Navigator.pushNamed(
                              context,
                              RoutesManager.bankTransferDetails,
                              arguments: BankTransferDetailsArg(
                                deposit3Arg: widget.param,
                                providerOption: providerOption,
                              ),
                            );
                            return;
                          }

                          if (providerOption.code.contains("card")) {
                            // showCustomBottomSheet(
                            //   context: context,
                            //   isDismissible: true,
                            //   screen: CardPrepLoader(
                            //     deposit3Arg: widget.param,
                            //     providerOption: providerOption,
                            //   ),
                            // );
                            return;
                          }

                          if (providerOption.code.contains("wallet")) {
                            Navigator.pushNamed(
                              context,
                              RoutesManager.opayWalletDetails,
                              arguments: OpayWalletDetailsArg(
                                deposit3Arg: widget.param,
                                providerOption: providerOption,
                              ),
                            );
                            return;
                          }
                        },
                        provider: widget.param.provider.payment_options[i],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //
}

class Deposit3Arg {
  final VirtualAccountProvider provider;
  final num amount;

  Deposit3Arg({required this.provider, required this.amount});
}
