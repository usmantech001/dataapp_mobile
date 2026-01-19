import 'dart:convert';
import 'package:dataplug/core/constants.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/image_manager/image_manager.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

import '../../../../core/enum.dart';
import '../../../../core/helpers/auth_helper.dart';
import '../../../../core/model/core/user.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../core/services/secure_storage.dart';
import '../../../../core/utils/validators.dart';
import '../../../../gen/assets.gen.dart';
import '../../../misc/custom_components/custom_input_field.dart';
import '../../../misc/custom_components/custom_text_btn.dart';
import '../../../misc/custom_snackbar.dart';

class SignIn extends StatefulWidget {
  User? user;
  SignIn({super.key, this.user});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final spacer = const SizedBox(height: 30);

  final ScrollController controller = ScrollController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool biometricAvailable = false;
  LocalAuthentication localAuth = LocalAuthentication();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        biometricAvailable = await localAuth.canCheckBiometrics;
        setState(() {});
      } catch (_) {}
    });
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: ColorManager.kWhite,
      body: SafeArea(
        bottom: false,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //
                Assets.images.dataplugLogoText.image(width: 150, height: 30),

                Gap(30.h),

                Text(
                      widget.user == null ? "Log In " : "Welcome Back!",
                      style: get24TextStyle()
                          .copyWith(wordSpacing: .1, ),
                    ),
                    Gap(12.h),
                    Text(widget.user == null ? "Log in to access your account and manage your finances easily." : 'Please enter your password to sign in and manage your finances smoothly.', style: get14TextStyle().copyWith(
                      color: ColorManager.kGreyColor.withValues(alpha: .7)
                    ),),
                    Gap(32.h),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      //
                      Column(
                        children: [
                          if (widget.user == null)
                            CustomInputField(
                              formHolderName: "Email",
                              hintText: "Enter your email",
                              textEditingController: emailController,
                              textInputAction: TextInputAction.next,
                              validator: (val) => Validator.validateEmail(val),
                              onChanged: (_) => setState(() {}),
                            ),
                          if (widget.user == null) spacer,

                        
                          CustomInputField(
                            formHolderName: "Password",
                            hintText: "Enter your password",
                            textInputAction: TextInputAction.done,
                            textEditingController: passwordController,
                            isPasswordField: true,
                            validator: (v) => Validator.validatePassword(v),
                            onChanged: (_) => setState(() {}),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: CustomTextBtn(
                                text: "Forgot Password?",
                                isActive: true,
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RoutesManager.passwordReset1);
                                },
                                loading: false,
                              ),
                            ),
                          ),

                          //

                          if (widget.user != null &&
                              biometricAvailable &&
                              (widget.user?.login_biometric_activated ?? false))
                            buildBiometricCard(),
                          spacer,
                          
                          CustomButton(
                            text: "Proceed",
                            isActive: true,
                            onTap: () async {
                              if (!(_formKey.currentState?.validate() ??
                                  false)) {
                                return;
                              }
                              String email =
                                  widget.user?.email ?? emailController.text;
                              String password = passwordController.text;
                              if (widget.user != null) {
                                var nextGlobalLogin =
                                    await SecureStorage.getInstance()
                                        .then((pref) => pref.getString(
                                            Constants.kGlobalLoginKey))
                                        .catchError((_) => null);
                                DateTime now = DateTime.now();

                                if (nextGlobalLogin != null) {
                                  final nextGlobalLoginDate =
                                      DateTime.parse(nextGlobalLogin);
                                  final diff =
                                      nextGlobalLoginDate.difference(now);
                                  print('...the difference is ${diff.inDays}');
                                  bool localSiginDue =
                                      nextGlobalLoginDate.isBefore(now);
                                  if (localSiginDue) {
                                    signIn(LoginProvider.password,
                                            email: email, password: password)
                                        .catchError((e) {
                                      // widget.user = null;
                                      setState(() => loginLoading = false);
                                      showCustomToast(
                                          context: context,
                                          description: e.toString(),
                                          type: ToastType.error);
                                    });
                                  } else {
                                    localSigin(password);
                                  }
                                } else {
                                  signIn(LoginProvider.password,
                                          email: email, password: password)
                                      .catchError((e) {
                                    // widget.user = null;
                                    setState(() => loginLoading = false);
                                    showCustomToast(
                                        context: context,
                                        description: e.toString(),
                                        type: ToastType.error);
                                  });
                                }
                              } else {
                                signIn(LoginProvider.password,
                                        email: email, password: password)
                                    .catchError((e) {
                                  // widget.user = null;
                                  setState(() => loginLoading = false);
                                  showCustomToast(
                                      context: context,
                                      description: e.toString(),
                                      type: ToastType.error);
                                });
                              }
                            },
                            loading: loginLoading,
                          ),
                          if (widget.user != null) ...[
                            Gap(30.h),
                            AltRoute(
                                routeTo: () {
                                  setState(() {
                                    widget.user = null;
                                  });
                                },
                                text1: 'Not ${widget.user?.firstname ?? ""}? ',
                                underline: false,
                                text2: 'Switch Account')
                          ],
                          // if (widget.user == null)
                          // const Padding(
                          //   padding: EdgeInsets.only(top: 16),
                          //   child: Row(
                          //     mainAxisAlignment:
                          //         MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       //
                          //       SocialAuth(
                          //           text: "Continue with Google",
                          //           image: ImageManager.kGoogleIcon),
                          //       Gap(16),
                          //       SocialAuth(
                          //           text: "Continue with Apple",
                          //           image: ImageManager.kAppleIcon),
                          //     ],
                          //   ),
                          // ),
                          //const SizedBox(height: 10),
                         if (widget.user == null) Padding(
                           padding: EdgeInsets.only(top: 30.h),
                           child: RichText(
                              text: TextSpan(
                                style: get12TextStyle().copyWith(fontSize: 12),
                                children: [
                                   TextSpan(text: "Don’t have an account? ", style: get14TextStyle().copyWith(color: ColorManager.kGreyColor.withValues(alpha: .7))),
                                  TextSpan(
                                    text: "Create an Account?",
                                    style: get14TextStyle().copyWith(color: ColorManager.kPrimary),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushReplacementNamed(
                                            context, RoutesManager.onboarding1);
                                      },
                                    //
                                  )
                                ],
                              ),
                            ),
                         )
                        ],
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

  Future<void> _verifyBiometrics(BuildContext context) async {
    bool didAuthenticate = await localAuth.authenticate(
        localizedReason: "Please complete the authentication process");

    //
    if (didAuthenticate) {
      var authCred = await SecureStorage.getInstance()
          .then((pref) => json.decode(pref.getString("authCred") ?? "{}"))
          .catchError((_) => {});

      String email = authCred["user"]["email"];
      String password = authCred["password"];
      var nextGlobalLogin = await SecureStorage.getInstance()
          .then((pref) => pref.getString(Constants.kGlobalLoginKey))
          .catchError((_) => null);
      DateTime now = DateTime.now();

      if (nextGlobalLogin != null) {
        final nextGlobalLoginDate = DateTime.parse(nextGlobalLogin);
        final diff = nextGlobalLoginDate.difference(now);
        print('...the difference is ${diff.inDays}');
        bool localSiginDue = nextGlobalLoginDate.isBefore(now);
        if (!localSiginDue) {
          signIn(LoginProvider.password, email: email, password: password)
              .catchError((e) {
            // widget.user = null;
            setState(() => loginLoading = false);
            showCustomToast(
                context: context,
                description: e.toString(),
                type: ToastType.error);
          });
        } else {
          localSigin(password);
        }
      } else {
        signIn(LoginProvider.password, email: email, password: password)
            .catchError((e) {
          // widget.user = null;
          setState(() => loginLoading = false);
          showCustomToast(
              context: context,
              description: e.toString(),
              type: ToastType.error);
        });
      }

      // LoginProvider loginProvider =
      //     enumFromString(LoginProvider.values, authCred["loginProvider"])!;
      // String password = authCred["password"];
      // // String? social_token = authCred["social_token"];

      // signIn(loginProvider, email: email, password: password).catchError((_) {
      //   // widget.user = null;
      //   log("$_", name: "Error");
      //   setState(() => loginLoading = false);
      //   // AuthHelper.logout(context);
      //   showCustomToast(
      //       context: context, description: "$_", type: ToastType.error);
      // });
    }
  }

  bool loginLoading = false;
  Future<void> localSigin(String password) async {
    var authCred = await SecureStorage.getInstance()
        .then((pref) => json.decode(pref.getString("authCred") ?? "{}"))
        .catchError((_) => {});
    print('...auth cred $authCred');
    User user = User.fromMap(authCred['user']);
    String storedPassword = authCred["password"];
    if (storedPassword == password) {
      print('..before navigating email verified is ${user.email_verified}');
      await AuthHelper.routeAuthenticated(context,
          user: user, password: password);
      AuthHelper.updateSavedUserDetails(user);
    } else {
      showCustomToast(
          context: context,
          description: "Invalid Credentials",
          type: ToastType.error);
    }
  }

  Future<void> signIn(LoginProvider loginProvider,
      {required String email, required String password}) async {
    // if (googleSignInLoading || appleSignInLoading || loginLoading) return;

    setState(() => loginLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    User user = await AuthHelper.signIn(loginProvider,
        email: email, password: password);
    await AuthHelper.routeAuthenticated(context,
        user: user, password: password);
    AuthHelper.updateSavedUserDetails(user);
    AuthHelper.saveNextGlobalLogin();
    if (user.biometricToken != null) {
      AuthHelper.updateBiometricToken(user.biometricToken!);
    }

    setState(() => loginLoading = false);
  }

  Widget buildBiometricCard() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _verifyBiometrics(context),
      child: Container(
        margin: const EdgeInsets.only(top: 24, bottom: 5, left: 15, right: 15),
        padding: const EdgeInsets.all(12.5),
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
                  Text(
                    "Tap here to use Face ID/thumb print to login",
                    style: get12TextStyle().copyWith(
                      height: 1.0,
                      color: ColorManager.kTextDark7,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            Image.asset(ImageManager.kFaceIcon,
                color: ColorManager.kPrimary, width: 36),
          ],
        ),
      ),
    );
  }
}

class AltRoute extends StatelessWidget {
  final String text1, text2;
  final VoidCallback routeTo;
  final bool? underline;
  const AltRoute(
      {super.key,
      required this.text1,
      required this.text2,
      this.underline = true,
      required this.routeTo});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text1,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                color: ColorManager.kBlack.withValues(alpha: .6))),
        const SizedBox(width: 4),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: routeTo,
          child: Text(
            text2,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: ColorManager.kPrimary,
                decoration:
                    underline == true ? TextDecoration.underline : null),
          ),
        ),
      ],
    );
  }
}
