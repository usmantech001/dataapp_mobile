import 'dart:developer';

import 'package:dataplug/core/helpers/tiktok_helper.dart';
import 'package:dataplug/core/utils/app-loader.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_scaffold.dart';
import 'package:dataplug/presentation/misc/image_manager/image_manager.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:dataplug/presentation/screens/auth/verify_email.dart/misc/verify_email_arg.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/enum.dart';
import '../../../../core/helpers/auth_helper.dart';
import '../../../../core/model/core/country.dart';
import '../../../../core/utils/validators.dart';
import '../../../../gen/assets.gen.dart';
import '../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../misc/custom_components/custom_input_field.dart';
import '../../../misc/custom_snackbar.dart';
import '../../../misc/select_country.dart';
import '../misc/social_auth.dart';

class Onboarding1 extends StatefulWidget {
  const Onboarding1({super.key});

  @override
  State<Onboarding1> createState() => _Onboarding1State();
}

class _Onboarding1State extends State<Onboarding1> {
  final spacer = const SizedBox(height: 16);

  final ScrollController controller = ScrollController();

  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController referralController = TextEditingController();
  String countryCode = "+234";

  Country? country;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: ColorManager.kPrimaryLight,
      backgroundColor: ColorManager.kWhite,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // color: ColorManager.kPrimaryLight,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //
                  Padding(
                    padding: const EdgeInsets.only(left: 0, top: 0),
                    child: Assets.images.dataplugLogoText
                        .image(width: 118, height: 30),
                  ),
                  Gap(25),
                  Text(
                    "Create an Account",
                    style: get24TextStyle(),
                  ),
                  Gap(12),
                  Text(
                    "Sign Up Today to Manage Data and Pay Bills in One Place",
                    style: get14TextStyle(),
                  ),
                  /*
                   RichText(
                        text: TextSpan(
                          style: get12TextStyle().copyWith(fontSize: 13),
                          children: [
                            const TextSpan(text: "Have an account? "),
                            TextSpan(
                              text: "Sign in",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: ColorManager.kPrimary,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacementNamed(
                                      context, RoutesManager.signIn);
                                },
                            )
                          ],
                        ),
                      )
                   */

