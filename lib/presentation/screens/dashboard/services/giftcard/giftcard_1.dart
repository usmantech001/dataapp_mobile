import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/core/model/core/giftcard_product_provider.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_progress.dart';
import 'package:dataplug/presentation/misc/image_manager/image_manager.dart';

import '../../../../../core/helpers/generic_helper.dart';
import '../../../../../core/model/core/giftcard_category_provider.dart';
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
import 'arg.dart';
import 'giftcard_2.dart';

class Giftcard1 extends StatefulWidget {
  const Giftcard1({super.key});

  @override
  State<Giftcard1> createState() => _Giftcard1State();
}

class _Giftcard1State extends State<Giftcard1> {
  final spacer = const SizedBox(height: 16);

  ScrollController controller = ScrollController();

  bool loading = true;
  bool isLoadingMoreCategories = false;
  List<GiftcardCategory> categories = [];
  GiftcardCategory? category;
  Country? country;
  List<GiftCardProduct>? giftcards;
  GiftCardProduct? giftcard;
  bool isLoadingMoreGiftcards = false;
  int giftcardPage = 1;

  String giftcardCurrency = '';

  ScrollController giftcardScrollController = ScrollController();
  ScrollController categoryScrollController = ScrollController();

  List<GiftcardType> types = [
    GiftcardType("Physical"),
    GiftcardType("Virtual")
  ];
  GiftcardType? type;
  Future<void> getDataList({int page = 1}) async {
    if (page > 1) {
      setState(() {
        isLoadingMoreCategories = true;
      });
    }
    await ServicesHelper.getGiftcardCategories(search: '', page: page)
        .then((value) {
      if (mounted) {
        setState(() {
          categories.addAll(value.data); // Add more categories to the list
          if (page == 1) {
            loading =
                false; // Set loading to false after initial data is fetched
          } else {
            isLoadingMoreCategories = false; // Pagination loading done
          }
        });
      }
    }).catchError((msg) {
      showCustomToast(context: context, description: msg.toString());
      if (mounted) {
        setState(() {
          if (page == 1) {
            loading =
                false; // Also set loading to false on error to avoid infinite loading
          } else {
            isLoadingMoreCategories = false;
          }
        });
      }
    });
  }

  Widget buildCategoryLoadingIndicator() {
    if (isLoadingMoreCategories) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return SizedBox.shrink();
  }

  Future<void> getGiftcardProduct(
      {required String categoryId,
      required String countryId,
      int page = 1}) async {
    if (page > 1) {
      setState(() {
        isLoadingMoreGiftcards = true;
      });
    }
    await ServicesHelper.getGiftcardProduct(
            categoryId: categoryId, countryId: countryId)
        .then((value) {
      if (mounted) {
        setState(() {
          if (page == 1) {
            giftcards = value.data;
          } else {
            giftcards?.addAll(value.data);
            isLoadingMoreGiftcards = false;
          }
          // Update giftcardPage only if new data is received
          if (value.data.isNotEmpty) {
            giftcardPage = page;
          }
          loading = false;
        });
      }
    }).catchError((msg) {
      showCustomToast(context: context, description: msg.toString());
      if (mounted) {
        setState(() {
          if (page > 1) {
            isLoadingMoreGiftcards = false;
          } else {
            loading = false;
          }
        });
      }
    });
  }

  List<GiftcardCategory> categories1 = [];
  String category1 = '';
  bool loading1 = true;
  bool isLoadingMoreCategories1 = false;

  @override
  void initState() {
    super.initState();
    getDataList(page: 1); // Fetch the first page of categories
  }

  Future<void> getDataList1({int page = 1}) async {
    if (page > 1) {
      setState(() {
        isLoadingMoreCategories = true;
      });
    }
    await ServicesHelper.getGiftcardCategories(search: '', page: page)
        .then((value) {
      if (mounted) {
        setState(() {
          categories.addAll(value.data); // Add more categories to the list
          if (page == 1) {
            loading =
                false; // Set loading to false after initial data is fetched
          } else {
            isLoadingMoreCategories = false; // Pagination loading done
          }
        });
      }
    }).catchError((msg) {
      print(msg); // Handle error here
      if (mounted) {
        setState(() {
          if (page == 1) {
            loading = false; // Set loading to false if there is an error
          } else {
            isLoadingMoreCategories = false;
          }
        });
      }
    });
  }

  //
  // @override
  // void initState() {
  //   giftcardScrollController.addListener(() {
  //     if (giftcardScrollController.position.atEdge) {
  //       if (giftcardScrollController.position.pixels != 0) {
  //         if (!isLoadingMoreGiftcards) {
  //           getGiftcardProduct(
  //             categoryId: category?.id.toString() ?? "",
  //             countryId: country?.id.toString() ?? "",
  //             page: giftcardPage + 1,
  //           );
  //         }
  //       }
  //     }
  //   });
  //   // WidgetsBinding.instance.addPostFrameCallback((_) {
  //     getDataList();
  //   // });
  //   super.initState();
  // }

