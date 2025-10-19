import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/core/utils/utils.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_check_confirmed.dart';
import 'package:dataplug/presentation/misc/image_manager/image_manager.dart';
import 'package:dataplug/presentation/screens/dashboard/services/epin/misc/epin_arg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/helpers/generic_helper.dart';
import '../../../../../core/model/core/e_pin_product.dart';
import '../../../../../core/model/core/e_pin_provider.dart';
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
import 'buy_epin_2.dart';

class BuyEPin1 extends StatefulWidget {
  const BuyEPin1({super.key});

  @override
  State<BuyEPin1> createState() => _BuyEPin1State();
}

class _BuyEPin1State extends State<BuyEPin1> {
  final spacer = const SizedBox(height: 40);

  ScrollController controller = ScrollController();

  bool loading = true;
  List<EPinProvider> epinProviders = [];
  EPinProvider? epinProvider;

  Future<void> getDataList() async {
    await ServicesHelper.getEPinProviders().then((value) {
      epinProviders = value;
    }).catchError((msg) {
      showCustomToast(context: context, description: msg.toString());
    });

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getDataList();
    });
    super.initState();
  }

  List<EPinProduct> epinProducts = [];
  EPinProduct? epinProduct;
  bool epinProductLoading = false;
  Future<void> getProductList(EPinProvider provider) async {
    setState(() => epinProductLoading = true);
    await ServicesHelper.getEPinProducts(provider.id).then((value) {
      epinProducts = value;
    }).catchError((msg) {
      showCustomToast(context: context, description: msg.toString());
    });

    if (mounted) setState(() => epinProductLoading = false);
  }

  TextEditingController customerIdController = TextEditingController(text: "");

  List<EPinProductType> productTypes = [
    EPinProductType("UTME"),
    EPinProductType("DE"),
  ];
  EPinProductType? productType;

  //
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
                        Image.asset(ImageManager.kPinIcon, width: 44),
                        const SizedBox(height: 13),
                        Text(
                          "Buy E-PIN",
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
                margin: const EdgeInsets.only(top: 16, bottom: 40),
                color: ColorManager.kBar2Color,
              ),

              Expanded(
                child: loading
                    ? buildLoading(wrapWithExpanded: false)
                    : ListView(
                        controller: controller,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        children: [
                          //
                          CustomDropdownButtonFormField(
                            items: epinProviders,
                            selectedItem: epinProvider,
                            labelText: 'Select Network',
                            formHolderName: "Provider",
                            onChanged: (idx) {
                              epinProvider = epinProviders[idx];
                              setState(() {
                                epinProduct = null;
                              });
                              getProductList(epinProvider!);
                            },
                            suffixIcon: Icon(Icons.keyboard_arrow_down_sharp,
                                color: ColorManager.kFormHintText, size: 25),
                          ),

                          spacer,
                          CustomDropdownButtonFormField(
                            enabled: !epinProductLoading,
                            items: epinProducts,
                            selectedItem: epinProduct,
                            labelText: 'Select Product',
                            formHolderName: "Product",
                            onChanged: (idx) {
                              epinProduct = epinProducts[idx];
                              setState(() {});
                            },
                            suffixIcon: epinProductLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          ColorManager.kPrimary),
                                    ),
                                  )
                                : Icon(Icons.keyboard_arrow_down_sharp,
                                    color: ColorManager.kFormHintText,
                                    size: 25),
                          ),

                          spacer,
                          CustomDropdownButtonFormField(
                            enabled: epinProduct != null,
                            items: productTypes,
                            selectedItem: productType,
                            labelText: 'Select Product',
                            formHolderName: "Product",
                            onChanged: (idx) {
                              productType = productTypes[idx];
                            },
                          ),

                          //
                          spacer,
                          CustomInputField(
                            formHolderName: "Candidate Number",
                            textEditingController: customerIdController,
                            textInputAction: TextInputAction.done,
                            textInputType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            maxLength: 10,
                            counterText: "",
                            onChanged: (e) {
                              setState(() => verifiedName = "");
                              if (e.length == 10) {
                                verifyInfo().then((_) {}).catchError((_) {});
                              }
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

                          spacer,
                          IgnorePointer(
                            child: CustomInputField(
                              formHolderName: "Amount",
                              hintText: "",
                              textInputAction: TextInputAction.done,
                              textEditingController: TextEditingController(
                                text: formatCurrency(epinProduct?.amount),
                              ),
                            ),
                          ),
                          const SizedBox(height: 85),
                          CustomButton(
                            text: "Proceed",
                            isActive: true,
                            onTap: () async {
                              if (epinProvider == null ||
                                  epinProduct == null ||
                                  productType == null ||
                                  verifiedName.trim().isEmpty ||
                                  customerIdController.text.isEmpty) {
                                showCustomToast(
                                    context: context,
                                    description: "Please fill in all details");
                                return;
                              }

                              await GenericHelper.getDiscount(
                                      'education',
                                      epinProvider?.code ?? "",
                                      epinProduct?.amount.toString(),
                                      epinProduct?.code ?? "")
                                  .then((value) async {
                                // widget.param.phone = phoneController.text;
                                // widget.param.discount = value;
                                print("Discount ::: ${value.toJson()}");
                                setState(() => loading = false);

                                await showCustomBottomSheet(
                                  context: context,
                                  isDismissible: true,
                                  screen: BuyEPin2(
                                    param: EPinArg(
                                      provider: epinProvider!,
                                      epinProduct: epinProduct!,
                                      discount: value,
                                      number: customerIdController.text,
                                      ePinProductType: productType!,
                                    ),
                                  ),
                                );
                              });

                              //
                            },
                            loading: false,
                          ),

                          const SizedBox(height: 35),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String verifiedName = "";
  bool verifyingInfo = false;
  Future<void> verifyInfo() async {
    setState(() => verifyingInfo = true);
    verifiedName = await ServicesHelper.verifyEpinDetails(
            type: (productType?.field ?? "").toLowerCase(),
            number: customerIdController.text)
        .then((value) => value)
        .catchError((e) {
      if (mounted) {
        showCustomToast(context: context, description: "$e");
        setState(() => loading = false);
      }
    });

    verifyingInfo = false;
    if (mounted) setState(() {});
  }
}
