import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_check_confirmed.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_progress.dart';
import 'package:dataplug/presentation/misc/image_manager/image_manager.dart';
import 'package:dataplug/presentation/screens/dashboard/services/betting/arg.dart';
import 'package:dataplug/presentation/screens/dashboard/services/betting/betting_2.dart';
import '../../../../../core/helpers/generic_helper.dart';
import '../../../../../core/model/core/betting_provider.dart';
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

class Betting1 extends StatefulWidget {
  const Betting1({super.key});

  @override
  State<Betting1> createState() => _Betting1State();
}

class _Betting1State extends State<Betting1> {
  final spacer = const SizedBox(height: 40);

  ScrollController controller = ScrollController();

  bool loading = true;
  List<BettingProvider> tvServiceProviders = [];
  BettingProvider? tvServiceProvider;
  Future<void> getDataList() async {
    await ServicesHelper.getBettingProviders().then((value) {
      tvServiceProviders = value;
    }).catchError((msg) {
      showCustomToast(context: context, description: msg.toString());
    });

    if (mounted) setState(() => loading = false);
  }

  //
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getDataList();
    });
    super.initState();
  }

  TextEditingController bettingIdController = TextEditingController(text: "");
  TextEditingController amountController = TextEditingController(text: "");

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
                          Image.asset(ImageManager.kBettingIcon, width: 44),
                          const SizedBox(height: 13),
                          Text(
                            "Fund Betting",
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
                    child: loading
                        ? buildLoading(wrapWithExpanded: false)
                        : ListView(
                            controller: controller,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            children: [
                              CustomDropdownButtonFormField(
                                items: tvServiceProviders,
                                labelText: '',
                                formHolderName: "Service Provider",
                                selectedItem: tvServiceProvider,
                                onChanged: (idx) {
                                  bettingIdController.text = '';
                                  verifiedName = "";
                                  setState(() => tvServiceProvider =
                                      tvServiceProviders[idx]);
                                },
                              ),
                      
                    
                              //
                    
                              spacer,
                              CustomInputField(
                                  formHolderName: "Bet ID / Phone Number",
                                  hintText: "",
                                  textEditingController: bettingIdController,
                                  textInputAction: TextInputAction.next,
                                  textInputType: TextInputType.text,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  counterText: "",
                                  enabled: tvServiceProvider != null,
                                  onChanged: (e) {
                                    verifiedName = "";
                                    setState(() {});
                                    Future.delayed(Duration(seconds: 1));
                                    _onVerifyMerchant(bettingIdController.text);
                                  }),
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
                              if (verifiedName.isNotEmpty)
                                Row(
                                  children: [
                                    CustomCheckConfirmed(
                                      text: "Attached Name: $verifiedName",
                                      showCheck: false,
                                    )
                                  ],
                                ),
                              spacer,
                              CustomInputField(
                                formHolderName: "Amount",
                                textInputAction: TextInputAction.done,
                                textEditingController: amountController,
                                textInputType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  // _amountFormatter
                                ],
                                validator: (val) => Validator.validateField(
                                    fieldName: "Amount", input: val),
                                onChanged: (_) => setState(() {}),
                              ),
                              const SizedBox(height: 85),
                              CustomButton(
                                text: "Proceed",
                                isActive: true,
                                onTap: () async {
                                  if (tvServiceProvider == null ||
                                      verifiedName.trim().isEmpty) {
                                    showCustomToast(
                                      context: context,
                                      description: "Please verify merchat",
                                    );
                    
                                    return;
                                  }
                    
                                  if (!(_formKey.currentState?.validate() ??
                                      false)) {
                                    return;
                                  }
                                  //
                    
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
                                  num amount = (parseNum(amountController.text
                                          .replaceAll(",", "")) ??
                                      0);
                                  await GenericHelper.getDiscount(
                                          'betting',
                                          tvServiceProvider?.name ?? "",
                                          amount.toString(),
                                          null)
                                      .then((value) async {
                                    // widget.param.phone = phoneController.text;
                                    // widget.param.discount = value;
                                    print("Discount ::: ${value.toJson()}");
                                    setState(() => loading = false);
                                    BettingArg arguments = BettingArg(
                                      provider: tvServiceProvider!,
                                      amount: amountController.text,
                                      number: bettingIdController.text,
                                      name: verifiedName!,
                                      discount: value,
                                    );
                                    await moveNext(context, arg: arguments);
                                    //  await showCustomBottomSheet(
                                    //       context: context,
                                    //       isDismissible: true,
                                    //       screen: BuyAirtime2(
                                    //         param: AirtimeArg(
                                    //           airtimeProvider: provider!,
                                    //           phone: phoneController.text,
                                    //           discount: value,
                                    //           amount: parseNum(amountController.text
                                    //                   .replaceAll(",", "")) ??
                                    //               0,
                                    //         ),
                                    //       ),
                                    //     );
                                    // await showCustomBottomSheet(
                                    //   context: context,
                                    //   screen: AirtimeSummary(param: widget.param),
                                    // );
                                  });
                                },
                                loading: btnLoading,
                              ),
                    
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

  moveNext(BuildContext context, {required BettingArg arg}) {
    showCustomBottomSheet(
      context: context,
      isDismissible: true,
      screen: Betting2(arg: arg),
    );
  }

  String verifiedName = "";
  bool verifyingInfo = false;
  Timer? _debounce;

  final Duration _debounceDuration = const Duration(seconds: 2);

  void _onVerifyMerchant(String id) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () {
      // call your API here
      if (id.length >= 3) {
        verifyInfo().catchError((_) {
          print(_);
        });
      }
    });
  }

  Future<void> verifyInfo() async {
    setState(() => verifyingInfo = true);
    verifiedName = await ServicesHelper.verifyBettingDetails(
            provider: tvServiceProvider!.code, number: bettingIdController.text)
        .then((value) => value)
        .catchError((e) {
      setState(() => verifyingInfo = false);
      showCustomToast(context: context, description: "$e");
    });

    verifyingInfo = false;
    if (mounted) setState(() {});
  }

  bool btnLoading = false;
}
