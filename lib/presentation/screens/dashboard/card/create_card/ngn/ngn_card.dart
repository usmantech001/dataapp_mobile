import 'dart:developer';

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
import 'package:provider/provider.dart';

import '../../../../../../core/model/core/card_rate.dart';
import '../../../../../../core/model/core/card_service_fee.dart';
import '../../../../../../core/providers/card_provider.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../../../misc/custom_components/custom_btn.dart';
import '../../../../../misc/custom_components/custom_input_field.dart';
import '../../../../../misc/custom_snackbar.dart';
import '../../../../../misc/route_manager/routes_manager.dart';

class CreateNgnCard extends StatefulWidget {
  const CreateNgnCard({super.key});

  @override
  State<CreateNgnCard> createState() => _CreateNgnCardState();
}

class _CreateNgnCardState extends State<CreateNgnCard> {
  bool _hasAgreed = false;
  ScrollController controller = ScrollController();
  TextEditingController cardHolderNameController = TextEditingController();

  final spacer = const SizedBox(height: 20);

  @override
  void initState() {
    context.read<CardProvider>().getCardRate(currency: 'NGN');
    context.read<CardProvider>().getCardServiceFee(currency: 'NGN');
    context.read<CardProvider>().getMinimumAmount(currency: 'NGN');
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
          child: Consumer<CardProvider>(builder: (context, provider, _) {
            final CardRate? rateModel = provider.cardRate;
            final CardServiceFee? feeModel = provider.serviceFee;
            final CardServiceFee? minAmountModel = provider.minimumAmount;

            final num rate = rateModel?.rate ?? 0;
            final num fee = feeModel?.value ?? 0;
            final num minAmount = minAmountModel?.value ?? 0;

           
            return GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
              child: ListView(
                children: [
                  // Top header row with back icon and title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: BackIcon(),
                      ),
                      Expanded(
                        child: Text(
                          "Create NGN Virtual Card",
                          textAlign: TextAlign.center,
                          style: get18TextStyle(),
                        ),
                      ),
                      const SizedBox(width: 40), // Space placeholder
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
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: ColorManager.kPrimary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(19),
                            border: Border.all(
                              color: ColorManager.kPrimary,
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Image.asset(Assets.images.verveLogo.path,
                                  width: 50, height: 29),
                              const SizedBox(width: 10),
                              Text(
                                "Verve",
                                style: get16TextStyle().copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: ColorManager.kTextDark7,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                                      "N${fee}",
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
                                      "N${minAmountModel?.value}",
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
                        Gap(54),
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
              
                            if (!_hasAgreed) {
                              showCustomToast(
                                context: context,
                                description: "Please accept the terms of service",
                              );
                              return;
                            }
              
                          
              
                            Navigator.pushNamed(
                                context, RoutesManager.enterCardAddressRoute,
                                arguments: CardSummaryArg(
                                  rate: 0,
                                  issuer: "Verve",
                                  holderName: cardHolderNameController.text,
                                  amount: minAmount,
                                  fee: fee,
                                  type: "Naira",
                                  address: Address.fromJson({
                                    "line1": "",
                                    "city": "",
                                    "state": "",
                                    "postal_code": "",
                                    "country": ""
                                  }),
                                  amountInNaira: parseNum(
                                          "${fee + minAmount}".replaceAll(",", "")) ??
                                      0,
                                ));
              
                            //  await showCustomBottomSheet(
                            //               context: context,
                            //               isDismissible: true,
                            //               screen: CardSummary(
                            //                 param: CardSummaryArg(
                            //                   issuer: "Verve",
                            //                   holderName: cardHolderNameController.text,
                            //                   amountInNaira: 100,
                            //                   fee: 4500,
                            //                   type: "Naira",
                            //                   address: Address(
                            //                     line1: "",
                            //                     city: "",
                            //                     state: "",
                            //                     postalCode: "",
                            //                     country: "",
                            //                   ),
                            //                   amount: parseNum("4,600"
                            //                           .replaceAll(",", "")) ??
                            //                       0,
                            //                 ),
                            //               ),
                            //             );
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
