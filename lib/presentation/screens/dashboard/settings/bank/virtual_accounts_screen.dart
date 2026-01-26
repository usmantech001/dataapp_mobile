import 'package:dataplug/core/providers/wallet_controller.dart';
import 'package:dataplug/core/utils/custom_image.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class VirtualAccountsScreen extends StatefulWidget {
  const VirtualAccountsScreen({super.key});

  @override
  State<VirtualAccountsScreen> createState() => _VirtualAccountsScreenState();
}

class _VirtualAccountsScreenState extends State<VirtualAccountsScreen> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<WalletController>().getStaticAccounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final wallerController = context.read<WalletController>();
    return Scaffold(
      appBar: CustomAppbar(title: 'Bank Account'),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 24.h, left: 15.w, right: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Virtual Accounts',
                  style: get18TextStyle(),
                ),
                InkWell(
                  onTap: () => pushNamed(RoutesManager.quickFund),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                    decoration: BoxDecoration(
                        color: ColorManager.kPrimary,
                        borderRadius: BorderRadius.circular(8.r)),
                    child: Row(
                      spacing: 6.w,
                      children: [
                        svgImage(imgPath: 'assets/icons/flash-icon.svg'),
                        Text(
                          'Quick Fund',
                          style: get14TextStyle()
                              .copyWith(color: ColorManager.kWhite),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Consumer<WalletController>(builder: (context, controller, child) {
            return Expanded(
              child: controller.gettingVirtualAccs
                  ? Center(child: CircularProgressIndicator(
                    color: ColorManager.kPrimary,
                  ))
                  : controller.virtualAccounts.isEmpty
                      ? Column(
                        spacing: 10.h,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 35.r,
                              backgroundColor:
                                  ColorManager.kPrimary.withValues(alpha: .05),
                              child:
                                  svgImage(imgPath: 'assets/icons/history.svg'),
                            ),
                            Text(
                              'No Virtual Accounts Found',
                              style: get16TextStyle(),
                            ),
                            Text(
                              'Kindly generate static account to have accounts here',
                              style: get14TextStyle().copyWith(
                                  color: ColorManager.kGreyColor
                                      .withValues(alpha: .6)),
                            )
                          ],
                        )
                      : ListView.separated(

                          // shrinkWrap: true,
                          padding: EdgeInsets.symmetric(
                              vertical: 30, horizontal: 15.w),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 20.h),
                              decoration: BoxDecoration(
                                  color: ColorManager.kWhite,
                                  borderRadius: BorderRadius.circular(16.r)),
                              child: Column(
                                spacing: 12.h,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  VirtualAccountRowText(
                                      name: 'Bank Name', value: 'Usman'),
                                  VirtualAccountRowText(
                                    name: 'Account Number',
                                    value: '3161001031',
                                    hasIcon: true,
                                  ),
                                  VirtualAccountRowText(
                                      name: 'Bank Name', value: 'Usman'),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => Gap(15.h),
                          itemCount: 1),
            );
          }),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
              child: Column(
                spacing: 20.h,
                children: [
                  
                 CustomButton(
                      text: 'Generate Safehaven Account',
                      isActive: true,
                      onTap: () {
                         
                        wallerController.onStaticProviderSelected('safehaven');
                        pushNamed(RoutesManager.verifyBvnNin);
                      },
                      loading: false),
                  CustomButton(
                      text: 'Generate Monify Account',
                      isActive: true,
                      onTap: () {
                        wallerController.onStaticProviderSelected('monify');
                        pushNamed(RoutesManager.verifyBvnNin);
                      },
                      loading: false),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class VirtualAccountRowText extends StatelessWidget {
  const VirtualAccountRowText(
      {super.key,
      required this.name,
      required this.value,
      this.hasIcon = false});
  final String name;
  final String value;
  final bool hasIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: get16TextStyle()
              .copyWith(color: ColorManager.kGreyColor.withValues(alpha: .7)),
        ),
        Row(
          children: [
            Text(
              value,
              style: get16TextStyle().copyWith(color: ColorManager.kGreyColor),
            ),
            if (hasIcon)
              Container(
                  margin: EdgeInsets.only(left: 4.w),
                  height: 20.h,
                  width: 20.w,
                  decoration: BoxDecoration(
                      color: ColorManager.kPrimary.withValues(alpha: .08),
                      borderRadius: BorderRadius.circular(4.r)),
                  child: Icon(
                    Icons.copy,
                    color: ColorManager.kPrimary,
                    size: 15,
                  ))
          ],
        )
      ],
    );
  }
}
