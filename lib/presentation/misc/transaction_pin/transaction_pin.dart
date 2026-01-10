import 'dart:async';
import 'dart:developer';

import 'package:dataplug/core/helpers/auth_helper.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/image_manager/image_manager.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../../core/constants.dart';
import '../../../core/providers/user_provider.dart';
import '../color_manager/color_manager.dart';

class TransactionPin extends StatefulWidget {
  final Function(BuildContext context, {required String transaction_pin})?
      funcCall;

  const TransactionPin({super.key, this.funcCall});

  @override
  State<TransactionPin> createState() => _TransactionPinState();
}

class _TransactionPinState extends State<TransactionPin> {
  ScrollController controller = ScrollController();
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  TextEditingController pinController = TextEditingController();

  @override
  void initState() {
    checkBiometric();
    super.initState();
  }

  LocalAuthentication localAuth = LocalAuthentication();

  String? biometric_token;
  bool canAuthorizeWithBiometrics = false;
  Future<void> checkBiometric() async {
    bool deviceSupportBiometric =
        await localAuth.canCheckBiometrics.catchError((_) => false);
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    biometric_token = await AuthHelper.getCacheBiometricToken();
  
    if (biometric_token != null &&
        deviceSupportBiometric &&
        userProvider.user.login_biometric_activated) {
      canAuthorizeWithBiometrics = true;
    }

    setState(() {});
  }

  Future<void> verifyBiometric() async {
    log("Start+++BIO");
    bool didAuthenticate = await localAuth.authenticate(
        localizedReason: "Please complete the authentication process");
    if (didAuthenticate == false) return;
    proceed(biometric_token ?? "");
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print('... is biometric enabaled ${
        Provider.of<UserProvider>(context).user.login_biometric_activated}. and the biometric token is $biometric_token');
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        height: 580,
        color: ColorManager.kWhite,
        padding: const EdgeInsets.symmetric(
            horizontal: Constants.kHorizontalScreenPadding),
        child: Column(
          children: [
            const SizedBox(height: 21),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(flex: 1, child: SizedBox()),
                Expanded(
                  flex: 2,
                  child: Text("Transaction PIN",
                      textAlign: TextAlign.center, style: get18TextStyle()),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (loading == false) Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Icon(CupertinoIcons.xmark,
                            size: 20, color: ColorManager.kTextDark7),
                      ),
                    ),
                  ),
                ),
                //
              ],
            ),
            customDivider(margin: const EdgeInsets.only(top: 19, bottom: 18)),
            Text(
              "Kindly enter your transaction PIN to proceed\nwith  your transaction",
              textAlign: TextAlign.center,
              style: get14TextStyle().copyWith(height: 1.65),
            ),
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 25),
                controller: controller,
                children: [
                  Form(
                    key: _formKey,
                    child: PinCodeTextField(
                      appContext: context,
                      length: 4,
                      obscureText: !false,
                      animationType: AnimationType.fade,
                      pinTheme: getPinTheme(width: 70),
                      cursorColor: ColorManager.kFormHintText,
                      cursorWidth: 1.5,
                      cursorHeight: 20,
                      animationDuration: const Duration(milliseconds: 50),
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: pinController,
                      keyboardType: TextInputType.number,
                      onCompleted: (_) {},
                      onChanged: (_) {},
                      beforeTextPaste: (_) => true,
                      mainAxisAlignment: MainAxisAlignment.start,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => Navigator.pushNamed(
                          context, RoutesManager.changeTransactionPin),
                      child: Text(
                        "Forgot PIN?",
                        style: get12TextStyle().copyWith(
                          color: ColorManager.kPrimary,
                        ),
                      ),
                    ),
                  ),
                  if (canAuthorizeWithBiometrics)
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => verifyBiometric(),
                      child: Container(
                        margin: const EdgeInsets.only(top: 26),
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorManager.kPrimaryLight,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Use Face ID/Thumb print",
                                    style: get14TextStyle().copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: ColorManager.kPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text("Tap here to confirm trasacation",
                                      style: get12TextStyle())
                                ],
                              ),
                            ),
                            Image.asset(ImageManager.kFaceIcon, color: ColorManager.kPrimary,  width: 32)
                          ],
                        ),
                      ),
                    ),

                  //
                  const SizedBox(height: 40),
                ],
              ),
            ),
            CustomButton(
              text: "Done",
              isActive: true,
              onTap: () {
                _formKey.currentState!.validate();
                if (pinController.text.length != 4) {
                  errorController.add(ErrorAnimationType.shake);
                  return;
                }
                proceed(pinController.text);
              },
              loading: loading,
            ),
            const SizedBox(height: 35)
          ],
        ),
      ),
    );
  }

  bool loading = false;
  Future<void> proceed(String pin) async {
    setState(() => loading = true);
    await widget.funcCall!(context, transaction_pin: pin);
    setState(() => loading = false);
  }
}
