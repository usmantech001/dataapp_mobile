import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/enum.dart';
import '../../../../../../core/helpers/user_helper.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../../../misc/color_manager/color_manager.dart';
import '../../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../../misc/custom_components/custom_btn.dart';
import '../../../../../misc/custom_components/custom_elements.dart';
import '../../../../../misc/custom_components/custom_input_field.dart';
import '../../../../../misc/custom_components/custom_scaffold.dart';
import '../../../../../misc/custom_snackbar.dart';
import '../../../../../misc/image_manager/image_manager.dart';
import '../../../../../misc/style_manager/styles_manager.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final spacer = const SizedBox(height: 30);

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  ScrollController controller = ScrollController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppbar(title: 'Change Password'),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //

              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    CustomInputField(
                      formHolderName: "Old Password",
                      hintText: "Enter your old password",
                      textInputAction: TextInputAction.next,
                      isPasswordField: true,
                      textEditingController: oldPasswordController,
                      validator: (value) => Validator.validateField(
                          fieldName: "Old Password", input: value),
                    ),
                    spacer,

                    CustomInputField(
                      formHolderName: "New Password",
                      hintText: "Enter your new password",
                      textInputAction: TextInputAction.next,
                      isPasswordField: true,
                      textEditingController: newPasswordController,
                      validator: (value) => Validator.validateField(
                          fieldName: "New Password", input: value),
                      onChanged: (_) => setState(() {}),
                    ),
                    spacer,

                    CustomInputField(
                      formHolderName: "Confirm Password",
                      hintText: "Confirm your new password",
                      textInputAction: TextInputAction.done,
                      isPasswordField: true,
                      textEditingController: confirmNewPasswordController,
                      onChanged: (_) => setState(() {}),
                      validator: (v) => Validator.doesPasswordMatch(
                        password: newPasswordController.text,
                        confirmPassword: confirmNewPasswordController.text,
                      ),
                    ),
                    spacer,

                    //
                    const SizedBox(height: 54),
                    CustomButton(
                      text: "Save Password",
                      isActive: true,
                      onTap: () {
                        if (!(_formKey.currentState?.validate() ?? false)) {
                          showCustomToast(
                            context: context,
                            description:
                                "Please ensure that all input are filled correctly.",
                          );
                          return;
                        }

                        updatePassword();
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
    );
  }

  bool loading = false;
  Future<void> updatePassword() async {
    setState(() => loading = true);
    await UserHelper.updatePassword(
            old_password: oldPasswordController.text,
            password: newPasswordController.text)
        .then((msg) {
      if (mounted) {
        showCustomToast(
            context: context, description: msg, type: ToastType.success);
        Navigator.pop(context);
      }
    }).catchError((err) {
      if (mounted) {
        showCustomToast(context: context, description: err.toString());
      }
    });

    setState(() => loading = false);
  }
}
