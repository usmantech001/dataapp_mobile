import 'dart:async';

import 'package:dataplug/core/model/core/auth_success_model.dart';
import 'package:dataplug/core/providers/auth_controller.dart';
import 'package:dataplug/core/utils/app-loader.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../../../misc/color_manager/color_manager.dart';
import '../../../../../misc/custom_components/custom_btn.dart';
import '../../../../../misc/custom_snackbar.dart';

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
      child: Scaffold(
        appBar: CustomAppbar(title: 'Change Transaction PIN'),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding:
                            const EdgeInsets.only(top: 5, bottom: 10, left: 15),
                        child: Text("Enter Old PIN", style: get16TextStyle())),

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
                      animationDuration: const Duration(milliseconds: 50),
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
                      padding:
                          const EdgeInsets.only(top: 25, bottom: 10, left: 15),
                      child: Text("Enter New PIN", style: get16TextStyle()),
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
                      animationDuration: const Duration(milliseconds: 50),
                      enableActiveFill: true,
                      errorAnimationController: errorController2,
                      controller: textEditingController2,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {},
                    ),

                    Padding(
                      padding:
                          const EdgeInsets.only(top: 25, bottom: 10, left: 15),
                      child: Text("Confirm New Pin", style: get16TextStyle()),
                    ),
                    PinCodeTextField(
                      appContext: context,
                      length: 4,
                      obscureText: false,
                      textInputAction: TextInputAction.done,
                      mainAxisAlignment: MainAxisAlignment.start,
                      animationType: AnimationType.fade,
                      validator: (value) => Validator.doesPasswordMatch(
                        confirmPassword: textEditingController2.text,
                        password: value,
                        fieldName: "Confirm Pin",
                      ),
                      pinTheme: getPinTheme(width: 70),
                      cursorColor: ColorManager.kFormHintText,
                      cursorWidth: 1.5,
                      cursorHeight: 20,
                      animationDuration: const Duration(milliseconds: 50),
                      enableActiveFill: true,
                      errorAnimationController: errorController3,
                      controller: textEditingController3,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {},
                    ),

                    //
                    const SizedBox(height: 54),
                    CustomButton(
                      text: "Save Pin",
                      isActive: true,
                      onTap: () async {
                        // if (!_formKey.currentState!.validate()) {
                        //   return;
                        // }

                        if (textEditingController.text.length != 4) {
                          errorController.add(ErrorAnimationType.shake);
                          return;
                        }

                        if (textEditingController2.text.length != 4) {
                          errorController2.add(ErrorAnimationType.shake);
                          return;
                        }

                        if (textEditingController3.text.length != 4) {
                          errorController3.add(ErrorAnimationType.shake);
                          return;
                        }

                        if(textEditingController2.text!=textEditingController3.text){
                          showCustomToast(context: context, description: 'Please ensure your new pain match');
                          return;
                        }

                        displayLoader(context);
                        final controller = context.read<AuthController>();
                        controller.changeTransactionPin(oldPin: textEditingController.text, newPin: textEditingController2.text, onSuccess: () {
                          
                          removeUntilAndPushScreen(RoutesManager.authSuccessful, RoutesManager.security, arguments: AuthSuccessModel(title: 'PIN Change Successful', description: 'Your Transaction PIN Change successful. Thank you.', onTap: (){
                            popScreen();
                          }, btnText: 'Go to Security'));
                        },
                        onError: (error) {
                          popScreen();
                          showCustomToast(
                              context: context, description: error);
                        },
                        );
                        /*
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
                              context: context, description: e.toString());
                        });

                        setState(() => loading = false);
                        */
                      },
                      loading: false,
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
}
