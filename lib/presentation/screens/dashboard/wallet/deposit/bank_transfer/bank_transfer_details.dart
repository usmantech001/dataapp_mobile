import 'dart:async';

import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/core/utils/utils.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/model/core/virtual_account_provider.dart';
import '../../../../../../core/model/core/virtual_bank_detail.dart';
import '../../../../../../core/providers/user_provider.dart';
import '../../../../../misc/color_manager/color_manager.dart';
import '../../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../../misc/custom_components/custom_elements.dart';
import '../../../../../misc/custom_components/custom_empty_state.dart';
import '../../../../../misc/custom_components/custom_key_value_state.dart';
import '../../../../../misc/custom_components/custom_scaffold.dart';
import '../../../../../misc/custom_components/loading.dart';
import '../../../../../misc/custom_snackbar.dart';
import '../../../../../misc/image_manager/image_manager.dart';
import '../../../../../misc/style_manager/styles_manager.dart';
import '../deposit_3.dart';

class BankTransferDetails extends StatefulWidget {
  final BankTransferDetailsArg param;
  const BankTransferDetails({super.key, required this.param});

  @override
  State<BankTransferDetails> createState() => _BankTransferDetailsState();
}

class _BankTransferDetailsState extends State<BankTransferDetails> {
  ScrollController controller = ScrollController();

  bool loading = true;
  VirtualBankDetail? bank;

  Future<void> fetchBank() async {
    await ServicesHelper.fundWallet(
      provider: widget.param.deposit3Arg.provider.name,
      amount: widget.param.deposit3Arg.amount,
      method: widget.param.providerOption.code,
    ).then((nuban) {
      bank = VirtualBankDetail.fromMap(nuban);
      startTimer(bank!);
    }).catchError((err) {
      if (mounted)
        showCustomToast(context: context, description: err.toString());
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

  //
  late Timer _timer;
  String _timeString = '';
  startTimer(VirtualBankDetail bk) {
    DateTime expiredAt = bk.expired_at ?? DateTime(1999);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (DateTime.now().isAfter(expiredAt)) {
        setState(() {
          _timeString = 'Expired';
          _timer.cancel();
        });
      } else {
        setState(() {
          Duration difference = expiredAt.difference(DateTime.now());
          _timeString =
              '${(difference.inMinutes % 60).toString().padLeft(2, '0')}:${(difference.inSeconds % 60).toString().padLeft(2, '0')}';
        });
      }
    });
  }

  @override
  void dispose() {
    try {
      controller.dispose();
      _timer.cancel();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            capitalize(
                                "${widget.param.deposit3Arg.provider.name} ${widget.param.providerOption.name}"),
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
                      child: bank == null
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
                                      CustomKeyValueState(
                                          title: "Bank Name",
                                          desc: bank!.bank_name),
                                      CustomKeyValueState(
                                        title: "Bank Account Number",
                                        desc: "",
                                        descW: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(bank!.account_number,
                                                textAlign: TextAlign.right,
                                                style: get12TextStyle()),
                                            Gap(5),
                                            GestureDetector(
                                              onTap: () {
                                                Clipboard.setData(ClipboardData(
                                                    text:
                                                        bank!.account_number));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          "Account number copied to clipboard")),
                                                );
                                              },
                                              child: Image.asset(
                                                "assets/images/copy-icon.png",
                                                width: 26,
                                                height: 26,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      CustomKeyValueState(
                                        title: "Bank Account Name",
                                        desc: bank!.account_name,
                                      ),
                                      CustomKeyValueState(
                                        title: "Amount",
                                        desc: formatCurrency(
                                          widget.param.deposit3Arg.amount,
                                        ),
                                      ),

                                      // CustomKeyValueState(title: "Service Charge", desc: "N0.00"),
                                    ],
                                  ),
                                ),
                                //

                                Center(
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 18),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: ColorManager.kPrimaryLight,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                            CupertinoIcons
                                                .exclamationmark_circle_fill,
                                            color: ColorManager.kPrimary,
                                            size: 17),
                                        const SizedBox(width: 5),
                                        RichText(
                                          text: TextSpan(
                                            style: get12TextStyle().copyWith(),
                                            children: _timeString != "Expired"
                                                ? [
                                                    const TextSpan(
                                                        text:
                                                            "The account expires in: "),
                                                    TextSpan(
                                                      text: _timeString
                                                              .isNotEmpty
                                                          ? " $_timeString"
                                                          : " ${DateFormat('mm:ss').format(bank?.expired_at ?? DateTime(1999))}",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: ColorManager
                                                            .kPrimary,
                                                      ),
                                                    )
                                                  ]
                                                : [
                                                    TextSpan(
                                                      text: "Account Expired",
                                                      style: TextStyle(
                                                          color: ColorManager
                                                              .kTextDark,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 70),
                                CustomButton(
                                  text: "I have made the transfer",
                                  isActive: _timeString != "Expired",
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

class BankTransferDetailsArg {
  final Deposit3Arg deposit3Arg;
  final VirtualAccProviderPaymentOptions providerOption;

  BankTransferDetailsArg(
      {required this.deposit3Arg, required this.providerOption});
}