  TextEditingController amountController = TextEditingController(text: "");
  TextEditingController _quantityController = TextEditingController(text: "1");

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

  @override
  Widget build(BuildContext context) {
    //  _quantityController = TextEditingController(text: "1");
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
                          Image.asset(ImageManager.kGiftIcon, width: 44),
                          const SizedBox(height: 13),
                          Text(
                            "Buy Giftcard",
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
                                onTap: () {
                                  final controller = ScrollController();
                                  controller.addListener(() {
                                    if (controller.position.atEdge) {
                                      if (controller.position.pixels == 0) {
                                        // At the top
                                      } else {
                                        // At the bottom
                                        if (!isLoadingMoreCategories) {
                                          // Load more categories
                                          getDataList(
                                              page: (categories.length / 10)
                                                      .round() +
                                                  1); // Assuming 10 items per page
                                        }
                                      }
                                    }
                                  });
                                },
                                items: categories,
                                labelText: '',
                                formHolderName: "Giftcard Category",
                                selectedItem: category,
                                onChanged: (idx) {
                                  setState(() {
                                    category = categories[idx];
                                    country = null;
                                    giftcard = null;
                                    amountController.text = '';
                                  });
                                },
                              ),
                    
                              // GiftcardCategorySelector(
                              //   categories: categories,
                              //   labelText: "Giftcard Category",
                              //   onChanged: (idx) {
                              //     // setState(() => category);
                              //       setState(() => category = categories[idx]);
                              //   },
                              // ),
                    
                              spacer,
                              CustomDropdownButtonFormField(
                                items: category?.countries ?? [],
                                labelText: '',
                                formHolderName: "Country",
                                selectedItem: country,
                                onChanged: (idx) {
                                  setState(() {
                                    country = category?.countries[idx];
                                    giftcard = null;
                                    amountController.text = '';
                                  });
                                  if (category != null && country != null) {
                                    getGiftcardProduct(
                                        categoryId: category!.id.toString(),
                                        countryId: country!.id.toString());
                                  }
                                },
                              ),
                              //
                              spacer,
                              CustomDropdownButtonFormField(
                                enabled: country != null,
                                items: giftcards ?? [],
                                labelText: '',
                                formHolderName: "Product",
                                selectedItem: giftcard,
                                onTap: () {
                                  final controller = ScrollController();
                                  controller.addListener(() {
                                    if (controller.position.atEdge) {
                                      if (controller.position.pixels == 0) {
                                        // At the top
                                      } else {
                                        // At the bottom
                                        if (!isLoadingMoreGiftcards) {
                                          getGiftcardProduct(
                                            categoryId:
                                                category?.id.toString() ?? "",
                                            countryId:
                                                country?.id.toString() ?? "",
                                            page: giftcardPage + 1,
                                          );
                                        }
                                      }
                                    }
                                  });
                                },
                                onChanged: (idx) {
                                  setState(() {
                                    giftcard = giftcards![idx];
                                    giftcardCurrency =
                                        giftcards?[idx].currency ?? "";
                                    amountController.text = "";
                                  });
                    
                                  log(giftcard!.priceList!.length.toString(),
                                      name: "Price List");
                                },
                              ),
                              spacer,
                              if (giftcard != null)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Rate: ${RegExp(r'Rate[:\s]*([^\.\n]+)').firstMatch(giftcard!.toName())?.group(1)?.trim() ?? ''}",
                                      style: TextStyle(
                                          color: ColorManager.kPrimary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "Min${giftcard!.toName().split("Min").last.replaceAll(")", "")}",
                                      style: TextStyle(
                                          color: ColorManager.kPrimary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                )
                              else
                                const SizedBox.shrink(),
                              spacer,
                    
                              CustomDropdownButtonFormField(
                                items: types,
                                selectedItem: type,
                                labelText: 'Select Giftcard Type',
                                formHolderName: "Giftcard Type",
                                hintText: "",
                                textInputAction: TextInputAction.next,
                                onChanged: (int idx) => setState(() {
                                  type = types[idx];
                                }),
                              ),
                              spacer,
                    
                              CustomInputField(
                                  onTap: () {
                                    if (giftcard?.priceList?.isNotEmpty ??
                                        false) {
                                      _showAmountPicker(
                                          priceList: giftcard?.priceList ?? []);
                                    }
                                  },
                                  readOnly:
                                      giftcard?.priceList?.isNotEmpty ?? false,
                                  formHolderName: "Amount",
                                  textInputAction: TextInputAction.done,
                                  textEditingController: amountController,
                                  textInputType: TextInputType.number,
                                  prefixIconConstraints:
                                      BoxConstraints(maxWidth: 100),
                                  prefixIcon: Text(
                                      "   ${getCurrencySymbol(giftcardCurrency)}"),
                                  suffixIcon: giftcard?.priceList?.isNotEmpty ??
                                          false
                                      ? Icon(Icons.keyboard_arrow_down_sharp,
                                          color: ColorManager.kFormHintText,
                                          size: 25)
                                      : null,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    // _amountFormatter
                                  ],
                                  validator: (val) => Validator.validateField(
                                      fieldName: "Amount", input: val),
                                  onChanged: (value) {
                                    final amount =
                                        convertMoneyText(amountController.text);
                                    final qty = int.tryParse(
                                            _quantityController.text) ??
                                        1;
                                    final rate = giftcard?.buyRate ?? 0.0;
                    
                                    calcUSDEqui(amount, qty);
                                    calcNairaEqui(amount * qty, rate);
                                  }),
                              spacer,
                              amountController.text.isEmpty
                                  ? SizedBox.shrink()
                                  : Text(
                                      "Amount in Naira: NGN ${formatNumber(payableInNGN)}"),
                    
