import 'package:dataplug/core/enum.dart';
import 'package:dataplug/core/providers/wallet_controller.dart';
import 'package:dataplug/core/utils/app-loader.dart';
import 'package:dataplug/core/utils/custom_bottom_sheet.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_snackbar.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class VerifyBvnOtpScreen extends StatefulWidget {
  const VerifyBvnOtpScreen({
    super.key,
  });

  @override
  State<VerifyBvnOtpScreen> createState() => _VerifyBvnOtpScreenState();
}

class _VerifyBvnOtpScreenState extends State<VerifyBvnOtpScreen> {
  final spacer = const SizedBox(height: 30);

  TextEditingController textEditingController = TextEditingController();

  //

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<WalletController>().requestSafeHavenOtp();
  }

  @override
  Widget build(BuildContext context) {
   final walletController = context.read<WalletController>();
    return Scaffold(
      backgroundColor: ColorManager.kWhite,
      appBar: CustomAppbar(
        title: '',
        hasLogo: true,
      ),
      body: SafeArea(
        bottom: false,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Enter verification code",
                      textAlign: TextAlign.center,
                      style: get24TextStyle().copyWith(),
                    ),
                  ],
                ),
                Gap(12),
                Text(
                  "We have sent a verification code to the number attached to your BVN",
                  textAlign: TextAlign.center,
                  style: get14TextStyle().copyWith(),
                ),
                Gap(32.h),
                Column(
                  children: [
                    PinCodeTextField(
                      appContext: context,
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: getPinTheme(),
                      cursorColor: ColorManager.kPrimary,
                      cursorWidth: 1.5,
                      cursorHeight: 20,
                      textStyle: get18TextStyle()
                          .copyWith(fontWeight: FontWeight.w500),
                      animationDuration: const Duration(milliseconds: 50),
                      enableActiveFill: true,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      onCompleted: (_) {},
                      //onChanged: (_) => setState(() {}),
                      beforeTextPaste: (_) => true,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    const SizedBox(height: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 12.h,
                      children: [
                        Text(
                          "Didn’t receive a code? ",
                          style: get12TextStyle(),
                        ),

                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            displayLoader(context);
                            context.read<WalletController>().requestSafeHavenOtp(onSuccess: (){
                              popScreen();
                              showCustomToast(context: context, description: 'OTP has been sent to the number attached to your BVN', type: ToastType.success);
                              return;
                            }, onError: (error) {
                              popScreen();
                              showCustomToast(context: context, description: error);
                            },);
                          },
                          child: Text(
                            "Resend New Code",
                            style: get12TextStyle().copyWith(
                              fontWeight: FontWeight.w500,
                              color: ColorManager.kPrimary,
                            ),
                          ),
                        ),
                        //

                        //
                      ],
                    ),
                    Gap(50.h),
                    CustomButton(
                        text: "Proceed",
                        isActive: true,
                        onTap: () async {
                          
                          if (textEditingController.text.length == 6) {
                            displayLoader(context);
                            context.read<WalletController>().validateIDOTP(
                                textEditingController.text,
                                onSuccess: () {
                                  showCustomMessageBottomSheet(
                              context: context,
                              title: 'ID Verified Successfully',
                              description:
                                  'Your ID have been verified successfully. You can now generate static accounts.',
                              onTap: () {
                                displayLoader(context);
                                walletController.generateStaticAccount(onSuccess: (){
                                  
                                  removeUntilAndPushScreen(RoutesManager.virtualAccounts, RoutesManager.bottomNav);
                                }, onError: (error) {
                                  popScreen();
                                  showCustomToast(context: context, description: error);
                                  
                                },);
                                 
                              });
                                }, onError: (error) {
                                  showCustomToast(
                                context: context,
                                description: error, type: ToastType.error);
                                },);
                          } else {
                            showCustomToast(
                                context: context,
                                description: 'Your OTP can\'t be less than 6');
                            return;
                          }
                        },
                        loading: false),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
