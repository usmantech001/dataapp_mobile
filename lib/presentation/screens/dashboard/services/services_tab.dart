import 'package:dataplug/core/constants.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_container.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../../core/providers/generic_provider.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../gen/assets.gen.dart';
import '../../../misc/color_manager/color_manager.dart';
import '../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../misc/custom_snackbar.dart';
import '../../../misc/image_manager/image_manager.dart';
import '../../../misc/style_manager/styles_manager.dart';
import 'internet_data/select_data_type.dart';
// import 'internet_data/select_data_type.dart';

class ServiceTab extends StatefulWidget {
  const ServiceTab({super.key});

  @override
  State<ServiceTab> createState() => _ServiceTabState();

  // static Widget buildServiceCard(String name,
  //     {required String image,
  //     bool showHeader = false,
  //     bool showFooter = false,
  //     required Function onTap}) {
  //   return CustomContainer(
  //     header: showHeader ? const SizedBox(width: 100, height: 20) : null,
  //     footer: showFooter ? const SizedBox(width: 100, height: 20) : null,
  //     onTap: () => onTap(),
  //     padding: const EdgeInsets.all(20),
  //     borderRadiusSize: 32,
  //     child: Row(
  //       children: [
  //         Image.asset(image, width: 44),
  //         const SizedBox(width: 11),
  //         Text(name,
  //             style: get14TextStyle().copyWith(fontWeight: FontWeight.w500)),
  //         const Spacer(),
  //         Icon(Icons.chevron_right, color: ColorManager.kBarColor)
  //       ],
  //     ),
  //   );
  // }

