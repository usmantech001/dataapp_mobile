import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_empty_state.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_scaffold.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
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

    return CustomScaffold(
      backgroundColor: ColorManager.kPrimary,
      body: SafeArea(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.only(left: 15),
                      alignment: Alignment.centerLeft,
                      child: const BackIcon(),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          padding: EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              color: ColorManager.kPrimaryLight,
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                  image: AssetImage(
                                      Assets.images.kBankSettingIcon.path))),
                        ),
                        //
                        Text(
                          "Bank Information",
                          textAlign: TextAlign.center,
                          style: get18TextStyle(),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(flex: 1, child: SizedBox()),
                ],
              ),

              //

              //
              customDivider(
                height: 1,
                margin: const EdgeInsets.only(top: 16),
                color: ColorManager.kBar2Color,
              ),

              Expanded(
                child: loading
                    ? ListView(
                        padding:
                            const EdgeInsets.only(top: 27, left: 20, right: 20),
                        children: const [
                          SquareShimmer(height: 75, width: double.infinity),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: SquareShimmer(
                                height: 50, width: double.infinity),
                          ),
                          SquareShimmer(height: 75, width: double.infinity),
                        ],
                      )
                    : RefreshIndicator(
                        onRefresh: () => userProvider.updateAddedBanks(),
                        child: bankList.isEmpty
                            ? ListView(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 55),
                                children: [
                                  CustomEmptyState(
                                    imgHeight: 0,
                                    imgWidth: 0,
                                    title: "You are yet to add a bank accoount",
                                    btnTitle: "Add new account",
                                    onTap: () async {
                                      await Navigator.pushNamed(
                                          context, RoutesManager.addBank);
                                      setState(() {});
                                    },
                                  ),
                                ],
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, top: 26),
                                itemCount: bankList.length + 1,
                                controller: controller,
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
                                        UserHelper.deleteSavedBank(userBank.id)
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

                                  return Center(
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 25),
                                      alignment: Alignment.center,
                                      width: 187,
                                      child: CustomButton(
                                        text: "",
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.add,
                                                color: ColorManager.kWhite,
                                                size: 20),
                                            const SizedBox(width: 3),
                                            Text(
                                              "Add new account",
                                              style: get14TextStyle().copyWith(
                                                  color: ColorManager.kWhite,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        isActive: true,
                                        onTap: () async {
                                          await Navigator.pushNamed(
                                              context, RoutesManager.addBank);
                                          setState(() {});
                                        },
                                        loading: false,
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (_, int i) =>
                                    const SizedBox(height: 10),
                              ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
