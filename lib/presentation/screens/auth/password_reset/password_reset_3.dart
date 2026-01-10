import 'dart:async';

import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_scaffold.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Set a new password",
                    style: get24TextStyle().copyWith(
                      wordSpacing: .1,
                    ),
                  ),
                  Gap(12.h),
                  Text(
                    'Create a strong password to secure your account',
                    style: get14TextStyle().copyWith(
                        color: ColorManager.kGreyColor.withValues(alpha: .7)),
                  ),
            
                Gap(32.h),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                  
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