  static Widget buildServiceCard(String name,
      {required BuildContext context, required String image, required Function onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap(),
      child:Container(
        width: Responsive.w(context, 82),
        height: Responsive.w(context, 86),
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: ColorManager.kPrimaryLight,
            border: Border.all(color: ColorManager.kPrimary),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

class _ServiceTabState extends State<ServiceTab> {
  final ScrollController controller = ScrollController();
  Future<void> refreshPageInfo(
      UserProvider userProvider, GenericProvider genericProvider) async {
    await Future.wait([
      userProvider.updateUserInfo(),
      userProvider.checkUnreadNotification(),
      userProvider.updateRecentTxns(),
      genericProvider.getServiceStatus(),
    ]);
  }

  @override
  void initState() {
    context.read<GenericProvider>().getServiceStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GenericProvider genericProvider = Provider.of<GenericProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return RefreshIndicator(
      onRefresh: () => refreshPageInfo(userProvider, genericProvider),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          controller: controller, // ✅ Attach the scroll controller
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Constants.kHorizontalScreenPadding,
                    vertical: 16),
                child: Text(
                  "Bills",
                  style: get14TextStyle().copyWith(
                    fontSize: 16,
                    color: ColorManager.kBlack,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Constants.kHorizontalScreenPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (genericProvider.serviceStatus?.airtime?.status ==
                            true ||
                        genericProvider.serviceStatus?.airtime?.value
                                ?.toLowerCase() ==
                            "coming-soon" ||
                        genericProvider.serviceStatus?.airtime?.value
                                ?.toLowerCase() !=
                            "deactivated")
                      ServiceTab.buildServiceCard("Airtime",
                          context: context, image: Assets.icons.slider.path, onTap: () {
                        if (genericProvider.serviceStatus?.airtime?.value
                                    ?.toLowerCase() ==
                                "coming-soon" ||
                            genericProvider.serviceStatus?.airtime?.value
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
                      }),
                    Gap(8),
                    if (genericProvider.serviceStatus?.data?.status == true ||
                        genericProvider.serviceStatus?.data?.value
                                ?.toLowerCase() ==
                            "coming-soon" ||
                        genericProvider.serviceStatus?.data?.value
                                ?.toLowerCase() !=
                            "deactivated")
                      ServiceTab.buildServiceCard("Data", context: context,
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
                            screen: const SelectDataType());
                        // Navigator.pushNamed(
                        //       context,
                        //       RoutesManager.buyData1,
                        //     );
                      }),
                    Gap(8),
                    if (genericProvider.serviceStatus?.electricity?.status ==
                            true ||
                        genericProvider.serviceStatus?.electricity?.value
                                ?.toLowerCase() ==
                            "coming-soon" ||
                        genericProvider.serviceStatus?.electricity?.value
                                ?.toLowerCase() !=
                            "deactivated")
                      ServiceTab.buildServiceCard("Electricity",context: context,
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
                        Navigator.pushNamed(
                            context, RoutesManager.buyElectricity1);
                      }),
                    Gap(8),
                    if (genericProvider.serviceStatus?.tv?.status == true ||
                        genericProvider.serviceStatus?.tv?.value
                                ?.toLowerCase() ==
                            "coming-soon" ||
                        genericProvider.serviceStatus?.tv?.value
                                ?.toLowerCase() !=
                            "deactivated")
                      ServiceTab.buildServiceCard("TV/Cable", context: context,
                          image: Assets.icons.devices.path, onTap: () {
                        if (genericProvider.serviceStatus?.tv?.value
                                    ?.toLowerCase() ==
                                "coming-soon" ||
                            genericProvider.serviceStatus?.tv?.value
                                    ?.toLowerCase() ==
                                "temporarily-unavailable") {
                          showCustomToast(
                              context: context,
                              description: genericProvider
                                      .serviceStatus?.tv?.message
                                      ?.toLowerCase() ??
                                  "This service is not available at the moment.");
                          return;
                        }
                        Navigator.pushNamed(context, RoutesManager.cableTv1);
                      }),
                  ],
                ),
              ),
              Gap(10),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Constants.kHorizontalScreenPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (genericProvider.serviceStatus?.betting?.status ==
                            true ||
                        genericProvider.serviceStatus?.betting?.value
                                ?.toLowerCase() ==
                            "coming-soon" ||
                        genericProvider.serviceStatus?.betting?.value
                                ?.toLowerCase() !=
                            "deactivated")
                      ServiceTab.buildServiceCard("Betting", context: context,
                          image: Assets.icons.crown.path, onTap: () {
                        if (genericProvider.serviceStatus?.betting?.value
                                    ?.toLowerCase() ==
                                "coming-soon" ||
                            genericProvider.serviceStatus?.betting?.value
                                    ?.toLowerCase() ==
                                "temporarily-unavailable") {
                          showCustomToast(
                              context: context,
                              description: genericProvider
                                      .serviceStatus?.betting?.message
                                      ?.toLowerCase() ??
                                  "This service is not available at the moment.");
                          return;
                        }
                        Navigator.pushNamed(context, RoutesManager.betting1);
                      }),
                    Gap(10),
                    if (genericProvider.serviceStatus?.ePin?.status == true ||
                        genericProvider.serviceStatus?.ePin?.value
                                ?.toLowerCase() ==
                            "coming-soon" ||
                        genericProvider.serviceStatus?.ePin?.value
                                ?.toLowerCase() !=
                            "deactivated")
                      ServiceTab.buildServiceCard("E-PIN",context: context,
                          image: Assets.icons.lock.path, onTap: () {
                        if (genericProvider.serviceStatus?.ePin?.value
                                    ?.toLowerCase() ==
                                "coming-soon" ||
                            genericProvider.serviceStatus?.ePin?.value
                                    ?.toLowerCase() ==
                                "temporarily-unavailable" ||
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
                      }),
                  ],
                ),
              ),
              Gap(16),
              Divider(
                thickness: .5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Constants.kHorizontalScreenPadding,
                    vertical: 16),
                child: Text(
                  "Others",
                  style: get14TextStyle().copyWith(
                    fontSize: 16,
                    color: ColorManager.kBlack,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Constants.kHorizontalScreenPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (genericProvider.serviceStatus?.giftcards?.status ==
                            true ||
                        genericProvider.serviceStatus?.giftcards?.value
                                ?.toLowerCase() ==
                            "coming-soon" ||
                        genericProvider.serviceStatus?.giftcards?.value
                                ?.toLowerCase() !=
                            "deactivated")
                      ServiceTab.buildServiceCard("Giftcard", context: context,
                          image: Assets.icons.money4.path, onTap: () {
                        if (genericProvider.serviceStatus?.giftcards?.value
                                    ?.toLowerCase() ==
                                "coming-soon" ||
                            genericProvider.serviceStatus?.giftcards?.value
                                    ?.toLowerCase() ==
                                "temporarily-unavailable" ||
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
                        Navigator.pushNamed(context, RoutesManager.giftcardMain,
                            arguments: 1);
                      }),
                    Gap(10),
                    if (genericProvider
                                .serviceStatus?.internationalData?.status ==
                            true ||
                        genericProvider.serviceStatus?.internationalData?.value
                                ?.toLowerCase() ==
                            "coming-soon" ||
                        genericProvider.serviceStatus?.internationalData?.value
                                ?.toLowerCase() !=
                            "deactivated")
                      ServiceTab.buildServiceCard("Int'l Data", context: context,
                          image: Assets.icons.arrangeSquare2.path, onTap: () {
                        if (genericProvider
                                    .serviceStatus?.internationalData?.value
                                    ?.toLowerCase() ==
                                "coming-soon" ||
                            genericProvider
                                    .serviceStatus?.internationalData?.value
                                    ?.toLowerCase() ==
                                "temporarily-unavailable" ||
                            genericProvider
                                    .serviceStatus?.internationalData?.value
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
                      }),
                    Gap(10),
                    if (genericProvider
                                .serviceStatus?.internationalAirtime?.status ==
                            true ||
                        genericProvider
                                .serviceStatus?.internationalAirtime?.value
                                ?.toLowerCase() ==
                            "coming-soon" ||
                        genericProvider
                                .serviceStatus?.internationalAirtime?.value
                                ?.toLowerCase() !=
                            "deactivated")
                      ServiceTab.buildServiceCard("Int'l Airtime",
                          context: context,  image: Assets.icons.slider.path, onTap: () {
                        if (genericProvider
                                    .serviceStatus?.internationalAirtime?.value
                                    ?.toLowerCase() ==
                                "coming-soon" ||
                            genericProvider
                                    .serviceStatus?.internationalAirtime?.value
                                    ?.toLowerCase() ==
                                "temporarily-unavailable" ||
                            genericProvider
                                    .serviceStatus?.internationalAirtime?.value
                                    ?.toLowerCase() ==
                                "temporarily-unavailable") {
                          showCustomToast(
                              context: context,
                              description: genericProvider.serviceStatus
                                      ?.internationalAirtime?.message
                                      ?.toLowerCase() ??
                                  "This service is not available at the moment.");
                          return;
                        }
                        Navigator.pushNamed(
                            context, RoutesManager.internationalAirtime1);
                      }),
                  ],
                ),
              ),
              Gap(16),
              Divider(
                thickness: .5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Constants.kHorizontalScreenPadding,
                    vertical: 16),
                child: Text(
                  "Wallet Activities",
                  style: get14TextStyle().copyWith(
                    fontSize: 16,
                    color: ColorManager.kBlack,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Constants.kHorizontalScreenPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (genericProvider.serviceStatus?.withdraw?.status ==
                            true ||
                        genericProvider.serviceStatus?.withdraw?.value
                                ?.toLowerCase() ==
                            "coming-soon" ||
                        genericProvider.serviceStatus?.withdraw?.value
                                ?.toLowerCase() !=
                            "deactivated")
                      ServiceTab.buildServiceCard("Withdraw",context: context,
                          image: Assets.icons.sendSqaure2.path, onTap: () {
                        if (genericProvider.serviceStatus?.withdraw?.value
                                    ?.toLowerCase() ==
                                "coming-soon" ||
                            genericProvider.serviceStatus?.withdraw?.value
                                    ?.toLowerCase() ==
                                "temporarily-unavailable" ||
                            genericProvider.serviceStatus?.withdraw?.value
                                    ?.toLowerCase() ==
                                "temporarily-unavailable") {
                          showCustomToast(
                              context: context,
                              description: genericProvider
                                      .serviceStatus?.withdraw?.message
                                      ?.toLowerCase() ??
                                  "This service is not available at the moment.");
                          return;
                        }
                        Navigator.pushNamed(context, RoutesManager.withdraw1);
                      }),
                    Gap(10),
                    if (genericProvider.serviceStatus?.transfer?.status ==
                            true ||
                        genericProvider.serviceStatus?.transfer?.value
                                ?.toLowerCase() ==
                            "coming-soon" ||
                        genericProvider.serviceStatus?.transfer?.value
                                ?.toLowerCase() !=
                            "deactivated")
                      ServiceTab.buildServiceCard("Transfer", context: context,
                          image: Assets.icons.convertCard.path, onTap: () {
                        if (genericProvider.serviceStatus?.transfer?.value
                                    ?.toLowerCase() ==
                                "coming-soon" ||
                            genericProvider.serviceStatus?.transfer?.value
                                    ?.toLowerCase() ==
                                "temporarily-unavailable" ||
                            genericProvider.serviceStatus?.transfer?.value
                                    ?.toLowerCase() ==
                                "temporarily-unavailable") {
                          showCustomToast(
                              context: context,
                              description: genericProvider
                                      .serviceStatus?.transfer?.message
                                      ?.toLowerCase() ??
                                  "This service is not available at the moment.");
                          return;
                        }
                        Navigator.pushNamed(context, RoutesManager.transfer1);
                      }),
                    Gap(10),
                    if (genericProvider.serviceStatus?.fund?.status == true ||
                        genericProvider.serviceStatus?.fund?.value
                                ?.toLowerCase() ==
                            "coming-soon" ||
                        genericProvider.serviceStatus?.fund?.value
                                ?.toLowerCase() !=
                            "deactivated")
                      ServiceTab.buildServiceCard("Top Up", context: context,
                          image: Assets.icons.walletAddColored.path, onTap: () {
                        if (genericProvider.serviceStatus?.fund?.value
                                    ?.toLowerCase() ==
                                "coming-soon" ||
                            genericProvider.serviceStatus?.fund?.value
                                    ?.toLowerCase() ==
                                "temporarily-unavailable" ||
                            genericProvider.serviceStatus?.fund?.value
                                    ?.toLowerCase() ==
                                "temporarily-unavailable") {
                          showCustomToast(
                              context: context,
                              description: genericProvider
                                      .serviceStatus?.fund?.message
                                      ?.toLowerCase() ??
                                  "This service is not available at the moment.");
                          return;
                        }
                        Navigator.pushNamed(context, RoutesManager.deposit1);
                      }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
