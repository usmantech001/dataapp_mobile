import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants.dart';
import '../../../../../core/enum.dart';
import '../../../../../core/helpers/user_helper.dart';
import '../../../../../core/model/core/bank.dart';
import '../../../../../core/providers/user_provider.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../../misc/custom_components/custom_btn.dart';
import '../../../../misc/custom_components/custom_elements.dart';
import '../../../../misc/custom_components/custom_input_field.dart';
import '../../../../misc/custom_components/custom_scaffold.dart';
import '../../../../misc/custom_components/select_bank.dart';
import '../../../../misc/custom_snackbar.dart';
import '../../../../misc/style_manager/styles_manager.dart';

class AddBank extends StatefulWidget {
  const AddBank({super.key});

  @override
  State<AddBank> createState() => _AddBankState();
}

class _AddBankState extends State<AddBank> {
  final spacer = const SizedBox(height: 40);

  final TextEditingController bankController = TextEditingController();
  final TextEditingController accountNoController = TextEditingController();
  final TextEditingController accNameController = TextEditingController();
  final ScrollController controller = ScrollController();
  Bank? selectedBank;

  bool verified = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

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
                      child: Text(
                        "Add Bank Account",
                        textAlign: TextAlign.center,
                        style: get18TextStyle(),
                      ),
                    ),
                    const Expanded(flex: 1, child: SizedBox()),
                  ],
                ),

                //

                //
                customDivider(
                  height: 1,
                  margin: const EdgeInsets.only(top: 16, bottom: 55),
                  color: ColorManager.kBar2Color,
                ),

                Expanded(
                  child: ListView(
                    controller: controller,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () async {
                          if (loading == true) return;
                          Bank? res = await showCustomBottomSheet(
                              context: context, screen: const SelectBank());
                          if (res != null) {
                            selectedBank = res;
                            accNameController.text = "";
                            verified = false;
                            setState(() {});
                          }
                        },
                        child: IgnorePointer(
                          child: CustomInputField(
                            formHolderName: "Bank Name",
                            hintText: "",
                            textInputAction: TextInputAction.next,
                            textEditingController:
                                TextEditingController(text: selectedBank?.name),
                            suffixIcon: Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: ColorManager.kFormHintText,
                            ),
                          ),
                        ),
                      ),
                      spacer,

                      CustomInputField(
                        formHolderName: "Bank Account Number",
                        hintText: "",
                        textInputAction: TextInputAction.next,
                        textEditingController: accountNoController,
                        textInputType: TextInputType.number,
                        maxLength: 10,
                        counterText: "",
                        onChanged: (e) {
                          accNameController.text = "";
                          verified = false;
                          setState(() {});
                          if (e.length == 10 && selectedBank != null) {
                            verifyBankInfo().then((_) {}).catchError((_) {});
                          }
                        },
                        validator: (val) => val!.isEmpty
                            ? "Account Number cannot be empty !!"
                            : null,
                      ),
                      spacer,

                      if (accNameController.text.isNotEmpty)
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14.5, vertical: 7.5),
                              decoration: BoxDecoration(
                                color: ColorManager.kPrimaryLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "Attached Name: ${accNameController.text}",
                                style: get12TextStyle().copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: ColorManager.kPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 85),

                      CustomButton(
                        text: "Save Account",
                        isActive: enableCreateBtn(
                            field1: selectedBank?.name ?? "",
                            field2: accountNoController.text,
                            field3: accNameController.text),
                        onTap: () async {
                          //
                          try {
                            if (!verified) {
                              await verifyBankInfo();
                              return;
                            }

                            //
                            setState(() => loading = true);

                            String msg = "";

                            msg = await UserHelper.saveBankInfo(
                              bank_id: selectedBank?.id ?? "",
                              account_number: accountNoController.text,
                              account_name: accNameController.text,
                            );
                            await userProvider.updateUserInfo();
                            await userProvider
                                .updateAddedBanks()
                                .then((_) {})
                                .catchError((_) {});

                            if (mounted) {
                              showCustomToast(
                                  context: context,
                                  description: msg,
                                  type: ToastType.success);
                              Future.delayed(Constants.kDefaultToatDelay,
                                  () => Navigator.pop(context));
                            }
                          } catch (e) {
                            if (mounted) {
                              showCustomToast(
                                  context: context,
                                  description: "$e",
                                  type: ToastType.error);
                              setState(() => loading = false);
                            }
                          }
                          //
                        },
                        loading: loading,
                      ),
                      //
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

  //

  bool enableCreateBtn(
      {required String field1,
      required String field2,
      required String field3}) {
    return field1.isNotEmpty && field2.isNotEmpty && field3.isNotEmpty;
  }

  Future<void> verifyBankInfo() async {
    setState(() => loading = true);
    accNameController.text = await UserHelper.verifyBankInfo(
      bank_id: selectedBank?.id ?? "",
      account_number: accountNoController.text,
    ).then((value) => value).catchError((e) {
      if (mounted) {
        showCustomToast(context: context, description: "$e");
        setState(() => loading = false);
      }
    });

    loading = false;
    verified = true;
    if (mounted) setState(() {});
  }
}
