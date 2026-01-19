import 'dart:io';

import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_scaffold.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../../../core/enum.dart';
import '../../../../../core/helpers/user_helper.dart';
import '../../../../../core/model/core/country.dart';
import '../../../../../core/model/core/state.dart';
import '../../../../../core/model/core/user.dart';
import '../../../../../core/providers/user_provider.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../../misc/custom_components/custom_dialog_popup.dart';
import '../../../../misc/custom_components/custom_input_field.dart';
import '../../../../misc/custom_components/custom_selectable_btn_with_dot.dart';
import '../../../../misc/custom_snackbar.dart';
import '../../../../misc/popups/confirmation_popup.dart';
import '../../../../misc/select_country.dart';
import '../../../../misc/select_state.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final spacer = const SizedBox(height: 30);

  bool imageUploading = false;
  Future<void> updateProfileImage(
      ImageSource imageSource, UserProvider userProvider) async {
    Navigator.pop(context);
    try {
      File? file = await selectImage(imageSource);
      if (file == null) return;
      setState(() => imageUploading = true);
      String imageUrl = await uploadImageToImageKit(file);
      User user = await UserHelper.updateAvater(imageUrl);
      userProvider.updateUser(user);

      imageUploading = false;
      if (mounted) {
        setState(() {});
        showCustomToast(
          context: context,
          description: "Profile image uploaded successfully",
          type: ToastType.success,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => imageUploading = false);
        showCustomToast(
            context: context, description: e.toString(), type: ToastType.error);
      }
    }
  }

  final _formKey = GlobalKey<FormState>();

  ScrollController controller = ScrollController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneCodeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();

  Country? phoneCountry;
  Country? country;
  Gender? gender;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      setController(userProvider.user!);
    });

    super.initState();
  }

  setController(User user) {
    firstnameController.text = user.firstname ?? "";
    lastnameController.text = user.lastname ?? "";
    phoneCodeController.text = user.phone_code ?? "234";
    phoneController.text = user.phone ?? "";
    countryController.text = user.country ?? "";
    stateController.text = user.state ?? "";
    userNameController.text = user.username ?? "";

    if (user.gender?.toLowerCase() == "male") {
      gender = Gender.male;
    }

    if (user.gender?.toLowerCase() == "female") {
      gender = Gender.female;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    User user = userProvider.user;

    print('...avatar is ${user.avatar}');

    return Scaffold(
      backgroundColor: ColorManager.kWhite,
      appBar: CustomAppbar(title: 'Profile Settings'),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 24.h),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: imageUploading
                        ? SizedBox(
                            width: 75,
                            height: 50,
                            child: Center(
                              child: CircularProgressIndicator(
                                  color: ColorManager.kTextColor,
                                  strokeWidth: 2.4),
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {
                              await showDialogPopup(
                                context,
                                ConfirmationPopup(
                                  title: "Update profile image",
                                  desc:
                                      "Please take a picture of yourself or upload a picture from your gallery to continue",
                                  cancelText: "Camera",
                                  proceedText: "Gallery",
                                  onCancel: () async =>
                                      updateProfileImage(
                                          ImageSource.camera,
                                          userProvider),
                                  onProceed: () async =>
                                      updateProfileImage(
                                          ImageSource.gallery,
                                          userProvider),
                                ),
                                barrierDismissible: true,
                              );
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                const SizedBox(
                                    width: 55, height: 50),
                              user.avatar!=null && !user.avatar!.contains('null')?  SizedBox(
                                  width: 45,
                                  height: 45,
                                  child: Center(
                                    child: loadNetworkImage(
                                      
                                      borderRadius:
                                          BorderRadius.circular(
                                              50),
                                      user.avatar ?? "",
                                      width: 45,
                                      height: 45,
                                      fit: BoxFit.cover,
                                      strokeWidth: 2.4,
                                      strokeWidthColor:
                                          ColorManager.kTextColor,
                                    ),
                                  ),
                                ): CircleAvatar(
                                  radius: 52,
                                  backgroundColor: ColorManager.kGreyF8,
                                  child: Icon(Icons.person_outline, size: 50,color: ColorManager.kGreyE8,),
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: 0,
                                  child: SizedBox(
                                    height: 40,
                                    width: 45,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          decoration:
                                              BoxDecoration(
                                            borderRadius:
                                                BorderRadius
                                                    .circular(8),
                                            color: ColorManager
                                                .kPrimaryLight,
                                                border: Border.all(color: ColorManager.kGreyE8, width: 2)
                                          ),
                                          padding:
                                              const EdgeInsets
                                                  .all(5),
                                          child: Icon(
                                            LucideIcons.camera,
                                            size: 10,
                                            color: ColorManager
                                                .kPrimary,
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
                              
                CustomInputField(
                  formHolderName: "First Name",
                  hintText: "Enter your first name",
                  textInputAction: TextInputAction.next,
                  textEditingController: firstnameController,
                  validator: (val) => Validator.validateField(
                      fieldName: "First name", input: val),
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
                              
                //
                spacer,
                IgnorePointer(
                  child: CustomInputField(
                    formHolderName: "Email",
                    hintText: "Enter your email",
                    textInputAction: TextInputAction.next,
                    textEditingController: TextEditingController(
                        text: userProvider.user?.email ?? ""),
                  ),
                ),
                              
                spacer,
                CustomInputField(
                  maxLength: 10,
                  formHolderName: "Phone Number",
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Country? res =
                              await showCustomBottomSheet(
                                  context: context,
                                  screen: const SelectCountry());
                          if (res != null) {
                            phoneCountry = res;
                            phoneCodeController.text =
                                res.phone_code ?? "";
                            setState(() {});
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 4.5),
                              child: Text(
                                  " ${phoneCountry?.phone_code ?? "+${phoneCodeController.text}"}",
                                  style: get16TextStyle()
                                      .copyWith(
                                          fontWeight:
                                              FontWeight.w400)),
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
                      )
                    ],
                  ),
                  textInputAction: TextInputAction.next,
                  textEditingController: phoneController,
                  textInputType: TextInputType.number,
                  validator: (val) => Validator.validateField(
                      fieldName: "Phone Number", input: val),
                ),
                              
                spacer,
                CustomInputField(
                  formHolderName: "Username",
                  hintText: "Enter your username",
                  textInputAction: TextInputAction.next,
                  textEditingController: userNameController,
                  validator: (val) => Validator.validateField(
                      fieldName: "Username", input: val),
                ),
                              
                spacer,
                Text("Gender",
                    style: get14TextStyle().copyWith(
                        fontWeight: FontWeight.w300,
                        color: ColorManager.kFadedTextColor)),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomSelectableButtonsWithDot(
                          text: "Male",
                          selected: gender == Gender.male,
                          onTap: (_) => setState(
                            () => gender = Gender.male,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomSelectableButtonsWithDot(
                          text: "Female",
                          selected: gender == Gender.female,
                          onTap: (_) => setState(
                            () => gender = Gender.female,
                          ),
                        ),
                      ),
                              
                      //
                    ],
                  ),
                ),
                              
                //
                spacer,
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () async {
                          Country? res =
                              await showCustomBottomSheet(
                                  context: context,
                                  screen: const SelectCountry());
                              
                          if (res != null) {
                            countryController.text =
                                res.name ?? "";
                            country = res;
                            setState(() {});
                          }
                        },
                        child: IgnorePointer(
                          child: CustomInputField(
                            formHolderName: "Country",
                            hintText: "",
                            textEditingController:
                                TextEditingController(
                                    text: countryController
                                            .text.isEmpty
                                        ? "NA"
                                        : countryController.text),
                            textInputAction: TextInputAction.next,
                            suffixIcon: Icon(
                                CupertinoIcons.chevron_down,
                                size: 18,
                                color: ColorManager.kTextDark),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () async {
                          if (country == null) {
                            String msg = countryController
                                    .text.isEmpty
                                ? "You need to select a country."
                                    ""
                                : "Please reselect country to fetch related state.";
                              
                            showCustomToast(
                                context: context,
                                description: msg);
                            return;
                          }
                          AppState? res =
                              await showCustomBottomSheet(
                                  context: context,
                                  screen: SelectState(
                                      countryId:
                                          "${country?.id}"));
                              
                          if (res != null) {
                            stateController.text = res.name ?? "";
                            setState(() {});
                          }
                        },
                        child: IgnorePointer(
                          child: CustomInputField(
                            formHolderName: "State",
                            hintText: "",
                            textEditingController:
                                TextEditingController(
                                    text: stateController
                                            .text.isEmpty
                                        ? "NA"
                                        : stateController.text),
                            textInputAction: TextInputAction.done,
                            suffixIcon: Icon(
                                CupertinoIcons.chevron_down,
                                size: 18,
                                color: ColorManager.kTextDark),
                          ),
                        ),
                      ),
                    ),
                              
                    //
                  ],
                ),
                              
                spacer,
                CustomButton(
                  text: "Update",
                  isActive: true,
                  onTap: () {
                    if (!(_formKey.currentState?.validate() ??
                        false)) return;
                              
                    if (gender == null) {
                      showCustomToast(
                        context: context,
                        description:
                            "Please fill all the details.",
                      );
                      return;
                    }
                              
                    //
                    updateProfile(userProvider);
                  },
                  loading: updateLoading,
                ),
                              
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool updateLoading = false;
  Future<void> updateProfile(UserProvider userProvider) async {
    if (firstnameController.text.isEmpty ||
        lastnameController.text.isEmpty ||
        userNameController.text.isEmpty ||
        phoneCodeController.text.isEmpty ||
        phoneController.text.isEmpty ||
        countryController.text.isEmpty ||
        stateController.text.isEmpty) {
      showCustomToast(
        context: context,
        description: "Please fill all the details.",
        type: ToastType.error,
      );

      return;
    }

    setState(() => updateLoading = true);

    try {
      User user = await UserHelper.updateProfile(
        firstname: firstnameController.text,
        lastname: lastnameController.text,
        username: userNameController.text,
        phone_code: phoneCodeController.text,
        phone: phoneController.text,
        country: countryController.text,
        state: stateController.text,
        gender: enumToString(gender),
      );
      userProvider.updateUser(user);
      setController(user);

      if (mounted) {
        showCustomToast(
          context: context,
          description: "Profile update was successful",
          type: ToastType.success,
        );
      }
    } catch (err) {
      if (mounted) {
        showCustomToast(
            context: context,
            description: err.toString(),
            type: ToastType.error);
      }
    }

    setState(() => updateLoading = false);
  }
}
