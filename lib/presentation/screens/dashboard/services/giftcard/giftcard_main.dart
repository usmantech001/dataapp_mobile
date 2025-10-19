import 'dart:io';

import 'package:dataplug/core/helpers/giftcard_helper.dart';
import 'package:dataplug/core/model/core/giftcard_txn.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../../../core/enum.dart';
import '../../../../../core/helpers/service_helper.dart';
import '../../../../../core/model/core/giftcard_category_provider.dart';
import '../../../../../core/model/dashboard_tabs.dart';
import '../../../../../core/providers/generic_provider.dart';
import '../../../../../core/providers/user_provider.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_btn.dart';
import '../../../../misc/custom_components/custom_container.dart';
import '../../../../misc/custom_components/custom_elements.dart';
import '../../../../misc/custom_components/custom_empty_state.dart';
import '../../../../misc/custom_snackbar.dart';
import '../../../../misc/image_manager/image_manager.dart';
import '../../../../misc/notification_bell.dart';
import '../../../../misc/route_manager/routes_manager.dart';
import '../../../../misc/style_manager/styles_manager.dart';
import 'giftcard_txn.dart';

class GiftCardMain extends StatefulWidget {
  final int activeTab;
  const GiftCardMain({super.key, required this.activeTab});

  @override
  State<GiftCardMain> createState() => _GiftCardMainState();
}

class _GiftCardMainState extends State<GiftCardMain> {
  bool loading = true;
  bool isLoadingMoreCategories = false;
  List<GiftcardCategory> categories = [];
  List<GiftcardTxn> history = [];
  GiftcardCategory? category;
  Country? country;

  bool isLoadingMoreGiftcards = false;
  int giftcardPage = 1;

  String giftcardCurrency = '';

