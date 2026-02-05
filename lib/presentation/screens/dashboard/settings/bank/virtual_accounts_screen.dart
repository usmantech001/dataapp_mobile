import 'package:dataplug/core/enum.dart';
import 'package:dataplug/core/providers/user_provider.dart';
import 'package:dataplug/core/providers/wallet_controller.dart';
import 'package:dataplug/core/utils/app-loader.dart';
import 'package:dataplug/core/utils/custom_bottom_sheet.dart';
import 'package:dataplug/core/utils/custom_image.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_snackbar.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      //if (!mounted) return;
    final walletController = context.read<WalletController>();
    if(walletController.virtualAccounts.isEmpty){
     walletController.getStaticAccounts();
    }
    });
  }

  @override
  Widget build(BuildContext context) {
    //final wallerController = context.watch<WalletController>();
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: CustomAppbar(title: 'Bank Account'),
      body: Consumer<WalletController>(
          builder: (context, wallerController, child) {
        return Column(
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
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 12.w),
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
                    ? Center(
                        child: CircularProgressIndicator(
                        color: ColorManager.kPrimary,
                      ))
                    : controller.virtualAccounts.isEmpty
                        ? Column(
                            spacing: 10.h,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 35.r,
                                backgroundColor: ColorManager.kPrimary
                                    .withValues(alpha: .05),
                                child: svgImage(
                                    imgPath: 'assets/icons/history.svg'),
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
                              final accountDetails =
                                  wallerController.virtualAccounts[index];
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
                                        name: 'Bank Name',
                                        value: accountDetails.customer_name),
                                    VirtualAccountRowText(
                                      name: 'Account Number',
                                      value: accountDetails.account_number,
                                      hasIcon: true,
                                      onTap: () {
                                        Clipboard.setData(
                                           ClipboardData(
                                              text: accountDetails.account_number),
                                        );
                                        showCustomToast(context: context, description: 'Account number successfully copied', type: ToastType.success);
                                      },
                                    ),
                                    VirtualAccountRowText(
                                        name: 'Bank Name',
                                        value: accountDetails.bank_name),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => Gap(15.h),
                            itemCount: wallerController.virtualAccounts.length),
              );
            }),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                child: Column(
                  spacing: 20.h,
                  children: [
                    if (!wallerController.alreadyGeneratedSafeHavenAcc)
                      CustomButton(
                          text: 'Generate Safehaven Account',
                          isActive: true,
                          onTap: () {
                            wallerController
                                .onStaticProviderSelected('safehaven');
                            // pushNamed(RoutesManager.verifyBvnNin);
                            if (userProvider.user.bvn_verified) {
                              displayLoader(context);
                              wallerController.generateStaticAccount(
                                onSuccess: () {
                                  popScreen();
                                  showCustomMessageBottomSheet(
                                      context: context,
                                      title: 'Virtual Accpunt Generated',
                                      description:
                                          'You have successfully generated your monnify static account.',
                                      onTap: () {
                                        popScreen();
                                        wallerController.getStaticAccounts();
                                      });
                                },
                                onError: (err) {
                                  popScreen();
                                  showCustomToast(
                                      context: context, description: err);
                                },
                              );
                            } else {
                              pushNamed(RoutesManager.verifyBvnNin);
                            }
                          },
                          loading: false),
                    if (!wallerController.alreadyGeneratedMonnifyAcc)
                      CustomButton(
                          text: 'Generate Monify Account',
                          isActive: true,
                          onTap: () {
                            wallerController
                                .onStaticProviderSelected('monnify');
                            if (userProvider.user.bvn_verified) {
                              displayLoader(context);
                              wallerController.generateStaticAccount(
                                onSuccess: () {
                                  popScreen();
                                  showCustomMessageBottomSheet(
                                      context: context,
                                      title: 'Virtual Accpunt Generated',
                                      description:
                                          'You have successfully generated your monnify static account.',
                                      onTap: () {
                                        popScreen();
                                        wallerController.getStaticAccounts();
                                      });
                                },
                                onError: (err) {
                                  popScreen();
                                  showCustomToast(
                                      context: context, description: err);
                                },
                              );
                            } else {
                              pushNamed(RoutesManager.verifyBvnNin);
                            }
                          },
                          loading: false),
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}

class VirtualAccountRowText extends StatelessWidget {
  const VirtualAccountRowText(
      {super.key,
      required this.name,
      required this.value,
      this.hasIcon = false,
      this.onTap});
  final String name;
  final String value;
  final bool hasIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 50.w,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: get16TextStyle()
              .copyWith(color: ColorManager.kGreyColor.withValues(alpha: .7)),
        ),
        Flexible(
          child: InkWell(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    value,
                    textAlign: TextAlign.end,
                    style: get16TextStyle()
                        .copyWith(color: ColorManager.kGreyColor),
                  ),
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
            ),
          ),
        )
      ],
    );
  }
}
