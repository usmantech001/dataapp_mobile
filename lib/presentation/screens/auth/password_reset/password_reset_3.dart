import 'dart:async';

import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_scaffold.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/enum.dart';
import '../../../../core/helpers/auth_helper.dart';
import '../../../../core/utils/validators.dart';
import '../../../misc/custom_components/custom_back_icon.dart';
import '../../../misc/custom_components/custom_input_field.dart';
import '../../../misc/custom_snackbar.dart';
import 'misc/password_reset_3_arg.dart';

class PasswordReset3 extends StatefulWidget {
  final PasswordReset3Arg param;
  const PasswordReset3({super.key, required this.param});

  @override
  State<PasswordReset3> createState() => _PasswordReset3State();
}

class _PasswordReset3State extends State<PasswordReset3> {
  final spacer = const SizedBox(height: 30);

  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPController = TextEditingController();
  ScrollController controller = ScrollController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    passController.dispose();
    confirmPController.dispose();
    controller.dispose();
    super.dispose();
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
                  child: Text(
                    "Reset Password",
                    textAlign: TextAlign.left,
                    style: get18TextStyle().copyWith(fontSize: 16.5),
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
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                child: Text("Set New Password",
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

                        //
                        Expanded(
                          child: ListView(
                            controller: controller,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            children: [
                              CustomInputField(
                                formHolderName: "New Password",
                                hintText: "Enter your password",
                                textInputAction: TextInputAction.next,
                                isPasswordField: true,
                                textEditingController: passController,
                                validator: (val) =>
                                    Validator.validatePassword(val),
                                onChanged: (_) => setState(() {}),
                              ),
                              spacer,
                              CustomInputField(
                                formHolderName: "Confirm Password",
                                hintText: "Enter your password",
                                textInputAction: TextInputAction.done,
                                isPasswordField: true,
                                textEditingController: confirmPController,
                                onChanged: (_) => setState(() {}),
                                validator: (val) => Validator.doesPasswordMatch(
                                  password: passController.text,
                                  confirmPassword: confirmPController.text,
                                ),
                              ),
                              spacer,
                              spacer,
                              spacer,
                              CustomButton(
                                text: "Complete",
                                isActive: true,
                                onTap: () async {
                                  if (!(_formKey.currentState?.validate() ??
                                      false)) {
                                    return;
                                  }
                                  setState(() => loading = true);
                                  await resetPassword();
                                  setState(() => loading = false);
                                },
                                loading: loading,
                              ),
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

  //
  bool loading = false;
  Future<void> resetPassword() async {
    await AuthHelper.completePasswordReset(
      email: widget.param.email,
      otp: widget.param.otp,
      password: passController.text,
    ).then((msg) async {
      showCustomToast(
          context: context, description: msg, type: ToastType.success);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    }).catchError((e) {
      showCustomToast(context: context, description: e.toString());
    });
  }
}
