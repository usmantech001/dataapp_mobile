import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dataplug/core/constants.dart';
import 'package:dataplug/core/enum.dart';
import 'package:dataplug/core/model/core/static_account_details.dart';
import 'package:dataplug/core/utils/utils.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_container.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/custom_snackbar.dart';
import 'package:dataplug/presentation/misc/image_manager/image_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:dataplug/presentation/screens/dashboard/home/generate_account_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../../core/helpers/service_helper.dart';
import '../../../../core/model/core/banner.dart';
import '../../../../core/model/core/user.dart';
import '../../../../core/model/core/virtual_account_provider.dart';
import '../../../../core/model/core/virtual_bank_detail.dart';
import '../../../../core/providers/generic_provider.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../gen/assets.gen.dart';
import '../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../misc/custom_components/custom_dialog_popup.dart';
import '../../../misc/custom_components/custom_input_field.dart';
import '../../../misc/custom_components/image_preview.dart';
import '../../../misc/route_manager/routes_manager.dart';
import '../history/history_tab.dart';
import '../services/internet_data/select_data_type.dart';
import 'verify_identity_otp.dart';
// import '../services/internet_data/select_data_type.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();

  static buildHeader(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 24),
          child: Row(
            children: [
              /*
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("WALLET BALANCE",
                        style: get12TextStyle()
                            .copyWith(color: ColorManager.kWhite)),
                    const SizedBox(height: 3),
                    RichText(
                      text: TextSpan(
                        style: get20TextStyle()
                            .copyWith(color: ColorManager.kWhite),
                        children: [
                          TextSpan(
                            text: userProvider.balanceVisible
                                ? formatNumber(userProvider.user.wallet_balance)
                                : "*****",
                          ),
                          const TextSpan(
                              text: " NGN", style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              */

              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  userProvider.toggleBalanceVisibility();
                },
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    userProvider.balanceVisible
                        ? LucideIcons.eyeOff
                        : LucideIcons.eye,
                    color: ColorManager.kWhite,
                    size: 16,
                  ),
                ),
              ),

              customDivider(
                height: 32,
                width: 1,
                color: ColorManager.kWhite.withOpacity(.5),
                margin: const EdgeInsets.only(right: 13, left: 13),
              ),

              //
              Expanded(
                child: CustomButton(
                  boxDecoration: BoxDecoration(
                    border: Border.all(
                        color: ColorManager.kWhite.withOpacity(.9), width: .35),
                    borderRadius: BorderRadius.circular(170),
                    color: ColorManager.kWhite.withOpacity(.3),
                  ),
                  text: "Withdraw",
                  isActive: true,
                  onTap: () {
                    Navigator.pushNamed(context, RoutesManager.withdraw1);
                  },
                  loading: false,
                ),
              ),
            ],
          ),
        ),

        //
        Row(
          children: [
            Expanded(
              flex: 1,
              child: CustomButton(
                text: "",
                boxDecoration: BoxDecoration(
                  border: Border.all(
                      color: ColorManager.kWhite.withOpacity(.9), width: .35),
                  borderRadius: BorderRadius.circular(170),
                  color: ColorManager.kWhite.withOpacity(.3),
                ),
                isActive: true,
                onTap: () {
                  Navigator.pushNamed(context, RoutesManager.deposit1);
                },
                loading: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 22, color: ColorManager.kWhite),
                    const SizedBox(width: 3.5),
                    Text(
                      "Top Up",
                      style: get14TextStyle().copyWith(
                        fontWeight: FontWeight.w600,
                        color: ColorManager.kWhite,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              flex: 1,
              child: CustomButton(
                text: "",
                boxDecoration: BoxDecoration(
                  border: Border.all(
                      color: ColorManager.kWhite.withOpacity(.9), width: .35),
                  borderRadius: BorderRadius.circular(170),
                  color: ColorManager.kWhite.withOpacity(.3),
                ),
                isActive: true,
                onTap: () {
                  Navigator.pushNamed(context, RoutesManager.transfer1);
                },
                loading: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(ImageManager.kTransferIcon,
                        width: 16, color: ColorManager.kWhite),
                    const SizedBox(width: 3.5),
                    Text(
                      "Transfer",
                      style: get14TextStyle().copyWith(
                        fontWeight: FontWeight.w600,
                        color: ColorManager.kWhite,
                      ),
                    )
                  ],
                ),
              ),
            ),

            //
          ],
        ),

        const SizedBox(height: 17)
      ],
    );
  }

  static Widget buildServiceItemCard(String name,
      {required String image, required Function onTap, required BuildContext context}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap(),
      child: Container(
        width: Responsive.w(context, 82),
        height: Responsive.w(context, 85),
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: ColorManager.kPrimaryLight,
            border: Border.all(color: ColorManager.kPrimary),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            SvgPicture.asset(image),
            const SizedBox(height: 5),
            Text(
              name,
              textAlign: TextAlign.center,
              style: get14TextStyle()
                  .copyWith(color: ColorManager.kTextDark.withOpacity(.8), fontSize: name.length > 10 ? 12 : 14),
            )
          ],
        ),
      ),
    );
  }
}

