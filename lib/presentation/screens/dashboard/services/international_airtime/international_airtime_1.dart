import 'dart:developer';

import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_progress.dart';
import 'package:dataplug/presentation/misc/image_manager/image_manager.dart';
import 'package:dataplug/presentation/screens/dashboard/services/international_airtime/international_airtime_arg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/helpers/generic_helper.dart';
import '../../../../../core/model/core/country.dart';
import '../../../../../core/model/core/operator_provider.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../../misc/custom_components/custom_dropdown_btn.dart';
import '../../../../misc/custom_components/custom_elements.dart';
import '../../../../misc/custom_components/custom_input_field.dart';
import '../../../../misc/custom_components/custom_scaffold.dart';
import '../../../../misc/custom_snackbar.dart';
import '../../../../misc/select_intl_bill_country.dart';
import '../../../../misc/style_manager/styles_manager.dart';
import 'international_airtime_2.dart';

class InternationalAirtime1 extends StatefulWidget {
  const InternationalAirtime1({super.key});

  @override
  State<InternationalAirtime1> createState() => _InternationalAirtime1State();
}

class _InternationalAirtime1State extends State<InternationalAirtime1> {
  final spacer = const SizedBox(height: 16);

  ScrollController controller = ScrollController();

  // bool loading = true;
  List<OperatorProvider> operators = [];
  OperatorProvider? operator;
  Country? country;

  String amountInNGN = "0 NGN";

  Future<void> getDataList({required String iso2}) async {
    await ServicesHelper.getInternationalAirtimeProviders(
            iso2: country?.iso2 ?? "")
        .then((value) {
      setState(() {
        operators = value;
      });
    }).catchError((msg) {
      showCustomToast(context: context, description: msg.toString());
    });

    // if (mounted) setState(() => loading = false);
  }

