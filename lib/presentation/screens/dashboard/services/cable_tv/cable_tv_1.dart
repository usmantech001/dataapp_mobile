import 'dart:async';

import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_check_confirmed.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_progress.dart';
import 'package:dataplug/presentation/misc/image_manager/image_manager.dart';
import 'package:dataplug/presentation/screens/dashboard/services/cable_tv/misc/arg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/model/core/cable_tv_plan.dart';
import '../../../../../core/model/core/cable_tv_provider.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../misc/custom_components/custom_dropdown_btn.dart';
import '../../../../misc/custom_components/custom_elements.dart';
import '../../../../misc/custom_components/custom_input_field.dart';
import '../../../../misc/custom_components/custom_scaffold.dart';
import '../../../../misc/custom_components/loading.dart';
import '../../../../misc/custom_snackbar.dart';
import '../../../../misc/route_manager/routes_manager.dart';
import '../../../../misc/style_manager/styles_manager.dart';

class CableTv1 extends StatefulWidget {
  const CableTv1({super.key});

  @override
  State<CableTv1> createState() => _CableTv1State();
}

class _CableTv1State extends State<CableTv1> {
  final spacer = const SizedBox(height: 40);

  ScrollController controller = ScrollController();

  bool loading = true;
  List<CableTvProvider> tvServiceProviders = [];
  CableTvProvider? tvServiceProvider;

  Timer? _debounce;

  final Duration _debounceDuration = const Duration(seconds: 2);

  void _onVerifyMerchant() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () {
      // call your API here
      if (decoderNumberController.text.length >= 5) {
        verifyInfo().catchError((_) {
          print(_);
        });
      }
    });
  }

  Future<void> getDataList() async {
    await ServicesHelper.getTVServiceProviders().then((value) {
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

  TextEditingController decoderNumberController =
      TextEditingController(text: "");

  final _formKey = GlobalKey<FormState>();

  List<CableTvType> types = [CableTvType("Renew"), CableTvType("Change")];
  CableTvType? type;

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
                          Image.asset(ImageManager.kCableTvIcon, width: 44),
                          const SizedBox(height: 13),
                          Text(
                            "Pay TV/Cable",
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
                                  decoderNumberController.text = '';
                                  verifiedName = "";
                                  setState(() => tvServiceProvider =
                                      tvServiceProviders[idx]);
                                },
                              ),
                              spacer,
                              CustomDropdownButtonFormField(
                                items: types,
                                selectedItem: type,
                                labelText: 'Select  Type',
                                formHolderName: "Type",
                                hintText: "",
                                textInputAction: TextInputAction.next,
                                onChanged: (int idx) => setState(() {
                                  type = types[idx];
                                }),
                              ),
                    
                              //
                    
                              spacer,
                              CustomInputField(
                                formHolderName: "Decoder Number",
                                hintText: "",
                                textEditingController: decoderNumberController,
                                textInputAction: TextInputAction.next,
                                textInputType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                maxLength: 20,
                                counterText: "",
                                enabled:
                                    tvServiceProvider != null && type != null,
                                onChanged: (e) {
                                  // verifiedName = "";
                                  // setState(() {});
                                  // if (e.length == 10) {
                                  //   verifyInfo().catchError((_) {});
                                  // }
                                  _onVerifyMerchant();
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
                              if (verifiedName.isNotEmpty)
                                Row(
                                  children: [
                                    CustomCheckConfirmed(
                                      text: "Attached Name: $verifiedName",
                                      showCheck: false,
                                    )
                                  ],
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
                                      description: "Please select a network",
                                    );
                    
                                    return;
                                  }
                    
                                  if (!(_formKey.currentState?.validate() ??
                                      false)) {
                                    return;
                                  }
                                  //
                    
                                  setState(() => btnLoading = true);
                                  List<CableTvPlan> dList =
                                      await ServicesHelper.getTvPlans(
                                              tvServiceProvider!.id)
                                          .catchError((msg) {
                                    showCustomToast(
                                        context: context,
                                        description: msg.toString());
                                  });
                    
                                  setState(() => btnLoading = false);
                                  if (dList.isEmpty) return;
                    
                                  Navigator.pushNamed(
                                    context,
                                    RoutesManager.cableTv2,
                                    arguments: CableTvArg(
                                      provider: tvServiceProvider!,
                                      plans: dList,
                                      number: decoderNumberController.text,
                                      type: type!,
                                    ),
                                  );
                    
                                  //
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

  String verifiedName = "";
  bool verifyingInfo = false;
  Future<void> verifyInfo() async {
    setState(() => verifyingInfo = true);
    verifiedName = await ServicesHelper.verifyTvDetails(
            provider: tvServiceProvider!.name,
            number: decoderNumberController.text)
        .then((value) => value)
        .catchError((e) {
      showCustomToast(context: context, description: "$e");
    });

    verifyingInfo = false;
    if (mounted) setState(() {});
  }

  bool btnLoading = false;
}
