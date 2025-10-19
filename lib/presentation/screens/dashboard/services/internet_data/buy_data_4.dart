import 'dart:developer';

import 'package:dataplug/core/helpers/generic_helper.dart';
import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_progress.dart';
import 'package:dataplug/presentation/misc/image_manager/image_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants.dart';
import '../../../../../core/enum.dart';
import '../../../../../core/model/core/data_plans.dart';
import '../../../../../core/model/core/data_provider.dart';
import '../../../../../core/providers/generic_provider.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../../misc/custom_components/custom_elements.dart';
import '../../../../misc/custom_components/custom_input_field.dart';
import '../../../../misc/custom_components/custom_scaffold.dart';
import '../../../../misc/custom_snackbar.dart';
import '../../../../misc/select_contact.dart';
import '../../../../misc/style_manager/styles_manager.dart';
import 'buy_data_3.dart';
import 'misc/buy_data_arg.dart';
import 'misc/internet_data_item.dart';

class BuyData4 extends StatefulWidget {
  // final DataPurchaseType param;
  const BuyData4({
    super.key,
    // required this.param
  });

  @override
  State<BuyData4> createState() => _BuyData4State();
}

class _BuyData4State extends State<BuyData4> {
  final spacer = const SizedBox(height: 40);

  bool loading = true;
  List<DataProvider> dataProviders = [];
  DataProvider? dataProvider;
  List<DataPlan> dataList = [];
  List<String> dataPlanTypes = [];
  DataPlan? dataPlan;
  String type = 'sme';

  bool isPorted = false;
  void _toggleIsPorted() {
    setState(() {
      isPorted = !isPorted;
    });
    // _verifyPhone();
  }

  Future<void> getDataPlans() async {
    // List<DataPlan> dataList =
    await ServicesHelper.getDataPlan(dataProvider!.id, type).then((value) {
      dataList = value;
      log(dataList.toString(), name: "Data Plans");
    }).catchError((msg) {
      showCustomToast(context: context, description: msg.toString());
    });

    if (mounted) setState(() => loading = false);
  }
  // setState(() => btnLoading = true);

  // if (dataList.isEmpty) return;
  Future<void> getDataList() async {
    await ServicesHelper.getDataProvider().then((value) {
      dataProviders = value
          .where((service) =>
              service.code != 'smile' && service.code != 'spectranet')
          .toList();

      dataProvider = dataProviders.first;
      // log(dataProvider?.name ?? "", name: "Selected Provider");
      // getDataPlans();
      fetchTabs();
    }).catchError((msg) {
      showCustomToast(context: context, description: msg.toString());
    });

    if (mounted) setState(() => loading = false);
  }

  void fetchTabs() async {
    await ServicesHelper.getDataPlanTypes(dataProvider?.code ?? "")
        .then((value) {
      dataPlanTypes = value.reversed.toList();
      log(dataPlanTypes.toString());
      type = dataPlanTypes.first.split(" ").last.toLowerCase();
      // log(dataProvider?.name ?? "", name: "Selected Provider");
      getDataPlans();
    }).catchError((msg) {
      showCustomToast(context: context, description: msg.toString());
    }); // use actual provider
    if (mounted) setState(() {});
  }