                              spacer,
                    
                              CustomInputField(
                                formHolderName: "Quantity",
                                textInputAction: TextInputAction.done,
                                textEditingController: _quantityController,
                                textInputType: TextInputType.numberWithOptions(
                                    decimal: false),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) {
                                  // calcUSDEqui(convertMoneyText(value),
                                  //     int.parse(_quantityController.text));
                    
                                  // calcNairaEqui(convertMoneyText(value),
                                  //     giftcard?.buyRate ?? 0.0);
                                  //   setState(() {
                                  final amount =
                                      convertMoneyText(amountController.text);
                                  final qty = int.tryParse(value) ?? 1;
                                  final rate = giftcard?.buyRate ?? 0.0;
                    
                                  calcUSDEqui(amount, qty);
                                  calcNairaEqui(amount * qty, rate);
                                  // });
                                },
                              ),
                              spacer,
                    
                              // CustomInputField(
                              //   enabled: false,
                    
                              //   formHolderName: "Amount",
                              //   textInputAction: TextInputAction.done,
                              //   textEditingController: TextEditingController(
                              //       text: "${formatNumber(payableInNGN)}"),
                              //   textInputType: TextInputType.number,
                              //   suffixConstraints:
                              //       BoxConstraints(maxWidth: 200),
                              //   suffixIcon: Container(
                              //     padding: EdgeInsets.all(5),
                              //     decoration: BoxDecoration(
                              //         borderRadius: BorderRadius.circular(10),
                              //         color: ColorManager.kPrimaryLight),
                              //     child: Text(
                              //       '\$$payableInUSD',
                              //       style: TextStyle(
                              //           color: ColorManager.kPrimary,
                              //           fontSize: 12,
                              //           fontWeight: FontWeight.w500),
                              //     ),
                              //   ),
                              //   inputFormatters: [
                              //     FilteringTextInputFormatter.digitsOnly,
                              //     // _amountFormatter
                              //   ],
                              //   onChanged: (_) => setState(() {}),
                              // ),
                              const SizedBox(height: 85),
                              CustomButton(
                                text: "Proceed",
                                isActive: true,
                                onTap: () async {
                                  if (category == null) {
                                    showCustomToast(
                                      context: context,
                                      description: "Please select category",
                                    );
                                    return;
                                  }
                    
                                  if (!(_formKey.currentState?.validate() ??
                                      false)) {
                                    return;
                                  }
                    
                                  setState(
                                      () => btnLoading = true); // Start loading
                    
                                  Map<String, dynamic> body = {
                                    "giftcard_id": giftcard?.id,
                                    "amount": (parseNum(amountController.text
                                                .replaceAll(",", "")) ??
                                            0) *
                                        num.parse(_quantityController.text),
                                    "trade_type": 'buy',
                                  };
                    
                                  try {
                                    final value =
                                        await ServicesHelper.getBreakdown(body);
                                    setState(() => loading = false);
                    
                                    GiftcardArg arguments = GiftcardArg(
                                      product: giftcard!,
                                      amount: amountController.text,
                                      breakdown: value,
                                      amountInNGN: payableInNGN.toString(),
                                      type: type!,
                                      category: category?.name ?? "",
                                      quantity: _quantityController.text,
                                      total: payableInUSD.toString(),
                                    );
                    
                                    moveNext(context, arg: arguments);
                                  } catch (err) {
                                    setState(() => btnLoading =
                                        false); // Stop loading on error
                                    showCustomToast(
                                      context: context,
                                      description: err.toString(),
                                    );
                                  }
                                },
                                loading: loading,
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

  void _showAmountPicker({required List<num> priceList}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        builder: (context) => Container(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      "Select Amount",
                      style: get18TextStyle(),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView(
                        shrinkWrap: true,
                        children: priceList.map((amount) {
                          return ListTile(
                            title: Text('${formatNumber(amount)}',
                                style: get16TextStyle()),
                            onTap: () {
                              amountController.text = formatNumber(amount);

                              calcNairaEqui(convertMoneyText(amount.toString()),
                                  giftcard?.buyRate ?? 0.0);
                              Navigator.pop(context);
                            },
                          );
                        }).toList()),
                  ),
                ],
              ),
            ));
  }

  moveNext(BuildContext context, {required GiftcardArg arg}) {
    showCustomBottomSheet(
      context: context,
      isDismissible: true,
      screen: Giftcard2(arg: arg),
    );
  }

  bool btnLoading = false;
}