class _HomeTabState extends State<HomeTab> {
  Future<void> refreshPageInfo(
      UserProvider userProvider, GenericProvider genericProvider) async {
    await Future.wait([
      userProvider.updateUserInfo(),
      userProvider.checkUnreadNotification(),
      userProvider.updateRecentTxns(),
      genericProvider.getServiceStatus(),
      updateBanners(),
    ]);
  }

  bool loading = true;
  StaticBankDetail? bank;

  Future<void> fetchBank() async {
    log("here");
    await ServicesHelper.getStaticAccount().then((nuban) {
      bank = StaticBankDetail.fromMap(nuban['data'].first);
    }).catchError((err) {
      if (mounted)
        showCustomToast(context: context, description: err.toString());
    });
    loading = false;
    if (mounted) setState(() {});
  }

  //
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // fetchBank();
      updateBanners();
    });
    super.initState();
  }

  Future<void> updateBanners() async {
    try {
      GenericProvider genericProvider =
          Provider.of<GenericProvider>(context, listen: false);
      genericProvider.updateBanners();
    } catch (_) {}
  }

  //
  @override
  Widget build(BuildContext context) {
    GenericProvider genericProvider = Provider.of<GenericProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);

    //
    return RefreshIndicator(
      color: ColorManager.kPrimary,
      onRefresh: () => refreshPageInfo(userProvider, genericProvider),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          vertical: Constants.kHorizontalScreenPadding,
          horizontal: Constants.kHorizontalScreenPadding,
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              InkWell(
                onTap: () {
                  if (userProvider.user.phone == null) {
                    showCustomToast(
                        context: context,
                        description:
                            "Please complete your profile to continue.");
                  } else {
                    _showAccountDetailsBottomSheet(context, userProvider);
                  }
                },
                child: Text("View Account Number",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: ColorManager.kPrimary,
                        decoration: TextDecoration.underline,
                        decorationColor: ColorManager.kPrimary)),
              ),
            ],
          ),
          Gap(16),

          Container(
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
              color: ColorManager.kPrimary,
              borderRadius: BorderRadius.circular(19.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(19.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1), // shadow color
                          spreadRadius: 2, // the spread radius of the shadow
                          blurRadius:
                              8, // how much the shadow should be blurred
                          offset: Offset(0, 4), // shadow direction (x, y)
                        ),
                      ]),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "WALLET BALANCE",
                                  style: get14TextStyle().copyWith(
                                    fontSize: 12,
                                    color: ColorManager.kBlack,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Gap(5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style: get28TextStyle().copyWith(
                                          fontSize: 28,
                                          color: ColorManager.kBlack
                                              .withValues(alpha: .85),

                                          // fontWeight: FontWeight.w800,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: userProvider.balanceVisible
                                                ? formatNumber(userProvider
                                                    .user.wallet_balance)
                                                : "************",
                                          ),
                                          const TextSpan(
                                              text: " NGN",
                                              style: TextStyle(fontSize: 20)),
                                        ],
                                      ),
                                    ),
                                    Gap(10),
                                    GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        userProvider.toggleBalanceVisibility();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: Icon(
                                          userProvider.balanceVisible
                                              ? LucideIcons.eyeOff
                                              : LucideIcons.eye,
                                          color: ColorManager.kBlack,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RoutesManager.deposit1);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: ColorManager.kPrimary,
                                  borderRadius: BorderRadius.circular(7.0),
                                ),
                                child: Row(
                                  children: [
                                    Assets.icons.walletAdd.svg(),
                                    Gap(6),
                                    Text(
                                      "Top Up",
                                      style: get14TextStyle().copyWith(
                                        fontSize: 12,
                                        color: ColorManager.kWhite,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        indent: 16,
                        endIndent: 16,
                        thickness: .5,
                      ),
                      Gap(5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final screenW = MediaQuery.of(context).size.width;
                            final scale = (screenW / 375)
                                .clamp(0.8, 1.0); // base on iPhone 11 width

                            final iconSize = 17 * scale;
                            final fontSize = 14 * scale;
                            final padding = 8 * scale;
                            final borderRadius = 10 * scale;

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // --- Withdraw Funds Button ---
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, RoutesManager.withdraw1);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(padding),
                                    decoration: BoxDecoration(
                                      color: ColorManager.kPrimaryLight,
                                      borderRadius:
                                          BorderRadius.circular(borderRadius),
                                    ),
                                    child: Row(
                                      children: [
                                        Assets.icons.sendSqaure2.svg(
                                            width: iconSize, height: iconSize),
                                        SizedBox(width: 8 * scale),
                                        Text(
                                          "Withdraw Funds",
                                          style: get14TextStyle().copyWith(
                                            fontSize: fontSize,
                                            color: ColorManager.kPrimary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(width: 10 * scale),

                                // --- Transfer Funds Button ---
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, RoutesManager.transfer1);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(padding),
                                    decoration: BoxDecoration(
                                      color: ColorManager.kPrimaryLight,
                                      borderRadius:
                                          BorderRadius.circular(borderRadius),
                                    ),
                                    child: Row(
                                      children: [
                                        Assets.icons.convertCard.svg(
                                            width: iconSize, height: iconSize),
                                        SizedBox(width: 8 * scale),
                                        Text(
                                          "Transfer Funds",
                                          style: get14TextStyle().copyWith(
                                            fontSize: fontSize,
                                            color: ColorManager.kPrimary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Gap(16),
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Assets.icons.clipboardText.svg(),
                        Gap(10),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HistoryTab()));
                          },
                          child: Row(
                            children: [
                              Text("See all transactions in history",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: ColorManager.kWhite,
                                      decoration: TextDecoration.underline,
                                      decorationColor: ColorManager.kWhite)),
                              Gap(10),
                              Assets.icons.forwardArrow.svg()
                            ],
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          Gap(16),
          Divider(
            thickness: .5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Popular Services",
                  style: get14TextStyle().copyWith(
                    fontSize: 14,
                    color: ColorManager.kBlack,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                InkWell(
                  onTap: () {
                    genericProvider.updatePage(DashboardTabs.services);
                  },
                  child: Row(
                    children: [
                      Text("See all services",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: ColorManager.kPrimary,
                              decoration: TextDecoration.underline,
                              decorationColor: ColorManager.kPrimary)),
                      Gap(10),
                      Assets.icons.forwardArrow.svg(
                          colorFilter: ColorFilter.mode(
                              ColorManager.kPrimary, BlendMode.srcIn))
                    ],
                  ),
                ),
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (genericProvider.serviceStatus?.data?.status == true ||
                  genericProvider.serviceStatus?.data?.value?.toLowerCase() ==
                      "coming-soon" ||
                  genericProvider.serviceStatus?.data?.value?.toLowerCase() !=
                      "deactivated")
                HomeTab.buildServiceItemCard("Data",
                    image: Assets.icons.arrangeSquare2.path, onTap: () {
                  if (genericProvider.serviceStatus?.data?.value
                              ?.toLowerCase() ==
                          "coming-soon" ||
                      genericProvider.serviceStatus?.data?.value
                              ?.toLowerCase() ==
                          "temporarily-unavailable") {
                    showCustomToast(
                        context: context,
                        description: genericProvider
                                .serviceStatus?.data?.message
                                ?.toLowerCase() ??
                            "This service is not available at the moment.");
                    return;
                  }
                  showCustomBottomSheet(
                    context: context,
                    isDismissible: true,
                    screen: const SelectDataType(),
                  );
                }, context: context),
              if (genericProvider.serviceStatus?.airtime?.status == true ||
                  genericProvider.serviceStatus?.airtime?.value
                          ?.toLowerCase() ==
                      "coming-soon" ||
                  genericProvider.serviceStatus?.airtime?.value
                          ?.toLowerCase() !=
                      "deactivated")
                HomeTab.buildServiceItemCard("Airtime",
                    image: Assets.icons.slider.path, onTap: () {
                  if (genericProvider.serviceStatus?.airtime?.value
                              ?.toLowerCase() ==
                          "coming-soon" ||
                      genericProvider.serviceStatus?.electricity?.value
                              ?.toLowerCase() ==
                          "temporarily-unavailable") {
                    showCustomToast(
                        context: context,
                        description: genericProvider
                                .serviceStatus?.airtime?.message
                                ?.toLowerCase() ??
                            "This service is not available at the moment.");
                    return;
                  }
                  Navigator.pushNamed(context, RoutesManager.buyAirtime1);
                }, context: context),
              if (genericProvider.serviceStatus?.electricity?.status == true ||
                  genericProvider.serviceStatus?.electricity?.value
                          ?.toLowerCase() ==
                      "coming-soon" ||
                  genericProvider.serviceStatus?.electricity?.value
                          ?.toLowerCase() !=
                      "deactivated")
                HomeTab.buildServiceItemCard("Electriciy",
                    image: Assets.icons.flashCircle.path, onTap: () {
                  if (genericProvider.serviceStatus?.electricity?.value
                              ?.toLowerCase() ==
                          "coming-soon" ||
                      genericProvider.serviceStatus?.electricity?.value
                              ?.toLowerCase() ==
                          "temporarily-unavailable") {
                    showCustomToast(
                        context: context,
                        description: genericProvider
                                .serviceStatus?.electricity?.message
                                ?.toLowerCase() ??
                            "This service is not available at the moment.");
                    return;
                  }
                  Navigator.pushNamed(context, RoutesManager.electricityProviders);
                }, context: context),
              if (genericProvider.serviceStatus?.tv?.status == true ||
                  genericProvider.serviceStatus?.tv?.value?.toLowerCase() ==
                      "coming-soon" ||
                  genericProvider.serviceStatus?.tv?.value?.toLowerCase() !=
                      "deactivated")
                HomeTab.buildServiceItemCard("TV/Cable",
                    image: Assets.icons.devices.path, onTap: () {
                  if (genericProvider.serviceStatus?.tv?.value?.toLowerCase() ==
                          "coming-soon" ||
                      genericProvider.serviceStatus?.tv?.value?.toLowerCase() ==
                          "temporarily-unavailable") {
                    showCustomToast(
                        context: context,
                        description: genericProvider.serviceStatus?.tv?.message
                                ?.toLowerCase() ??
                            "This service is not available at the moment.");
                    return;
                  }
                  Navigator.pushNamed(context, RoutesManager.cableTvProviders);
                }, context: context),
            ],
          ),
          Gap(16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (genericProvider.serviceStatus?.internationalData?.status ==
                      true ||
                  genericProvider.serviceStatus?.internationalData?.value
                          ?.toLowerCase() ==
                      "coming-soon" ||
                  genericProvider.serviceStatus?.internationalData?.value
                          ?.toLowerCase() !=
                      "deactivated")
                HomeTab.buildServiceItemCard("Int'l Data",
                    image: Assets.icons.arrangeSquare2.path, onTap: () {
                  if (genericProvider.serviceStatus?.internationalData?.value
                              ?.toLowerCase() ==
                          "coming-soon" ||
                      genericProvider.serviceStatus?.internationalData?.value
                              ?.toLowerCase() ==
                          "temporarily-unavailable") {
                    showCustomToast(
                        context: context,
                        description: genericProvider
                                .serviceStatus?.internationalData?.message
                                ?.toLowerCase() ??
                            "This service is not available at the moment.");
                    return;
                  }
                  Navigator.pushNamed(
                      context, RoutesManager.internationalData1);
                }, context: context),
              if (genericProvider.serviceStatus?.internationalAirtime?.status ==
                      true ||
                  genericProvider.serviceStatus?.internationalAirtime?.value
                          ?.toLowerCase() ==
                      "coming-soon" ||
                  genericProvider.serviceStatus?.internationalAirtime?.value
                          ?.toLowerCase() !=
                      "deactivated")
                HomeTab.buildServiceItemCard("Int'l Airtime",
                    image: Assets.icons.slider.path, onTap: () {
                  if (genericProvider.serviceStatus?.internationalAirtime?.value
                              ?.toLowerCase() ==
                          "coming-soon" ||
                      genericProvider.serviceStatus?.internationalAirtime?.value
                              ?.toLowerCase() ==
                          "temporarily-unavailable") {
                    showCustomToast(
                        context: context,
                        description: genericProvider
                                .serviceStatus?.internationalAirtime?.message
                                ?.toLowerCase() ??
                            "This service is not available at the moment.");
                    return;
                  }
                  Navigator.pushNamed(
                      context, RoutesManager.internationalAirtime1);
                }, context: context),
              if (genericProvider.serviceStatus?.giftcards?.status == true ||
                  genericProvider.serviceStatus?.giftcards?.value
                          ?.toLowerCase() ==
                      "coming-soon" ||
                  genericProvider.serviceStatus?.giftcards?.value
                          ?.toLowerCase() !=
                      "deactivated")
                HomeTab.buildServiceItemCard("Giftcard",
                    image: Assets.icons.money4.path, onTap: () {
                  if (genericProvider.serviceStatus?.giftcards?.value
                              ?.toLowerCase() ==
                          "coming-soon" ||
                      genericProvider.serviceStatus?.giftcards?.value
                              ?.toLowerCase() ==
                          "temporarily-unavailable") {
                    showCustomToast(
                        context: context,
                        description: genericProvider
                                .serviceStatus?.giftcards?.message
                                ?.toLowerCase() ??
                            "This service is not available at the moment.");
                    return;
                  }
                  Navigator.pushNamed(context, RoutesManager.giftcard1);
                }, context: context),
              if (genericProvider.serviceStatus?.ePin?.status == true ||
                  genericProvider.serviceStatus?.ePin?.value?.toLowerCase() ==
                      "coming-soon" ||
                  genericProvider.serviceStatus?.ePin?.value?.toLowerCase() !=
                      "deactivated")
                HomeTab.buildServiceItemCard("E-PIN",
                    image: Assets.icons.lock.path, onTap: () {
                  if (genericProvider.serviceStatus?.ePin?.value
                              ?.toLowerCase() ==
                          "coming-soon" ||
                      genericProvider.serviceStatus?.ePin?.value
                              ?.toLowerCase() ==
                          "temporarily-unavailable") {
                    showCustomToast(
                        context: context,
                        description: genericProvider
                                .serviceStatus?.ePin?.message
                                ?.toLowerCase() ??
                            "This service is not available at the moment.");
                    return;
                  }
                  Navigator.pushNamed(context, RoutesManager.buyEPin1);
                }, context: context),
              // HomeTab.buildServiceItemCard("Betting",
              //     image: Assets.icons.crown.path, onTap: () {
              //   Navigator.pushNamed(context, RoutesManager.betting1);
              // }),
            ],
          ),
          Gap(16),
          Divider(
            thickness: .5,
          ),
          Gap(16),

          //  buildBannerView(size, genericProvider.banners),

          CarouselSlider(
            options: CarouselOptions(
              viewportFraction: 1,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlay: genericProvider.banners.length > 1 ? true : false,
              // enlargeCenterPage: true,
              height: 170,
            ),
            // items: [
            //   AdBanner(),
            //   AdBanner(),
            // ],
            items: genericProvider.banners.map((banner) {
              return AdBanner(
                  banner:
                      banner); // Replace with the actual widget that uses the banner data
            }).toList(),
          ),

          //
          const SizedBox(height: 24),

          for (int i = 0; i < userProvider.recentTxns.length; i++)
            // ServiceHistoryTile(param: userProvider.recentTxns[i]),

            // (userProvider.recentTxns.isEmpty)
            //     ? CustomContainer(
            //         header: Text("HISTORY",
            //             style: get14TextStyle().copyWith(
            //                 color: ColorManager.kTextDark.withOpacity(.7))),
            //         width: double.infinity,
            //         margin: const EdgeInsets.only(top: 15),
            //         child: Text("Your recent transactions will appear here.",
            //             textAlign: TextAlign.center, style: get14TextStyle()),
            //       )
            //     : Center(
            //         child: CustomButton(
            //           height: 25,
            //           padding: const EdgeInsets.symmetric(vertical: 5),
            //           width: 129,
            //           text: "See all transactions",
            //           textStyle: get12TextStyle().copyWith(
            //             color: ColorManager.kPrimary,
            //           ),
            //           isActive: true,
            //           backgroundColor: ColorManager.kPrimaryLight,
            //           border: Border.all(
            //               width: .5, color: ColorManager.k267E9B.withOpacity(.3)),
            //           loading: false,
            //           onTap: () {
            //             genericProvider.updatePage(DashboardTabs.history);
            //           },
            //         ),
            //       ),

            const SizedBox(height: 30)
        ],
      ),
    );
  }

  Future<void> genAcount({required String bvn}) async {
    // if (googleSignInLoading || appleSignInLoading || loginLoading) return;
    print("here");

    await Future.delayed(const Duration(seconds: 1));

    ServicesHelper.generateAccount();
  }

  void _generateStaticAccountBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => GenerateAccountBottomSheet(),
    );
  }

