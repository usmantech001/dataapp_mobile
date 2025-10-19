import 'package:dataplug/core/enum.dart';
import 'package:dataplug/core/model/core/system_bank.dart';
import 'package:dataplug/core/utils/utils.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_empty_state.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_scaffold.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../core/helpers/generic_helper.dart';
import '../../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../../misc/custom_components/custom_container.dart';
import '../../../../../misc/custom_components/custom_key_value_state.dart';
import '../../../../../misc/custom_components/loading.dart';
import '../../../../../misc/custom_snackbar.dart';

class ManualDepositDetail extends StatefulWidget {
  final num param;
  const ManualDepositDetail({super.key, required this.param});

  @override
  State<ManualDepositDetail> createState() => _ManualDepositDetailState();
}

class _ManualDepositDetailState extends State<ManualDepositDetail> {
  final spacer = const SizedBox(height: 30);

  bool loading = true;
  SystemBank? systemBank;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchSystemBank();
    });
    super.initState();
  }

  Future<void> fetchSystemBank() async {
    await GenericHelper.getSystemBankList().catchError((err) {
      showCustomToast(context: context, description: err.toString());
    }).then((value) {
      if (value.isNotEmpty) systemBank = value[0];
    });
    loading = false;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          flex: 2,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 13),
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

                              //
                              Text(
                                "Manual Funding",
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
                      margin: const EdgeInsets.only(top: 16, bottom: 20),
                      color: ColorManager.kBar2Color,
                    ),

                    loading
                        ? buildLoading()
                        : Expanded(
                            child: systemBank == null
                                ? RefreshIndicator(
                                    color: ColorManager.kPrimary,
                                    onRefresh: () => fetchSystemBank(),
                                    child: ListView(
                                      children: [
                                        const SizedBox(height: 50),
                                        CustomEmptyState(
                                          btnTitle: "",
                                          onTap: () {},
                                          showBTn: false,
                                          title:
                                              "Manual Funding Not Available at the moment. Pull down to refresh.",
                                        )

                                        //
                                      ],
                                    ),
                                  )
                                : ListView(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
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
                                              text:
                                                  formatCurrency(widget.param),
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

                                      //
                                      CustomContainer(
                                        width: double.infinity,
                                        margin: const EdgeInsets.only(
                                            top: 45, bottom: 70),
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
                                                desc: systemBank!.bank_name),
                                            CustomKeyValueState(
                                              title: "Bank Account Number",
                                              desc: systemBank!.account_number,
                                            ),
                                            CustomKeyValueState(
                                              title: "Bank Account Name",
                                              desc: systemBank!.account_name,
                                            ),
                                            CustomKeyValueState(
                                                title: "Amount",
                                                desc: formatCurrency(
                                                    widget.param)),

                                            // CustomKeyValueState(title: "Service Charge", desc: "N0.00"),
                                          ],
                                        ),
                                      ),

                                      CustomButton(
                                        text: "I have made the transfer",
                                        isActive: true,
                                        onTap: () async {
                                          showCustomToast(
                                              context: context,
                                              description:
                                                  "Request noted, please contact support.",
                                              type: ToastType.success);
                                          await Future.delayed(const Duration(
                                              milliseconds: 550));
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        loading: false,
                                      )
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
}
