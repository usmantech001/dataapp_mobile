import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../core/enum.dart';
import '../../../../core/helpers/service_helper.dart';
import '../../../misc/color_manager/color_manager.dart';
import '../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../misc/custom_components/custom_btn.dart';
import '../../../misc/custom_components/custom_container.dart';
import '../../../misc/custom_components/custom_input_field.dart';
import '../../../misc/custom_snackbar.dart';
import '../../../misc/route_manager/routes_manager.dart';
import '../../../misc/style_manager/styles_manager.dart';
import 'verify_identity_otp.dart';

class GenerateAccountBottomSheet extends StatefulWidget {
  @override
  _GenerateAccountBottomSheetState createState() =>
      _GenerateAccountBottomSheetState();
}

class _GenerateAccountBottomSheetState
    extends State<GenerateAccountBottomSheet> {
  TextEditingController _bvnController = TextEditingController();
  TextEditingController _fNameController = TextEditingController();
  TextEditingController _lNameController = TextEditingController();

  DateTime? dateOfBirth;
  bool btnLoading = false;
  String _selectedIdType = 'bvn';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * .9,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: ColorManager.kFormHintText,
                  ),
                ),
              ],
            ),
            CustomContainer(
              margin: const EdgeInsets.only(top: 0),
              padding: EdgeInsets.all(16),
              width: double.infinity,
              header: Text(
                "GENERATE ACCOUNT",
                style: get14TextStyle().copyWith(
                  color: ColorManager.kTextDark.withOpacity(.7),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Text(
                        "Kindly provide your BVN or NIN",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),
                    Gap(16),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    //   child: DropdownButtonFormField<String>(
                    //     decoration: InputDecoration(
                    //       labelText: 'Select ID Type',
                    //       border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //     ),
                    //     value: _selectedIdType,
                    //     items: [
                    //       DropdownMenuItem(value: 'bvn', child: Text('BVN')),
                    //       DropdownMenuItem(value: 'nin', child: Text('NIN')),
                    //     ],
                    //     onChanged: (value) {
                    //       setState(() {
                    //         _selectedIdType = value ?? 'bvn';
                    //       });
                    //     },
                    //   ),
                    // ),
                    // Gap(16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CustomInputField(
                        formHolderName: "First Name",
                        hintText: "Enter First Name",
                        textEditingController: _fNameController,
                        textInputType: TextInputType.name,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    Gap(16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CustomInputField(
                        formHolderName: "Last Name",
                        hintText: "Enter Last Name",
                        textEditingController: _lNameController,
                        textInputType: TextInputType.name,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    Gap(16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CustomInputField(
                        formHolderName:
                            // _selectedIdType == 'bvn' ?

                            "BVN",
                        // : "NIN",
                        hintText:
                            // _selectedIdType == 'bvn'
                            //     ?
                            "Enter BVN",
                        // : "Enter NIN",
                        textEditingController: _bvnController,
                        textInputType: TextInputType.number,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    Gap(16),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: CustomInputField(
                        formHolderName: "Date Of Birth",
                        hintText: "Select your date of birth",
                        textEditingController: TextEditingController(
                          text: dateOfBirth == null
                              ? ""
                              : "${dateOfBirth?.year}-${dateOfBirth?.month}-${dateOfBirth?.day}",
                        ),
                        textInputAction: TextInputAction.done,
                        readOnly: true,
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now()
                                .subtract(Duration(days: 365 * 100)),
                            lastDate: DateTime.now()
                                .subtract(Duration(days: 365 * 18)),
                          );
                          if (date != null) {
                            setState(() {
                              dateOfBirth = date;
                            });
                          }
                        },
                      ),
                    ),
                    Gap(16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CustomButton(
                        text: "Generate Account",
                        isActive: true,
                        onTap: () async {
                          try {
                            if (!(_formKey.currentState?.validate() ?? false)) {
                              return showCustomToast(
                                context: context,
                                description: "Please fill all required fields",
                              );
                            }

                            if (dateOfBirth == null) {
                              return showCustomToast(
                                context: context,
                                description: "Please select your date of birth",
                              );
                            }

                            setState(() => btnLoading = true);

  
                            // await ServicesHelper.validateIdentification(
                            await ServicesHelper.validateBVN(
                              number: _bvnController.text,
                              dob:
                                  "${dateOfBirth?.year}-${dateOfBirth!.month < 10 ? "0" : ""}${dateOfBirth?.month}-${dateOfBirth!.day < 10 ? "0" : ""}${dateOfBirth?.day}",
                              lName: _lNameController.text,
                              fName: _fNameController.text,
                              // type: _selectedIdType,
                            ).then((value) async {
                              if (value["bvn_validated"] &&
                                  value['bvn_verified']) {
                                showCustomToast(
                                  context: context,
                                  description: "BVN validated successfully",
                                  type: ToastType.success,
                                );

//                                 await ServicesHelper.generateVirtualAccount()
//                                     .then((value) {
//                                   // print("object");

//                                   showCustomToast(
//                                       context: context,
//                                       description:
//                                           "Virtual account generated successfully",
//                                       type: ToastType.success);
// //  Navigator.pop(context);
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  RoutesManager.dashboardWrapper,
                                  (Route<dynamic> route) => false,
                                );

//                                 if (mounted) setState(() => btnLoading = false);
//                                   // Navigator.pop(context);
//                                 });

                                // showCustomBottomSheet(
                                //   context: context,
                                //   screen: VerifyBVNOTPView(
                                //     type: _selectedIdType,
                                //   ),
                                // );
                              } else {
                                if (mounted) setState(() => btnLoading = false);
                                // Handle the false case (maybe show an error, stop navigation, etc.)
                                showCustomToast(
                                  context: context,
                                  description: "Unable to validate BVN",
                                  type: ToastType.error,
                                );
                                return;
                              }
                            }).catchError((error) {
                              if (mounted) setState(() => btnLoading = false);
                              showCustomToast(
                                context: context,
                                description: "$error",
                                type: ToastType.error,
                              );
                            });
                          } catch (_) {
                            showCustomToast(
                              context: context,
                              description: "$_",
                              type: ToastType.error,
                            );
                            if (mounted) setState(() => btnLoading = false);
                          }
                        },
                        loading: btnLoading,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(40.0),
                          Text(
                            'Why We Need your ${_selectedIdType.toUpperCase()}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          Gap(16.0),
                          Text(
                            'We use your $_selectedIdType to confirm your identity. When you provide it, we can only access your name, date of birth, and the phone number linked to it.',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Gap(24.0),
                          Text(
                            'We cannot access your bank accounts, transaction history, or any other sensitive financial information.',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(50),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