  ScrollController giftcardScrollController = ScrollController();
  ScrollController categoryScrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    getDataList(page: 1); // Fetch the first page of
    getHistory(); // Fetch gift card history
  }

  final List<DashboardTabsItems> pages = DashboardTabsItems.data;
  // getGiftcardTxns

  Future<void> getDataList({int page = 1}) async {
    if (page > 1) {
      setState(() {
        isLoadingMoreCategories = true;
      });
    }
    await ServicesHelper.getGiftcardCategories(
            search: '', page: page, perPage: 10)
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

  Future<void> getHistory() async {
    await GiftCardHelper.getGiftcardTxns('').then((value) {
      history = value;
    }).catchError((msg) {
      showCustomToast(context: context, description: msg.toString());
    });

    if (mounted) setState(() => loading = false);
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

  @override
  Widget build(BuildContext context) {
    GenericProvider genericProvider = Provider.of<GenericProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Container(
            color: ColorManager.kWhite,
            padding: const EdgeInsets.only(top: 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 28,
                            width: 28,
                            child: loadNetworkImage(
                              userProvider.user.avatar ?? "",
                              errorDefaultImage: ImageManager.kProfileFallBack,
                              height: 28,
                              width: 28,
                              fit: BoxFit.cover,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          Gap(16),
                          Text(
                            "Hi, ${userProvider.user.firstname}",
                            style: get14TextStyle().copyWith(
                              color: ColorManager.kBlack,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const CustomNotificationBell()
                    ],
                  ),
                ])),
      ),
      bottomSheet: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          // color: DashboardTabsItems.getBottomBarColor(
          //   genericProvider.currentPage,
          // ),
          border: Border(
            top: BorderSide(
                width: 1, color: ColorManager.kBarColor.withOpacity(.2)),
          ),
        ),
        padding: EdgeInsets.only(
            left: 15,
            right: 15,
            bottom:
                (Platform.isIOS && MediaQuery.of(context).size.height <= 740)
                    ? 3
                    : 13,
            top: 0),
        height: DashboardTabsItems.getBottomSheetHieght(context),
        margin: const EdgeInsets.only(bottom: 6, top: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: pages.map((e) {
            // using widget actve tab set the active tab
            bool active =
                (e.dashboardTabs == DashboardTabs.values[widget.activeTab]);
            return Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  // if (active) return;

                  genericProvider
                      .updatePage(DashboardTabs.values[widget.activeTab]);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RoutesManager.dashboardWrapper,
                    (route) => false,
                    arguments: DashboardTabs.values[widget.activeTab],
                  );
                  // checkNotification();
                },
                behavior: HitTestBehavior.translucent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      e.inactiveUrl,
                      width: e.width,
                      height: e.height,
                      color: active
                          ? ColorManager.kPrimary
                          : ColorManager.kTextDark,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      e.name,
                      style: get12TextStyle().copyWith(
                          fontWeight:
                              // active ? FontWeight.w500 :
                              FontWeight.w400,
                          color:
                              // active
                              //     ? ColorManager.kPrimary
                              //     :
                              ColorManager.kTextDark),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Gift card',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 110,
                child: loading
                    ? Center(
                        child: CircularProgressIndicator(
                        backgroundColor: ColorManager.kPrimary,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(ColorManager.kWhite),
                      ))
                    : ListView.separated(
                        separatorBuilder: (context, index) => Gap(16),
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(left: 0),
                        itemBuilder: (context, index) {
                          final giftCard = categories[index];
                          return GestureDetector(
                            onTap: () {},
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                    width: 86,
                                    height: 86,
                                    margin: EdgeInsets.only(top: 10),
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: Color(0xffeeeeee)
                                          .withValues(alpha: .4),
                                      borderRadius: BorderRadius.circular(19),
                                      border: Border.all(
                                          color: Color(0xffeeeeee), width: 1.5),
                                    ),
                                    child: Container(
                                      height: 42,
                                      width: 42,
                                      decoration: BoxDecoration(
                                          color: ColorManager.kPrimaryLight,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  giftCard.toIcon()),
                                              fit: BoxFit.cover)),
                                    )),
                              ],
                            ),
                          );
                        }),
              ),
              const SizedBox(height: 8),
              loading
                  ? Gap(0)
                  : history.isEmpty
                      ? SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Gift Card History',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      // color: ColorManager.kPrimary,
                                      decoration: TextDecoration.underline,
                                      decorationColor: ColorManager.kWhite)),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      RoutesManager.allGiftcardTransactions);
                                },
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Assets.icons.clipboardText.svg(),
                                        Gap(10),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context,
                                                RoutesManager
                                                    .allGiftcardTransactions);
                                          },
                                          child: Row(
                                            children: [
                                              Text("See all",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          ColorManager.kPrimary,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      decorationColor:
                                                          ColorManager
                                                              .kPrimary)),
                                              Gap(10),
                                              Assets.icons.forwardArrow.svg(
                                                  colorFilter: ColorFilter.mode(
                                                      ColorManager.kPrimary,
                                                      BlendMode.srcIn))
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ),
              loading
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Center(
                          child: CircularProgressIndicator(
                              backgroundColor: ColorManager.kPrimary,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  ColorManager.kWhite))),
                    )
                  : history.isEmpty
                      ? Container(
                        margin: EdgeInsets.only(top: MediaQuery.sizeOf(context).height * .1),
                          padding: const EdgeInsets.all(16.0),
                          alignment: Alignment.center,
                          child: CustomContainer(
                            header: const SizedBox(height: 10, width: 85),
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 27),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("You are yet to make a transactions",
                                    textAlign: TextAlign.center,
                                    style: get14TextStyle()),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: 187,
                                  child: CustomButton(
                                    text: "Buy Giftcard",
                                    isActive: true,
                                    onTap: () {
                                           Navigator.pushNamed(context, RoutesManager.giftcard1);
                                    },
                                    loading: false,
                                  ),
                                ),
                              ],
                            ),
                          ))
                      : ListView.separated(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          separatorBuilder: (context, index) => Gap(10),
                          itemCount: history.length > 5 ? 5 : history.length,
                          shrinkWrap: true,
                          itemBuilder: (_, index) {
                            final item = history[index];
                            return GiftcardTxnTile(param: item);
                          },
                        ),
              if (history.isNotEmpty) ...[
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RoutesManager.giftcard1);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: const Color(0xFF00C9A7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Buy Gift card',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
