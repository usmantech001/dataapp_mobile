import 'package:dataplug/core/utils/utils.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_scaffold.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:dataplug/presentation/screens/dashboard/card/create_card/arg/card_summary_arg.dart';
import 'package:dataplug/presentation/screens/dashboard/card/create_card/card_summary.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/model/core/card_rate.dart';
import '../../../../../../core/model/core/card_service_fee.dart';
import '../../../../../../core/providers/card_provider.dart';
import '../../../../../../core/providers/generic_provider.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../../../misc/custom_components/custom_btn.dart';
import '../../../../../misc/custom_components/custom_input_field.dart';
import '../../../../../misc/custom_components/custom_progress.dart';
import '../../../../../misc/custom_snackbar.dart';
import '../../../../../misc/route_manager/routes_manager.dart';

class CreateUsdCard extends StatefulWidget {
  const CreateUsdCard({super.key});

  @override
  State<CreateUsdCard> createState() => _CreateUsdCardState();
}

class _CreateUsdCardState extends State<CreateUsdCard> {
  bool _hasAgreed = false;
  ScrollController controller = ScrollController();
  String selectedCardType = '';
  TextEditingController cardHolderNameController = TextEditingController();

  Widget _buildCardTypeSelector() {
    final cardTypes = [
      {'type': 'visa', 'icon': Assets.images.visaLogo.path},
      {'type': 'mastercard', 'icon': Assets.images.mastercardLogo.path},
    ];

    return Row(
      children: cardTypes.map((card) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () => setState(() => selectedCardType = card['type']!),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: selectedCardType == card['type']
                      ? ColorManager.kPrimary.withOpacity(0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(
                    color: selectedCardType == card['type']
                        ? ColorManager.kPrimary
                        : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Image.asset(card['icon']!, width: 50, height: 29),
                    const SizedBox(width: 10),
                    Text(
                      capitalizeFirstString(card['type']!.toUpperCase()),
                      style: get16TextStyle().copyWith(
                        fontWeight: FontWeight.w500,
                        color: ColorManager.kTextDark7,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  final spacer = const SizedBox(height: 20);

  @override
  void initState() {
    context.read<CardProvider>().getCardRate(currency: 'USD');
    context.read<CardProvider>().getCardServiceFee(currency: 'USD');
      context.read<CardProvider>().getMinimumAmount(currency: 'USD');
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
          child: Consumer<CardProvider>(
            builder: (context, provider, _) {
            final CardRate? rateModel = provider.cardRate;
            final CardServiceFee? feeModel = provider.serviceFee;
            final CardServiceFee? minimumAmount = provider.minimumAmount;

            final num rate = rateModel?.rate ?? 0;
            final num fee = feeModel?.value ?? 0;
            final num minAmount = minimumAmount?.value ?? 0;
            final num amount = 1;
            final num nairaEquivalent = rate * (fee + amount);
            return GestureDetector(
                 onTap: () => FocusScope.of(context).unfocus(),
              child: ListView(
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
                            "Create USD Virtual Card",
                            textAlign: TextAlign.center,
                            style: get18TextStyle(),
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: CustomProgress(value: 1, valuePerct: .4),
                        ),
                      ),
                    ],
                  ),
                  customDivider(
                      height: 1, margin: const EdgeInsets.only(top: 16)),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomInputField(
                          formHolderName: "Card Holder Name",
                          hintText: "Enter card holder name",
                          textInputAction: TextInputAction.next,
                          textEditingController: cardHolderNameController,
                          validator: (val) => Validator.validateField(
                            fieldName: "Card Holder Name",
                            input: val,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Card Issuer',
                            style: get14TextStyle().copyWith(
                                fontWeight: FontWeight.w400,
                                color: ColorManager.kFadedTextColor),
                          ),
                        ),
                        _buildCardTypeSelector(),
                        spacer,
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: ColorManager.kPrimary.withValues(alpha: .21),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 10, right: 10, left: 10),
                                child: Row(
                                  children: [
                                    // Icon(Icons.info_outline, color: ColorManager.kPrimary), and text
                                    Icon(Icons.info,
                                        color: ColorManager.kBlack, size: 20),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        "Card Creation Summary.",
                                        style: get12TextStyle().copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: ColorManager.kTextDark7,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              customDivider(
                                  color: ColorManager.kDividerColor
                                      .withValues(alpha: .7),
                                  margin: const EdgeInsets.only(top: 20),
                                  height: 1.0),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Card Creation Fee.",
                                      style: get12TextStyle().copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: ColorManager.kBlack
                                            .withValues(alpha: .5),
                                      ),
                                    ),
                                    Text(
                                      "\$${fee}",
                                      style: get12TextStyle().copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: ColorManager.kTextDark7,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Minimum Card Balance.",
                                      style: get12TextStyle().copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: ColorManager.kBlack
                                            .withValues(alpha: .5),
                                      ),
                                    ),
                                    Text(
                                      "\$${minAmount}",
                                      style: get12TextStyle().copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: ColorManager.kTextDark7,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // row of rate
                            Text(
                              'Rate',
                              style: get14TextStyle().copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: ColorManager.kFadedTextColor),
                            ),
              
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: ColorManager.kPrimaryLight,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text("\$1 = ₦${rate.toStringAsFixed(0)}",
                                    style: get14TextStyle().copyWith(
                                      fontFamily: GoogleFonts.roboto().fontFamily, 
                                      fontWeight: FontWeight.w600,
                                      color: ColorManager.kPrimary,
                                    ))),
                          ],
                        ),
                        Gap(60),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // row of rate
                            Text(
                              'Naira Equivalent',
                              style: get14TextStyle().copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: ColorManager.kFadedTextColor),
                            ),
                            Gap(10),
                            Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(17),
                                decoration: BoxDecoration(
                                  color: ColorManager.kPrimaryLight,
                                  borderRadius: BorderRadius.circular(19),
                                ),
                                child: Text("₦${formatNumber( (fee +minAmount) * rate)}",
                                    style: get14TextStyle().copyWith(
                                      fontFamily: GoogleFonts.roboto().fontFamily, 
                                      fontWeight: FontWeight.w600,
                                      color: ColorManager.kPrimary,
                                    ))),
                          ],
                        ),
                        Gap(24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 16.0,
                              width: 16.0,
                              child: buildCheckbox(),
                            ),
                            Gap(12),
                            TermsText(
                              text1: 'I accept Virtual card ',
                              text2: 'terms of service',
                              link: 'terms of service',
                            ),
                          ],
                        ),
                        Gap(42),
                        CustomButton(
                          text: "Proceed",
                          isActive: true,
                          onTap: () async {
                            if (cardHolderNameController.text.isEmpty) {
                              showCustomToast(
                                context: context,
                                description: "Please enter card holder name",
                              );
                              return;
                            }
              
                            if (selectedCardType.isEmpty) {
                              showCustomToast(
                                context: context,
                                description: "Please select a card type",
                              );
                              return;
                            }
              
                            if (!_hasAgreed) {
                              showCustomToast(
                                context: context,
                                description: "Please accept the terms of service",
                              );
                              return;
                            }
                            // final payable = param.amount -
                            //     num.parse(param.discount.discount.toString() ?? "0") +
                            //     fee;
                            // if (userProvider.user.wallet_balance >= payable) {
                            //   createTransaction(BuildContext context,
                            //       {required String transaction_pin}) async {
                            //     try {
                            //       ServiceTxn _ = await ServicesHelper.buyAiritme(
                            //         phone: param.phone,
                            //         amount: payable,
                            //         isPorted: param.is_ported,
                            //         provider: param.airtimeProvider.code,
                            //         pin: "$transaction_pin",
                            //       );
              
                            //       await userProvider.updateUserInfo();
              
                            //       await Navigator.pushNamed(
                            //           context, RoutesManager.transactionStatus,
                            //           arguments: _);
                            //       Navigator.pop(context);
                            //       Navigator.pop(context);
                            //       Navigator.pop(context);
                            //     } catch (err) {
                            //       showCustomToast(
                            //           context: context, description: err.toString());
                            //     }
                            //   }
              
                            //   //
                            //   await showCustomBottomSheet(
                            //       context: context,
                            //       screen: TransactionPin(funcCall: createTransaction));
                            // } else {
                            //   showCustomToast(
                            //       context: context, description: "Insufficient Balance");
                            // }
                            Navigator.pushNamed(
                                context, RoutesManager.enterCardAddressRoute,
                                arguments: CardSummaryArg(
                                  rate: rate,
                                  issuer: selectedCardType,
                                  holderName: cardHolderNameController.text,
                                  amount: minAmount,
                                  fee: fee,
                                  type: "Dollar",
                                  address: Address.fromJson({
                                    "line1": "",
                                    "city": "",
                                    "state": "",
                                    "postal_code": "",
                                    "country": ""
                                  }),
                                  amountInNaira:
                                      parseNum("${(fee + minAmount) * rate}".replaceAll(",", "")) ?? 0,
                                ));
                          },
                          loading: false,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget buildCheckbox() => Checkbox(
        checkColor: ColorManager.kWhite,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        side: BorderSide(color: ColorManager.kPrimary),
        splashRadius: 3,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(3.0))),
        activeColor: ColorManager.kPrimary,
        fillColor:
            WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          return ColorManager.kPrimary;
        }),
        value: _hasAgreed,
        onChanged: (bool? value) {
          setState(() {
            _hasAgreed = value!;
          });
        },
      );
}

class TermsText extends StatelessWidget {
  final String text1, text2, link;
  const TermsText(
      {super.key,
      required this.text1,
      required this.text2,
      required this.link});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: ColorManager.kBlack.withValues(alpha: .6)),
        children: <TextSpan>[
          TextSpan(text: text1),
          TextSpan(
              text: text2,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ColorManager.kPrimary,
                  decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  debugPrint('Terms of Service"');
                }),
        ],
      ),
    );
  }
}
