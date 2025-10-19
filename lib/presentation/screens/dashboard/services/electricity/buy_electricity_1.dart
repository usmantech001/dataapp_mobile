import 'dart:async';
import 'dart:developer';

import 'package:provider/provider.dart';
import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_check_confirmed.dart';
import 'package:dataplug/presentation/misc/image_manager/image_manager.dart';
import 'package:dataplug/presentation/screens/dashboard/services/electricity/arg/electricity_arg.dart';
// import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/helpers/generic_helper.dart';
import '../../../../../core/model/core/electricity_provider.dart';
import '../../../../../core/model/core/user.dart';
import '../../../../../core/model/electricity_customer.dart';
import '../../../../../core/providers/user_provider.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../../misc/custom_components/custom_dropdown_btn.dart';
import '../../../../misc/custom_components/custom_elements.dart';
import '../../../../misc/custom_components/custom_input_field.dart';
import '../../../../misc/custom_components/custom_scaffold.dart';
import '../../../../misc/custom_components/loading.dart';
import '../../../../misc/custom_snackbar.dart';
import '../../../../misc/style_manager/styles_manager.dart';
import 'buy_electricity_2.dart';

class BuyElectricity1 extends StatefulWidget {
  const BuyElectricity1({super.key});

  @override
  State<BuyElectricity1> createState() => _BuyElectricity1State();
}

class _BuyElectricity1State extends State<BuyElectricity1> {
  final spacer = const SizedBox(height: 40);
  Timer? _debounce;

  final Duration _debounceDuration = const Duration(seconds: 2);

  void _onVerifyMerchant(String meterNo) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () {
      // call your API here
      if (meterNo.length >= 5) {
        verifyInfo().catchError((_) {
          print(_);
        });
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getDataList();
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      setController(userProvider.user!);
    });

    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  setController(User user) {
    if (user.phone != null && user.phone!.isNotEmpty) {
      phoneController.text = user.phone!;
    }
  }

  bool loadingDataList = true;
  Future<void> getDataList() async {
    await ServicesHelper.getElectricityProvider().then((value) {
      if (value.isNotEmpty) {
        electricityProviders = value;
      }
    }).catchError((_) {});
    if (mounted) setState(() => loadingDataList = false);
  }

  ScrollController controller = ScrollController();
  List<ElectricityProvider> electricityProviders = [];
  ElectricityProvider? electricityProvider;

  List<ElectricityMeterType> meterTypes = [
    ElectricityMeterType("Prepaid", true),
    ElectricityMeterType("Postpaid", false),
  ];
  ElectricityMeterType? meterType;

  TextEditingController meterNumberController = TextEditingController(text: "");
  TextEditingController amountController = TextEditingController(text: "");
  TextEditingController phoneController = TextEditingController(text: "");

