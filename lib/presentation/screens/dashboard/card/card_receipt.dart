import 'package:dataplug/core/constants.dart';
import 'package:dataplug/core/model/core/card_data.dart' show CardData;
import 'package:dataplug/core/model/core/service_txn.dart';
import 'package:dataplug/core/utils/utils.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_container.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_scaffold.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../core/enum.dart';
import '../../../../core/model/core/card_transactions.dart';
import '../../../../gen/assets.gen.dart';
import '../../../misc/custom_components/custom_back_icon.dart';
import '../../../misc/custom_components/custom_key_value_state.dart';
import '../../../misc/custom_snackbar.dart';
import '../../../misc/image_manager/image_manager.dart';
import '../../../misc/route_manager/routes_manager.dart';

class CardHistoryDetails extends StatefulWidget {
  final CardTransaction param;
  const CardHistoryDetails({super.key, required this.param});

  @override
  State<CardHistoryDetails> createState() => _CardHistoryDetailsState();
}

class _CardHistoryDetailsState extends State<CardHistoryDetails> {
  ScrollController controller = ScrollController();
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    
    return CustomScaffold(
      backgroundColor: ColorManager.kPrimary,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            decoration: BoxDecoration(
                color: ColorManager.kWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
            child: Column(
              children: [
                Screenshot(
                  controller: screenshotController,
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
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 15),
                                child: BackIcon(
                                  onTap: () =>
                                      Navigator.pop(context),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Image.asset(Assets.images.kVirtualCard2.path,
                                      width: 43),
                                  const SizedBox(height: 10),
                                  Text( widget.param.narration.contains("creat") ? "Virtual Card Creation Receipt": "Transaction Receipt",
                                      textAlign: TextAlign.center,
                                      style: get18TextStyle()),
                                ],
                              ),
                            ),
                            const Expanded(flex: 1, child: SizedBox()),
                          ],
                        ),
                        customDivider(
                          height: 1,
                          margin: const EdgeInsets.only(top: 16, bottom: 26),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0, bottom: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // ,
                              const SizedBox(width: 4),
                              Text(
                                  "${widget.param.currency} ${widget.param.narration}",
                                  textAlign: TextAlign.center,
                                  style: get14TextStyle().copyWith(
                                      color: ColorManager.kTextDark7)),
                            ],
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: RichText(
                                text: TextSpan(
                                  style: get26TextStyle()
                                      .copyWith(fontWeight: FontWeight.w900),
                                  children: [
                                    TextSpan(text: formatNumber(widget.param.meta.feeDetails.baseAmount)),
                                    TextSpan(
                                      text: " ${widget.param.currency}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 11),
                            Icon(
                              getIconData(),
                              color: ColorManager.getStatusTextColor(
                                  Status.successful),
                              size: 17,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              capitalizeFirstString(
                                  enumToString(Status.successful)),
                              style: get14TextStyle().copyWith(
                                fontWeight: FontWeight.w500,
                                color: ColorManager.getStatusTextColor(
                                    Status.successful),
                              ),
                            )
                          ],
                        ),
                        //

                        ListView(
                          shrinkWrap: true,
                          controller: controller,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          children: children(),
                        ),
                        Gap(24),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData getIconData() {
    switch (Status.successful) {
      case Status.successful:
        return CupertinoIcons.check_mark_circled_solid;

      case Status.failed:
        return Icons.cancel;

      case Status.reversed:
        return CupertinoIcons.arrow_2_circlepath_circle_fill;

      case Status.pending:
        return CupertinoIcons.exclamationmark_circle_fill;

      default:
        return CupertinoIcons.exclamationmark_circle_fill;
    }
  }

  //
  List<Widget> children() {
    var res = <Widget>[];

    res.addAll(
      [
        CustomContainer(
          margin: const EdgeInsets.only(
            left: Constants.kHorizontalScreenPadding,
            right: Constants.kHorizontalScreenPadding,
            top: 26,
          ),
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          header: Text(
            "DETAILS",
            style: get14TextStyle().copyWith(color: ColorManager.kTextDark7),
          ),
          child: Column(
            children: [
              CustomKeyValueState(
                title: "Transaction Ref",
                desc: widget.param.reference,
                descW: GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: widget.param.reference));

                    showCustomToast(
                        context: context,
                        description: "Transaction ID copied to clipbaord",
                        type: ToastType.success);
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      spacing: 10,
                      children: [
                        Text(widget.param.reference, style: get12TextStyle()),
                        Icon(
                          Icons.copy,
                          size: 12,
                          color: ColorManager.kPrimary,
                        ),
                      ]),
                ),
              ),

              CustomKeyValueState(
                title: "Transaction Date",
                desc: DateFormat('dd/MM/yyyy').format(widget.param.date),
              ),

              CustomKeyValueState(
                title: "Transaction Time",
                desc: DateFormat('hh:mm a').format(widget.param.date),
              ),
              // CustomKeyValueState(
              //   title: "Card Holder Name",
              //   desc: "",
              // ),
              // CustomKeyValueState(
              //   title: "Card Issuer",
              //   desc: widget.param.type
              // ),
       
              CustomKeyValueState(
                title: widget.param.narration.contains("creat") ?  "Card Creation Fee" : "Amount" ,
                desc: formatCurrency(widget.param.amount, code: widget.param.currency),
              ),
                         CustomKeyValueState(
                title: "Service Charge" ,
                desc: formatCurrency(widget.param.meta.feeDetails.feeAmount, code:widget.param.narration.contains("creat") ? widget.param.currency:  widget.param.meta.feeDetails.feeCurrency),
              ),
            CustomKeyValueState(
                title: "Total" ,
                desc: formatCurrency(widget.param.meta.feeDetails.totalAmount, code: widget.param.narration.contains("creat") ? widget.param.currency:  widget.param.meta.feeDetails.feeCurrency),
              ),

            ],
          ),
        ),
        Gap(24),
      ],
    );
    return res;
  }
}