  //
  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // getDataList();
    // });
    super.initState();
  }

  TextEditingController _amountController = TextEditingController(text: "");
  TextEditingController _emailController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  double convertMoneyText(String value) {
    String formattedString = value;

    // Step 1: Remove the Naira symbol (₦)
    String cleanString = formattedString.replaceAll('₦', '');

    // Step 2: Remove commas
    cleanString = cleanString.replaceAll(',', '');

    // Step 3: Convert to double
    double result = double.parse(cleanString);

    // log(result.toString()); // Output: 5000.00

    return result;
  }

  final _formKey = GlobalKey<FormState>();
  num payableInUSD = 0;
  num payableInNGN = 0;
  void calcUSDEqui(num amount, int quantity) {
    setState(() {
      payableInUSD = amount * quantity;
    });
  }

  void calcNairaEqui(num amount, double rate) {
    setState(() {
      payableInNGN = amount * rate;
    });
  }

  double finalRate = 0; // use double, not int

  void calculateNairaPerCurrency(num rate) {
    if (rate <= 0) {
      setState(() {
        finalRate = 0;
      });
      return;
    }

    setState(() {
      finalRate = 1 / rate; // keep as double
    });
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
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.only(left: 15, top: 15),
                        alignment: Alignment.centerLeft,
                        child: const BackIcon(),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Image.asset(ImageManager.kBuyAirtime2, width: 44),
                          const SizedBox(height: 13),
                          Text(
                            "Buy International Airtime",
                            textAlign: TextAlign.center,
                            style: get18TextStyle(),
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: CustomProgress(value: 1, valuePerct: .4),
                      ),
                    ),
                  ],
                ),

                //

                //
                customDivider(
                  height: 1,
                  margin: const EdgeInsets.only(top: 16, bottom: 40),
                  color: ColorManager.kBar2Color,
                ),

                Expanded(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: ListView(
                      controller: controller,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      children: [
                        // CustomDropdownButtonFormField(
                        //   items: categories,
                        //   labelText: '',
                        //   formHolderName: "Country",
                        //   selectedItem: category,
                        //   onChanged: (idx) {
                        //     setState(() => category = categories[idx]);
                        //   },
                        // ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            Country? res = await showCustomBottomSheet(
                                context: context,
                                screen: const SelectIntlBillCountry(
                                  type: "airtime",
                                ));
                    
                            if (res != null) {
                              setState(() {
                                // Clear operator and operatorType even if same country selected
                                if (country == null ||
                                    country!.iso2 != res.iso2) {
                                  operator =
                                      null; // Clear operator when country changes
                                  // TODO: clear operatorType if implemented
                                  _amountController.clear();
                                  _phoneController.clear();
                                  _emailController.clear();
                                }
                                country = res;
                                _countryController.text = res.name ?? "";
                              });
                              await getDataList(iso2: country?.iso2 ?? "");
                            }
                          },
                          child: IgnorePointer(
                            child: CustomInputField(
                              formHolderName: "Country",
                              hintText: "",
                              textEditingController: TextEditingController(
                                  text: _countryController.text),
                              textInputAction: TextInputAction.next,
                              suffixIcon: Icon(CupertinoIcons.chevron_down,
                                  size: 18, color: ColorManager.kTextDark),
                            ),
                          ),
                        ),
                        spacer,
                    
                        // CustomDropdownButtonFormField(
                        //   items: category?.countries ?? [],
                        //   labelText: '',
                        //   formHolderName: "Country",
                        //   selectedItem: country,
                        //   onChanged: (idx) {
                        //     setState(
                        //         () => country = category!.countries[idx]);
                        //     getGiftcardProduct(
                        //         categoryId: category?.id.toString() ?? "",
                        //         countryId: country?.id.toString() ?? "");
                        //   },
                        // ),
                        //
                        spacer,
                    
                        CustomDropdownButtonFormField(
                          enabled: country != null,
                          items: operators,
                          labelText: '',
                          formHolderName: "Operator",
                          selectedItem: operator,
                          onChanged: (idx) {
                            setState(() {
                              operator = operators[idx];
                              // TODO: Clear operatorType here if implemented in future
                              // Clear other dependent fields if any
                              _amountController.clear();
                              _phoneController.clear();
                              _emailController.clear();
                            });
                            // log(operator?.rate ?? "", name: "Rate");
                            calculateNairaPerCurrency(operator?.rate ?? 0.0);
                          },
                        ),
                    
                        spacer,
                    
                        CustomInputField(
                          formHolderName: "Amount",
                          textInputAction: TextInputAction.done,
                          textEditingController: _amountController,
                          textInputType: TextInputType.number,
                          suffixConstraints: BoxConstraints(maxWidth: 200),
                          suffixIcon: operator != null
                              ? Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: ColorManager.kPrimaryLight,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    "₦${finalRate.toStringAsFixed(2)} = 1 ${operator?.currency ?? ""}",
                                    style:
                                        TextStyle(color: ColorManager.kPrimary,fontFamily: GoogleFonts.roboto().fontFamily, ),
                                  ),
                                )
                              : null,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            // _amountFormatter
                          ],
                          validator: (val) => Validator.validateField(
                              fieldName: "Amount", input: val),
                          onChanged: (value) {
                            calculateNairaPerCurrency(operator?.rate ?? 0.0);
                    
                            double amt =
                                double.tryParse(value.isEmpty ? "0" : value) ??
                                    0;
                            setState(() {
                              double ngnValue = amt * finalRate;
                              amountInNGN =
                                  "₦${ngnValue.toStringAsFixed(2)}"; // formatted with 2 decimals
                            });
                          },
                        ),
                        // onChanged: (_) {
                    
                        //   setState(() {
                    
                        // });
                        // },
                        // ),
                        spacer,
                        CustomInputField(
                            enabled: false,
                            formHolderName: "Amount in Naira",
                            textInputAction: TextInputAction.done,
                            textEditingController:
                                TextEditingController(text: amountInNGN),
                            textInputType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              // _amountFormatter
                            ],
                            validator: (val) => Validator.validateField(
                                fieldName: "Amount", input: val),
                            onChanged: (value) {
                              // log(operator?.rate ?? "", name: "Rate");
                              calculateNairaPerCurrency(operator?.rate ?? 0.0);
                              // calcUSDEqui(convertMoneyText(value),
                              //     int.parse(_quantityController.text));
                    
                              // calcNairaEqui(convertMoneyText(value),
                              //     giftcard?.buyRate ?? 0.0);
                            }),
                        spacer,
                        CustomInputField(
                          formHolderName: "Phone Number",
                          prefixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                // onTap: () async {
                                //   Country? res =
                                //       await showCustomBottomSheet(
                                //           context: context,
                                //           screen: const SelectCountry());
                                //   if (res != null) {
                                //     phoneCountry = res;
                                //     phoneCodeController.text =
                                //         res.phone_code ?? "";
                                //     setState(() {});
                                //   }
                                // },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 4.5),
                                      child: Text(
                                          " ${country?.phone_code ?? "+ "}",
                                          style: get16TextStyle().copyWith(
                                              fontWeight: FontWeight.w400)),
                                    ),
                                    dropDownIcon(
                                      width: 24,
                                      padding: EdgeInsets.zero,
                                      color: ColorManager.kTextColor
                                          .withOpacity(.4),
                                    ),
                                    customDivider(
                                      width: 1,
                                      height: 35,
                                      color: ColorManager.kBarColor,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          textInputAction: TextInputAction.next,
                          textEditingController: _phoneController,
                          textInputType: TextInputType.number,
                          validator: (val) => Validator.validateField(
                              fieldName: "Phone Number", input: val),
                        ),
                        spacer,
                        // CustomInputField(
                        //   formHolderName: "Email Address",
                    
                        //   textEditingController: _emailController,
                        //   textInputType: TextInputType.emailAddress,
                        //   // suffixConstraints: BoxConstraints(maxWidth: 200),
                        //   // suffixIcon: Container(
                        //   //   padding: EdgeInsets.all(5),
                        //   //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                        //   //   color: ColorManager.kPrimaryLight
                        //   //   ),
                        //   //   child: Text('\$200', style: TextStyle(color: ColorManager.kPrimary, fontSize: 12, fontWeight: FontWeight.w500),),
                        //   // ),
                    
                        //   onChanged: (value) {
                        //     // calcUSDEqui(convertMoneyText(value),
                        //     //     int.parse(_quantityController.text));
                    
                        //     // calcNairaEqui(convertMoneyText(value),
                        //     //     giftcard?.buyRate ?? 0.0);
                        //     //   setState(() {
                    
                        //     // });
                        //   },
                        // ),
                    
                        const SizedBox(height: 35),
                        CustomButton(
                          text: "Proceed",
                          isActive: true,
                          onTap: () async {
                            if (operator == null) {
                              showCustomToast(
                                context: context,
                                description: "Please select category",
                              );
                    
                              return;
                            }
                    
                            if (!(_formKey.currentState?.validate() ?? false)) {
                              return;
                            }
                    
                            // setState(() => btnLoading = true);
                            // List<CableTvPlan> dList =
                            //     await ServicesHelper.getTvPlans(
                            //             tvServiceProvider!.id)
                            //         .catchError((msg) {
                            //   showCustomToast(
                            //       context: context,
                            //       description: msg.toString());
                            // });
                    
                            // setState(() => btnLoading = false);
                            // if (dList.isEmpty) return;
                    
                            // Navigator.pushNamed(
                            //   context,
                            //   RoutesManager.cableTv2,
                            //   arguments: CableTvArg(
                            //     provider: tvServiceProvider!,
                            //     plans: dList,
                            //     number: decoderNumberController.text,
                            //     type: type!,
                            //   ),
                            // );
                    
                            InternationalAirtimeArg arguments =
                                InternationalAirtimeArg(
                              amountInNGN:
                                  (double.parse(_amountController.text) *
                                          finalRate)
                                      .toString(),
                              amountInCurrrency: _amountController.text,
                              country: country!,
                              emailAddress: _emailController.text,
                              phoneNumber: _phoneController.text,
                              provider: operator!,
                            );
                    
                            moveNext(context, arg: arguments);
                          },
                          loading: btnLoading,
                        ),
                        Gap(24)
                        //
                      ],
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

  moveNext(BuildContext context, {required InternationalAirtimeArg arg}) async {
    log(
      arg.amountInNGN.toString() ?? "",
    );
    await GenericHelper.getDiscount('international-airtime', arg.provider.code,
            double.parse(arg.amountInNGN), null)
        .then((value) async {
      arg.discount = value;
      print("Discount ::: ${value.toJson()}");
      await showCustomBottomSheet(
        context: context,
        isDismissible: true,
        screen: InternationalAirtime2(arg: arg),
      );
    });
  }

  bool btnLoading = false;
}