//   void _generateStaticAccountBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       isScrollControlled: true,
//       builder: (context) {
//         TextEditingController _bvnController = TextEditingController();
//         DateTime? dateOfBirth;
//         final _formKey = GlobalKey<FormState>();

//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 IconButton(
//                     onPressed: () => Navigator.of(context).pop(),
//                     icon: Icon(
//                       Icons.close,
//                       color: ColorManager.kFormHintText,
//                     )),
//               ],
//             ),
//             CustomContainer(
//               margin: const EdgeInsets.only(top: 0),
//               padding: EdgeInsets.all(16),
//               width: double.infinity,
//               header: Text("GENERATE ACCOUNT",
//                   style: get14TextStyle()
//                       .copyWith(color: ColorManager.kTextDark.withOpacity(.7))),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                       child: Text(
//                         "Kindly provide your BVN",
//                         style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.black,
//                             fontWeight: FontWeight.w200),
//                       ),
//                     ),

//                     // 24.toColumnSizedBox(),

//                     // 10.toColumnSizedBox(),

//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: CustomInputField(
//                         formHolderName: "",
//                         hintText: "Enter BVN",
//                         textEditingController: _bvnController,
//                         textInputType: TextInputType.number,
//                         onChanged: (_) => setState(() {}),
//                       ),
//                     ),

