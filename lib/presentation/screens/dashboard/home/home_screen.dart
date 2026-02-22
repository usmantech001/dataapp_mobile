import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:dataplug/core/model/core/user.dart';
import 'package:dataplug/core/providers/data_controller.dart';
import 'package:dataplug/core/providers/user_provider.dart';
import 'package:dataplug/core/providers/wallet_controller.dart';
import 'package:dataplug/core/utils/app-loader.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/gen/assets.gen.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/notification_bell.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:dataplug/presentation/screens/dashboard/home/widgets/service_container.dart';
import 'package:dataplug/presentation/screens/dashboard/home/widgets/wallet_activities_container.dart';
import 'package:dataplug/presentation/screens/dashboard/home/widgets/wallet_container.dart';
import 'package:dataplug/presentation/screens/dashboard/services/internet_data/buy_smile_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      print('..user ${userProvider.user.fullName}');
      user = userProvider.user;
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final walletController = context.watch<WalletController>();
    final dataController = context.watch<DataController>();
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.only(top: 20.h),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Assets.images.dataplugLogoText.image(width: 118, height: 22),
                  const CustomNotificationBell()
                ],
              ),
            ),
            Expanded(
              child: CustomRefreshIndicator(
                onRefresh: () {
                  context.read<DataController>().getRecommendedDataPlans();
                  return context.read<WalletController>().getWalletBalance();
                },
                builder: (context, child, controller) {
                  return Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      if (controller.isDragging || controller.isRefreshEnabled)
                        Positioned(
                          top: 24,
                          child: Opacity(
                            opacity: controller.value.clamp(0.0, 1.0),
                            child: const LoadingIndicator(),
                          ),
                        ),

                      
                      Transform.translate(
                        offset: Offset(0, controller.value * 80),
                        child: child,
                      ),
                    ],
                  );
                },
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WalletContainer(),
                            Row(
                              spacing: 8.w,
                              children: [
                                Expanded(
                                    child: WalletActivitiesContainer(
                                  name: 'Add Money',
                                  iconPath: 'fund',
                                  // textColor: ColorManager.kPrimary,
                                  // bgColor: ColorManager.kPrimary.withValues(alpha: .08),
                                  onTap: () {
                                    pushNamed(RoutesManager.virtualAccounts);
                                  },
                                )),
                                Expanded(
                                    child: WalletActivitiesContainer(
                                  name: 'Transfer',
                                  iconPath: 'transfer',
                                  onTap: () => Navigator.pushNamed(
                                      context, RoutesManager.transfer),
                                )),
                                Expanded(
                                    child: WalletActivitiesContainer(
                                  name: 'Withdraw',
                                  iconPath: 'withdraw',
                                  onTap: () =>
                                      pushNamed(RoutesManager.withdraw),
                                )),
                              ],
                            ),
                            Gap(24.h),
                            ServiceContainer(
                                title: 'Popular Services',
                                serviceTypes: [
                                  ServiceTypeContainer(
                                    name: 'Data',
                                    iconPath: 'data-icon',
                                    onTap: () =>
                                        pushNamed(RoutesManager.buyData),
                                  ),
                                  ServiceTypeContainer(
                                      name: 'Airtime',
                                      iconPath: 'airtime-icon',
                                      onTap: () => Navigator.pushNamed(
                                          context, RoutesManager.buyAirtime1)),
                                  ServiceTypeContainer(
                                      name: 'Electricity',
                                      iconPath: 'electricity-icon',
                                      onTap: () => Navigator.pushNamed(context,
                                          RoutesManager.electricityProviders)),
                                  ServiceTypeContainer(
                                      name: 'TV/Cable',
                                      iconPath: 'cable-icon',
                                      onTap: () => Navigator.pushNamed(context,
                                          RoutesManager.cableTvProviders)),
                                  ServiceTypeContainer(
                                      name: 'Int\'t Data',
                                      iconPath: 'intl-data-icon',
                                      onTap: () => pushNamed(
                                          RoutesManager.intlDataCountries)),
                                  ServiceTypeContainer(
                                      name: 'Int\'t Airtime',
                                      iconPath: 'intl-airtime-icon',
                                      onTap: () => Navigator.pushNamed(context,
                                          RoutesManager.intlAirtimeCountries)),
                                  ServiceTypeContainer(
                                      name: 'GiftCard',
                                      iconPath: 'giftcard-icon',
                                      onTap: () => Navigator.pushNamed(context,
                                          RoutesManager.giftcardCategory)),
                                  ServiceTypeContainer(
                                      name: 'More',
                                      iconPath: 'more-icon',
                                      onTap: () {
                                        pushNamed(RoutesManager.services);
                                      }),
                                ]),
                          ],
                        ),
                      ),
                      Gap(24.h),
                      if (walletController.banners.isNotEmpty)
                        CarouselSlider.builder(
                          itemCount: walletController.banners.length,
                          itemBuilder: (context, index, _) {
                            final banner = walletController.banners[index];
                            return ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: banner.featured_image,
                                  fit: BoxFit.contain,
                                ));
                          },
                          options: CarouselOptions(
                            // aspectRatio: 18/7,
                            viewportFraction: 1,
                            height: 165.h,
                          ),
                        ),
                      Gap(10),
                      Center(
                          child: SmoothPageIndicator(
                        controller: PageController(),
                        count: walletController.banners.length,
                        effect: WormEffect(
                            activeDotColor: ColorManager.kPrimary,
                            dotHeight: 8),
                      )),
                      Gap(24.h),
                      if (dataController.recommendedPlans.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 15.w),
                              child: Text(
                                'Recommended for you',
                                style: get16TextStyle()
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              height: 140.h,
                              child: ListView.separated(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.w, vertical: 12.h),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    final plan =
                                        dataController.recommendedPlans[index];
                                    return PlanBox(
                                        plan: plan,
                                        onTap: () {
                                          dataController.onPlanSelected(plan,
                                              isRecommended: true);
                                          pushNamed(
                                              RoutesManager.buyRecommendedData);
                                        });
                                  },
                                  separatorBuilder: (context, index) => Gap(20),
                                  itemCount:
                                      dataController.recommendedPlans.length),
                            )
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
