import 'dart:async';

import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_scaffold.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../../misc/image_manager/image_manager.dart';

class Activate2FA extends StatefulWidget {
  const Activate2FA({super.key});

  @override
  State<Activate2FA> createState() => _Activate2FAState();
}

class _Activate2FAState extends State<Activate2FA> {
  final spacer = const SizedBox(height: 30);

  final _formKey = GlobalKey<FormState>();
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: ColorManager.kPrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 15),
                            child: const BackIcon(),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Image.asset(ImageManager.kActivateLogin2FA,
                                  width: 43),
                              const SizedBox(height: 10),
                              Text("Activate Login 2FA",
                                  textAlign: TextAlign.center,
                                  style: get18TextStyle()),
                            ],
                          ),
                        ),
                        const Expanded(flex: 1, child: SizedBox()),
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
                        "Kindly input the OTP that has been sent to rahmon*****@gmail.com",
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
                              length: 4,
                              obscureText: false,
                              animationType: AnimationType.fade,
                              pinTheme: getPinTheme(),
                              cursorColor: ColorManager.kFormHintText,
                              cursorWidth: 1.5,
                              cursorHeight: 20,
                              animationDuration:
                                  const Duration(milliseconds: 50),
                              enableActiveFill: true,
                              // errorAnimationController: errorController,
                              // controller: textEditingController,
                              keyboardType: TextInputType.number,
                              onCompleted: (_) {},
                              onChanged: (_) => setState(() {}),
                              beforeTextPaste: (_) => true,
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                          ),
                          const SizedBox(height: 10),

                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: get12TextStyle(),
                              children: [
                                const TextSpan(text: "Didn’t receive a code? "),
                                TextSpan(
                                  text: "Resend",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: ColorManager.kPrimary,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {},
                                )
                              ],
                            ),
                          ),

                          //
                          spacer,
                          spacer,
                          spacer,
                          CustomButton(
                              text: "Proceed",
                              isActive: true,
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RoutesManager.passwordReset3);
                              },
                              loading: false),
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
    );
  }

  //

  //
}
