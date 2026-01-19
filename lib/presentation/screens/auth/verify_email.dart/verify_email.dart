import 'dart:async';

import 'package:dataplug/core/utils/app-loader.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/custom_components/loading.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:dataplug/presentation/screens/auth/password_reset/misc/password_reset_3_arg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../../../core/enum.dart';
import '../../../../core/helpers/auth_helper.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../gen/assets.gen.dart';
import '../../../misc/custom_components/custom_back_icon.dart';
import '../../../misc/custom_snackbar.dart';
import 'misc/verify_email_arg.dart';

class VerifyEmail extends StatefulWidget {
  final VerifyEmailArg param;

  const VerifyEmail({super.key, required this.param});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final spacer = const SizedBox(height: 30);

  final _formKey = GlobalKey<FormState>();
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  TextEditingController textEditingController = TextEditingController();

  //
  bool requestOtpLoading = false;
  Future<void> sendOtp() async {
    //setState(() => requestOtpLoading = true);
    displayLoader(context);

    try {
      String msg = "";

      if (widget.param.emailVerificationType == EmailVerificationType.twoFA) {
        msg =
            await AuthHelper.resend2FAOtp(email: widget.param.user.email ?? "");
      } else if (widget.param.emailVerificationType ==
          EmailVerificationType.pinUpdate) {
        // msg = await AuthHelper.sendPinResetOtp();
      } else if (widget.param.emailVerificationType ==
          EmailVerificationType.passordReset) {
        msg = await AuthHelper.resendPasswordResetOtp(
            email: widget.param.user.email ?? "");
      } else {
        msg = await AuthHelper.resendOtp(token: widget.param.token);
      }

      // ignore: use_build_context_synchronously
      showCustomToast(
          context: context, description: msg, type: ToastType.success);
    } catch (err) {
      showCustomToast(
          context: context, description: err.toString(), type: ToastType.error);
    }

   // setState(() => requestOtpLoading = false);
   popScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.kWhite,
      appBar: CustomAppbar(title: '', hasLogo: true,),
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
                //
            
                //
                Gap(12),
                Text(
                  "We have sent a verification code to",
                  textAlign: TextAlign.center,
                  style: get14TextStyle().copyWith(),
                ),
                Text(
                  "${widget.param.user.email}",
                  textAlign: TextAlign.center,
                  style: get14TextStyle().copyWith(fontWeight: FontWeight.w700),
                  
                ),
                //
                          
                Gap(32.h),
                Column(
                            
                  children: [
                    Form(
                      key: _formKey,
                      child: PinCodeTextField(
                        appContext: context,
                        length: 6,
                        obscureText: false,
                        animationType: AnimationType.fade,
                        pinTheme: getPinTheme(),
                        cursorColor: ColorManager.kPrimary,
                        cursorWidth: 1.5,
                        cursorHeight: 20,
                        textStyle: get18TextStyle().copyWith(fontWeight: FontWeight.w500),
                        animationDuration:
                            const Duration(milliseconds: 50),
                        enableActiveFill: true,
                        errorAnimationController: errorController,
                        controller: textEditingController,
                        keyboardType: TextInputType.number,
                        onCompleted: (_) {},
                        onChanged: (_) => setState(() {}),
                        beforeTextPaste: (_) => true,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
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
                        
                        requestOtpLoading
                            ? Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: buildLoader())
                            : GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () => sendOtp(),
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
                        
                    //
                    spacer,
                    spacer,
                    spacer,
                    CustomButton(
                        text: "Proceed",
                        isActive: true,
                        onTap: () async {
                          _formKey.currentState!.validate();
                          if (textEditingController.text.length != 6) {
                            errorController
                                .add(ErrorAnimationType.shake);
                            return;
                          }
                        
                          // print(
                          //     "widget.param.emailVerificationType ${widget.param.emailVerificationType}");
                        
                          if (widget.param.emailVerificationType ==
                              EmailVerificationType.signp) {
                            await confirmSignUpOtp(
                                textEditingController.text);
                          }
                        
                          if (widget.param.emailVerificationType ==
                              EmailVerificationType.passordReset) {
                            
                            await verifyPasswordResetOtp(
                                textEditingController.text);
                          }
                        
                          if (widget.param.emailVerificationType ==
                              EmailVerificationType.login) {
                              
                            await confirmLoginOtp();
                          }
                        
                          if (widget.param.emailVerificationType ==
                              EmailVerificationType.twoFA) {
                        
                            await confirm2FAOtp();
                          }
                        
                          // if (widget.param.emailVerificationType ==
                          //     EmailVerificationType.pinUpdate) {
                          //   setState(() => loading = true);
                          //   await confirmPinUpdateOtp();
                          //   setState(() => loading = false);
                          // }
                        
                          // Navigator.pushNamed(
                          //     context, RoutesManager.dashboardWrapper);
                          // // Navigator.pushNamedAndRemoveUntil(
                          // //     context,
                          // //     RoutesManager.dashboardWrapper,
                          // //     (Route<dynamic> route) => false);
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

  //

  bool loading = false;
  Future<void> confirmSignUpOtp(String code) async {
    displayLoader(context);
    await AuthHelper.verifyEmail(code: code, token: widget.param.token)
        .then((msg) async {
          popScreen();
      showCustomToast(
          context: context, description: msg, type: ToastType.success);
      Future.delayed(const Duration(milliseconds: 1000), () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, RoutesManager.signIn);
      });
    }).catchError((e) {
      showCustomToast(context: context, description: e.toString());
    });
  }

  Future<void> verifyPasswordResetOtp(String code) async {
    displayLoader(context);
    String email = widget.param.user.email ?? "";
    await AuthHelper.verifyPasswordResetOtp(email: email, token: code)
        .then((msg) async {
          popScreen();
      showCustomToast(
          context: context, description: msg, type: ToastType.success);

      Navigator.pushNamed(context, RoutesManager.passwordReset3,
          arguments: PasswordReset3Arg(email: email, otp: code));

      //
    }).catchError((e) {
      popScreen();
      showCustomToast(context: context, description: e.toString());
    });
  }

  Future<void> confirm2FAOtp() async {
    displayLoader(context);
    await AuthHelper.completeTwoFa(
      code: textEditingController.text,
      email: widget.param.user.email ?? "",
      password: widget.param.password ?? "",
    ).then((user) async {
      popScreen();
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      userProvider.updateUser(user);
      Navigator.pushNamedAndRemoveUntil(context, RoutesManager.dashboardWrapper,
          (Route<dynamic> route) => false);
    }).catchError((e) {
      popScreen();
      showCustomToast(
          context: context, description: e.toString(), type: ToastType.error);
    });
  }

  Future<void> confirmLoginOtp() async {
    displayLoader(context);
    await AuthHelper.verifyEmail(
            code: textEditingController.text, token: widget.param.token)
        .then((msg) async {
          popScreen();
      showCustomToast(
          context: context, description: msg, type: ToastType.success);
      //
      if (widget.param.user.pin_activated == false) {
        Navigator.pushNamed(context, RoutesManager.setTransactionPin);
        return;
      }

      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      await userProvider.updateUserInfo();
      Navigator.pushNamedAndRemoveUntil(context, RoutesManager.dashboardWrapper,
          (Route<dynamic> route) => false);
    }).catchError((e) {
      popScreen();
      showCustomToast(
          context: context, description: e.toString(), type: ToastType.error);
    });
  }
}
