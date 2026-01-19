import 'package:dataplug/core/enum.dart';
import 'package:dataplug/core/model/core/user.dart';
import 'package:dataplug/core/utils/app-loader.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/gen/assets.gen.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:dataplug/presentation/screens/auth/verify_email.dart/misc/verify_email_arg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/helpers/auth_helper.dart';
import '../../../../core/utils/validators.dart';
import '../../../misc/custom_components/custom_input_field.dart';
import '../../../misc/custom_snackbar.dart';

class PasswordReset1 extends StatefulWidget {
  const PasswordReset1({super.key});

  @override
  State<PasswordReset1> createState() => _PasswordReset1State();
}

class _PasswordReset1State extends State<PasswordReset1> {
  final spacer = const SizedBox(height: 30);
  ScrollController controller = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    controller.dispose();
    super.dispose();
  }

  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.kWhite,
      body: SafeArea(
        bottom: false,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 24.h),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Assets.images.dataplugLogoText.image(width: 150, height: 30),
                  Gap(30.h),
                  Text(
                    "Reset your password",
                    style: get24TextStyle().copyWith(
                      wordSpacing: .1,
                    ),
                  ),
                  Gap(12.h),
                  Text(
                    'Enter your email to receive a secure verification code',
                    style: get14TextStyle().copyWith(
                        color: ColorManager.kGreyColor.withValues(alpha: .7)),
                  ),
                  Gap(32.h),
                  Column(
                    children: [
                      //
                      Column(
                        children: [
                          CustomInputField(
                            formHolderName: "Email",
                            hintText: "Enter your email",
                            textEditingController: emailController,
                            textInputAction: TextInputAction.done,
                            validator: (val) => Validator.validateEmail(val),
                            onChanged: (_) => setState(() {}),
                          ),
                          Gap(24.h),
                          CustomButton(
                            text: "Proceed",
                            isActive: true,
                            onTap: () async {
                              if (!(_formKey.currentState?.validate() ??
                                  false)) {
                                return;
                              }

                              await getResetPasswordOtp(
                                  emailController.text.trim());
                             
                            },
                            loading: loading,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //
  bool loading = false;
  Future<void> getResetPasswordOtp(String email) async {
    displayLoader(context);
    await AuthHelper.resendPasswordResetOtp(email: email).then((value) {
      popScreen();
      Navigator.pushNamed(
        context,
        RoutesManager.verifyEmail,
        arguments: VerifyEmailArg(
          emailVerificationType: EmailVerificationType.passordReset,
          user: User(email: email),
          token: "",
        ),
      );
    }).catchError((_) {
      popScreen();
      showCustomToast(
          context: context, description: _.toString(), type: ToastType.error);
    });

    setState(() => loading = false);
  }
}
