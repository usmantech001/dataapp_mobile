import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../../../core/helpers/giftcard_helper.dart';
import '../../../../../core/model/core/giftcard_txn.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_appbar.dart';
import '../../../../misc/custom_components/custom_scaffold.dart';
import '../../../../misc/shimmers/square_shimmer.dart';
import '../../../../misc/style_manager/styles_manager.dart';
import 'giftcard_txn.dart';


class GiftcardTxnView extends StatefulWidget {
  final bool? hideAppBar;
  const GiftcardTxnView({super.key, this.hideAppBar});

  @override
  State<GiftcardTxnView> createState() => _GiftcardTxnViewState();
}

class _GiftcardTxnViewState extends State<GiftcardTxnView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchHistory();
    });
    scrollController.addListener(pagination);
    super.initState();
  }

  bool paginatedLoading = false;

  // ALL
  int all_txn_page = 1;
  List<GiftcardTxn> transactionHistory = [];

  // FILTER
  int filter_txn_page = 1;
  List<GiftcardTxn> allFilter = [];

  // SEARCH
  int search_txn_page = 1;
  List<GiftcardTxn> allSearch = [];

  //
  void pagination() async {
    if ((scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !paginatedLoading)) {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() => paginatedLoading = true);
        fetchHistory();
      }
    }
  }

  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();

  bool fetching = true;

  String? filterQueryParam;
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      // appBar: (widget.hideAppBar == true)
      //     ? PreferredSize(
      //         child: const SizedBox(),
      //         preferredSize: MediaQuery.of(context).size)
      //     : CustomAppBar(
      //         title: Text("Giftcard Transactions", style: get18TextStyle()),
      //         elevation: 1),
      body: Column(
        children: [
         // SizedBox(height: DashboardTabsItems.getDasboardTabTopPadding),
        

          /// ///
          // GestureDetector(
          //   behavior: HitTestBehavior.translucent,
          //   onTap: () async {
          //     // var queryParam = await Navigator.pushNamed(
          //     //     context, RoutesManager.walletHistoryFilter,
          //     //     arguments: filterQueryParam);

          //     // print(queryParam);

          //     // if (queryParam == null) {
          //     //   filterQueryParam = null;
          //     //   searchController.text = "";
          //     //   setState(() {});
          //     //   return;
          //     // }
          //     // startFilter(queryParam.toString());
          //   },
          //   child: Container(
          //     margin: const EdgeInsets.only(top: 10),
          //     padding: const EdgeInsets.symmetric(
          //         horizontal: 15, vertical: 10),
          //     decoration: BoxDecoration(
          //       color: ColorManager.kFormBg.withOpacity(.5),
          //       border:
          //           Border.all(color: ColorManager.kPrimary, width: 0.5),
          //     ),
          //     child: Row(
          //       children: [
          //         Icon(Icons.filter_list, color: ColorManager.kSmallText),
          //         const SizedBox(width: 15),
          //         Text(
          //           "FILTER",
          //           style: get14TextStyle()
          //               .copyWith(color: ColorManager.kSmallText),
          //         ),
          //         const Spacer(),
          //         if (filterQueryParam != null)
          //           Icon(Icons.check, color: ColorManager.kPrimaryFade)
          //       ],
          //     ),
          //   ),
          // ),

          //
          fetching
              ? Expanded(
                  child: ListView.separated(
                    // padding: const EdgeInsets.all(15),
                    separatorBuilder: ((context, index) =>
                        const SizedBox(height: 20)),
                    itemCount: 5,
                    itemBuilder: (_, int i) =>
                        const SquareShimmer(width: double.infinity, height: 50),
                  ),
                )
              : Expanded(
                  child: RefreshIndicator(
                    color: ColorManager.kPrimary,
                    onRefresh: () => fetchHistory(forceRefresh: true),
                    child: (getElements().isEmpty)
                        ? ListView(
                            children: const [
                              // NoContent(
                              //   displayImage: true,
                              //   title: "Please try different search param(s)",
                              // ),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(
                                top: 0, bottom: 37, left: 0, right: 0),
                            addAutomaticKeepAlives: false,
                            controller: scrollController,
                            shrinkWrap: true,
                            itemCount: getElements().length,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (_, int i) {
                              return GiftcardTxnTile(param: getElements()[i]);
                            },
                          ),
                  ),
                ),

          //
          // PAGINATING...
          paginatedLoading
              ? const Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: SquareShimmer(height: 50, width: double.infinity))
              : const SizedBox()
        ],
      ),
    );
  }

  List<GiftcardTxn> getElements() {
    if (filterQueryParam != null) {
      return allFilter;
    } else if (searchController.text.isNotEmpty) {
      return allSearch;
    } else {
      return transactionHistory;
    }
  }

  Timer? timer;
  Future<void> startSearch(String arg) async {
    allSearch.clear();
    search_txn_page = 1;
    filterQueryParam = null;
    if (arg.isEmpty) {
      setState(() {});
      return;
    }
    if (mounted) setState(() => fetching = true);
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 750), () async {
      await fetchHistory();
      fetching = false;
      if (mounted) setState(() {});
    });
  }

  //
  Future<void> startFilter(String arg) async {
    allFilter.clear();
    filter_txn_page = 1;
    filterQueryParam = arg;
    if (mounted) setState(() => fetching = true);
    await fetchHistory();
    fetching = false;
    if (mounted) setState(() {});
  }

  Future<void> fetchHistory({bool forceRefresh = false}) async {
    // ADD QUERY FOR SEARCH AND FILTER IF AVAILABLE
    String query = "&per_page=50";
    String page = (forceRefresh) ? "page=1" : "page=$all_txn_page";
    String others = "";
    if (filterQueryParam != null) {
      others = "$filterQueryParam";
      page = "page=$filter_txn_page";
    } else if (searchController.text.isNotEmpty) {
      others = "filter[reference]=${searchController.text}";
      page = "page=$search_txn_page";
    }
    if (others.isEmpty) {
      query = "$query&$page&$others";
    } else {
      query = "$query&$page&$others";
    }

    await GiftCardHelper.getGiftcardTxns(query).then((value) {
      if (forceRefresh) {
        /* For forceRefresh, reset history page to 2 */
        if (filterQueryParam != null) {
          filter_txn_page = 2;
        } else if (searchController.text.isNotEmpty) {
          search_txn_page = 2;
        } else {
          all_txn_page = 2;
        }
      } else if (value.isNotEmpty) {
        if (filterQueryParam != null) {
          filter_txn_page = filter_txn_page + 1;
        } else if (searchController.text.isNotEmpty) {
          search_txn_page = search_txn_page + 1;
        } else {
          all_txn_page = all_txn_page + 1;
        }
      }

      /// IF no filter is applied
      if (forceRefresh) {
        if (filterQueryParam != null) {
          allFilter = value;
        } else if (searchController.text.isNotEmpty) {
          allSearch = value;
        } else {
          transactionHistory = value;
        }
      } else {
        if (filterQueryParam != null) {
          allFilter.addAll(value);
        } else if (searchController.text.isNotEmpty) {
          allSearch.addAll(value);
        } else {
          transactionHistory.addAll(value);
        }
      }

      fetching = false;
      paginatedLoading = false;
    }).catchError((err, stackTrace) {
      // throw err.toString();
      print("error ");
      print("stackTrace: $stackTrace");

      print("e $err");
    });

    if (mounted) setState(() => paginatedLoading = false);
  }
}
