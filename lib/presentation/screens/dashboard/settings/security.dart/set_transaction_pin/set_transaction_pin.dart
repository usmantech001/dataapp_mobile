import 'dart:async';

import 'package:dataplug/core/utils/app-loader.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/enum.dart';
import '../../../../../../core/helpers/auth_helper.dart';
import '../../../../../../core/providers/user_provider.dart';
import '../../../../../misc/color_manager/color_manager.dart';
import '../../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../../misc/custom_components/custom_elements.dart';
import '../../../../../misc/custom_components/custom_scaffold.dart';
import '../../../../../misc/custom_snackbar.dart';
import '../../../../../misc/image_manager/image_manager.dart';
import '../../../../../misc/route_manager/routes_manager.dart';
import '../../../../../misc/style_manager/styles_manager.dart';

class SetTransactionPin extends StatefulWidget {
  const SetTransactionPin({super.key});

  @override
  State<SetTransactionPin> createState() => _SetTransactionPinState();
}

class _SetTransactionPinState extends State<SetTransactionPin> {
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  TextEditingController textEditingController = TextEditingController();

  StreamController<ErrorAnimationType> errorController2 =
      StreamController<ErrorAnimationType>();
  TextEditingController textEditingController2 = TextEditingController();
  ScrollController controller = ScrollController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    try {
      controller.dispose();
      errorController.close();
      textEditingController.dispose();
      errorController2.close();
      textEditingController2.dispose();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppbar(title: 'Set Transaction Pin'),
        body: SafeArea(
          bottom: false,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        
                       
                                    
                        Padding(
                          padding: const EdgeInsets.only(
                               bottom: 10, top: 15),
                          child: Text("Enter PIN",
                              style: get14TextStyle()),
                        ),
                        PinCodeTextField(
                          appContext: context,
                          length: 4,
                          obscureText: false,
                        mainAxisAlignment: MainAxisAlignment.center,
                          animationType: AnimationType.fade,
                          pinTheme: getPinTheme(width: 70),
                          cursorColor: ColorManager.kFormHintText,
                          cursorWidth: 1.5,
                          cursorHeight: 20,
                          animationDuration:
                              const Duration(milliseconds: 50),
                          enableActiveFill: true,
                          errorAnimationController: errorController,
                          controller: textEditingController,
                          keyboardType: TextInputType.number,
                          onCompleted: (_) {},
                          onChanged: (_) {},
                          beforeTextPaste: (_) => true,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                               bottom: 10, top: 35),
                          child: Text("Confirm PIN",
                              style: get14TextStyle()),
                        ),
                        PinCodeTextField(
                          appContext: context,
                          length: 4,
                          obscureText: false,
                          animationType: AnimationType.fade,
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
                          onCompleted: (_) {},
                          onChanged: (_) {},
                          beforeTextPaste: (_) => true,
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        const SizedBox(height: 54),
                        CustomButton(
                          text: "Save PIN",
                          isActive: true,
                          onTap: () async {
                            _formKey.currentState!.validate();
                            if (textEditingController.text.length !=
                                4) {
                              errorController
                                  .add(ErrorAnimationType.shake);
                              return;
                            }
                                    
                            if (textEditingController.text !=
                                textEditingController2.text) {
                              showCustomToast(
                                context: context,
                                description: "Ensure both PIN match",
                                type: ToastType.error,
                              );
                                    
                              return;
                            }
                                    
                          
                            await completeSetup();
                           
                                    
                            //
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
        ),
      ),
    );
  }

 // bool loading = false;
  Future<void> completeSetup() async {
    displayLoader(context);
    await AuthHelper.setPin(textEditingController.text).then((user) async {
      popScreen();
      showCustomToast(
        context: context,
        description: "Pin Set successfully",
        type: ToastType.success,
      );
     print('...the new user data after pin set is ${user.toMap()}');
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      userProvider.updateUser(user);
      AuthHelper.updateSavedUserDetails(user);
      Navigator.pushNamedAndRemoveUntil(context, RoutesManager.bottomNav,
          (Route<dynamic> route) => false);
    }).catchError((e) {
      popScreen();
      showCustomToast(
          context: context, description: e.toString(), type: ToastType.error);
    });
  }
}
