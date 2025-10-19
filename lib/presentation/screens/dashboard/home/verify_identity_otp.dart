import 'dart:async';

import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/enum.dart';
import '../../../misc/color_manager/color_manager.dart';
import '../../../misc/custom_components/custom_btn.dart';
import '../../../misc/custom_components/custom_elements.dart';
import '../../../misc/custom_components/custom_input_field.dart';
import '../../../misc/custom_snackbar.dart';
import '../../../misc/route_manager/routes_manager.dart';
import '../../../misc/style_manager/styles_manager.dart';

class VerifyBVNOTPView extends StatefulWidget {
  final String type;
  const VerifyBVNOTPView({
    super.key,
    required this.type,
  });

  @override
  State<VerifyBVNOTPView> createState() => _VerifyBVNOTPViewState();
}

class _VerifyBVNOTPViewState extends State<VerifyBVNOTPView> {
  ScrollController controller = ScrollController();

  final _formKey = GlobalKey<FormState>();
  bool loginLoading = false;

  Widget buildSpacer() => const SizedBox(height: 20);
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  TextEditingController bvnController = TextEditingController();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // if (widget.emailVerificationType == EmailVerificationType.login ||
      //     widget.emailVerificationType == EmailVerificationType.pinUpdate) {
      //   sendOtp();
      // }
    });
    super.initState();
  }

  bool requestOtpLoading = false;
  // Future<void> sendOtp() async {
  //   setState(() => requestOtpLoading = true);

  //   try {
  //     String msg = "";

  //     if (widget.emailVerificationType == EmailVerificationType.twoFA) {
  //       msg = await AuthHelper.resend2FAOtp(email: widget.user.email);
  //     } else if (widget.emailVerificationType ==
  //         EmailVerificationType.pinUpdate) {
  //       msg = await AuthHelper.sendPinResetOtp();
  //     } else {
  //       msg = await AuthHelper.resendOtp(token: widget.token);
  //     }

  //     // ignore: use_build_context_synchronously
  //     showCustomToast(
  //         context: context, description: msg, type: ToastType.success);
  //   } catch (err) {
  //     showCustomToast(
  //         context: context, description: err.toString(), type: ToastType.error);
  //   }

  //   setState(() => requestOtpLoading = false);
  // }

  @override
  void dispose() {
    try {
      controller.dispose();
      errorController.close();
      bvnController.dispose();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        // height: size.height * .8,
        padding: EdgeInsets.only(top: 60),
        color: ColorManager.kWhite,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              // customBar(margin: const EdgeInsets.only(bottom: 25, top: 10)),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 15),
              //   child: Row(
              //     children: [
              //       // GestureDetector(
              //       //   behavior: HitTestBehavior.translucent,
              //       //   onTap: () => Navigator.pop(context),
              //       //   child: Image.asset(ImageManager.kArrowBack, width: 30),
              //       // ),
              //       const SizedBox(width: 15),
              //       Text(
              //         "Verify Your BVN",
              //         style: get18TextStyle(),
              //       ),
              //     ],
              //   ),
              // ),

              Container(
                color: ColorManager.kWhite,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Gap(16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => Navigator.pop(context),
                          child: Icon(Icons.close),
                        ),
                        Flexible(
                          child: Text(
                            "Verify Your  ${widget.type.toLowerCase() == 'bvn' ? 'BVN' : 'NIN'}",
                            style: get18TextStyle().copyWith(
                              color: ColorManager.kBlack,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                      ],
                    ),
                    const SizedBox(height: 12)
                  ],
                ),
              ),
              customDivider(
                margin: const EdgeInsets.only(top: 15),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  controller: controller,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 70, bottom: 25),
                      child: Text(
                        "Kindly input the OTP that has been sent to your linked phone number",
                        textAlign: TextAlign.left,
                        style: get14TextStyle(),
                      ),
                    ),

                    Form(
                      key: _formKey,
                      child: CustomInputField(
                        formHolderName: "",
                        hintText: "Enter OTP to proceed",
                        textEditingController: bvnController,
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please enter OTP";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),

                    // const SizedBox(height: 60),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       "Didn’t get any code?",
                    //       style: get14TextStyle().copyWith(
                    //         color: ColorManager.kFadedTextColor,
                    //       ),
                    //     ),
                    //     const SizedBox(width: 8),
                    //     requestOtpLoading
                    //         ? SizedBox(
                    //             height: 12,
                    //             width: 12,
                    //             child: Center(
                    //               child: CircularProgressIndicator(
                    //                   strokeWidth: 1.0,
                    //                   valueColor: AlwaysStoppedAnimation<Color>(
                    //                       ColorManager.kPrimary)),
                    //             ),
                    //           )
                    //         : CustomTextBtn(
                    //             text: "Resend",
                    //             isActive: true,
                    //             onTap: () => sendOtp(),
                    //             loading: false,
                    //           )
                    //   ],
                    // ),

                    //
                    Padding(
                      padding: const EdgeInsets.only(top: 36, bottom: 30),
                      child: CustomButton(
                        text: "Proceed",
                        isActive: true,
                        onTap: () async {
                          _formKey.currentState!.validate();
                          if (bvnController.text.isEmpty) {
                            errorController.add(ErrorAnimationType.shake);
                            return;
                          }
                          setState(() => loading = true);
                          await ServicesHelper.validateIdentificationOTP(
                            otp: bvnController.text,
                            type: widget.type.toLowerCase(),
                          ).then((value) async {
                            print("object: $value");

                            showCustomToast(
                                context: context,
                                description: "BVN Verified successfully",
                                type: ToastType.success);
                            //                           await ServicesHelper.generateVirtualAccount()
                            //                               .then((value) {
                            //                             // print("object");

                            //                             showCustomToast(
                            //                                 context: context,
                            //                                 description:
                            //                                     "Virtual account generated successfully",
                            //                                 type: ToastType.success);
                            // //  Navigator.pop(context);
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              RoutesManager.dashboardWrapper,
                              (Route<dynamic> route) => false,
                            );

                            //   if (mounted) setState(() => loading = false);
                            //   // Navigator.pop(context);
                            // });

                            if (mounted) setState(() => loading = false);
                            // Navigator.pop(context);
                          }).catchError((error) {
                            if (mounted) setState(() => loading = false);
                            showCustomToast(
                                context: context,
                                description: "$error",
                                type: ToastType.error);
                          });

                          // if (widget.emailVerificationType ==
                          //     EmailVerificationType.signp) {
                          //   setState(() => loading = true);
                          //   await confirmSignUpOtp();
                          //   setState(() => loading = false);
                          // }

                          // if (widget.emailVerificationType ==
                          //     EmailVerificationType.login) {
                          //   setState(() => loading = true);
                          //   await confirmLoginOtp();
                          //   setState(() => loading = false);
                          // }

                          // if (widget.emailVerificationType ==
                          //     EmailVerificationType.twoFA) {
                          //   setState(() => loading = true);
                          //   await confirm2FAOtp();
                          //   setState(() => loading = false);
                          // }

                          // if (widget.emailVerificationType ==
                          //     EmailVerificationType.pinUpdate) {
                          //   setState(() => loading = true);
                          //   await confirmPinUpdateOtp();
                          //   setState(() => loading = false);
                          // }
                        },
                        loading: loading,
                      ),
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

  bool loading = false;
  // Future<void> confirmBVNOtp() async {
  //   await AuthHelper.verifyEmail(
  //           code: textEditingController.text, token: widget.token)
  //       .then((msg) async {
  //     showCustomToast(
  //         context: context, description: msg, type: ToastType.success);
  //     Future.delayed(const Duration(milliseconds: 1000), () {
  //       Navigator.pop(context);
  //       Navigator.pop(context);
  //     });
  //   }).catchError((e) {
  //     showCustomToast(
  //         context: context, description: e.toString(), type: ToastType.error);
  //   });
  // }

  // Future<void> confirmLoginOtp() async {
  //   await AuthHelper.verifyEmail(
  //           code: textEditingController.text, token: widget.token)
  //       .then((msg) async {
  //     showCustomToast(
  //         context: context, description: msg, type: ToastType.success);
  //     //
  //     if (widget.user.pin_activated == false) {
  //       showCustomBottomSheet(
  //           context: context, screen: const SetupTxnPinView());
  //       return;
  //     }

  //     UserProvider userProvider =
  //         Provider.of<UserProvider>(context, listen: false);
  //     await userProvider.updateUserInfo();
  //     Navigator.pushNamedAndRemoveUntil(context, RoutesManager.dashboardWrapper,
  //         (Route<dynamic> route) => false);
  //   }).catchError((e) {
  //     showCustomToast(
  //         context: context, description: e.toString(), type: ToastType.error);
  //   });
  // }

  // Future<void> confirm2FAOtp() async {
  //   await AuthHelper.completeTwoFa(
  //           code: textEditingController.text,
  //           email: widget.user.email,
  //           password: widget.password ?? "")
  //       .then((user) async {
  //     UserProvider userProvider =
  //         Provider.of<UserProvider>(context, listen: false);
  //     userProvider.updateUser(user);
  //     Navigator.pushNamedAndRemoveUntil(context, RoutesManager.dashboardWrapper,
  //         (Route<dynamic> route) => false);
  //   }).catchError((e) {
  //     showCustomToast(
  //         context: context, description: e.toString(), type: ToastType.error);
  //   });
  // }

  // Future<void> confirmPinUpdateOtp() async {
  //   await AuthHelper.verifyPinResetOtp(textEditingController.text)
  //       .then((msg) async {
  //     showCustomToast(
  //         context: context, description: msg, type: ToastType.success);
  //     showCustomBottomSheet(
  //         context: context,
  //         enableDrag: true,
  //         screen: TxnPinUpdateView(code: textEditingController.text));
  //   }).catchError((e) {
  //     showCustomToast(
  //         context: context, description: e.toString(), type: ToastType.error);
  //   });
  // }
}
