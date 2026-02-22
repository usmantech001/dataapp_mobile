import 'package:dataplug/core/model/core/custom_network_image.dart';
import 'package:dataplug/core/model/core/review_model.dart';
import 'package:dataplug/core/providers/data_controller.dart';
import 'package:dataplug/core/providers/general_controller.dart';
import 'package:dataplug/core/utils/app-loader.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/core/utils/review_bottomsheet.dart';
import 'package:dataplug/core/utils/summary_info.dart';
import 'package:dataplug/core/utils/utils.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_bottom_sheet.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_input_field.dart';
import 'package:dataplug/presentation/misc/custom_components/summary_item.dart';
import 'package:dataplug/presentation/misc/custom_snackbar.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/select_contact.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:dataplug/presentation/screens/dashboard/services/airtime/buy_airtime_1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class BuyRecommendedDataScreen extends StatefulWidget {
  const BuyRecommendedDataScreen({super.key});

  @override
  State<BuyRecommendedDataScreen> createState() => _BuyRecommendedDataScreenState();
}

class _BuyRecommendedDataScreenState extends State<BuyRecommendedDataScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<DataController>().clearData();
  }
  @override
  Widget build(BuildContext context) {
    
    return Consumer<DataController>(builder: (context, controller, child) {
      return Scaffold(
        appBar: CustomAppbar(title: 'Buy Data'),
        bottomNavigationBar: CustomBottomNavBotton(
            text: 'Proceed',
            onTap: () {
              if (controller.phoneNumberController.text.isEmpty) {
                showCustomToast(
                    context: context,
                    description: 'Please enter a phone number');
                return;
              }

              final generalController = context.read<GeneralController>();
              num serviceCharge = generalController.serviceCharge?.data ?? 0;
              num totalAmount = calculateTotalAmount(
                  amount: controller.selectedRecommendedPlan!.amount.toString(),
                  charge: serviceCharge);
              final summaryItems = [
                SummaryItem(
                    title: 'Network',
                    name: controller.selectedRecommendedPlan?.provider?.name ?? ""),
                SummaryItem(
                  title: 'Phone number',
                  name: controller.phoneNumberController.text.trim(),
                  hasDivider: true,
                ),
                if (serviceCharge != 0)
                  SummaryItem(
                    title: 'Service Charge',
                    name: formatCurrency(serviceCharge),
                  ),
                SummaryItem(title: 'Amount', name: formatCurrency(totalAmount)),
              ];
              final reviewDetails = ReviewModel(
                  summaryItems: summaryItems,
                  amount: controller.selectedRecommendedPlan!.amount.toString(),
                  providerName: controller.selectedRecommendedPlan?.provider?.name,
                  logo: controller.selectedRecommendedPlan?.logo,
                  shortInfo: '${controller.selectedRecommendedPlan?.provider?.name ?? ""} Data',
                  onPinCompleted: (pin) async {
                    displayLoader(context);
                    controller.buyData(
                      pin,
                      onSuccess: (transactionInfo) {
                        popScreen();
                        final items = getSummaryItems(
                             transInfo:  transactionInfo, TransactionType.data);
                        final review = ReceiptModel(
                            summaryItems: items,
                            amount: transactionInfo.amount.toString(),
                            shortInfo:
                                '${transactionInfo.meta.provider?.name ?? ""} Airtime');
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            RoutesManager.successful,
                            (Route<dynamic> route) => false,
                            arguments: review);
                      },
                      onError: (error) {
                        popScreen();
                        showCustomErrorTransaction(
                            context: context, errMsg: error);
                      },
                    );
                  });
              showReviewBottomShhet(context, reviewDetails: reviewDetails);
            }),
        body: Consumer<DataController>(builder: (context, controller, child) {
          return SingleChildScrollView(
            padding:
                EdgeInsetsGeometry.symmetric(horizontal: 15.w, vertical: 24.h),
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
                        'Selected Package',
                        style: get16TextStyle()
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      Gap(15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CustomNetworkImage(
                                  imageUrl:
                                      controller.selectedRecommendedPlan!.logo ??
                                          ""),
                              Gap(12),
                              SizedBox(
                                width: 200,
                                child: Text(
                                  controller.selectedRecommendedPlan!.name,
                                  style: get14TextStyle()
                                      .copyWith(fontWeight: FontWeight.w400),
                                ),
                              )
                            ],
                          ),
                         
                        ],
                      ),
                      Gap(8.h),
                      Text(
                        '${controller.selectedRecommendedPlan!.duration} Days',
                        style: get16TextStyle()
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                CustomInputField(
                  formHolderName: "Phone Number",
                  textInputAction: TextInputAction.next,
                  textEditingController: controller.phoneNumberController,
                  textInputType: TextInputType.number,
                  suffixIcon: InkWell(
                    onTap: () async {
                      bool permissionGranted =
                          await FlutterContacts.requestPermission();
                      if (permissionGranted) {
                        Contact? res = await showCustomBottomSheet(
                          context: context,
                          isDismissible: true,
                          screen: SelectFromContactWidget(),
                        );
                        if (res != null) {
                          print('...response from contact is $res');
                          // phoneController.text = res
                          //     .phones.first.number
                          //     .replaceAll(" ", "")
                          //     .replaceAll("(", "")
                          //     .replaceAll(")", "")
                          //     .replaceAll("+234", "0")
                          //     .replaceAll("-", "")
                          //     .trim();
                          //setState(() {});
                        }
                      }
                    },
                    child: Icon(
                      Icons.person,
                      size: 24,
                      color: ColorManager.kPrimary,
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ],
            ),
          );
        }),
      );
    });
  }
}
