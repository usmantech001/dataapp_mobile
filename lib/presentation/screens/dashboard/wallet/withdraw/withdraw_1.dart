import 'package:dataplug/core/constants.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_progress.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_small_btn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/model/core/user_bank.dart';
import '../../../../../core/providers/user_provider.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../misc/custom_components/custom_elements.dart';
import '../../../../misc/custom_components/custom_scaffold.dart';
import '../../../../misc/custom_components/loading.dart';
import '../../../../misc/custom_snackbar.dart';
import '../../../../misc/route_manager/routes_manager.dart';
import '../../../../misc/style_manager/styles_manager.dart';
import '../../settings/bank/misc/bank_card.dart';

class Withdraw1 extends StatefulWidget {
  const Withdraw1({super.key});

  @override
  State<Withdraw1> createState() => _Withdraw1State();
}

class _Withdraw1State extends State<Withdraw1> {
  final spacer = const SizedBox(height: 40);

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
      await userProvider.updateAddedBanks().then((_) {
        setState(() => loading = false);
      }).catchError((_) {
        showCustomToast(
            context: context,
            description: "An error occured, please retry again.");
        setState(() => loading = false);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<UserBank> userBanks = Provider.of<UserProvider>(context).savedBanks;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.only(left: 15),
                      alignment: Alignment.topLeft,
                      child: const BackIcon(),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        "Select Bank Account",
                        textAlign: TextAlign.center,
                        style: get18TextStyle(),
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: CustomProgress(value: 1, valuePerct: .4),
                    ),
                  ),
                ],
              ),

              //

              //
              customDivider(
                height: 1,
                margin: const EdgeInsets.only(top: 16, bottom: 30),
                color: ColorManager.kBar2Color,
              ),

              Expanded(
                child: loading
                    ? buildLoading(wrapWithExpanded: false)
                    : ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigator.pushNamed(
                              //     context, RoutesManager.withdraw2);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: Constants.kHorizontalScreenPadding,
                                right: Constants.kHorizontalScreenPadding,
                                bottom: 22,
                              ),
                              child: Text(
                                "Kindly select your preferred withdrawal account",
                                textAlign: TextAlign.left,
                                style: get14TextStyle().copyWith(
                                  color: ColorManager.kTextDark7,
                                ),
                              ),
                            ),
                          ),
                          for (int i = 0; i < userBanks.length; i++)
                            BankCard(
                              footer: const SizedBox(width: 100, height: 10),
                              header: null,
                              showDelete: false,
                              showNextArrow: true,
                              showBankIcon: true,
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RoutesManager.withdraw2,
                                    arguments: userBanks[i]);
                              },
                              userBank: userBanks[i],
                            ),
                          const SizedBox(height: 40),
                          Center(
                            child: SizedBox(
                                width: 187,
                                child: CustomSmallBtn(
                                  text: "+ Add new account",
                                  isActive: true,
                                  onTap: () async {
                                    await Navigator.pushNamed(
                                        context, RoutesManager.addBank);
                                    setState(() {});
                                  },
                                  loading: false,
                                  borderColor: ColorManager.kPrimaryLight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add,
                                          color: ColorManager.k267E9B,
                                          size: 20),
                                      const SizedBox(width: 3),
                                      Text(
                                        "Add new account",
                                        style: get14TextStyle().copyWith(
                                          color: ColorManager.k267E9B,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
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
