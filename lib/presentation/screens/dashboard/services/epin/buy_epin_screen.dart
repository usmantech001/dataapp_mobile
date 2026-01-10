import 'package:dataplug/core/model/core/review_model.dart';
import 'package:dataplug/core/providers/betting_controller.dart';
import 'package:dataplug/core/providers/electricity_controller.dart';
import 'package:dataplug/core/providers/epin_controller.dart';
import 'package:dataplug/core/utils/custom_verifying.dart';
import 'package:dataplug/core/utils/formatters.dart';
import 'package:dataplug/core/utils/review_bottomsheet.dart';
import 'package:dataplug/core/utils/summary_info.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/amount_suggestion.dart';
import 'package:dataplug/presentation/misc/custom_components/amount_textfield.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_input_field.dart';
import 'package:dataplug/presentation/misc/custom_components/meter_selector.dart';
import 'package:dataplug/presentation/misc/custom_components/summary_container.dart';
import 'package:dataplug/presentation/misc/custom_components/summary_item.dart';
import 'package:dataplug/presentation/misc/custom_snackbar.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class BuyEpinScreen extends StatefulWidget {
  const BuyEpinScreen({super.key});

  @override
  State<BuyEpinScreen> createState() => _BuyEpinScreenState();
}

class _BuyEpinScreenState extends State<BuyEpinScreen> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //context.read<BettingController>().clearValues();
    });
  }
List<String> jambTypes = [
    'UTME',
    'DE'
  ];
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        appBar: CustomAppbar(title: 'Buy E-PIN'),
        bottomNavigationBar: CustomBottomNavBotton(
            text: 'Continue',
            onTap: () {
              final controller = context.read<EpinController>();
              if (controller.numberErrMsg != null 
              //|| controller.meterNumberController.text.isEmpty
              ) {
                showCustomToast(
                  context: context,
                  // meesage
                  description:
                      controller.numberErrMsg??"",
                );
              }
      
              
      
               final summaryItems = [
                SummaryItem(title: 'EPin Provider', name: controller.selectedProvider?.name ?? ""),
                SummaryItem(title: 'EPin Product', name: controller.selectedProduct?.name ?? ""),
                SummaryItem(
                  title: 'Candidate Number',
                  name: controller.numberController.text.trim(),
                  
                ),
                
                SummaryItem(
                    title: 'Amount', name: formatCurrency(num.parse(controller.selectedProduct?.amount.toString()??'0'), decimal: 0)),
                SummaryItem(
                    title: 'Service Charge', name: "₦0.00", hasDivider: true,),    
                SummaryItem(
                    title: 'Total Amount', name: formatCurrency(num.parse(controller.selectedProduct?.amount.toString()??'0'), decimal: 0)),     
              ];
              final reviewDetails = ReviewModel(
                  summaryItems: summaryItems,
                  amount: formatUseableAmount(controller.selectedProduct?.amount.toString()??""),
                  shortInfo: 'Epin',
                  providerName: controller.selectedProvider?.name,
                  logo: controller.selectedProvider?.logo,
                  onChangeProvider: () => Navigator.pushNamed(context, RoutesManager.electricityProviders,),
                  onPinCompleted: (pin) async {
                    print('...on pin completed $pin');
                    controller.purchaseEPin(pin,  onSuccess: (transactionInfo) {
                        final items = getSummaryItems(
                            transactionInfo, TransactionType.epin);
                        final review = ReceiptModel(
                            summaryItems: items,
                            amount: transactionInfo.amount.toString(),
                            shortInfo: 'EPin'
                            );
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            RoutesManager.successful,
                            (Route<dynamic> route) => false,
                            arguments: review);
                      }, onError: (error) {
                      showCustomErrorTransaction(context: context, errMsg: error);
                    } ,);
                   
                  });
             showReviewBottomShhet(context, reviewDetails: reviewDetails);
      
      
            }),
        body: Consumer<EpinController>(
            builder: (context, controller, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(left: 15, right: 15, top: 24, bottom: 30),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus(); // dismisses keyboard
              },
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                 ReviewHeaderContainer(
                providerType: "EPin",
                providerName: controller.selectedProvider?.name??"",
                logo: controller.selectedProvider?.logo??"",
                
                onChange: (){},
              ),
             if(controller.selectedProvider?.code == 'jamb') Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jamb Type',
                      style: get18TextStyle()
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    Gap(10),
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                            child: MeterSelector(
                                meterType: jambTypes[0],
                                isSelected: controller.isUtme,
                                onTap: () {
                              controller.toggleJambType();
                                })),
                        Expanded(
                            child: MeterSelector(
                                meterType: jambTypes[1],
                                isSelected: !controller.isUtme,
                                onTap: () {
                                  controller.toggleJambType();
                                })),
                      ],
                    ),
                  ],
                ),
                  Column(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomInputField(
                        formHolderName: 'Candidate Number',
                        hintText: 'Enter Candidate Number',
                        focusNode: controller.focusNode,
                        textEditingController:
                            controller.numberController,
                      ),
                      controller.verifyingNumber
                          ? CustomVerifying(text: 'Verifying jamb number')
                          : !controller.verifyingNumber &&
                                  controller.numberErrMsg != null
                              ? Text(
                                  controller.numberErrMsg!,
                                  style: get14TextStyle()
                                      .copyWith(color: ColorManager.kError),
                                )
                              : SizedBox(),
                    ],
                  ),
                  
                  AmountTextField(
                    controller: TextEditingController(text: formatCurrency(num.parse(controller.selectedProduct?.amount.toString()??'0'), decimal: 0)),
                    readOnly: true,
                    onChanged: (value) {
                      
                    },
                  ),
                  
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}