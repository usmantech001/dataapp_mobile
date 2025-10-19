import 'dart:async';

import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_scaffold.dart';
import 'package:dataplug/presentation/misc/custom_components/loading.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:dataplug/presentation/screens/auth/password_reset/misc/password_reset_3_arg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    setState(() => requestOtpLoading = true);

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

    setState(() => requestOtpLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: ColorManager.kPrimaryLight,
      body: SafeArea(
        bottom: false,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: ColorManager.kPrimaryLight,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Assets.images.dataplugLogoText.image(width: 150, height: 30),
                    
                      customDivider(
                    height: 1,
                    margin: const EdgeInsets.only(top: 16, bottom: 20),
                    color: ColorManager.kPrimary.withOpacity(.1),
                  ),
                      Text(
                        widget.param.emailVerificationType ==
                                EmailVerificationType.passordReset
                            ? "Reset Password"
                            : "Sign Up ",
                        textAlign: TextAlign.left,
                        style: get18TextStyle().copyWith(fontSize: 16.5),
                      ),
                    ],
                  ),
                ),
              ),
              //

              //
              Expanded(
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
                          const Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: BackIcon(),
                            ),
                          ),
                          Expanded(
                              flex: 2,
                              child: Text("Verify your Email",
                                  textAlign: TextAlign.center,
                                  style: get16TextStyle())),
                          const Flexible(flex: 1, child: SizedBox()),
                        ],
                      ),
                      customDivider(
                        height: 1,
                        margin: const EdgeInsets.only(top: 16, bottom: 26),
                        color: ColorManager.kPrimary.withOpacity(.1),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Text(
                          "Kindly input the OTP that has been sent to\n${widget.param.user.email}",
                          textAlign: TextAlign.center,
                          style: get14TextStyle().copyWith(),
                        ),
                      ),
                      //

                      const SizedBox(height: 32),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          children: [
                            Form(
                              key: _formKey,
                              child: PinCodeTextField(
                                appContext: context,
                                length: 6,
                                obscureText: false,
                                animationType: AnimationType.fade,
                                pinTheme: getPinTheme(),
                                cursorColor: ColorManager.kFormHintText,
                                cursorWidth: 1.5,
                                cursorHeight: 20,
                                animationDuration:
                                    const Duration(milliseconds: 50),
                                enableActiveFill: true,
                                errorAnimationController: errorController,
                                controller: textEditingController,
                                keyboardType: TextInputType.number,
                                onCompleted: (_) {},
                                onChanged: (_) => setState(() {}),
                                beforeTextPaste: (_) => true,
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                          "Resend",
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
                                    setState(() => loading = true);
                                    await confirmSignUpOtp(
                                        textEditingController.text);
                                    setState(() => loading = false);
                                  }

                                  if (widget.param.emailVerificationType ==
                                      EmailVerificationType.passordReset) {
                                    setState(() => loading = true);
                                    await verifyPasswordResetOtp(
                                        textEditingController.text);
                                    setState(() => loading = false);
                                  }

                                  if (widget.param.emailVerificationType ==
                                      EmailVerificationType.login) {
                                    setState(() => loading = true);
                                    await confirmLoginOtp();
                                    setState(() => loading = false);
                                  }

                                  if (widget.param.emailVerificationType ==
                                      EmailVerificationType.twoFA) {
                                    setState(() => loading = true);
                                    await confirm2FAOtp();
                                    setState(() => loading = false);
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
                                loading: loading),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //

  bool loading = false;
  Future<void> confirmSignUpOtp(String code) async {
    await AuthHelper.verifyEmail(code: code, token: widget.param.token)
        .then((msg) async {
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
    String email = widget.param.user.email ?? "";
    await AuthHelper.verifyPasswordResetOtp(email: email, token: code)
        .then((msg) async {
      showCustomToast(
          context: context, description: msg, type: ToastType.success);

      Navigator.pushNamed(context, RoutesManager.passwordReset3,
          arguments: PasswordReset3Arg(email: email, otp: code));

      //
    }).catchError((e) {
      showCustomToast(context: context, description: e.toString());
    });
  }

  Future<void> confirm2FAOtp() async {
    await AuthHelper.completeTwoFa(
      code: textEditingController.text,
      email: widget.param.user.email ?? "",
      password: widget.param.password ?? "",
    ).then((user) async {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      userProvider.updateUser(user);
      Navigator.pushNamedAndRemoveUntil(context, RoutesManager.dashboardWrapper,
          (Route<dynamic> route) => false);
    }).catchError((e) {
      showCustomToast(
          context: context, description: e.toString(), type: ToastType.error);
    });
  }

  Future<void> confirmLoginOtp() async {
    await AuthHelper.verifyEmail(
            code: textEditingController.text, token: widget.param.token)
        .then((msg) async {
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
      showCustomToast(
          context: context, description: e.toString(), type: ToastType.error);
    });
  }
}
