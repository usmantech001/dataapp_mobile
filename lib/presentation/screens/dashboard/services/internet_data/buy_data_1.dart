// ✅ This is your edited BuyData1 screen with working tabs & dynamic bundles based on selected TabBar


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:gap/gap.dart';

import '../../../../../core/enum.dart';
import '../../../../../core/helpers/generic_helper.dart';
import '../../../../../core/helpers/service_helper.dart';
import '../../../../../core/model/core/data_plans.dart';
import '../../../../../core/model/core/data_provider.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../../misc/custom_components/custom_elements.dart';
import '../../../../misc/custom_components/custom_input_field.dart';
import '../../../../misc/custom_components/custom_progress.dart';
import '../../../../misc/custom_components/custom_scaffold.dart';
import '../../../../misc/custom_components/loading.dart';
import '../../../../misc/custom_snackbar.dart';
import '../../../../misc/image_manager/image_manager.dart';
import '../../../../misc/select_contact.dart';
import '../../../../misc/style_manager/styles_manager.dart';
import 'buy_data_3.dart';
import 'misc/buy_data_arg.dart';
import 'misc/internet_data_item.dart';

class BuyData1 extends StatefulWidget {
  final DataPurchaseType param;
  const BuyData1({super.key, required this.param});

  @override
  State<BuyData1> createState() => _BuyData1State();
}

class _BuyData1State extends State<BuyData1> with TickerProviderStateMixin {
  final spacer = const SizedBox(height: 40);
  late TabController _tabController;

  Map<String, List<DataPlan>> groupedBundles = {};
  List<String> tabKeys = [];
  bool isLoading = true;

  List<DataPlan> currentTabPlans = [];

  void _loadBundles() async {
    final bundles =
        await ServicesHelper.getDataPlan(dataProvider!.id, 'direct');
    groupedBundles = groupBundlesByDuration(bundles);
    tabKeys = groupedBundles.keys.toList();

    _tabController = TabController(length: tabKeys.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        currentTabPlans = groupedBundles[tabKeys[_tabController.index]] ?? [];
      });
    });

    currentTabPlans = groupedBundles[tabKeys.first] ?? [];

    setState(() {
      isLoading = false;
    });
  }

  bool loading = true;
  List<DataProvider> dataProviders = [];
  DataProvider? dataProvider;

  Future<void> getDataList() async {
    await ServicesHelper.getDataProvider().then((value) {
      dataProviders = value
          .where((service) =>
              service.code != 'smile' && service.code != 'spectranet')
          .toList();
      dataProvider = dataProviders.first;

      _loadBundles();
    }).catchError((msg) {
      showCustomToast(context: context, description: msg.toString());
    });

    if (mounted) setState(() => loading = false);
  }

  Map<String, String> durationLabels = {
    "1": "Daily",
    "2": "2 Days",
    "3": "3 Days",
    "7": "Weekly",
    "14": "Bi-Weekly",
    "30": "Monthly",
    "60": "2-Month",
    "90": "3-Month",
    "365": "Yearly",
  };
  List<String> sortedDurations = [];

  Map<String, List<DataPlan>> groupBundlesByDuration(List<DataPlan> bundles) {
    Map<String, List<DataPlan>> grouped = {};
    for (var bundle in bundles) {
      String label = durationLabels[bundle.duration] ?? "Others";
      if (!grouped.containsKey(label)) {
        grouped[label] = [];
      }
      grouped[label]?.add(bundle);
    }
    return grouped;
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

  bool isPorted = false;
  void _toggleIsPorted() => setState(() => isPorted = !isPorted);
  // AirtimeProvider? provider;
  TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: ColorManager.kPrimary,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
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
                buildHeader(),
                customDivider(
                  height: 1,
                  margin: const EdgeInsets.only(top: 16, bottom: 30),
                  color: ColorManager.kBar2Color,
                ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: loading || isLoading
                        ? buildLoading(wrapWithExpanded: false)
                        : ListView(
                            controller: controller,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            children: [
                              buildProviderSelector(),
                              // spacer,
                              SizedBox(
                                height: 10,
                              ),
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
                                  FilteringTextInputFormatter.digitsOnly
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
                              if (phoneError && !isPorted) ...[
                                // SizedBox(height: 10,),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.red.withValues(alpha: .0),
                                      borderRadius: BorderRadius.circular(8)),
                                  padding:
                                      const EdgeInsets.only(left: 3, top: 2),
                                  child: Text(
                                    "Phone number does not match selected network",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () => _toggleIsPorted(),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Checkbox(
                                        value: isPorted,
                                        activeColor: ColorManager.kPrimary,
                                        onChanged: (v) => _toggleIsPorted()),
                                    SizedBox(
                                      width: 0,
                                    ),
                                    Text("Is this number ported?"),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              buildTabAndPlans(),
                            ],
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
              child: Padding(
                  padding: EdgeInsets.only(left: 15, top: 15),
                  child: BackIcon())),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Image.asset(ImageManager.kBuyData2, width: 44),
                const SizedBox(height: 13),
                Text("Buy Data",
                    textAlign: TextAlign.center, style: get18TextStyle()),
              ],
            ),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 15),
              child: CustomProgress(value: 1, valuePerct: .4),
            ),
          )
        ],
      );

  Widget buildProviderSelector() => SizedBox(
        height: 110,
        child: ListView.separated(
          separatorBuilder: (_, __) => Gap(16),
          scrollDirection: Axis.horizontal,
          itemCount: dataProviders.length,
          itemBuilder: (context, index) {
            final biller = dataProviders[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  dataProvider = biller;
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

                  _loadBundles();
                });
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 86,
                    height: 86,
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: dataProvider?.name == biller.name
                          ? ColorManager.kPrimaryLight
                          : Colors.white,
                      borderRadius: BorderRadius.circular(19),
                      border: Border.all(
                          color: dataProvider?.name == biller.name
                              ? ColorManager.kPrimaryLight
                              : const Color(0xffeeeeee),
                          width: 1.5),
                    ),
                    child: Column(
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
                  if (dataProvider?.name == biller.name)
                    Positioned(
                      top: 5,
                      right: -5,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: ColorManager.kPrimary,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(Icons.check,
                            color: Colors.white, size: 15),
                      ),
                    )
                ],
              ),
            );
          },
        ),
      );

  Widget buildTabAndPlans() => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: UnderlineTabIndicator(
                borderSide:
                    BorderSide(color: ColorManager.kPrimary, width: 2.0),
              ),
              labelColor: ColorManager.kPrimary,
              unselectedLabelColor: ColorManager.kTextColor,
              labelPadding: EdgeInsets.only(right: 16),
              tabs: tabKeys.map((e) => Tab(text: e)).toList(),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: currentTabPlans.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                final plan = currentTabPlans[index];
                return InternetDataItem(
                  plan: plan,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    if (!(_formKey.currentState?.validate() ?? false)) return;
                    moveNext(context, dataPlan: plan);
                  },
                );
              },
            ),
          ],
        ),
      );

  Future<void> moveNext(BuildContext context,
      {required DataPlan dataPlan}) async {
    await GenericHelper.getDiscount(
      'data',
      dataProvider?.code,
      dataPlan.amount,
      dataPlan.code,
    ).then((value) async {
      await showCustomBottomSheet(
        context: context,
        isDismissible: true,
        screen: BuyData3(
          arg: BuyDataArg(
            dataProvider: dataProvider!,
            phone: phoneController.text,
            dataPurchaseType: widget.param,
            dataPlans: currentTabPlans,
            discount: value,
            isPorted: isPorted,
          ),
          dataPlan: dataPlan,
        ),
      );
    });
  }
}
