import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../misc/custom_components/custom_container.dart';
import '../../../../misc/custom_components/custom_elements.dart';
import '../../../../misc/custom_components/custom_input_field.dart';
import '../../../../misc/custom_components/custom_scaffold.dart';
import '../../../../misc/image_manager/image_manager.dart';
import '../../../../misc/route_manager/routes_manager.dart';
import '../../../../misc/style_manager/styles_manager.dart';

class CompleteRegistration extends StatelessWidget {
  const CompleteRegistration({super.key});

  final spacer = const SizedBox(height: 16);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: ColorManager.kPrimary,
      body: SafeArea(
        bottom: false,
        child: Container(
          decoration: BoxDecoration(
            color: ColorManager.kWhite,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.only(left: 15),
                      alignment: Alignment.centerLeft,
                      child: const BackIcon(),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Complete Registration",
                      textAlign: TextAlign.center,
                      style: get18TextStyle(),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Text(
                            "Skip",
                            textAlign: TextAlign.end,
                            style: get12TextStyle().copyWith(
                              fontWeight: FontWeight.w700,
                              color: ColorManager.kPrimary,
                            ),
                          ),
                        ),
                      )),
                ],
              ),

              //

              //
              customDivider(
                height: 1,
                margin: const EdgeInsets.only(top: 16, bottom: 55),
                color: ColorManager.kBar2Color,
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  children: [
                    //
                    IgnorePointer(
                      child: CustomInputField(
                        formHolderName: "Username",
                        hintText: "moyorahm",
                        textInputAction: TextInputAction.next,
                        // textEditingController: passwordController,
                        // validator: (v) => Validator.validatePassword(v),
                        // onChanged: (_) => setState(() {}),
                      ),
                    ),
                    spacer,

                    IgnorePointer(
                      child: CustomInputField(
                        formHolderName: "Gender",
                        hintText: "Male",
                        textInputAction: TextInputAction.next,
                        // textEditingController: passwordController,
                        // validator: (v) => Validator.validatePassword(v),
                        // onChanged: (_) => setState(() {}),
                        suffixIcon: Icon(
                          Icons.keyboard_arrow_down_sharp,
                          color: ColorManager.kFormHintText,
                        ),
                      ),
                    ),
                    spacer,
                    Row(
                      children: [
                        Expanded(
                          child: IgnorePointer(
                            child: CustomInputField(
                              formHolderName: "Country",
                              hintText: "Nigeria",
                              // textEditingController: emailController,
                              textInputAction: TextInputAction.next,
                              // validator: (val) => Validator.validateEmail(val),
                              // onChanged: (_) => setState(() {}),
                              suffixIcon: Icon(CupertinoIcons.chevron_down,
                                  size: 18, color: ColorManager.kTextDark),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: IgnorePointer(
                            child: CustomInputField(
                              formHolderName: "State",
                              hintText: "Lagos",
                              // textEditingController: emailController,
                              textInputAction: TextInputAction.next,
                              // validator: (val) => Validator.validateEmail(val),
                              // onChanged: (_) => setState(() {}),
                              suffixIcon: Icon(CupertinoIcons.chevron_down,
                                  size: 18, color: ColorManager.kTextDark),
                            ),
                          ),
                        ),

                        //
                      ],
                    ),

                    //
                    // spacer,
                    const SizedBox(height: 25),
                    CustomContainer(
                      onTap: () {
                        // Navigator.pushNamed(
                        //     context, RoutesManager.changeTransactionPin);
                      },
                      padding: const EdgeInsets.all(20),
                      borderRadiusSize: 32,
                      child: Row(
                        children: [
                          //
                          Image.asset(ImageManager.kTxnPinIcon, width: 44),
                          const SizedBox(width: 11),

                          //
                          Text("Set Transaction PIN",
                              style: get14TextStyle()
                                  .copyWith(fontWeight: FontWeight.w500)),
                          const Spacer(),
                          Icon(Icons.chevron_right,
                              color: ColorManager.kBarColor)
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    CustomContainer(
                      padding: const EdgeInsets.all(20),
                      borderRadiusSize: 32,
                      child: Row(
                        children: [
                          //
                          Image.asset(ImageManager.kFaceID, width: 44),
                          const SizedBox(width: 11),

                          //
                          Text("Allow Face ID",
                              style: get14TextStyle()
                                  .copyWith(fontWeight: FontWeight.w500)),
                          const Spacer(),
                          Transform.scale(
                            transformHitTests: false,
                            scale: .65,
                            child: CupertinoSwitch(
                              activeColor: ColorManager.kPrimary,
                              value: false,
                              onChanged: (value) async {
                                // try {
                                //   User user = await UserHelper.toggleTwoFAStatus();
                                //   userProvider.updateUser(user);
                                //   showCustomToast(
                                //       context: context,
                                //       description: "2FA toggled successfully",
                                //       type: ToastType.success);
                                // } catch (err) {
                                //   showCustomToast(
                                //       context: context, description: err.toString());
                                // }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                    CustomButton(
                      text: "Submit",
                      isActive: true,
                      onTap: () => Navigator.pop(context),
                      loading: false,
                    ),
                    //
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