  bool phoneError = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getDataList();
    });

    phoneController.addListener(() {
      if (dataProvider != null && phoneController.text.length >= 4) {
        final isValid =
            isValidNetwork(phoneController.text, dataProvider!.name);
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

      if (phoneController.text.length >= 4 && (isPorted == false)) {
        final network = getNetwork(phoneController.text);

        // if (dataProviders.isNotEmpty) {
        final foundProvider = dataProviders.firstWhere(
          (p) => p.name.toLowerCase().contains(network.toLowerCase()),
        );

        setState(() {
          dataProvider = foundProvider;
        });
        // }
      }
    });

    super.initState();
  }

  TextEditingController phoneController = TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();

  ScrollController controller = ScrollController();

  moveNext(BuildContext context,
      {required DataPlan dataPlan,
      required bool isPorted,
      required DataProvider dataProvider}) async {
    await GenericHelper.getDiscount(
      'data',
      dataProvider.code,
      dataPlan.amount,
      dataPlan.code,
    ).then((value) async {
      print("Discount ::: ${value.toJson()}");
      showCustomBottomSheet(
        context: context,
        isDismissible: true,
        screen: BuyData3(
            arg: BuyDataArg(
                dataPlans: dataList,
                dataProvider: dataProvider,
                phone: phoneController.text,
                selectedPlan: dataPlan,
                discount: value,
                isPorted: isPorted,
                dataPurchaseType: type == 'sme'
                    ? DataPurchaseType.sme
                    :
                    // type == 'direct'
                    //     ? DataPurchaseType.direct
                    //     :
                    type == 'cg'
                        ? DataPurchaseType.cg
                        : type == 'gifting'
                            ? DataPurchaseType.gifting
                            : type == 'awoof'
                                ? DataPurchaseType.awoof
                                : DataPurchaseType.coupon),
            dataPlan: dataPlan),
      );
    });
  }

  Widget buildItems(BuildContext context,
      {required List<DataPlan> dPs, required String number}) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: dPs.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
        ),
        itemBuilder: (context, index) {
          final plan = dPs[index];
          return InternetDataItem(
            plan: plan,
            onTap: () {
              FocusScope.of(context).unfocus();
              if (!(_formKey.currentState?.validate() ?? false)) return;
              moveNext(context,
                  dataPlan: plan,
                  isPorted: isPorted,
                  dataProvider: dataProvider!);
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return CustomScaffold(
        backgroundColor: ColorManager.kPrimary,
        body: SafeArea(
            bottom: false,
            child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Container(
                    height: size.height,
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
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding:
                                    const EdgeInsets.only(left: 15, top: 15),
                                alignment: Alignment.centerLeft,
                                child: const BackIcon(),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  Image.asset(ImageManager.kBuyData2,
                                      width: 44),
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
                          margin: const EdgeInsets.only(top: 16, bottom: 14),
                          color: ColorManager.kBar2Color,
                        ),
                        Gap(16),

                        Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.75,
                            child: ListView(
                              controller: controller,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              children: [
                                buildProviderSelector(),
                                const Gap(10),
                                CustomInputField(
                                  formHolderName: "Phone Number",
                                  textInputAction: TextInputAction.next,
                                  textEditingController: phoneController,
                                  textInputType: TextInputType.number,
                                  suffixIcon: InkWell(
                                    onTap: () async {
                                      Contact? res =
                                          await showCustomBottomSheet(
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
                                    if (mobileValidation != null) {
                                      return mobileValidation;
                                    }
                                    return null;
                                  },
                                ),
                                if (phoneError && !isPorted)
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
                                plansAndTypes(),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ))));
  }

  SizedBox buildProviderSelector() {
    return SizedBox(
      height: 110,
      child: ListView.separated(
          separatorBuilder: (context, index) => Gap(16),
          scrollDirection: Axis.horizontal,
          itemCount: dataProviders.length,
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 16),
          itemBuilder: (context, index) {
            final biller = dataProviders[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  dataProvider = biller;
                  fetchTabs();
                  if (dataProvider != null &&
                      phoneController.text.length >= 4) {
                    final isValid = isValidNetwork(
                        phoneController.text, dataProvider!.name);
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
                });
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 86,
                    height: 86,
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: dataProvider?.name == biller.name
                          ? ColorManager.kPrimaryLight
                          : Colors.white,
                      borderRadius: BorderRadius.circular(19),
                      border: Border.all(
                          color: dataProvider?.name == biller.name
                              ? ColorManager.kPrimaryLight
                              : Color(0xffeeeeee),
                          width: 1.5),
                    ),
                    child: Column(
                      // spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        loadNetworkImage(
                          biller.toIcon(),
                          width: 24,
                          height: 24,
                          borderRadius: BorderRadius.circular(78),
                        ),
                        Text(
                          biller.name,
                          style: get14TextStyle().copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: ColorManager.kFadedTextColor),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: -5,
                    child: dataProvider?.name == biller.name
                        ? Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: ColorManager.kPrimary,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 15,
                            ),
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
            );
          }),
    );
  }

  DefaultTabController plansAndTypes() {
    return DefaultTabController(
      length: dataPlanTypes.isNotEmpty ? dataPlanTypes.length : 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            onTap: (index) {
              String selected = dataPlanTypes[index];
              String lastWord = selected.split(" ").last.toLowerCase();
              setState(() {
                type = lastWord;
                getDataPlans();
              });
            },
            indicatorSize: TabBarIndicatorSize.label,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: ColorManager.kPrimary, width: 2.0),
            ),
            labelColor: ColorManager.kPrimary,
            unselectedLabelColor: ColorManager.kTextColor,
            isScrollable: true,
            labelPadding: EdgeInsets.only(right: 16),
            tabAlignment: TabAlignment.start,
            tabs: dataPlanTypes.map((title) => Tab(text: title)).toList(),
          ),
          SizedBox(
            height: 400, // Give it a fixed height or use MediaQuery
            child: TabBarView(
              children: List.generate(
                dataPlanTypes.length,
                (index) {
                  if (dataList.isEmpty) {
                    return Center(child: Text("No data plans"));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    controller: controller,
                    itemCount: (dataList.length / 3).ceil(),
                    itemBuilder: (context, idx) {
                      int startIndex = idx * 3;
                      int endIndex = (startIndex + 3 <= dataList.length)
                          ? startIndex + 3
                          : dataList.length;

                      return buildItems(
                        context,
                        number: phoneController.text,
                        dPs: dataList.sublist(startIndex, endIndex),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool btnLoading = false;
}
