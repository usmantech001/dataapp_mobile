import 'dart:developer';

import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_scaffold.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/utils/validators.dart';
import '../../../../../core/model/core/country.dart';
import '../../../../../core/model/core/state.dart';
import '../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../../misc/custom_components/custom_btn.dart';
import '../../../../misc/custom_components/custom_input_field.dart';
import '../../../../misc/custom_components/custom_progress.dart';
import '../../../../misc/custom_snackbar.dart';
import '../../../../misc/select_country.dart';
import '../../../../misc/select_state.dart';
import 'arg/card_summary_arg.dart';
import 'card_summary.dart';

class EnterCardAddress extends StatefulWidget {
  final CardSummaryArg param;
  const EnterCardAddress({super.key, required this.param});

  @override
  State<EnterCardAddress> createState() => _EnterCardAddressState();
}

class _EnterCardAddressState extends State<EnterCardAddress> {
  ScrollController controller = ScrollController();
  TextEditingController _line1Controller = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _postalCode = TextEditingController();

  Country? country;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final spacer = const SizedBox(height: 20);

 @override
Widget build(BuildContext context) {
  return CustomScaffold(
    backgroundColor: ColorManager.kPrimary,
    body: SafeArea(
      bottom: false,
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: ColorManager.kWhite,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.only(top: 20),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              // Top row with back, title, and progress
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const BackIcon(),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Create ${widget.param.type.toLowerCase() == 'naira' ? 'NGN' : 'USD'} Virtual Card",
                        textAlign: TextAlign.center,
                        style: get18TextStyle(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const CustomProgress(value: 2, valuePerct: .8),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              customDivider(height: 1),

              // Scrollable form content
              Expanded(
                child: SingleChildScrollView(
                  controller: controller,
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Please provide billing address details",
                          style: get14TextStyle().copyWith(
                            fontWeight: FontWeight.w400,
                            color: ColorManager.kFadedTextColor,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Country
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            Country? res = await showCustomBottomSheet(
                              context: context,
                              screen: const SelectCountry(),
                            );
                            if (res != null) {
                              _countryController.text = res.name ?? "";
                              country = res;
                              setState(() {});
                            }
                          },
                          child: IgnorePointer(
                            child: CustomInputField(
                              formHolderName: "Country",
                              hintText: "",
                              textEditingController: _countryController,
                              textInputAction: TextInputAction.next,
                              suffixIcon: Icon(CupertinoIcons.chevron_down, size: 18, color: ColorManager.kTextDark),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // State
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            if (country == null) {
                              String msg = _countryController.text.isEmpty
                                  ? "You need to select a country."
                                  : "Please reselect country to fetch related state.";
                              showCustomToast(context: context, description: msg);
                              return;
                            }
                            AppState? res = await showCustomBottomSheet(
                              context: context,
                              screen: SelectState(countryId: "${country?.id}"),
                            );
                            if (res != null) {
                              _stateController.text = res.name ?? "";
                              setState(() {});
                            }
                          },
                          child: IgnorePointer(
                            child: CustomInputField(
                              formHolderName: "State",
                              hintText: "",
                              textEditingController: _stateController,
                              textInputAction: TextInputAction.done,
                              suffixIcon: Icon(CupertinoIcons.chevron_down, size: 18, color: ColorManager.kTextDark),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // City
                        CustomInputField(
                          formHolderName: "City",
                          hintText: "Enter city",
                          textInputAction: TextInputAction.next,
                          textEditingController: _cityController,
                          validator: (val) => Validator.validateField(fieldName: "City", input: val),
                          onChanged: (_) => setState(() {}),
                        ),

                        const SizedBox(height: 20),

                        // Address
                        CustomInputField(
                          formHolderName: "Address",
                          hintText: "Enter address line 1",
                          textInputAction: TextInputAction.next,
                          textEditingController: _line1Controller,
                          validator: (val) => Validator.validateField(fieldName: "address line 1", input: val),
                          onChanged: (_) => setState(() {}),
                        ),

                        const SizedBox(height: 20),

                        // Postal code
                        CustomInputField(
                          formHolderName: "Postal Code",
                          hintText: "Enter Postal Code",
                          textInputAction: TextInputAction.next,
                          textEditingController: _postalCode,
                          validator: (val) => Validator.validateField(fieldName: "Postal Code", input: val),
                          onChanged: (_) => setState(() {}),
                        ),

                        const Gap(42),

                        // Proceed Button
                        CustomButton(
                          text: "Proceed",
                          isActive: true,
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              await showCustomBottomSheet(
                                context: context,
                                isDismissible: true,
                                screen: CardSummary(
                                  param: CardSummaryArg(
                                    rate: widget.param.rate,
                                    type: widget.param.type,
                                    amount: widget.param.amount,
                                    amountInNaira: widget.param.amountInNaira,
                                    fee: widget.param.fee,
                                    issuer: widget.param.issuer,
                                    address: Address(
                                      line1: _line1Controller.text,
                                      city: _cityController.text,
                                      state: _stateController.text,
                                      postalCode: _postalCode.text,
                                      country: country?.iso2 ?? "",
                                    ),
                                    holderName: widget.param.holderName,
                                  ),
                                ),
                              );
                            }
                          },
                          loading: false,
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}

class TermsText extends StatelessWidget {
  final String text1, text2, link;
  const TermsText({
    super.key,
    required this.text1,
    required this.text2,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: ColorManager.kBlack.withValues(alpha: .6),
        ),
        children: <TextSpan>[
          TextSpan(text: text1),
          TextSpan(
            text: text2,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ColorManager.kPrimary,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                debugPrint('Terms of Service');
              },
          ),
        ],
      ),
    );
  }
}
