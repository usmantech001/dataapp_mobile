import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_empty_state.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_scaffold.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../../../core/enum.dart';
import '../../../../../core/helpers/user_helper.dart';
import '../../../../../core/model/core/user_bank.dart';
import '../../../../../core/providers/user_provider.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../misc/custom_components/custom_btn.dart';
import '../../../../misc/custom_snackbar.dart';
import '../../../../misc/image_manager/image_manager.dart';
import '../../../../misc/shimmers/square_shimmer.dart';
import '../misc/settings_icon_tab.dart';
import 'misc/bank_card.dart';

class AddedBanks extends StatefulWidget {
  const AddedBanks({super.key});

  @override
  State<AddedBanks> createState() => _AddedBanksState();
}

class _AddedBanksState extends State<AddedBanks> {
  final spacer = const SizedBox(height: 30);

  ScrollController controller = ScrollController();
  bool loading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);

      if (userProvider.savedBanks.isNotEmpty) {
        setState(() => loading = false);
      }
      await userProvider.updateAddedBanks().then((_) {}).catchError((_) {
        if (mounted) {
          showCustomToast(
            context: context,
            description: "An error occured, please retry again.",
          );
        }
      });

      setState(() => loading = false);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    List<UserBank> bankList = userProvider.savedBanks;

    return Scaffold(
      appBar: CustomAppbar(title: 'Bank Account'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 24.h),
        child: loading
            ? Column(
                children: const [
                  SquareShimmer(height: 75, width: double.infinity),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: SquareShimmer(height: 50, width: double.infinity),
                  ),
                  SquareShimmer(height: 75, width: double.infinity),
                ],
              )
            : RefreshIndicator(
                onRefresh: () => userProvider.updateAddedBanks(),
                child: Column(
                  children: [
                    bankList.isEmpty
                        ? CustomEmptyState(
                            imgHeight: 0,
                            imgWidth: 0,
                            title: "You are yet to add a bank accoount",
                            btnTitle: "Add new account",
                            onTap: () async {
                              await Navigator.pushNamed(
                                  context, RoutesManager.addBank);
                              setState(() {});
                            },
                          )
                        : Container(
                            padding:
                                EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
                            decoration: BoxDecoration(
                                color: ColorManager.kWhite,
                                borderRadius: BorderRadius.circular(20.r)),
                            child: Column(
                              children: [
                                ListView.separated(
                                  itemCount: bankList.length,
                                  controller: controller,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    if (index < (bankList.length)) {
                                      UserBank userBank = bankList[index];

                                      return BankCard(
                                        userBank: userBank,
                                        footer: (index == (bankList.length - 1))
                                            ? null
                                            : const SizedBox(
                                                width: 100, height: 10),
                                        onTap: () {},
                                        onDelete: () async {
                                          UserHelper.deleteSavedBank(
                                                  userBank.id)
                                              .then((msg) async {
                                            await userProvider
                                                .updateAddedBanks()
                                                .then((_) {})
                                                .catchError((_) {});
                                            await userProvider.updateUserInfo();
                                            if (mounted) {
                                              showCustomToast(
                                                context: context,
                                                description: msg,
                                                type: ToastType.success,
                                              );
                                            }
                                          }).catchError((msg) {
                                            showCustomToast(
                                                context: context,
                                                description: msg);
                                          });
                                        },
                                        header: (index == 0)
                                            ? null
                                            : const SizedBox(
                                                width: 100, height: 10),
                                      );
                                    }
                                  },
                                  separatorBuilder: (_, int i) =>
                                      const SizedBox(height: 10),
                                ),
                                CustomButton(
                                  text: "",
                                  isActive: true,
                                  onTap: () async {
                                    await Navigator.pushNamed(
                                        context, RoutesManager.addBank);
                                    setState(() {});
                                  },
                                  loading: false,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add,
                                          color: ColorManager.kWhite, size: 20),
                                      const SizedBox(width: 3),
                                      Text(
                                        "Add new account",
                                        style: get14TextStyle().copyWith(
                                            color: ColorManager.kWhite,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                    Gap(20.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 24.h),
                      decoration: BoxDecoration(
                          color: ColorManager.kWhite,
                          borderRadius: BorderRadius.circular(20.r)),
                      child: Column(
                        spacing: 20.h,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Why Add Your Bank Info?',
                            style: get20TextStyle()
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          Column(
                            spacing: 12.h,
                            children: [
                              BankInfoReasonContainer(firstText: 'Secure Payments', secondText: 'Receive your earnings directly to your bank with complete safety.'),
                              BankInfoReasonContainer(firstText: 'Fast & Automatic Transfers', secondText: 'Enjoy quick, hassle-free payouts without delays.'),
                              BankInfoReasonContainer(firstText: 'Encrypted & Protected', secondText: 'Your banking information stays 100% secure and confidential.'),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

class BankInfoReasonContainer extends StatelessWidget {
  const BankInfoReasonContainer({super.key, required this.firstText, required this.secondText});

  final String firstText;
  final String secondText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: ColorManager.kGreyColor.withValues(alpha: .08)))),
      child: Row(
        spacing: 8,
        children: [
          Icon(
            Icons.check_circle,
            color: ColorManager.kGreen,
          ),
          Flexible(
            child: RichText(
                text: TextSpan(
                    text: '$firstText – ',
                    style:
                        get14TextStyle().copyWith(fontWeight: FontWeight.w600),
                    children: [
                  TextSpan(
                      text: secondText,
                      style: get14TextStyle())
                ])),
          )
        ],
      ),
    );
  }
}