//                     Gap(16),
//                     Padding(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                       child: CustomInputField(
//                         formHolderName: "Date Of Birth",
//                         hintText: "Select your data of birth",
//                         textEditingController: TextEditingController(
//                             text: dateOfBirth == null
//                                 ? ""
//                                 : "${dateOfBirth?.year}-${dateOfBirth?.month}-${dateOfBirth?.day}"),
//                         textInputAction: TextInputAction.done,
//                         readOnly: true,
//                         onTap: () async {
//                           final date = await showDatePicker(
//                             context: context,
//                             firstDate: DateTime.now()
//                                 .subtract(Duration(days: 365 * 100)),
//                             lastDate: DateTime.now()
//                                 .subtract(Duration(days: 365 * 18)),
//                           );
//                           if (date != null) {
//                             dateOfBirth = date;
//                             setState(() {});
//                           }
//                         },
//                       ),
//                     ),
//  Gap(16),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: CustomButton(
//                         text: "Proceed",
//                         isActive: true,
//                         onTap: () async {
//                           if (!(_formKey.currentState?.validate() ?? false)) {
//                             return;
//                           }

//                           String bvn = _bvnController.text;

//                           await genAcount(bvn: bvn).catchError((e) {
//                             log(e);
//                             showCustomToast(
//                                 context: context,
//                                 description: e.toString(),
//                                 type: ToastType.error);

