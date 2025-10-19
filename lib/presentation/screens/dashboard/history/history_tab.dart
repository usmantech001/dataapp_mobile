import 'package:dataplug/core/constants.dart';
import 'package:dataplug/core/model/core/service_txn.dart';
import 'package:dataplug/core/providers/user_provider.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/loading.dart';
import 'package:dataplug/presentation/misc/custom_snackbar.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../../core/enum.dart';
import '../../../../core/providers/generic_provider.dart';
import '../../../../core/utils/utils.dart';
import '../../../../gen/assets.gen.dart';
import '../../../misc/color_manager/color_manager.dart';
import '../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../misc/custom_components/custom_empty_state.dart';
import '../../../misc/custom_components/segment.dart';
import '../../../misc/segment.dart';
import '../../../misc/shimmers/square_shimmer.dart';
import '../../../misc/style_manager/styles_manager.dart';
import '../services/giftcard/giftcard_transactions.dart';
import 'misc/history_filter.dart';
import 'misc/service_history_tile.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  static buildHeader(BuildContext context, {required DashboardTabs tabs}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(capitalizeFirstString(enumToString(tabs)),
              style: get20TextStyle().copyWith(color: ColorManager.kBlack)),

          //
          CustomButton(
            width: 95,
            height: 32,
            boxDecoration: BoxDecoration(
              border: Border.all(color: ColorManager.kPrimaryLight, width: .35),
              borderRadius: BorderRadius.circular(170),
              color: ColorManager.kPrimaryLight,
            ),
            text: "",
            isActive: true,
            onTap: () async {
              if (Provider.of<UserProvider>(context, listen: false)
                  .serviceTxn
                  .isEmpty) {
                showCustomToast(
                  context: context,
                  description:
                      "You need to have made transactions to enable filters.",
                );

                return;
              }

              await showCustomBottomSheet(
                  context: context, screen: const HistoryFilter());
            },
            loading: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.filter_list_rounded,
                    color: ColorManager.kPrimary, size: 19),
                const SizedBox(width: 4.5),
                Text(
                  "Filter",
                  style:
                      get14TextStyle().copyWith(color: ColorManager.kPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab>
    with SingleTickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  late TabController _tabController;
  int groupValue = 0;
  final PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();
    scrollController.addListener(pagination);
    _tabController = TabController(length: 2, vsync: this); // Two tabs
  }

  @override
  void dispose() {
    scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void pagination() async {
    if ((scrollController.position.pixels ==
        scrollController.position.maxScrollExtent)) {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        paginateHistory();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    GenericProvider genericProvider = Provider.of<GenericProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    final Map<int, Widget> segmentWidgets = <int, Widget>{
      0: buildSegment("Services", active: groupValue == 0),
      1: buildSegment("Giftcard", active: groupValue == 1),
    };
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: false,
        title: Text(
          "History",
          style: get14TextStyle().copyWith(
            fontSize: 20,
            color: ColorManager.kBlack,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.symmetric(
            //       vertical: 10, horizontal: Constants.kHorizontalScreenPadding),
            //   child: TabBar(
            //     controller: _tabController,
            //     labelColor: ColorManager.kPrimary,
            //     unselectedLabelColor: Colors.grey,
            //     indicatorColor: ColorManager.kPrimary,
            //     labelStyle: get16TextStyle().copyWith(fontWeight: FontWeight.w600),
            //     tabs: const [
            //       Tab(text: "Services"),
            //       Tab(text: "Gift Cards"),
            //     ],
            //   ),
            // ),
            // Expanded(
            //   child: TabBarView(
            //     controller: _tabController,
            //     children: [
            // _buildServiceTxnTab(userProvider, genericProvider),
            // _buildGiftCardTxnTab(userProvider, genericProvider),
            //     ],
            //   ),
            // ),

            if (genericProvider.serviceStatus?.giftcards?.status == true ||
                genericProvider.serviceStatus?.giftcards?.value
                        ?.toLowerCase() ==
                    "coming-soon" ||
                genericProvider.serviceStatus?.giftcards?.value
                        ?.toLowerCase() !=
                    "deactivated") ...[
              Container(
                padding: const EdgeInsets.only(
                    top: 22, bottom: 25, left: 32, right: 32),
                // alignment: Alignment.center,
                width: double.maxFinite,
                child: CupertinoSlidingSegmentedControlAlt<int>(
                  backgroundColor: ColorManager.kSlideBgColor,
                  thumbColor: ColorManager.kWhite,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                  groupValue: groupValue,
                  children: segmentWidgets,
                  onValueChanged: (value) {
                    _pageController.animateToPage(value!,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.linear);
                    setState(() => groupValue = value);
                  },
                ),
              ),
            ] else ...[
              SizedBox(
                height: 24,
              )
            ],

            //
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Constants.kHorizontalScreenPadding),
                child: PageView(
                  onPageChanged: (index) {
                    setState(() => groupValue = index);
                  },
                  controller: _pageController,
                  children: [
                    _buildServiceTxnTab(userProvider, genericProvider),
                    if (genericProvider.serviceStatus?.giftcards?.status ==
                            true ||
                        genericProvider.serviceStatus?.giftcards?.value
                                ?.toLowerCase() ==
                            "coming-soon" ||
                        genericProvider.serviceStatus?.giftcards?.value
                                ?.toLowerCase() !=
                            "deactivated") ...[
                      _buildGiftCardTxnTab(userProvider, genericProvider),
                    ]
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildServiceTxnTab(
      UserProvider userProvider, GenericProvider genericProvider) {
    if (userProvider.historyPageLoading) {
      return buildLoading(
        wrapWithExpanded: false,
        padding: const EdgeInsets.all(16),
        height: 55,
      );
    }

    if (userProvider.serviceTxn.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => refreshHistory(userProvider),
        color: ColorManager.kPrimary,
        child: ListView(
          padding: const EdgeInsets.only(top: 29),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomEmptyState(
                imgHeight: 81,
                imgWidth: 81,
                image: Assets.images.emptyHistory.path,
                title: "You are yet to make any transactions yet",
                btnTitle: "Go to services",
                onTap: () {
                  genericProvider.updatePage(DashboardTabs.services);
                },
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      child: Column(
        children: [
          if (userProvider.txnFilterActive) _buildActiveFilters(userProvider),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => refreshHistory(userProvider),
              color: ColorManager.kPrimary,
              child: Column(
                children: [
                  // HistoryTab.buildHeader(context, tabs: DashboardTabs.history),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: userProvider
                          .serviceTxnBasedOnActiveOrInActiveFilter.length,
                      itemBuilder: (_, i) => ServiceHistoryTile(
                        param: userProvider
                            .serviceTxnBasedOnActiveOrInActiveFilter[i],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (userProvider.txnPaginating)
            const Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: SquareShimmer(height: 50, width: double.infinity),
            ),
        ],
      ),
    );
  }

  Widget _buildGiftCardTxnTab(
      UserProvider userProvider, GenericProvider genericProvider) {
    // Assume this list exists
    return GiftcardTxnView(hideAppBar: true);
    // if (giftCardTxns.isEmpty) {
    //   return RefreshIndicator(
    //     onRefresh: () => userProvider.fetchGiftCardTxn(forceRefresh: true),
    //     color: ColorManager.kPrimary,
    //     child: ListView(
    //       padding: const EdgeInsets.only(top: 30),
    //       children: [
    //         const SizedBox(height: 25),
    //         CustomEmptyState(
    //           title: "No gift card transactions found",
    //           btnTitle: "Buy Gift Card",
    //           onTap: () {
    //             genericProvider.updatePage(DashboardTabs.giftCards);
    //           },
    //         ),
    //       ],
    //     ),
    //   );
    // }

    // return ListView.builder(
    //   padding: const EdgeInsets.all(16),
    //   itemCount: giftCardTxns.length,
    //   itemBuilder: (_, i) {
    //     final txn = giftCardTxns[i];
    //     return GiftCardTransactionTile(txn: txn); // You need to create this widget
    //   },
    // );
  }

  Widget _buildActiveFilters(UserProvider userProvider) {
    return Container(
      height: 35,
      margin: const EdgeInsets.only(bottom: 20),
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if (userProvider.filterCashFlowType != null)
              historyFilterCard(
                enumToString(userProvider.filterCashFlowType),
                onCancel: () {
                  userProvider.resetTxnFilter(
                    cashFlowType: null,
                    status: userProvider.filterStatus,
                    purpose: userProvider.filterPurpose,
                    startDate: userProvider.filterStartDate,
                    endDate: userProvider.filterEndDate,
                  );
                },
              ),
            if (userProvider.filterPurpose != null)
              historyFilterCard(
                ServiceTxn.serviceEnumToString(userProvider.filterPurpose!),
                onCancel: () {
                  userProvider.resetTxnFilter(
                    purpose: null,
                    cashFlowType: userProvider.filterCashFlowType,
                    status: userProvider.filterStatus,
                    startDate: userProvider.filterStartDate,
                    endDate: userProvider.filterEndDate,
                  );
                },
              ),
            if (userProvider.filterStatus != null)
              historyFilterCard(
                enumToString(userProvider.filterStatus),
                onCancel: () {
                  userProvider.resetTxnFilter(
                    status: null,
                    purpose: userProvider.filterPurpose,
                    cashFlowType: userProvider.filterCashFlowType,
                    startDate: userProvider.filterStartDate,
                    endDate: userProvider.filterEndDate,
                  );
                },
              ),
            if (userProvider.filterStartDate != null &&
                userProvider.filterEndDate != null)
              historyFilterCard(
                "Date Range: ${formatDateSlash(userProvider.filterStartDate)} - ${formatDateSlash(userProvider.filterEndDate)}",
                onCancel: () {
                  userProvider.resetTxnFilter(
                    startDate: null,
                    endDate: null,
                    status: userProvider.filterStatus,
                    purpose: userProvider.filterPurpose,
                    cashFlowType: userProvider.filterCashFlowType,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   GenericProvider genericProvider = Provider.of<GenericProvider>(context);
  //   UserProvider userProvider = Provider.of<UserProvider>(context);

  //   if (userProvider.historyPageLoading) {
  //     return buildLoading(
  //       wrapWithExpanded: false,
  //       padding: const EdgeInsets.all(16),
  //       height: 55,
  //     );
  //   }

  //   if (userProvider.serviceTxn.isEmpty) {
  //     return RefreshIndicator(
  //       onRefresh: () => refreshHistory(userProvider),
  //       color: ColorManager.kPrimary,
  //       child:
  //       // \Column(
  //       //   children: [

  //           ListView(
  //             padding: const EdgeInsets.only(top: 29),
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.all(16.0),
  //                 child: CustomEmptyState(
  //                   imgHeight: 81,
  //                   imgWidth: 81,
  //                   image: Assets.images.emptyHistory.path,
  //                   title: "You are yet to make any transactions yet",
  //                   btnTitle: "Go to services",
  //                   onTap: () {
  //                     genericProvider.updatePage(DashboardTabs.services);
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ),
  //       //   ],
  //       // ),
  //     );
  //   }

  //   return Padding(
  //     padding: const EdgeInsets.symmetric(
  //         vertical: 30, horizontal: Constants.kHorizontalScreenPadding),
  //     child: Column(
  //       children: [

  //         if (userProvider.txnFilterActive)
  //           Container(
  //             height: 35,

  //             margin: const EdgeInsets.only(bottom: 20),
  //             alignment: Alignment.centerLeft,
  //             child: SingleChildScrollView(
  //               scrollDirection: Axis.horizontal,
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   // CASHFLOW
  //                   if (userProvider.filterCashFlowType != null)
  //                     historyFilterCard(
  //                       enumToString(userProvider.filterCashFlowType),
  //                       onCancel: () {
  //                         userProvider.resetTxnFilter(
  //                           cashFlowType: null,
  //                           status: userProvider.filterStatus,
  //                           purpose: userProvider.filterPurpose,
  //                           startDate: userProvider.filterStartDate,
  //                           endDate: userProvider.filterEndDate,
  //                         );
  //                       },
  //                     ),

  //                   //
  //                   if (userProvider.filterPurpose != null)
  //                     historyFilterCard(
  //                       ServiceTxn.serviceEnumToString(
  //                           userProvider.filterPurpose!),
  //                       onCancel: () {
  //                         userProvider.resetTxnFilter(
  //                           purpose: null,
  //                           cashFlowType: userProvider.filterCashFlowType,
  //                           status: userProvider.filterStatus,
  //                           startDate: userProvider.filterStartDate,
  //                           endDate: userProvider.filterEndDate,
  //                         );
  //                       },
  //                     ),

  //                   if (userProvider.filterStatus != null)
  //                     historyFilterCard(
  //                       enumToString(userProvider.filterStatus),
  //                       onCancel: () {
  //                         userProvider.resetTxnFilter(
  //                           status: null,
  //                           purpose: userProvider.filterPurpose,
  //                           cashFlowType: userProvider.filterCashFlowType,
  //                           startDate: userProvider.filterStartDate,
  //                           endDate: userProvider.filterEndDate,
  //                         );
  //                       },
  //                     ),

  //                   if (userProvider.filterStartDate != null &&
  //                       userProvider.filterEndDate != null)
  //                     historyFilterCard(
  //                       "Date Range: ${formatDateSlash(userProvider.filterStartDate)} - ${formatDateSlash(userProvider.filterEndDate)}",
  //                       onCancel: () {
  //                         userProvider.resetTxnFilter(
  //                           startDate: null,
  //                           endDate: null,
  //                           status: userProvider.filterStatus,
  //                           purpose: userProvider.filterPurpose,
  //                           cashFlowType: userProvider.filterCashFlowType,
  //                         );
  //                       },
  //                     ),
  //                 ],
  //               ),
  //             ),
  //           ),

  //         //
  //         Expanded(
  //           child: RefreshIndicator(
  //             onRefresh: () => refreshHistory(userProvider),
  //             color: ColorManager.kPrimary,
  //             child: (userProvider
  //                     .serviceTxnBasedOnActiveOrInActiveFilter.isEmpty)
  //                 ? ListView(
  //                     padding: const EdgeInsets.only(top: 30),
  //                     children: [
  //                       const SizedBox(height: 25),
  //                       CustomEmptyState(
  //                         title: "You are yet to make any transactions yet",
  //                         btnTitle: "Go to services",
  //                         onTap: () {
  //                           genericProvider.updatePage(DashboardTabs.services);
  //                         },
  //                       ),
  //                     ],
  //                   )
  //                 : Column(
  //                   children: [
  //                       HistoryTab.buildHeader(context, tabs: DashboardTabs.history),
  //                     Expanded(
  //                       child: ListView.builder(
  //                           padding: const EdgeInsets.symmetric(),
  //                           itemCount: userProvider
  //                               .serviceTxnBasedOnActiveOrInActiveFilter.length,
  //                           physics: const AlwaysScrollableScrollPhysics(),
  //                           controller: scrollController,
  //                           itemBuilder: (_, int i) => ServiceHistoryTile(
  //                             param: userProvider
  //                                 .serviceTxnBasedOnActiveOrInActiveFilter[i],
  //                           ),
  //                         ),
  //                     ),
  //                   ],
  //                 ),
  //           ),
  //         ),

  //         // PAGINATING...
  //         userProvider.txnPaginating
  //             ? const Padding(
  //                 padding: EdgeInsets.only(bottom: 30),
  //                 child: SquareShimmer(height: 50, width: double.infinity))
  //             : const SizedBox()
  //       ],
  //     ),
  //   );
  // }

  Widget historyFilterCard(String text, {required Function onCancel}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7.5),
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(170),
        color: ColorManager.kSlideBgColor,
        border: Border.all(color: ColorManager.kBar2Color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(capitalizeFirstString(text),
              style: get14TextStyle().copyWith(color: ColorManager.kPrimary)),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => onCancel(),
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Icon(
                LucideIcons.x,
                size: 20,
                color: ColorManager.kBarColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> refreshHistory(UserProvider userProvider) async {
    (userProvider.txnFilterActive)
        ? await userProvider.fetchFilteredServiceTxn(forceRefresh: true)
        : await userProvider.updateServiceTxn(forceRefresh: true);
  }

  Future<void> paginateHistory() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    (userProvider.txnFilterActive)
        ? await userProvider.fetchFilteredServiceTxn(
            forceRefresh: false,
            cashFlowType: userProvider.filterCashFlowType,
            status: userProvider.filterStatus,
            purpose: userProvider.filterPurpose,
            startDate: userProvider.filterStartDate,
            endDate: userProvider.filterEndDate)
        : await userProvider.updateServiceTxn(forceRefresh: false);
  }
}
