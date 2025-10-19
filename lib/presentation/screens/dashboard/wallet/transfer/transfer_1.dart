import 'dart:async';

import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/core/model/core/user.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_check_confirmed.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_progress.dart';
import 'package:flutter/material.dart';

import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../misc/custom_components/custom_elements.dart';
import '../../../../misc/custom_components/custom_input_field.dart';
import '../../../../misc/custom_components/custom_scaffold.dart';
import '../../../../misc/custom_snackbar.dart';
import '../../../../misc/route_manager/routes_manager.dart';
import '../../../../misc/style_manager/styles_manager.dart';

class Transfer1 extends StatefulWidget {
  const Transfer1({super.key});

  @override
  State<Transfer1> createState() => _Transfer1State();
}

class _Transfer1State extends State<Transfer1> {
  final spacer = const SizedBox(height: 40);

  TextEditingController beneficiaryController = TextEditingController(text: "");
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    
    return CustomScaffold(
      backgroundColor: ColorManager.kPrimary,
      body: SafeArea(
        bottom: false,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
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
                          "Wallet Transfer",
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
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    controller: controller,
                    children: [
                      //
                      CustomInputField(
                        formHolderName: "Receiver username, email or phone number",
                        hintText: "@username, email or phone number",
                        textEditingController: beneficiaryController,
                        textInputAction: TextInputAction.done,
                        onChanged: (e) => startSearch(e),
                      ),
                      SizedBox(
                          height: (verifyingInfo || verifiedUser != null)
                              ? 10
                              : 40),
                      if (verifyingInfo)
                        Row(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, top: 3, bottom: 7),
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        ColorManager.kPrimary),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                      if (verifiedUser != null)
                        Row(
                          children: [
                            CustomCheckConfirmed(
                              text:
                                  "Attached Name: ${verifiedUser?.firstname} ${verifiedUser?.lastname}",
                              showCheck: false,
                            )
                          ],
                        ),

                      /// 07080625000
                      const SizedBox(height: 55),
                      CustomButton(
                        text: "Proceed",
                        isActive: true,
                        onTap: () async {
                          if (verifyingInfo || verifiedUser == null) {
                            showCustomToast(
                              context: context,
                              description: "Please enter a valid recipient",
                            );
                            return;
                          }

                          Navigator.pushNamed(context, RoutesManager.transfer2,
                              arguments: verifiedUser);
                        },
                        loading: false,
                      ),
                      const SizedBox(height: 65),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  User? verifiedUser;
  bool verifyingInfo = false;

  Timer? timer;
  Future<void> startSearch(String arg) async {
    verifiedUser = null;
    setState(() {});
    if (arg.isEmpty) return;
    if (mounted) setState(() => verifyingInfo = true);
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 750), () async {
      await verifyInfo(arg).then((_) {}).catchError((_) {});
      verifyingInfo = false;
      if (mounted) setState(() {});
    });
  }

  Future<void> verifyInfo(String arg) async {
    setState(() => verifyingInfo = true);
    verifiedUser =
        await ServicesHelper.verifyInAppTransferBeneficiaryDetails(arg)
            .then((value) => value)
            .catchError((e) {
      if (mounted) showCustomToast(context: context, description: "$e");
    });

    verifyingInfo = false;
    if (mounted) setState(() {});
  }
}