//                             Navigator.of(context).pop();
//                           });
//                         },
//                         loading: false,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Gap(40.0),
//                           Text(
//                             'Why We Need your BVN',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 16,
//                                 color: Colors.black),
//                           ),
//                           Gap(16.0),
//                           Text(
//                             'We use your BVN to confirm your identity. When you provide your BVN, we can only access your name, date of birth, and the phone number linked to it.',
//                             style: TextStyle(
//                                 fontSize: 15.0,
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.w400),
//                           ),
//                           Gap(24.0),
//                           Text(
//                             'We cannot access your bank accounts, transaction history, or any other sensitive financial information.',
//                             style: TextStyle(
//                                 fontSize: 15.0,
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.w400),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Gap(50)
//                   ],
//                 ),
//               ),
//             )
//           ],
//         );
//       },
//     );
//   }

  final Map<String, bool> _isGenerating = {
    "xixapay": false,
    "monnify": false,
    "safehaven": false,
  };
  void _showAccountDetailsBottomSheet(
      BuildContext context, UserProvider userProvider) async {
    log("here");
    List<VirtualBankDetail>? dt =
        await ServicesHelper.getVirtualAccount().catchError((_) {
      showCustomToast(
        context: context,
        description: "$_",
        type: ToastType.error,
      );
    });

    User user = userProvider.user;
    print('....bvn verified ${user.bvn_verified}');

    if (!(user.bvn_verified || user.bvn_validated)) {
      // 🚨 If BVN not verified/validated → show static account bottomsheet
      _generateStaticAccountBottomSheet(context);
      return;
    }

    // ✅ If BVN is verified/validated → show accounts + provider buttons
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        // wrap in StatefulBuilder to manage bottom sheet state
        return StatefulBuilder(
          builder: (context, setModalState) {
            // collect existing providers
            final existingProviders =
                (dt ?? []).map((a) => a.provider.toLowerCase()).toSet();

            // all possible providers
            final allProviders = ["xixapay", "monnify", "safehaven"];

            // filter providers that don’t exist yet
            final availableToGenerate = allProviders
                .where((p) => !existingProviders.contains(p.toLowerCase()))
                .toList();

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.close,
                            color: ColorManager.kFormHintText),
                      ),
                    ],
                  ),
                  // ✅ Show existing accounts
                  if (dt != null && dt.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: dt.length,
                      itemBuilder: (context, index) {
                        final account = dt[index];
                        return CustomContainer(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.all(16),
                          width: double.infinity,
                          header: Text(
                            "STATIC ACCOUNT DETAILS",
                            style: get14TextStyle().copyWith(
                              color: ColorManager.kTextDark.withOpacity(.7),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BankDetailRow(
                                title: "Bank Name",
                                value: Text(
                                  account.bank_name ?? "",
                                  style: get14TextStyle().copyWith(
                                    color:
                                        ColorManager.kTextDark.withOpacity(.9),
                                  ),
                                ),
                              ),
                              BankDetailRow(
                                title: "Account Number",
                                value: InkWell(
                                  onTap: () => Clipboard.setData(
                                    ClipboardData(
                                        text: account.account_number ?? ""),
                                  ).then((_) {
                                    showCustomToast(
                                      context: context,
                                      description:
                                          "Account number copied to clipboard",
                                      type: ToastType.success,
                                    );
                                  }),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        account.account_number ?? "",
                                        style: get14TextStyle().copyWith(
                                          color: ColorManager.kTextDark
                                              .withOpacity(.9),
                                        ),
                                      ),
                                      const Gap(10),
                                      Assets.images.copyIcon
                                          .image(width: 26, height: 26),
                                    ],
                                  ),
                                ),
                              ),
                              BankDetailRow(
                                title: "Account Name",
                                value: SizedBox(
                                  width: MediaQuery.sizeOf(context).width * .5,
                                  child: Text(
                                    account.account_name ?? "",
                                    textAlign: TextAlign.right,
                                    style: get14TextStyle().copyWith(
                                      color: ColorManager.kTextDark
                                          .withOpacity(.9),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  const Gap(20),

                  // ✅ Always show provider buttons if BVN is verified
                  if (availableToGenerate.isNotEmpty)
                    Column(
                      children: availableToGenerate.map((provider) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CustomButton(
                            isActive: true,
                            loading: _isGenerating[provider] == true,
                            onTap: () async {
                              setModalState(() {
                                _isGenerating[provider] = true; // start loading
                              });

                              log(_isGenerating[provider].toString(),
                                  name: "Loading");

                              if (provider.toLowerCase() == 'safehaven') {
                                try {
                                  final success = await ServicesHelper
                                      .requestSafeHavenOtp();

                                  if (!context.mounted) return;

                                  if (success == true) {
                                    // ✅ Close the bottomsheet before navigating
                                    Navigator.pop(context);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => VerifyBVNOTPView(
                                          type: "BVN", // pass id type if needed
                                        ),
                                      ),
                                    );
                                  } else {
                                    showCustomToast(
                                      context: context,
                                      description:
                                          "Unable to request OTP. Please try again.",
                                      type: ToastType.error,
                                    );
                                  }
                                } catch (e) {
                                  if (!context.mounted) return;

                                  showCustomToast(
                                    context: context,
                                    description: e.toString(),
                                    type: ToastType.error,
                                  );
                                } finally {
                                  setModalState(() {
                                    _isGenerating[provider] =
                                        false; // stop loading
                                  });
                                }
                              } else {
                                try {
                                  await ServicesHelper.generateVirtualAccount(
                                    provider.replaceAll(" ", ""),
                                  );

                                  if (!context.mounted) return;

                                  showCustomToast(
                                    context: context,
                                    description:
                                        "${capitalizeFirstString(provider)} virtual account generated successfully",
                                    type: ToastType.success,
                                  );

                                  Navigator.pop(context);
                                  _showAccountDetailsBottomSheet(
                                      context, userProvider);
                                } catch (e) {
                                  print('...the error is ${e.toString()}');
                                  if (!context.mounted) return;

                                  showCustomToast(
                                    context: context,
                                    description: e.toString(),
                                    type: ToastType.error,
                                  );

                                  Navigator.pop(context);
                                  _showAccountDetailsBottomSheet(
                                      context, userProvider);
                                } finally {
                                  setModalState(() {
                                    _isGenerating[provider] = false;
                                  });
                                }
                              }
                            },
                            text:
                                "Generate ${capitalizeFirstString(provider)} Account",
                          ),
                        );
                      }).toList(),
                    ),
                  const Gap(50),
                ],
              ),
            );
          },
        );
      },
    );
  }

