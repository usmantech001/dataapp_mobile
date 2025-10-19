import 'dart:async';

import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/core/utils/utils.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../../../core/model/core/virtual_account_provider.dart';
import '../../../../../../core/providers/user_provider.dart';
import '../../../../../misc/color_manager/color_manager.dart';
import '../../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../../misc/custom_components/custom_elements.dart';
import '../../../../../misc/custom_components/custom_empty_state.dart';
import '../../../../../misc/custom_components/custom_scaffold.dart';
import '../../../../../misc/custom_components/loading.dart';
import '../../../../../misc/custom_snackbar.dart';
import '../../../../../misc/image_manager/image_manager.dart';
import '../../../../../misc/style_manager/styles_manager.dart';
import '../deposit_3.dart';

class OpayWalletDetails extends StatefulWidget {
  final OpayWalletDetailsArg param;
  const OpayWalletDetails({super.key, required this.param});

  @override
  State<OpayWalletDetails> createState() => _OpayWalletDetailsState();
}

class _OpayWalletDetailsState extends State<OpayWalletDetails> {
  ScrollController controller = ScrollController();

  bool loading = true;
  String? qrCode;

  Future<void> fetchBank() async {
    await ServicesHelper.fundWallet(
      provider: widget.param.deposit3Arg.provider.name,
      amount: widget.param.deposit3Arg.amount,
      method: widget.param.providerOption.code,
    ).then((nuban) {
      qrCode = nuban['qrcode'];
    }).catchError((err) {
      if (mounted) {
        showCustomToast(context: context, description: err.toString());
      }
    });
    loading = false;
    if (mounted) setState(() {});
  }

  //
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchBank();
    });
    super.initState();
  }

  @override
  void dispose() {
    try {
      controller.dispose();
    } catch (_) {}
    super.dispose();
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
                                    widget.param.deposit3Arg.provider.logo,
                                    borderRadius: BorderRadius.circular(35),
                                    width: 18,
                                  ),
                                ),
                              )
                            ],
                          ),

                          //
                          const SizedBox(height: 5),
                          //
                          Text(
                            capitalize(widget.param.providerOption.name),
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
                margin: const EdgeInsets.only(top: 16, bottom: 30),
                color: ColorManager.kBar2Color,
              ),

              loading
                  ? buildLoading()
                  : Expanded(
                      child: qrCode == null
                          ? RefreshIndicator(
                              color: ColorManager.kPrimary,
                              onRefresh: () => fetchBank(),
                              child: ListView(
                                children: [
                                  const SizedBox(height: 50),
                                  CustomEmptyState(
                                    btnTitle: "",
                                    onTap: () {},
                                    showBTn: false,
                                    title:
                                        "An error occured while fetching bank details.Please pull down to refresh.",
                                  )

                                  //
                                ],
                              ),
                            )
                          : ListView(
                              controller: controller,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: get14TextStyle().copyWith(
                                        color: ColorManager.kTextDark7),
                                    children: [
                                      const TextSpan(
                                          text:
                                              "You are required to make a payment of "),
                                      TextSpan(
                                        text: formatCurrency(
                                            widget.param.deposit3Arg.amount),
                                        style: TextStyle(
                                          color: ColorManager.kPrimary,
                                        ),
                                      ),
                                      const TextSpan(
                                          text:
                                              " to the account details provided below"),
                                    ],
                                  ),
                                ),

                                //
                                CustomContainer(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(top: 45),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 25),
                                  header: Text(
                                    "DETAILS",
                                    style: get14TextStyle().copyWith(
                                        color: ColorManager.kTextDark7),
                                  ),
                                  child: Column(
                                    children: [
                                      QrImageView(
                                        data: qrCode ?? "",
                                        version: QrVersions.auto,
                                        size: 250,
                                      ),
                                    ],
                                  ),
                                ),
                                //

                                const SizedBox(height: 70),
                                CustomButton(
                                  text: "I have made the transfer",
                                  isActive: true,
                                  onTap: () async {
                                    setState(() => btnLoading = true);
                                    await Provider.of<UserProvider>(context,
                                            listen: false)
                                        .updateUserInfo();
                                    setState(() => btnLoading = false);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  loading: btnLoading,
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

  bool btnLoading = false;
}

class OpayWalletDetailsArg {
  final Deposit3Arg deposit3Arg;
  final VirtualAccProviderPaymentOptions providerOption;

  OpayWalletDetailsArg(
      {required this.deposit3Arg, required this.providerOption});
}
