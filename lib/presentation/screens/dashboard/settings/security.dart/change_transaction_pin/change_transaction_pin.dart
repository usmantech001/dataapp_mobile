import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../../core/enum.dart';
import '../../../../../../core/helpers/auth_helper.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../../../misc/color_manager/color_manager.dart';
import '../../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../../misc/custom_components/custom_btn.dart';
import '../../../../../misc/custom_components/custom_elements.dart';
import '../../../../../misc/custom_components/custom_scaffold.dart';
import '../../../../../misc/custom_snackbar.dart';
import '../../../../../misc/image_manager/image_manager.dart';
import '../../../../../misc/style_manager/styles_manager.dart';

class ChangeTransactionPin extends StatefulWidget {
  const ChangeTransactionPin({super.key});

  @override
  State<ChangeTransactionPin> createState() => _ChangeTransactionPinState();
}

class _ChangeTransactionPinState extends State<ChangeTransactionPin> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();
  TextEditingController textEditingController3 = TextEditingController();

  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  StreamController<ErrorAnimationType> errorController2 =
      StreamController<ErrorAnimationType>();
  StreamController<ErrorAnimationType> errorController3 =
      StreamController<ErrorAnimationType>();
  ScrollController controller = ScrollController();

  @override
  void dispose() {
    errorController.close();
    errorController2.close();
    errorController3.close();
    controller.dispose();
    super.dispose();
  }

  bool loading = false;

  //
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomScaffold(
        backgroundColor: ColorManager.kPrimary,
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                  Image.asset(ImageManager.kTxnPinIcon,
                                      width: 43),
                                  const SizedBox(height: 10),
                                  Text("Change Transaction PIN",
                                      textAlign: TextAlign.center,
                                      style: get18TextStyle()),
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
                          margin: const EdgeInsets.only(top: 16, bottom: 26),
                          color: ColorManager.kBar2Color,
                        ),

                        Expanded(
                          child: ListView(
                            controller: controller,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 10, left: 15),
                                  child: Text("Enter Old PIN",
                                      style: get14TextStyle())),

                              PinCodeTextField(
                                appContext: context,
                                length: 4,
                                obscureText: false,
                                mainAxisAlignment: MainAxisAlignment.start,
                                animationType: AnimationType.fade,
                                pinTheme: getPinTheme(width: 70),
                                cursorColor: ColorManager.kFormHintText,
                                cursorWidth: 1.5,
                                cursorHeight: 20,                             
                                animationDuration:
                                    const Duration(milliseconds: 50),
                                enableActiveFill: true,
                                textInputAction: TextInputAction.next,
                                errorAnimationController: errorController,
                                controller: textEditingController,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {},
                                validator: (value) => Validator.validateField(
                                    fieldName: "Old PIN", input: value),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 25, bottom: 10, left: 15),
                                child: Text("Enter New PIN",
                                    style: get14TextStyle()),
                              ),

                              ////
                              PinCodeTextField(
                                appContext: context,
                                length: 4,
                                obscureText: false,
                                textInputAction: TextInputAction.next,
                                mainAxisAlignment: MainAxisAlignment.start,
                                animationType: AnimationType.fade,
                                validator: (value) => Validator.validateField(
                                    fieldName: "New PIN", input: value),
                                pinTheme: getPinTheme(width: 70),
                                cursorColor: ColorManager.kFormHintText,
                                cursorWidth: 1.5,
                                cursorHeight: 20,
                                animationDuration:
                                    const Duration(milliseconds: 50),
                                enableActiveFill: true,
                                errorAnimationController: errorController2,
                                controller: textEditingController2,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {},
                              ),

                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 25, bottom: 10, left: 15),
                                child: Text("Confirm New Pin",
                                    style: get14TextStyle()),
                              ),
                              PinCodeTextField(
                                appContext: context,
                                length: 4,
                                obscureText: false,
                                textInputAction: TextInputAction.done,
                                mainAxisAlignment: MainAxisAlignment.start,
                                animationType: AnimationType.fade,
                                validator: (value) =>
                                    Validator.doesPasswordMatch(
                                  confirmPassword: textEditingController2.text,
                                  password: value,
                                  fieldName: "Confirm Pin",
                                ),
                                pinTheme: getPinTheme(width: 70),
                                cursorColor: ColorManager.kFormHintText,
                                cursorWidth: 1.5,
                                cursorHeight: 20,
                                animationDuration:
                                    const Duration(milliseconds: 50),
                                enableActiveFill: true,
                                errorAnimationController: errorController3,
                                controller: textEditingController3,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {},
                              ),

                              //
                              const SizedBox(height: 54),
                              CustomButton(
                                text: "Proceed",
                                isActive: true,
                                onTap: () async {
                                  // if (!_formKey.currentState!.validate()) {
                                  //   return;
                                  // }

                                  if (textEditingController.text.length != 4) {
                                    errorController
                                        .add(ErrorAnimationType.shake);
                                    return;
                                  }

                                  if (textEditingController2.text.length != 4) {
                                    errorController2
                                        .add(ErrorAnimationType.shake);
                                    return;
                                  }

                                  if (textEditingController3.text.length != 4) {
                                    errorController3
                                        .add(ErrorAnimationType.shake);
                                    return;
                                  }

                                  setState(() => loading = true);
                                  await AuthHelper.updateTransactionPin(
                                          old_pin: textEditingController.text,
                                          new_pin: textEditingController2.text)
                                      .then((msg) async {
                                    showCustomToast(
                                        context: context,
                                        description: msg,
                                        type: ToastType.success);

                                    Navigator.pop(context);
                                  }).catchError((e) {
                                    showCustomToast(
                                        context: context,
                                        description: e.toString());
                                  });

                                  setState(() => loading = false);
                                },
                                loading: loading,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
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