//   void _showAccountDetailsBottomSheet(
//       BuildContext context, UserProvider userProvider) async {
//     log("here");
//     List<VirtualBankDetail>? dt =
//         await ServicesHelper.getVirtualAccount().catchError((_) {
//       showCustomToast(
//           context: context, description: "$_", type: ToastType.error);
//     });

//     log(dt.toString(), name: "Time");

//     User user = userProvider.user;

//     if (user.bvn_verified || user.bvn_validated) {
//       showModalBottomSheet(
//         context: context,
//         backgroundColor: Colors.white,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         isScrollControlled: true,
//         builder: (context) {
//           // collect existing providers
//           // collect existing providers
//           final existingProviders =
//               (dt ?? []).map((a) => a.provider.toLowerCase()).toSet();

// // all possible providers
//           final allProviders = ["xixapay", "monnify", "safehaven"];

// // filter providers that don’t exist yet
//           final availableToGenerate = allProviders
//               .where((p) => !existingProviders.contains(p.toLowerCase()))
//               .toList();

//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     // Container(
//                     //   height: 5,
//                     //   width: 50,
//                     //   margin: const EdgeInsets.only(bottom: 16),
//                     //   decoration: BoxDecoration(
//                     //     color: Colors.grey[300],
//                     //     borderRadius: BorderRadius.circular(10),
//                     //   ),
//                     // ),
//                     IconButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         icon: Icon(
//                           Icons.close,
//                           color: ColorManager.kFormHintText,
//                         )),
//                   ],
//                 ),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: dt?.length,
//                   itemBuilder: (context, index) {
//                     final account = dt?[index];
//                     // String provider = account.provider;
//                     return CustomContainer(
//                       margin: const EdgeInsets.only(top: 16),
//                       padding: const EdgeInsets.all(16),
//                       width: double.infinity,
//                       header: Text(
//                         "STATIC ACCOUNT DETAILS",
//                         style: get14TextStyle().copyWith(
//                           color: ColorManager.kTextDark.withOpacity(.7),
//                         ),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           BankDetailRow(
//                             title: "Bank Name",
//                             value: Text(
//                               account?.bank_name ?? "",
//                               style: get14TextStyle().copyWith(
//                                 color: ColorManager.kTextDark.withOpacity(.9),
//                               ),
//                             ),
//                           ),
//                           BankDetailRow(
//                             title: "Account Number",
//                             value: InkWell(
//                               onTap: () => Clipboard.setData(
//                                 ClipboardData(
//                                     text: account?.account_number ?? ""),
//                               ).then((value) {
//                                 showCustomToast(
//                                   context: context,
//                                   description:
//                                       "Account number copied to clipboard",
//                                   type: ToastType.success,
//                                 );
//                               }),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   Text(
//                                     account?.account_number ?? "",
//                                     style: get14TextStyle().copyWith(
//                                       color: ColorManager.kTextDark
//                                           .withOpacity(.9),
//                                     ),
//                                   ),
//                                   const Gap(10),
//                                   Assets.images.copyIcon
//                                       .image(width: 26, height: 26),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           BankDetailRow(
//                             title: "Account Name",
//                             value: SizedBox(
//                               width: MediaQuery.sizeOf(context).width * .5,
//                               child: Text(
//                                 textAlign: TextAlign.right,
//                                 account?.account_name ?? "",
//                                 style: get14TextStyle().copyWith(
//                                   color: ColorManager.kTextDark.withOpacity(.9),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//                 const Gap(20),
//                 // Add button to generate other providers below
//                 if (availableToGenerate.isNotEmpty) ...[
//                   // Text(
//                   //   "Generate Account from Provider",
//                   //   style: get16TextStyle().copyWith(
//                   //     fontWeight: FontWeight.bold,
//                   //     color: ColorManager.kTextDark,
//                   //   ),
//                   // ),
//                   const Gap(12),
//                   Column(
//                     children: availableToGenerate.map((provider) {
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 12),
//                         child: CustomButton(
//                           isActive: true,
//                           loading: _isGenerating[provider] ==
//                               true, // 👈 bind loading state here
//                           onTap: () async {
//                             setState(() {
//                               _isGenerating[provider] = true; // start loading
//                             });

