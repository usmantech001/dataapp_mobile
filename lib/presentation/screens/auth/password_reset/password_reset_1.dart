import 'package:dataplug/core/enum.dart';
import 'package:dataplug/core/model/core/user.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_scaffold.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:dataplug/presentation/screens/auth/verify_email.dart/misc/verify_email_arg.dart';
import 'package:flutter/material.dart';

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
    return CustomScaffold(
      backgroundColor: ColorManager.kPrimaryLight,
      body: SafeArea(
        bottom: false,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Container(
                  color: ColorManager.kPrimaryLight,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        "Reset Password",
                        textAlign: TextAlign.left,
                        style: get18TextStyle().copyWith(fontSize: 16.5),
                      ),
                      customDivider(
                        height: 1,
                        margin: const EdgeInsets.only(top: 16, bottom: 10),
                        color: ColorManager.kPrimary.withOpacity(.1),
                      )
                    ],
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
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 20),
                    child: Column(
                      children: [
                        //
                        Expanded(
                          child: ListView(
                            controller: controller,
                            children: [
                              CustomInputField(
                                formHolderName: "Email",
                                hintText: "Enter your email",
                                textEditingController: emailController,
                                textInputAction: TextInputAction.done,
                                validator: (val) =>
                                    Validator.validateEmail(val),
                                onChanged: (_) => setState(() {}),
                              ),
                              spacer,
                              spacer,
                              spacer,
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
                        ),
                      ],
                    ),
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
  Future<void> getResetPasswordOtp(String email) async {
    setState(() => loading = true);
    await AuthHelper.resendPasswordResetOtp(email: email).then((value) {
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
      showCustomToast(
          context: context, description: _.toString(), type: ToastType.error);
    });

    setState(() => loading = false);
  }
}
