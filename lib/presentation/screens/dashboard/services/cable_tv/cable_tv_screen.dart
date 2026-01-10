import 'package:dataplug/core/model/core/custom_network_image.dart';
import 'package:dataplug/core/model/core/review_model.dart';
import 'package:dataplug/core/providers/cable_tv_controller.dart';
import 'package:dataplug/core/utils/app-loader.dart';
import 'package:dataplug/core/utils/custom_verifying.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/core/utils/summary_info.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_input_field.dart';
import 'package:dataplug/presentation/misc/custom_components/summary_item.dart';
import 'package:dataplug/presentation/misc/custom_snackbar.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class CableTvScreen extends StatefulWidget {
  const CableTvScreen({super.key});

  @override
  State<CableTvScreen> createState() => _CableTvScreenState();
}

class _CableTvScreenState extends State<CableTvScreen> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_){
      context.read<CableTvController>().clearData();
    });
  }
  @override
  Widget build(BuildContext context) {
   // final cableController = context.watch<CableTvController>();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        appBar: CustomAppbar(title: 'Pay TV/Cable'),
        bottomNavigationBar:
            CustomBottomNavBotton(text: 'Continue', onTap: () {
              final cableController = context.read<CableTvController>();
              if (cableController.decoderNumberErrMsg != null 
            //|| controller.meterNumberController.text.isEmpty
            ) {
              showCustomToast(
                context: context,
                // meesage
                description:
                    "Merchant not verified. Please check the meter number and try again.",
              );
              return;
            }

            if (cableController.decoderNumberController.text.isEmpty ) {
              showCustomToast(
                context: context,
                // meesage
                description: "Please enter your decoder number",
              );
              return;
            }

             final summaryItems = [
              SummaryItem(title: 'TV/Cables Provider', name: cableController.selectedProvider?.name ?? ""),
              SummaryItem(
                title: 'Package Type',
                name:  "${cableController.cableTvTypes[cableController.currentTabIndex]} Package",
                
              ),
              SummaryItem(
                  title: 'Duration', name: "${cableController.selectedPlan!.duration} Month",
                  hasDivider: true,
                  ),
                   SummaryItem(
                title: 'Decoder Number',
                name:  cableController.decoderNumberController.text.trim(),
                
              ),
            ];
       
            final reviewModel = ReviewModel(
                summaryItems: summaryItems,
                amount: cableController.selectedPlan!.amount.toString(),
                shortInfo: 'Pay TV/Cable Package',
                providerType: 'TV/Cable',
                providerName: cableController.selectedProvider?.name,
                logo: cableController.selectedProvider?.logo,
                onChangeProvider: () => Navigator.pushNamed(context, RoutesManager.electricityProviders,),
                onPinCompleted: (pin) async {
                  print('...on pin completed $pin');
                  displayLoader(context);
                  cableController.purchaseCableTv(pin, onSuccess: (transactionInfo) {
                    popScreen();
                        final items = getSummaryItems(
                            transactionInfo, TransactionType.cable);
                        final review = ReceiptModel(
                            summaryItems: items,
                            amount: transactionInfo.amount.toString(),
                            shortInfo:
                                transactionInfo.meta.provider?.name ?? "");
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            RoutesManager.successful,
                            (Route<dynamic> route) => false,
                            arguments: review);
                      }, onError: (error) {
                    popScreen();
                  showCustomErrorTransaction(context: context, errMsg: error);
                  } ,);
                 
                });
            Navigator.pushNamed(context, RoutesManager.reviewDetails,
                arguments: reviewModel);
            }),
        body: Consumer<CableTvController>(
          builder: (context, cableController, child) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(left: 15, right: 15, top: 24, bottom: 30),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(bottom: 24.h),
                    decoration: BoxDecoration(
                      color: ColorManager.kWhite,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Data Package',
                          style: get16TextStyle()
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        Gap(24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CustomNetworkImage(
                                    imageUrl:
                                        cableController.selectedProvider!.logo ??
                                            ""),
                                Gap(12),
                                SizedBox(
                                  width: 200,
                                  child: Text(
                                    cableController.selectedPlan!.name,
                                    style: get14TextStyle()
                                        .copyWith(fontWeight: FontWeight.w400),
                                  ),
                                )
                              ],
                            ),
                            InkWell(
                                onTap: () {},
                                child: Text(
                                  'Change',
                                  style: get14TextStyle().copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: ColorManager.kPrimary),
                                ))
                          ],
                        ),
                        Gap(8.h),
                        Text(
                          '${cableController.selectedPlan!.duration} Month',
                          style: get16TextStyle()
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  CustomInputField(
                    formHolderName: 'Decoder Number',
                    hintText: 'Enter decoder no.',
                    focusNode: cableController.focusNode,
                    textEditingController: cableController.decoderNumberController,
                  ),
                  cableController.verifyingDecoderNumber
                      ? CustomVerifying(text: 'Verifying decoder number')
                      : !cableController.verifyingDecoderNumber &&
                              cableController.decoderNumberErrMsg != null
                          ? Text(
                              cableController.decoderNumberErrMsg!,
                              style: get14TextStyle()
                                  .copyWith(color: ColorManager.kError),
                            )
                          : SizedBox(),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}
