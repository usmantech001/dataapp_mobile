import 'package:dataplug/core/providers/bank_controller.dart';
import 'package:dataplug/core/utils/app-loader.dart';
import 'package:dataplug/core/utils/custom_bottom_sheet.dart';
import 'package:dataplug/core/utils/custom_verifying.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../../../core/enum.dart';
import '../../../../../core/helpers/user_helper.dart';
import '../../../../../core/model/core/bank.dart';
import '../../../../../core/providers/user_provider.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../../misc/custom_components/custom_btn.dart';
import '../../../../misc/custom_components/custom_input_field.dart';
import '../../../../misc/custom_components/select_bank.dart';
import '../../../../misc/custom_snackbar.dart';
import '../../../../misc/style_manager/styles_manager.dart';

class AddBank extends StatefulWidget {
  const AddBank({super.key});

  @override
  State<AddBank> createState() => _AddBankState();
}

class _AddBankState extends State<AddBank> {

   @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<BankController>();
      controller.clearData();
    });
    super.initState();
  }
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: CustomAppbar(title: 'Add Bank Account'),
      body: Consumer<BankController>(builder: (context, controller, child) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 24.h),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              decoration: BoxDecoration(
                  color: ColorManager.kWhite,
                  borderRadius: BorderRadius.circular(16.r)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      await showCustomBottomSheet(
                          context: context, screen: const SelectBank());
                    },
                    child: IgnorePointer(
                      child: CustomInputField(
                        formHolderName: "Bank Name",
                        hintText: "",
                        textInputAction: TextInputAction.next,
                        textEditingController: TextEditingController(
                            text: controller.selectedBank?.name),
                        suffixIcon: Icon(
                          Icons.keyboard_arrow_down_sharp,
                          color: ColorManager.kFormHintText,
                        ),
                      ),
                    ),
                  ),
                  Gap(16.h),

                  CustomInputField(
                    formHolderName: "Bank Account Number",
                    hintText: "",
                    textInputAction: TextInputAction.next,
                    textEditingController: controller.accountNumberController,
                    textInputType: TextInputType.number,
                    maxLength: 10,
                    counterText: "",
                    focusNode: controller.focusNode,
                    // onChanged: (e) {
                    //   accNameController.text = "";
                    //   verified = false;
                    //   setState(() {});
                    //   if (e.length == 10 && selectedBank != null) {
                    //     verifyBankInfo().then((_) {}).catchError((_) {});
                    //   }
                    // },
                    // validator: (val) =>
                    //     val!.isEmpty ? "Account Number cannot be empty !!" : null,
                  ),
                  if (controller.verifyingBankInfo)
                    CustomVerifying(text: 'Verifying bank info'),
                  controller.bankInfoErrMsg != null
                      ? Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            controller.bankInfoErrMsg!,
                            style: get12TextStyle().copyWith(
                              color: ColorManager.kError,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : controller.attachedBankName != null
                          ? Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                spacing: 8.w,
                                children: [
                                  Container(
                                      height: 20.h,
                                      width: 20.w,
                                      //padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: ColorManager.kGreen,
                                        borderRadius:
                                            BorderRadiusGeometry.circular(6.r),
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        color: ColorManager.kWhite,
                                        size: 20,
                                      )),
                                  Text(
                                    controller.attachedBankName!,
                                    style: get12TextStyle().copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: ColorManager.kGreen,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox.shrink(),

                  Gap(24.h),

                  CustomButton(
                    text: "Save Account",
                    isActive: true,
                    onTap: () async {
                      if(controller.bankInfoErrMsg!=null){
                        showCustomToast(context: context, description: 'Please enter a valid account number');
                        return;
                      }
                      displayLoader(context);
                      controller.saveBankInfo(
                        onSuccess: (p0) {
                          popScreen();
                          showCustomMessageBottomSheet(context: context, title: 'Bank Account Added Successfully', description: 'Your bank account has been linked to your wallet. You can now make deposits and withdrawals anytime.', onTap: (){
                            removeUntilAndPushScreen(RoutesManager.addedBanks, RoutesManager.bottomNav);
                          });
                        },
                        onError: (error) {
                          popScreen();
                          showCustomMessageBottomSheet(context: context, title: 'Bank Account Linking Failed', description: error, onTap: (){
                            popScreen();
                          });
                        },
                      );
                    },
                    loading: false,
                  ),
                  //
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  //
  bool enableCreateBtn(
      {required String field1,
      required String field2,
      required String field3}) {
    return field1.isNotEmpty && field2.isNotEmpty && field3.isNotEmpty;
  }
}