  // final CurrencyTextInputFormatter _amountFormatter =
  //     CurrencyTextInputFormatter(symbol: "", decimalDigits: 2);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // dismisses keyboard
      },
      behavior: HitTestBehavior.opaque,
      child: CustomScaffold(
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
                        children: [
                          Image.asset(ImageManager.kElectricityIcon2,
                              width: 44),
                          const SizedBox(height: 13),
                          Text(
                            "Buy Electricity",
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
                  margin: const EdgeInsets.only(top: 16, bottom: 55),
                  color: ColorManager.kBar2Color,
                ),

                Expanded(
                  child: loadingDataList
                      ? buildLoading(wrapWithExpanded: false)
                      : ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          controller: controller,
                          children: [
                            CustomDropdownButtonFormField(
                              items: electricityProviders,
                              selectedItem: electricityProvider,
                              labelText: 'Select Provider',
                              formHolderName: "Service Provider",
                              hintText: "",
                              textInputAction: TextInputAction.next,
                              suffixIcon: Icon(
                                Icons.keyboard_arrow_down_sharp,
                                color: ColorManager.kFormHintText,
                                size: 25,
                              ),
                              onChanged: (int idx) {
                                setState(() {
                                  electricityProvider =
                                      electricityProviders[idx];
                                });
                              },
                            ),

                            //
                            spacer,
                            CustomDropdownButtonFormField(
                              items: meterTypes,
                              selectedItem: meterType,
                              labelText: 'Select Meter Type',
                              formHolderName: "Meter Type",
                              hintText: "",
                              textInputAction: TextInputAction.next,
                              suffixIcon: Icon(
                                Icons.keyboard_arrow_down_sharp,
                                color: ColorManager.kFormHintText,
                                size: 25,
                              ),
                              onChanged: (int idx) => setState(() {
                                meterType = meterTypes[idx];
                              }),
                            ),

                            //

                            spacer,
                            CustomInputField(
                              formHolderName: "Phone Number",
                              textEditingController: phoneController,
                              textInputAction: TextInputAction.next,
                              textInputType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              maxLength: 13,
                              counterText: "",
                              enabled: meterType != null &&
                                  electricityProvider != null,
                              onChanged: (e) {
                                // verifiedName = "";
                                // setState(() {});
                                // if (e.length == 13) {
                                //   verifyInfo().catchError((_) {
                                //     print(_);
                                //   });
                                // }
                              },
                            ),

                            spacer,
                            CustomInputField(
                              formHolderName: "Meter Number",
                              textEditingController: meterNumberController,
                              textInputAction: TextInputAction.next,
                              textInputType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              maxLength: 20,
                              counterText: "",
                              enabled: meterType != null &&
                                  electricityProvider != null,
                              onChanged: (e) {
                                // verifiedCustomer = "";
                                _onVerifyMerchant(e);
                                // setState(() {});
                                // Future.delayed(const Duration(seconds: 2));
                                // if (e.length >= 2) {
                                //   verifyInfo().catchError((_) {
                                //     print(_);
                                //   });
                                // }
                              },
                            ),
                            const SizedBox(height: 10),

                            if (verifyingInfo)
                              Row(
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, top: 3, bottom: 7),
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  ColorManager.kPrimary),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (verificationError.isNotEmpty) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14.5, vertical: 7.5),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        verificationError,
                                        style: get12TextStyle().copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: ColorManager.kError,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                            if (verifiedCustomer != null)
                              Row(
                                children: [
                                  CustomCheckConfirmed(
                                    text:
                                        "Attached Name: ${verifiedCustomer?.customerName ?? ""}",
                                    showCheck: false,
                                  )
                                ],
                              ),

                            //
                            spacer,
                            CustomInputField(
                              formHolderName: "Amount",
                              textEditingController: amountController,
                              textInputAction: TextInputAction.done,
                              textInputType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                // _amountFormatter
                              ],
                              enabled: meterType != null &&
                                  electricityProvider != null,
                              validator: (val) => Validator.validateField(
                                  fieldName: "Amount", input: val),
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 50),

                            CustomButton(
                              text: "Proceed",
                              isActive: true,
                              onTap: () async {
                                if (electricityProvider == null ||
                                    meterType == null ||
                                    amountController.text.isEmpty) {
                                  showCustomToast(
                                      context: context,
                                      description:
                                          "Please fill in all details");
                                  return;
                                }

                                if (verifiedCustomer == null) {
                                  showCustomToast(
                                    context: context,
                                    // meesage
                                    description:
                                        "Merchant not verified. Please check the number and try again.",
                                  );
                                  return;
                                }
                                log(electricityProvider?.code ?? "");
                                num amount = (parseNum(amountController.text
                                        .replaceAll(",", "")) ??
                                    0);

                                await GenericHelper.getDiscount(
                                        'electricity',
                                        electricityProvider?.code ?? "",
                                        amount.toString(),
                                        null)
                                    .then((value) async {
                                  // widget.param.phone = phoneController.text;
                                  // widget.param.discount = value;
                                  print("Discount ::: ${value.toJson()}");
                                  setState(() => loading = false);

                                  await showCustomBottomSheet(
                                    context: context,
                                    isDismissible: true,
                                    screen: BuyElectricity2(
                                      param: ElectricityArg(
                                        electricityProvider:
                                            electricityProvider!,
                                        amount: amount,
                                        meterType: meterType!,
                                        phone: phoneController.text,
                                        discount: value,
                                        meterNumber: meterNumberController.text,
                                        meterName:
                                            verifiedCustomer?.customerName ??
                                                "",
                                        meterAddress:
                                            verifiedCustomer?.address ?? "",
                                      ),
                                    ),
                                  );
                                });
                              },
                              loading: false,
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElectricityCustomer? verifiedCustomer;
  bool verifyingInfo = false;
  String verificationError = "";
  Future<void> verifyInfo() async {
    setState(() {
      verifyingInfo = true;
      verificationError = "";
      verifiedCustomer = null;
    });
    await ServicesHelper.verifyElectricityDetails(
      provider: electricityProvider!.code,
      isPrepaid: meterType!.isPrepaid,
      number: meterNumberController.text,
    ).then((value) {
      verifiedCustomer = value;
    }).catchError((e) {
      setState(() {
        verificationError = "";
        verifiedCustomer = null;
      });
      if (mounted) {
        // showCustomToast(context: context, description: "$e");
        setState(() => verifyingInfo = false);

        setState(() {
          verifyingInfo = false;

          verificationError = e.toString();
        });
      }
    });

    verifyingInfo = false;
    if (mounted) setState(() {});
  }

  //   String verificationError = "";

  // String verifiedName = "";

  // bool verifyingInfo = false;
  // Future<void> verifyInfo() async {
  //   setState(() {
  //     verifyingInfo = true;
  //     verificationError = "";
  //   });
  //   await ServicesHelper.verifyTvDetails(
  //           provider: tvServiceProvider!.name,
  //           number: decoderNumberController.text)
  //       .then((value) {
  //         setState(() {
  //           verifyingInfo = false;
  //           verifiedName = value;
  //         });
  //         return value;
  //       })
  //       .catchError((e) {
  //     setState(() {
  //       verifyingInfo = false;
  //       verifiedName = "";
  //       verificationError = e.toString();

  //     });

  //     return e;
  //   });

  //   verifyingInfo = false;
  //   if (mounted) setState(() {});
  // }

  bool loading = false;
}
