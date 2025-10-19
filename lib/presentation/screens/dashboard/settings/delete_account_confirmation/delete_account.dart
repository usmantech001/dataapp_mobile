import 'package:dataplug/presentation/misc/custom_components/custom_back_icon.dart';
import 'package:flutter/material.dart';

import '../../../../../core/helpers/auth_helper.dart';
import '../../../../../core/helpers/user_helper.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_btn.dart';
import '../../../../misc/custom_components/custom_elements.dart';
import '../../../../misc/custom_snackbar.dart';
import '../../../../misc/style_manager/styles_manager.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                BackIcon(onTap: () {
                  if (!loading) Navigator.pop(context);
                }),
                const SizedBox(width: 15),
                Text(
                  "Go Back",
                  style: get14TextStyle(),
                ),
              ],
            ),
          ),
          customDivider(),
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 25, left: 15),
            child: Text(
              "Are you sure you want to delete your account?",
              textAlign: TextAlign.left,
              style: get22TextStyle(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: CustomButton(
              text: "Delete Account",
              isActive: true,
              onTap: () async {
                try {
                  setState(() => loading = true);
                  await UserHelper.deleteAccount();
                  await AuthHelper.logout(context,
                      deactivateTokenAndRestart: true);
                  if (mounted) setState(() => loading = false);
                } catch (err) {
                  //
                  if (mounted) {
                    showCustomToast(
                        context: context, description: err.toString());
                    setState(() => loading = false);
                  }
                }
              },
              loading: loading,
              backgroundColor: ColorManager.kPrimary,
            ),
          ),
            SizedBox(height: 24,),
        ],
      ),
    );
  }
}