//                             try {
//                               await ServicesHelper.generateVirtualAccount(
//                                 provider.replaceAll(" ", ""),
//                               );

//                               if (!context.mounted) return;

//                               showCustomToast(
//                                 context: context,
//                                 description:
//                                     "${capitalizeFirstString(provider)} virtual account generated successfully",
//                                 type: ToastType.success,
//                               );

//                               Navigator.pop(context); // closes bottomsheet
//                               _showAccountDetailsBottomSheet(
//                                   context, userProvider); // refreshes list
//                             } catch (e) {
//                               if (!context.mounted) return;

//                               showCustomToast(
//                                 context: context,
//                                 description: e.toString(),
//                                 type: ToastType.error,
//                               );

//                               Navigator.pop(context);
//                               _showAccountDetailsBottomSheet(
//                                   context, userProvider);
//                             } finally {
//                               if (mounted) {
//                                 setState(() {
//                                   _isGenerating[provider] =
//                                       false; // stop loading
//                                 });
//                               }
//                             }
//                           },
//                           text:
//                               "Generate ${capitalizeFirstString(provider)} Account",
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ],
//                 const Gap(50),
//               ],
//             ),
//           );
//         },
//       );
//       return;
//     } else {
//       _generateStaticAccountBottomSheet(context);
//     }
//   }
}

