import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:gap/gap.dart';

import '../../../../../core/enum.dart';
import '../../../../../core/helpers/service_helper.dart';
import '../../../../../core/model/core/data_plans.dart';
import '../../../../../core/model/core/data_provider.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../../misc/custom_components/custom_btn.dart';
import '../../../../misc/custom_components/custom_elements.dart';
import '../../../../misc/custom_components/custom_input_field.dart';
import '../../../../misc/custom_components/custom_progress.dart';
import '../../../../misc/custom_components/custom_scaffold.dart';
import '../../../../misc/custom_components/loading.dart';
import '../../../../misc/custom_snackbar.dart';
import '../../../../misc/image_manager/image_manager.dart';
import '../../../../misc/route_manager/routes_manager.dart';
import '../../../../misc/select_contact.dart';
import '../../../../misc/style_manager/styles_manager.dart';
import 'misc/buy_data_arg.dart';

class BuyData5 extends StatefulWidget {
  final DataProvider param;
  const BuyData5({super.key, required this.param});

  @override
  State<BuyData5> createState() => _BuyData5State();
}

class _BuyData5State extends State<BuyData5> {
  final spacer = const SizedBox(height: 40);

  bool loading = true;
  List<DataProvider> dataProviders = [];

  Map<String, List<DataPlan>> groupedBundles = {};
  List<String> tabKeys = [];

  Future<void> getDataList() async {
    await ServicesHelper.getDataProvider().then((value) {
      dataProviders = value;
//   dataProviders = value.where(
//   (service) => service.code != 'smile' && service.code != 'spectranet'
// ).toList();
    }).catchError((msg) {
      showCustomToast(context: context, description: msg.toString());
    });

    if (mounted) setState(() => loading = false);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getDataList();
    });
    super.initState();
  }

  bool isPorted = false;
  void _toggleIsPorted() {
    setState(() {
      isPorted = !isPorted;
    });
    // _verifyPhone();
  }

  TextEditingController phoneController = TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();

  ScrollController controller = ScrollController();

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
                          Image.asset(ImageManager.kBuyData2, width: 44),
                          const SizedBox(height: 13),
                          Text(
                            "Buy Data",
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
                  margin: const EdgeInsets.only(top: 16, bottom: 55),
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
                              //
                              // CustomDropdownButtonFormField(
                              //   items: dataProviders,
                              //   labelText: 'Select Network',
                              //   formHolderName: "Network",
                              //   selectedItem: dataProvider,
                              //   onChanged: (_) {
                              //     dataProvider = dataProviders[_];
                              //     setState(() {});
                              //   },
                              // ),
                    
                              // spacer,
                    
                              // spacer,
                    
                              // spacer,
                              CustomInputField(
                                formHolderName:
                                    "${capitalizeFirstString(widget.param.name)} ID / Phone Number",
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
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                validator: (val) => isPorted
                                    ? null
                                    : Validator.validateMobile(val),
                              ),
                              const SizedBox(height: 10),
                              // Row(
                              //   children: [
                              //     CustomCheckConfirmed(
                              //         text: "Attached Name: JAMES IYIADE"),
                              //   ],
                              // ),
                              // GestureDetector(
                              //   onTap: () => _toggleIsPorted(),
                              //   child: Row(
                              //     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Checkbox(
                              //           value: isPorted,
                              //           onChanged: (v) => _toggleIsPorted()),
                              //       SizedBox(
                              //         width: 0,
                              //       ),
                              //       Text("Is this number ported?"),
                              //     ],
                              //   ),
                              // ),
                    
                              const SizedBox(height: 85),
                              // Center(
                              //   child: CircularProgressIndicator(
                              //     value: .1,
                              //     semanticsLabel: 'Circular progress indicator',
                              //     backgroundColor: Colors.grey[200],
                              //     valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                              //   ),
                              // ),
                              CustomButton(
                                text: "Proceed",
                                isActive: true,
                                onTap: () async {
                                  if (!(_formKey.currentState?.validate() ??
                                      false)) {
                                    return;
                                  }
                                  //
                    
                                  setState(() => btnLoading = true);
                                  List<DataPlan> dataList =
                                      await ServicesHelper.getDataPlan(
                                    widget.param!.id,
                                    'direct',
                                  ).catchError((msg) {
                                    showCustomToast(
                                        context: context,
                                        description: msg.toString());
                                  });
                    
                                  setState(() => btnLoading = false);
                                  if (dataList.isEmpty) return;
                    
                                  Navigator.pushNamed(
                                    context,
                                    RoutesManager.buyData2,
                                    arguments: BuyDataArg(
                                      dataProvider: widget.param,
                                      phone: phoneController.text,
                                      dataPurchaseType: DataPurchaseType.direct,
                                      isPorted: isPorted,
                                      discount: null,
                                      dataPlans: dataList,
                                    ),
                                  );
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

  bool btnLoading = false;
}
