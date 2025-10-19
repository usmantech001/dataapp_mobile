import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/image_manager/image_manager.dart';
import 'package:dataplug/presentation/screens/dashboard/services/airtime/arg/airtime_arg.dart';
// import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:gap/gap.dart';

import '../../../../../core/helpers/generic_helper.dart';
import '../../../../../core/model/core/airtime_provider.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../../misc/custom_components/custom_elements.dart';
import '../../../../misc/custom_components/custom_input_field.dart';
import '../../../../misc/custom_components/custom_scaffold.dart';
import '../../../../misc/custom_components/loading.dart';
import '../../../../misc/custom_snackbar.dart';
import '../../../../misc/select_contact.dart';
import '../../../../misc/style_manager/styles_manager.dart';
import 'buy_airtime_2.dart';

class BuyAirtime1 extends StatefulWidget {
  const BuyAirtime1({super.key});

  @override
  State<BuyAirtime1> createState() => _BuyAirtime1State();
}

class _BuyAirtime1State extends State<BuyAirtime1> {
  final spacer = const SizedBox(height: 20);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getDataList();
    });

    phoneController.addListener(() {
      if (provider != null && phoneController.text.length >= 4) {
        final isValid = isValidNetwork(phoneController.text, provider!.name);
        if (!isValid &&
            !isPorted &&
            phoneController.text.isNotEmpty &&
            phoneController.text.length >= 11) {
          setState(() {
            phoneError = true;
          });
        } else {
          setState(() {
            phoneError = false;
          });
        }
      }

      if (provider == null && phoneController.text.length >= 4) {
        final network = getNetwork(phoneController.text);

        if (airtimeProviders.isNotEmpty) {
          final foundProvider = airtimeProviders.firstWhere(
            (p) => p.name.toLowerCase().contains(network.toLowerCase()),
          );

          setState(() {
            provider = foundProvider;
          });
        }
      }
    });

    super.initState();
  }

  bool phoneVerified = false;
  bool isPorted = false;
  bool phoneError = false;

  // void _verifyPhone() async {
  //   if (phoneController.text.length == 11) {
  //     setState(() {
  //       phoneVerified = false;
  //     });
  //     if (isPorted) {
  //       setState(() {
  //         phoneVerified = true;
  //       });
  //     } else {
  //       AirtimeHelper.verifyPhoneNumber(phone: phoneController.text, provider: provider?.name).then((value) {
  //         setState(() {
  //           phoneVerified = true;
  //         });
  //       }).catchError((er) {
  //         // print("Error ::: $er");
  //         showCustomToast(context: context, description: "$er");
  //       });
  //     }
  //   }
  // }

  void _toggleIsPorted() {
    setState(() {
      isPorted = !isPorted;
    });
    // _verifyPhone();
  }

  bool loading = true;
  List<AirtimeProvider> airtimeProviders = [];
  Future<void> getDataList() async {
    await ServicesHelper.getAirtimeProviders().then((value) {
      airtimeProviders = value;
    }).catchError((msg) {
      showCustomToast(context: context, description: msg.toString());
    });

    if (mounted) setState(() => loading = false);
  }

  //

  @override
  void dispose() {
    phoneController.dispose();
    controller.dispose();
    amountController.dispose();
    super.dispose();
  }

  AirtimeProvider? provider;
  TextEditingController phoneController = TextEditingController(text: "");
  TextEditingController amountController = TextEditingController(text: "");
  final ScrollController controller = ScrollController();
  // final CurrencyTextInputFormatter _amountFormatter =
  //     CurrencyTextInputFormatter(symbol: "", decimalDigits: 2);

  final _formKey = GlobalKey<FormState>();

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
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          padding: const EdgeInsets.only(top: 20),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
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
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(ImageManager.kBuyAirtime2, width: 44),
                          const SizedBox(height: 13),
                          Text(
                            "Buy Airtime",
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

                Expanded(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: loading
                        ? buildLoading(wrapWithExpanded: false)
                        : ListView(
                            controller: controller,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            children: [
                              SizedBox(
                                height: 110,
                                child: ListView.separated(
                                  separatorBuilder: (context, index) => Gap(16),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: airtimeProviders.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final biller = airtimeProviders[index];
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          provider = biller;
                                          if (provider != null &&
                                              phoneController.text.length >=
                                                  4) {
                                            final isValid = isValidNetwork(
                                                phoneController.text,
                                                provider!.name);
                                            if (!isValid &&
                                                !isPorted &&
                                                phoneController
                                                    .text.isNotEmpty &&
                                                phoneController.text.length >=
                                                    11) {
                                              phoneError = true;
                                            } else {
                                              phoneError = false;
                                            }
                                          }
                                        });
                                      },
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Container(
                                            width: 86,
                                            height: 86,
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            padding: const EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                              color: provider?.name ==
                                                      biller.name
                                                  ? ColorManager.kPrimaryLight
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(19),
                                              border: Border.all(
                                                color: provider?.name ==
                                                        biller.name
                                                    ? ColorManager.kPrimaryLight
                                                    : const Color(0xffeeeeee),
                                                width: 1.5,
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                loadNetworkImage(
                                                  biller.toIcon(),
                                                  width: 24,
                                                  height: 24,
                                                  borderRadius:
                                                      BorderRadius.circular(78),
                                                ),
                                                Text(
                                                  biller.name,
                                                  style:
                                                      get14TextStyle().copyWith(fontFamily: GoogleFonts.roboto().fontFamily, 
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                    color: ColorManager
                                                        .kFadedTextColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (provider?.name == biller.name)
                                            Positioned(
                                              top: 5,
                                              right: -5,
                                              child: Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  color: ColorManager.kPrimary,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              spacer,
                              CustomInputField(
                                formHolderName: "Phone Number",
                                textInputAction: TextInputAction.next,
                                textEditingController: phoneController,
                                textInputType: TextInputType.number,
                                suffixIcon: InkWell(
                                  onTap: () async {
                                    Contact? res = await showCustomBottomSheet(
                                      context: context,
                                      isDismissible: true,
                                      screen: SelectFromContactWidget(),
                                    );
                                    if (res != null) {
                                      phoneController.text = res
                                          .phones.first.number
                                          .replaceAll(" ", "")
                                          .replaceAll("(", "")
                                          .replaceAll(")", "")
                                          .replaceAll("+234", "0")
                                          .replaceAll("-", "")
                                          .trim();
                                      setState(() {});
                                    }
                                  },
                                  child: Icon(
                                    Icons.person,
                                    size: 24,
                                    color: ColorManager.kPrimary,
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (val) {
                                  if (isPorted) return null;
                                  final mobileValidation =
                                      Validator.validateMobile(val);
                                  if (mobileValidation != null)
                                    return mobileValidation;
                                  return null;
                                },
                              ),
                              if (phoneError)
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding:
                                      const EdgeInsets.only(left: 3, top: 2),
                                  child: const Text(
                                    "Phone number does not match selected network",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: _toggleIsPorted,
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: isPorted,
                                      activeColor: ColorManager.kPrimary,
                                      onChanged: (v) => _toggleIsPorted(),
                                    ),
                                    const Text("Is this number ported?"),
                                  ],
                                ),
                              ),
                              spacer,
                              buildAmountSuggestion(),
                              const Gap(16),
                              CustomInputField(
                                formHolderName: "Amount",
                                textInputAction: TextInputAction.done,
                                textEditingController: amountController,
                                textInputType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (val) => Validator.validateField(
                                    fieldName: "Amount", input: val),
                                onChanged: (_) => setState(() {}),
                              ),
                              const SizedBox(height: 50),
                              CustomButton(
                                text: "Proceed",
                                isActive: true,
                                onTap: () async {
                                  if (provider == null) {
                                    showCustomToast(
                                      context: context,
                                      description: "Please select a network",
                                    );
                                    return;
                                  }

                                  if (!(_formKey.currentState?.validate() ??
                                      false)) {
                                    return;
                                  }

                                  num amount = (parseNum(amountController.text
                                          .replaceAll(",", "")) ??
                                      0);
                                  await GenericHelper.getDiscount(
                                    'airtime',
                                    provider?.name ?? "",
                                    amount.toString(),
                                    null,
                                  ).then((value) async {
                                    setState(() => loading = false);
                                    await showCustomBottomSheet(
                                      context: context,
                                      isDismissible: true,
                                      screen: BuyAirtime2(
                                        param: AirtimeArg(
                                          airtimeProvider: provider!,
                                          phone: phoneController.text,
                                          discount: value,
                                          is_ported: isPorted,
                                          amount: amount,
                                        ),
                                      ),
                                    );
                                  });
                                },
                                loading: false,
                              ),
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

  /// Suggested Amounts Widget
  // Widget buildAmountSuggestion() {
  //   final List<String> suggestions = [
  //     '100',
  //     '200',
  //     '500',
  //     '1000',
  //     '2000',
  //     '3000',
  //     '5000'
  //   ];

  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 10),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'Choose an amount',
  //           style: get14TextStyle().copyWith(fontFamily: GoogleFonts.roboto().fontFamily, 
  //             color: ColorManager.kFadedTextColor,
  //           ),
  //         ),
  //         const SizedBox(height: 10),
  //         Wrap(
  //           spacing: 10,
  //           runSpacing: 10,
  //           children: suggestions.map((amount) {
  //             return GestureDetector(
  //               onTap: () {
  //                 setState(() {
  //                   amountController.text = amount;
  //                 });
  //               },
  //               child: Container(
  //                 padding:
  //                     const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(8),
  //                   color: ColorManager.kPrimary.withOpacity(0.1),
  //                 ),
  //                 child: Text(
  //                   '₦$amount',
  //                   style: get14TextStyle().copyWith(fontFamily: GoogleFonts.roboto().fontFamily, 
  //                     color: ColorManager.kPrimary,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //             );
  //           }).toList(),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget buildAmountSuggestion() {
    final List<String> suggestions = [
      '50',
      '100',
      '200',
      '500',
      '800',
      '1000',
      '2000',
      '2500'
    ]; // Added 8 for better grid symmetry

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Choose an amount',
          style: get14TextStyle().copyWith(fontFamily: GoogleFonts.roboto().fontFamily, 
            color: ColorManager.kFadedTextColor,
          ),
        ),
        const SizedBox(height: 10),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2.5, // adjust to make boxes wider/taller
          children: suggestions.map((amount) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  amountController.text = amount;
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorManager.kPrimary.withOpacity(0.1),
                ),
                child: Text(
                  '₦$amount',
                  style: get14TextStyle().copyWith(fontFamily: GoogleFonts.roboto().fontFamily, 
                    color: ColorManager.kPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