class StaticAccountWidget extends StatelessWidget {
  final List<VirtualBankDetail> details;
  const StaticAccountWidget({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 5,
                width: 50,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  // color: Colors.grey[300],
                  color: Colors.transparent,

                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Text("STATIC ACCOUNT DETAILS",
                  style: get14TextStyle()
                      .copyWith(color: ColorManager.kTextDark.withOpacity(.7))),
              IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: ColorManager.kFormHintText,
                  )),
            ],
          ),
          ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (context, index) => Gap(10),
            itemCount: details.length,
            itemBuilder: (context, index) => CustomContainer(
              margin: const EdgeInsets.only(top: 0),
              padding: EdgeInsets.all(16),
              width: double.infinity,
              header: Text("",
                  style: get14TextStyle()
                      .copyWith(color: ColorManager.kTextDark.withOpacity(.7))),
              child: Column(
                children: [
                  BankDetailRow(
                      title: "Bank Name",
                      value: Text(details[index].bank_name,
                          style: get14TextStyle().copyWith(
                              color: ColorManager.kTextDark.withOpacity(.9)))),
                  BankDetailRow(
                      title: "Bank Account Number",
                      value: InkWell(
                        onTap: () => Clipboard.setData(ClipboardData(
                                text: details[index].account_number))
                            .then((value) {
                          showCustomToast(
                              context: context,
                              description: "Account number copied to clipboard",
                              type: ToastType.success);
                          // ToastAlert.showAlert("Referral code copied");
                        }),
                        child: Row(
                          children: [
                            Text(details[index].account_number,
                                style: get14TextStyle().copyWith(
                                    color: ColorManager.kTextDark
                                        .withValues(alpha: .9))),
                            Gap(10),
                            Assets.images.copyIcon.image(width: 18, height: 18)
                          ],
                        ),
                      )),
                  BankDetailRow(
                      title: "Bank Account Name",
                      value: Text(details[index].account_name,
                          style: get14TextStyle().copyWith(
                              color: ColorManager.kTextDark.withOpacity(.9)))),
                ],
              ),
            ),
          ),
          Gap(50)
        ],
      ),
    );
  }
}

class BankDetailRow extends StatelessWidget {
  final String title;
  final Widget value;
  const BankDetailRow({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: get14TextStyle()
                  .copyWith(color: ColorManager.kTextDark.withOpacity(.7))),
          value
        ],
      ),
    );
  }
}

class AdBanner extends StatelessWidget {
  final Banners banner;
  const AdBanner({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   width: double.maxFinite,
    //   height: 170,
    //   margin: EdgeInsets.symmetric(horizontal: 8),
    //   padding: EdgeInsets.all(14),
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(14),
    //     color: ColorManager.kPrimaryLight,
    //     //  image: DecorationImage(image: Assets.images.banner.provider())
    //   ),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Text(
    //         "Get 30% off on Electricity Purchase",
    //         style: get14TextStyle().copyWith(color: ColorManager.kTextDark),
    //       ),
    //       Gap(4),
    //       Text(
    //         "Enim libero ut pellent esque ut duis amet. Ut. pelle",
    //         overflow: TextOverflow.ellipsis,
    //         style: get14TextStyle()
    //             .copyWith(color: ColorManager.kTextDark.withOpacity(.7)),
    //       ),
    //       Gap(8),
    //       Container(
    //         padding: EdgeInsets.all(5),
    //         decoration: BoxDecoration(
    //             color: ColorManager.kPrimary,
    //             borderRadius: BorderRadius.circular(17)),
    //         child: Text(
    //           "Go Now",
    //           style: TextStyle(
    //               color: ColorManager.kWhite, fontWeight: FontWeight.w600),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        showDialogPopup(
            context, ImagePreviewPopupAlt(imageUrl: banner.preview_image),
            barrierDismissible: true,
            barrierColor: ColorManager.kBlack.withOpacity(.5));
      },
      child: Container(
        width: size.width * 0.9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: loadNetworkImage(banner.featured_image,
              fit: BoxFit.cover,
              height: 125,
              borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