                  const SizedBox(height: 10),
                ],
              ),
            ),
            //

            //
            Expanded(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorManager.kWhite,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        //
                        Expanded(
                          child: ListView(
                            controller: controller,
                            children: [
                              CustomInputField(
                                formHolderName: "First Name",
                                hintText: "Enter your first name",
                                textInputAction: TextInputAction.next,
                                textEditingController: firstnameController,
                                validator: (val) => Validator.validateField(
                                    fieldName: "First Name", input: val),
                                onChanged: (_) {
                                  setState(() {});
                                },
                              ),

                              spacer,
                              CustomInputField(
                                formHolderName: "Last Name",
                                hintText: "Enter your last name",
                                textInputAction: TextInputAction.next,
                                textEditingController: lastnameController,
                                validator: (val) => Validator.validateField(
                                    fieldName: "Last Name", input: val),
                                onChanged: (_) {
                                  setState(() {});
                                },
                              ),

                              spacer,
                              CustomInputField(
                                maxLength: 10,
                                formHolderName: "Phone Number",
                                hintText: '8050754432',
                                prefixIcon: GestureDetector(
                                  onTap: () async {
                                    Country? res = await showCustomBottomSheet(
                                        context: context,
                                        screen: const SelectCountry());
                                    if (res != null) {
                                      setState(() {
                                        countryCode = res.phone_code ?? "";
                                        country = res;
                                      });
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 4.5),
                                        child: Text(" ${countryCode ?? "--"}",
                                            style: get14TextStyle().copyWith(
                                                fontWeight: FontWeight.w400)),
                                      ),
                                      dropDownIcon(
                                        width: 24,
                                        padding: EdgeInsets.zero,
                                        color: ColorManager.kTextColor
                                            .withOpacity(.4),
                                      ),
                                      customDivider(
                                        width: 1,
                                        height: 35,
                                        color: ColorManager.kBarColor,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                      )
                                    ],
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                                textEditingController: phoneController,
                                textInputType: TextInputType.number,
                                validator: (val) => Validator.validateField(
                                    fieldName: "Phone Number", input: val),
                              ),

                              //
                              spacer,
                              CustomInputField(
                                formHolderName: "Email",
                                hintText: "Enter your email",
                                textEditingController: emailController,
                                textInputAction: TextInputAction.next,
                                validator: (val) =>
                                    Validator.validateEmail(val),
                                onChanged: (_) => setState(() {}),
                              ),
                              spacer,

                              CustomInputField(
                                formHolderName: "Password",
                                hintText: "Enter your password",
                                textInputAction: TextInputAction.next,
                                textEditingController: passwordController,
                                isPasswordField: true,
                                validator: (v) => Validator.validatePassword(v),
                                onChanged: (_) => setState(() {}),
                              ),
                              spacer,

                              CustomInputField(
                                formHolderName: "Referral Code (Optional)",
                                hintText: "Enter referral code",
                                textInputAction: TextInputAction.done,
                                textEditingController: referralController,
                              ),

                              spacer,
                              spacer,
                              CustomButton(
                                text: "Proceed",
                                isActive: true,
                                onTap: () async {
                                  try {
                                    if (!(_formKey.currentState?.validate() ??
                                        false)) {
                                      throw "Please ensure that all input are filled correctly.";
                                    }

                                    if (countryCode.isEmpty) {
                                      throw "Please ensure that all input are filled correctly.";
                                    }

                                    createAccount();

                                    //
                                  } catch (e) {
                                    log(e.toString());
                                    showCustomToast(
                                        context: context, description: "$e");
                                  }
                                },
                                loading: false,
                              ),

                              Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10.h),
                                  child: RichText(
                                    text: TextSpan(
                                      style:
                                          get12TextStyle().copyWith(fontSize: 12),
                                      children: [
                                        TextSpan(
                                            text: "Already have an Account? ",
                                            style: get14TextStyle().copyWith(
                                                color: ColorManager.kGreyColor
                                                    .withValues(alpha: .7))),
                                        TextSpan(
                                          text: "Sign In",
                                          style: get14TextStyle().copyWith(
                                              color: ColorManager.kPrimary),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.pushReplacementNamed(
                                                  context,
                                                  RoutesManager.signIn);
                                            },
                                          //
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),

//                               const Padding(
//                                 padding: EdgeInsets.only(top: 16),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     //
//                                     SocialAuth(
//                                         text: "Continue with Google",
//                                         image: ImageManager.kGoogleIcon),
// Gap(16),
//                                     SocialAuth(
//                                         text: "Continue with Apple",
//                                         image: ImageManager.kAppleIcon),
//                                   ],
//                                 ),
//                               ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //bool loading = false;
  Future<void> createAccount() async {
    displayLoader(context);

    await AuthHelper.signUp(
            firstname: firstnameController.text,
            lastname: lastnameController.text,
            email: emailController.text,
            password: passwordController.text,
            referrerCode: referralController.text,
            phone: phoneController.text,
            phoneCode: countryCode)
        .then((value) {
      TiktokHelper().logEvent('Registration', {
        'firstname': firstnameController.text,
        'lastname': lastnameController.text,
        'email': emailController.text,
        'phone': phoneController.text
      });
      popScreen();
      showCustomToast(
        context: context,
        description: "Account creation was sucessful.",
        type: ToastType.success,
      );
      log(value.toString(), name: "createAccount");

      Navigator.pushNamed(
        context,
        RoutesManager.verifyEmail,
        arguments: VerifyEmailArg(
          emailVerificationType: EmailVerificationType.signp,
          user: value['user'],
          token: value['token'],
        ),
      );
    }).catchError((e) {
      popScreen();
      showCustomToast(context: context, description: e.toString());
    });
    
  }
}
