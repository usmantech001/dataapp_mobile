import 'package:dataplug/core/providers/wallet_controller.dart';
import 'package:dataplug/core/utils/app-loader.dart';
import 'package:dataplug/core/utils/custom_image.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_input_field.dart';
import 'package:dataplug/presentation/misc/custom_snackbar.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class VerifyBvnNinScreen extends StatefulWidget {
  const VerifyBvnNinScreen({super.key});

  @override
  State<VerifyBvnNinScreen> createState() => _VerifyBvnNinScreenState();
}

class _VerifyBvnNinScreenState extends State<VerifyBvnNinScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Generate Account'),
      bottomNavigationBar:
          CustomBottomNavBotton(text: 'Continue', onTap: () {
            final controller = context.read<WalletController>();
            if(controller.firstNameController.text.isEmpty|| controller.lastNameController.text.isEmpty || controller.bvnController.text.isEmpty || controller.dobController.text.isEmpty){
              showCustomToast(context: context, description: 'Pleas fill all the field');
              return;
            }
            displayLoader(context);
            controller.validateID(onSuccess: (){
              
              popAndPushScreen(RoutesManager.verifyBvnNinOtp);
            }, onError: (error) {
              popScreen();
              showCustomToast(context: context, description: error);
            },);
            
          }),
      body: Consumer<WalletController>(
        builder: (context, controller, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 24.h),
            child: Column(
              spacing: 24.h,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                  decoration: BoxDecoration(
                      color: ColorManager.kWhite,
                      borderRadius: BorderRadius.circular(16.r)),
                  child: Column(
                    spacing: 16.h,
                    children: [
                      CustomInputField(
                        formHolderName: 'First Name',
                        hintText: 'Enter your first name',
                        textEditingController: controller.firstNameController,
                      ),
                      CustomInputField(
                        formHolderName: 'Last Name',
                        hintText: 'Enter your last name',
                        textEditingController: controller.lastNameController,
                      ),
                      CustomInputField(
                        formHolderName: 'BVN',
                        hintText: 'Enter your BVN',
                        textEditingController: controller.bvnController,
                      ),
                      CustomInputField(
                        formHolderName: 'Date of Birth',
                        hintText: 'dd/mm/yy',
                        readOnly: true,
                        textEditingController: controller.dobController,
                        onTap: () async{
                          final date = await showDatePicker(
                                context: context,
                                locale: const Locale('en', 'GB'),
                                firstDate: DateTime.now()
                                    .subtract(Duration(days: 365 * 100)),
                                lastDate: DateTime.now()
                                    .subtract(Duration(days: 365 * 18)),
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: ColorManager
                                            .kPrimary, // Header background and selected date
                                        onPrimary: Colors.white, // Text on header
                                        surface:
                                            Colors.white, // Calendar background
                                        onSurface: Colors.black, // Calendar text
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if(date!=null){
                                String dob = "${date.year}-${date.month}-${date.day}";
                                controller.onSelectDOB(dob);
                              }
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                  decoration: BoxDecoration(
                      color: ColorManager.kWhite,
                      borderRadius: BorderRadius.circular(16.r)),
                  child: Column(
                    spacing: 12.h,
                    children: [
                      Row(
                        spacing: 16.w,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.sp),
                            decoration: BoxDecoration(
                                color: ColorManager.kPrimary.withValues(alpha: .08),
                                borderRadius: BorderRadius.circular(10.r)),
                            child: svgImage(imgPath: 'assets/icons/verify.svg'),
                          ),
                          Text(
                            'Why We Ask for Your BVN',
                            style: get16TextStyle()
                                .copyWith(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      Text(
                        'Your BVN helps us confirm your identity quickly and safely. We can only view your name, date of birth, and the phone number linked to your BVN. \n\nWe cannot access your bank balance, transaction history, or any private financial details. Your data stays protected.',
                        style: get14TextStyle().copyWith(
                            color: ColorManager.kGreyColor.withValues(alpha: .7)),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        }
      ),
    );
  }
}
