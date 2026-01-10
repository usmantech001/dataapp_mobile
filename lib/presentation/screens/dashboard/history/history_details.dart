import 'dart:developer';
import 'dart:io';

import 'package:dataplug/core/constants.dart';
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
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/enum.dart';
import '../../../../gen/assets.gen.dart';
import '../../../misc/custom_components/custom_back_icon.dart';
import '../../../misc/custom_components/custom_key_value_state.dart';
import '../../../misc/custom_snackbar.dart';
import '../../../misc/image_manager/image_manager.dart';
import '../../../misc/route_manager/routes_manager.dart';

class HistoryDetails extends StatefulWidget {
  final ServiceTxn param;
  const HistoryDetails({super.key, required this.param});

  @override
  State<HistoryDetails> createState() => _HistoryDetailsState();
}

class _HistoryDetailsState extends State<HistoryDetails> {
  ScrollController controller = ScrollController();
  ScreenshotController screenshotController = ScreenshotController();

  Future<void> takeScreenshotAndShare() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = File('${directory.path}/screenshot.png');

      final imageBytes = await screenshotController.capture();
      if (imageBytes == null) return;

      await imagePath.writeAsBytes(imageBytes);

      Share.shareXFiles([XFile(imagePath.path)], text: "Check this out!");
    } catch (e) {
      print("Error capturing screenshot: $e");
    }
  }

  void reportTransaction(Map<String, dynamic> transactionDetails) async {
    final String subject = "Transaction Issue Report";
    final String email =
        "support@datasplug.com"; // Replace with actual support email

    final String transactionBody = "Transaction Report:\n\n"
        "Transaction ID: ${widget.param.reference}\n"
        "Remark: ${widget.param.remark}\n"
        "Status: ${widget.param.status}\n"
        "Purpose: ${widget.param.purpose}\n"
        "Type: ${widget.param.type}\n"
        "Transaction Date: ${formatDateSlash(widget.param.createdAt)}\n"
        "Transaction Time: ${getTimeFromDate(widget.param.createdAt)}\n"
        "Amount: ${formatCurrency(widget.param.amount)}\n"
        "Please review and assist with this transaction issue.";

    // Encode the subject and body
    // final String encodedSubject = Uri.encodeComponent(subject);
    // final String encodedBody = Uri.encodeComponent(transactionBody);

    final Uri emailUri = Uri.parse(
        "mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(transactionBody)}");

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch email app");
    }
  }

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
                                child: BackIcon(onTap: () {
                                  Navigator.pop(
                                    context,
                                    // RoutesManager.dashboardWrapper
                                    // (Route<dynamic> route) => false
                                  );
                                  // Navigator.pop(context)
                                  // Navigator.pushNamedAndRemoveUntil(
                                  //   context,
                                  //   RoutesManager.dashboardWrapper,
                                  //   (route) => false,
                                  // );
                                }),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Image.asset(ImageManager.kTxnReceiptIcon,
                                      width: 43),
                                  const SizedBox(height: 10),
                                  Text("Transaction Receipt",
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
                              (widget.param.purpose ==
                                          ServicePurpose.withdrawal ||
                                      widget.param.purpose ==
                                          ServicePurpose.deposit ||
                                      widget.param.purpose ==
                                          ServicePurpose.transfer)
                                  ? const SizedBox()
                                  : loadNetworkImage(
                                      widget.param.meta.provider?.logo??
                                          Assets.images.dataplugIcon.path,
                                      borderRadius: BorderRadius.circular(50),
                                      width: 24),
                              const SizedBox(width: 4),
                              Text(
                                  widget.param.provider.toLowerCase() == 'sudo'
                                      ? capitalizeFirstString(
                                          widget.param.remark)
                                      : ServiceTxn.serviceEnumToString(
                                          widget.param.purpose),
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
                                    TextSpan(
                                        text: formatNumber(
                                            widget.param.totalAmount)),
                                    const TextSpan(
                                      text: " NGN",
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
                                  widget.param.status),
                              size: 17,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              capitalizeFirstString(
                                  enumToString(widget.param.status)),
                              style: get14TextStyle().copyWith(
                                fontWeight: FontWeight.w500,
                                color: ColorManager.getStatusTextColor(
                                    widget.param.status),
                              ),
                            )
                          ],
                        ),
                        //

                        ListView(
                          shrinkWrap: true,
                          controller: controller,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          children: children(widget.param.purpose),
                        ),
                        Gap(24),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(color: ColorManager.kWhite),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          takeScreenshotAndShare();
                        },
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorManager.kPrimary),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 10,
                            children: [
                              Text("Share",
                                  style: get18TextStyle()
                                      .copyWith(color: ColorManager.kWhite)),
                              Icon(Icons.share,
                                  size: 16, color: ColorManager.kWhite)
                            ],
                          ),
                        ),
                      ),
                      Gap(24),
                      GestureDetector(
                        onTap: () {
                          // takeScreenshotAndShare();
                          reportTransaction(widget.param.toMap());
                        },
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorManager.kError),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 10,
                            children: [
                              Text("Report Transaction",
                                  style: get18TextStyle()
                                      .copyWith(color: ColorManager.kWhite)),
                              Icon(Icons.support,
                                  size: 16, color: ColorManager.kWhite)
                            ],
                          ),
                        ),
                      ),
                      Gap(24),
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

  IconData getIconData() {
    switch (widget.param.status) {
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
  List<Widget> children(ServicePurpose purpose) {
    var res = <Widget>[];

    // AIRTIME
    if (purpose == ServicePurpose.airtime) {
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
                  title: "Transaction ID",
                  desc: widget.param.reference,
                  descW: GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                          ClipboardData(text: widget.param.reference));

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
                  desc: formatDateSlash(widget.param.createdAt) ?? "",
                ),

                CustomKeyValueState(
                  title: "Transaction Time",
                  desc: getTimeFromDate(widget.param.createdAt) ?? "",
                ),

                //
                widget.param.fee <= 0
                    ? SizedBox.shrink()
                    : CustomKeyValueState(
                        title: "Service Charge",
                        desc: formatCurrency(widget.param.fee)),
                CustomKeyValueState(
                    title: "Amount", desc: formatCurrency(widget.param.amount)),
                CustomKeyValueState(
                    title: "Total",
                    desc: formatCurrency(widget.param.totalAmount)),
                CustomKeyValueState(
                  title: "Network",
                  desc: widget.param.meta.provider?.name ?? "NA",
                ),

                CustomKeyValueState(
                  title: "Recepient",
                  desc: widget.param.meta.customer?.phone ?? "NA",
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Remark",
                          style: get12TextStyle()
                              .copyWith(color: ColorManager.kTextDark7)),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                              ClipboardData(text: widget.param.remark));

                          showCustomToast(
                              context: context,
                              description:
                                  "Transaction Remark copied to clipbaord",
                              type: ToastType.success);
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 10,
                            children: [
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * .45,
                                child: Text(
                                    capitalizeFirstString(
                                      widget.param.remark,
                                    ),
                                    maxLines: 3,
                                    softWrap: true,
                                    textAlign: TextAlign.right,
                                    style: get12TextStyle()),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gap(24),
        ],
      );
    }

    // DATA
    if (purpose == ServicePurpose.data) {
      res.addAll([
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
                title: "Transaction ID",
                desc: widget.param.reference,
                descW: GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: widget.param.reference));

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
                desc: formatDateSlash(widget.param.createdAt) ?? "",
              ),
              CustomKeyValueState(
                title: "Transaction Time",
                desc: getTimeFromDate(widget.param.createdAt) ?? "",
              ),
              CustomKeyValueState(
                title: "Network",
                desc: widget.param.meta.provider?.name ?? "NA",
              ),

              CustomKeyValueState(
                title: "Recepient",
                desc: widget.param.meta.customer?.phone ?? "NA",
              ),

              Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Remark",
                        style: get12TextStyle()
                            .copyWith(color: ColorManager.kTextDark7)),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                            ClipboardData(text: widget.param.remark));

                        showCustomToast(
                            context: context,
                            description:
                                "Transaction Remark copied to clipbaord",
                            type: ToastType.success);
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * .35,
                              child: Text(
                                  capitalizeFirstString(
                                    widget.param.remark,
                                  ),
                                  maxLines: 3,
                                  softWrap: true,
                                  textAlign: TextAlign.right,
                                  style: get12TextStyle()),
                            ),
                            Icon(
                              Icons.copy,
                              size: 12,
                              color: ColorManager.kPrimary,
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
              CustomKeyValueState(
                  title: "Data Plan",
                  desc: widget.param.meta.product?.name??""),

              CustomKeyValueState(
                  title: "Service Charge",
                  desc: formatCurrency(widget.param.fee)),

              //
              CustomKeyValueState(
                  title: "Amount", desc: formatCurrency(widget.param.amount)),
              CustomKeyValueState(
                  title: "Total",
                  desc: formatCurrency(widget.param.totalAmount)),
            ],
          ),
        ),
      ]);
    }

    // electricity
    if (purpose == ServicePurpose.electricity) {
      String token = (widget.param.meta.token ?? "")
          .replaceAll('Token', '')
          .replaceAll(":", "")
          .trim();

      res.addAll([
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
                title: "Transaction ID",
                desc: widget.param.reference,
                descW: GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: widget.param.reference));

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
                desc: formatDateSlash(widget.param.createdAt) ?? "",
              ),

              CustomKeyValueState(
                title: "Transaction Time",
                desc: getTimeFromDate(widget.param.createdAt) ?? "",
              ),
              CustomKeyValueState(
                title: "Service Provider",
                desc: widget.param.meta.provider?.name ?? "NA",
              ),

              CustomKeyValueState(
                title: "Meter Number",
                desc: capitalize(widget.param.meta.customer?.meterNumber??""),
              ),

              // CustomKeyValueState(
              //   title: "Meter Name",
              //   desc: capitalize(widget.param.meta["customer"]["meter_name"]),
              // ),

              // CustomKeyValueState(
              //   title: "Meter Type",
              //   desc: capitalize(widget.param.meta["customer"]["meter_type"]),
              // ),

              Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Remark",
                        style: get12TextStyle()
                            .copyWith(color: ColorManager.kTextDark7)),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                            ClipboardData(text: widget.param.remark));

                        showCustomToast(
                            context: context,
                            description:
                                "Transaction Remark copied to clipbaord",
                            type: ToastType.success);
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * .35,
                              child: Text(
                                  capitalizeFirstString(
                                    widget.param.remark,
                                  ),
                                  maxLines: 3,
                                  softWrap: true,
                                  textAlign: TextAlign.right,
                                  style: get12TextStyle()),
                            ),
                            Icon(
                              Icons.copy,
                              size: 12,
                              color: ColorManager.kPrimary,
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
              //
              CustomKeyValueState(
                  title: "Amount", desc: formatCurrency(widget.param.amount)),
              CustomKeyValueState(
                  title: "Total",
                  desc: formatCurrency(widget.param.totalAmount)),
            ],
          ),
        ),
        Container(
          margin:
              const EdgeInsets.only(top: 10, bottom: 20, right: 20, left: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorManager.kPrimaryLight,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Electricity Token",
                      style: get12TextStyle().copyWith(
                        color: ColorManager.kTextDark7,
                      ),
                    ),
                    const SizedBox(height: 2.5),
                    Text(
                      token,
                      style: get14TextStyle().copyWith(
                        color: ColorManager.kPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => copyToClipboard(context, token),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(170),
                    color: ColorManager.kPrimary,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  child: Text(
                    "Copy",
                    style: get14TextStyle().copyWith(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
              )
            ],
          ),
        ),
      ]);
    }

    // tvSubscription
    if (purpose == ServicePurpose.tvSubscription) {
      res.addAll([
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
                title: "Transaction ID",
                desc: widget.param.reference,
                descW: GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: widget.param.reference));

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
                desc: formatDateSlash(widget.param.createdAt) ?? "",
              ),

              CustomKeyValueState(
                title: "Transaction Time",
                desc: getTimeFromDate(widget.param.createdAt) ?? "",
              ),
              // CustomKeyValueState(
              //   title: "Service Provider",
              //   desc: widget.param.meta["provider"]?["name"] ?? "NA",
              // ),

              // CustomKeyValueState(
              //   title: "Decoder Number",
              //   desc: capitalize(
              //       widget.param.meta["customer"]?["smartcard_number"]),
              // ),

              // CustomKeyValueState(
              //   title: "Plan",
              //   desc: capitalize(widget.param.meta["product"]?["name"]),
              // ),

              Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Remark",
                        style: get12TextStyle()
                            .copyWith(color: ColorManager.kTextDark7)),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                            ClipboardData(text: widget.param.remark));

                        showCustomToast(
                            context: context,
                            description:
                                "Transaction Remark copied to clipbaord",
                            type: ToastType.success);
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * .35,
                              child: Text(
                                  capitalizeFirstString(
                                    widget.param.remark,
                                  ),
                                  maxLines: 3,
                                  softWrap: true,
                                  textAlign: TextAlign.right,
                                  style: get12TextStyle()),
                            ),
                            Icon(
                              Icons.copy,
                              size: 12,
                              color: ColorManager.kPrimary,
                            ),
                          ]),
                    ),
                  ],
                ),
              ),

              //
              CustomKeyValueState(
                  title: "Amount", desc: formatCurrency(widget.param.amount)),
              CustomKeyValueState(
                  title: "Total",
                  desc: formatCurrency(widget.param.totalAmount)),
            ],
          ),
        ),
      ]);
    }

    // education
    if (purpose == ServicePurpose.education) {
      List<String> pins =
          (widget.param.meta.token?? "").toString().split(",");
      res.addAll([
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
                title: "Transaction ID",
                desc: widget.param.reference,
                descW: GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: widget.param.reference));

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
                desc: formatDateSlash(widget.param.createdAt) ?? "",
              ),

              CustomKeyValueState(
                title: "Transaction Time",
                desc: getTimeFromDate(widget.param.createdAt) ?? "",
              ),
              // CustomKeyValueState(
              //   title: "Exam Type",
              //   desc: capitalize(widget.param.meta["provider"]["name"]),
              // ),

              // CustomKeyValueState(
              //   title: "Candidate Number",
              //   desc: capitalize(
              //       widget.param.meta["customer"]["registration_number"]),
              // ),

              Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Remark",
                        style: get12TextStyle()
                            .copyWith(color: ColorManager.kTextDark7)),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                            ClipboardData(text: widget.param.remark));

                        showCustomToast(
                            context: context,
                            description:
                                "Transaction Remark copied to clipbaord",
                            type: ToastType.success);
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * .35,
                              child: Text(
                                  capitalizeFirstString(
                                    widget.param.remark,
                                  ),
                                  maxLines: 3,
                                  softWrap: true,
                                  textAlign: TextAlign.right,
                                  style: get12TextStyle()),
                            ),
                            Icon(
                              Icons.copy,
                              size: 12,
                              color: ColorManager.kPrimary,
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
              //
              CustomKeyValueState(
                  title: "Amount", desc: formatCurrency(widget.param.amount)),
              CustomKeyValueState(
                  title: "Total",
                  desc: formatCurrency(widget.param.totalAmount)),
            ],
          ),
        ),
        for (int i = 0; i < pins.length; i++)
          Container(
            margin:
                const EdgeInsets.only(top: 10, bottom: 20, right: 20, left: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorManager.kPrimaryLight,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    pins[i],
                    style: get14TextStyle().copyWith(
                      color: ColorManager.kPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => copyToClipboard(context, pins[i]),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(170),
                      color: ColorManager.kPrimary,
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                    child: Text(
                      "Copy",
                      style: get14TextStyle().copyWith(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                )
              ],
            ),
          ),
      ]);
    }
    // education
    if (purpose == ServicePurpose.betting) {
      List<String> pins =
          (widget.param.meta.token ?? "").toString().split(",");
      res.addAll([
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
                title: "Transaction ID",
                desc: widget.param.reference,
                descW: GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: widget.param.reference));

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
                desc: formatDateSlash(widget.param.createdAt) ?? "",
              ),

              CustomKeyValueState(
                title: "Transaction Time",
                desc: getTimeFromDate(widget.param.createdAt) ?? "",
              ),
              // CustomKeyValueState(
              //   title: "Provider",
              //   desc: capitalize(widget.param.meta["provider"]["name"]),
              // ),

              // CustomKeyValueState(
              //   title: "Betting ID/Number",
              //   desc: capitalize(widget.param.meta["customer"]["customer_id"]),
              // ),

              Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Remark",
                        style: get12TextStyle()
                            .copyWith(color: ColorManager.kTextDark7)),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                            ClipboardData(text: widget.param.remark));

                        showCustomToast(
                            context: context,
                            description:
                                "Transaction Remark copied to clipbaord",
                            type: ToastType.success);
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * .35,
                              child: Text(
                                  capitalizeFirstString(
                                    widget.param.remark,
                                  ),
                                  maxLines: 3,
                                  softWrap: true,
                                  textAlign: TextAlign.right,
                                  style: get12TextStyle()),
                            ),
                            Icon(
                              Icons.copy,
                              size: 12,
                              color: ColorManager.kPrimary,
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
              //
              CustomKeyValueState(
                  title: "Amount", desc: formatCurrency(widget.param.amount)),
              CustomKeyValueState(
                  title: "Total",
                  desc: formatCurrency(widget.param.totalAmount)),
            ],
          ),
        ),
        for (int i = 0; i < pins.length; i++)
          Container(
            margin:
                const EdgeInsets.only(top: 10, bottom: 20, right: 20, left: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorManager.kPrimaryLight,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    pins[i],
                    style: get14TextStyle().copyWith(
                      color: ColorManager.kPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => copyToClipboard(context, pins[i]),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(170),
                      color: ColorManager.kPrimary,
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                    child: Text(
                      "Copy",
                      style: get14TextStyle().copyWith(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                )
              ],
            ),
          ),
      ]);
    }

    // deposit
    if (purpose == ServicePurpose.deposit) {
      res.addAll([
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
              // CustomKeyValueState(title: "Remark", desc: widget.param.remark),

              CustomKeyValueState(
                title: "Transaction ID",
                desc: widget.param.reference,
                descW: GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: widget.param.reference));

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
                desc: formatDateSlash(widget.param.createdAt) ?? "",
              ),

              CustomKeyValueState(
                title: "Transaction Time",
                desc: getTimeFromDate(widget.param.createdAt) ?? "",
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Remark",
                        style: get12TextStyle()
                            .copyWith(color: ColorManager.kTextDark7)),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                            ClipboardData(text: widget.param.remark));

                        showCustomToast(
                            context: context,
                            description:
                                "Transaction Remark copied to clipbaord",
                            type: ToastType.success);
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * .35,
                              child: Text(
                                  capitalizeFirstString(
                                    widget.param.remark,
                                  ),
                                  maxLines: 3,
                                  softWrap: true,
                                  textAlign: TextAlign.right,
                                  style: get12TextStyle()),
                            ),
                            Icon(
                              Icons.copy,
                              size: 12,
                              color: ColorManager.kPrimary,
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
              widget.param.fee <= 0
                  ? SizedBox.shrink()
                  : CustomKeyValueState(
                      title: "Service Charge",
                      desc: formatCurrency(widget.param.fee)),
              //
              CustomKeyValueState(
                  title: "Amount", desc: formatCurrency(widget.param.amount)),

              CustomKeyValueState(
                  title: "Total",
                  desc: formatCurrency(widget.param.totalAmount)),
            ],
          ),
        ),
      ]);
    }

    // virtual card
    if (purpose == ServicePurpose.virtualCard) {
      res.addAll([
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
              // CustomKeyValueState(title: "Remark", desc: widget.param.remark),

              CustomKeyValueState(
                title: "Transaction Ref",
                desc: widget.param.reference,
                descW: GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: widget.param.reference));

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
                desc: formatDateSlash(widget.param.createdAt) ?? "",
              ),

              CustomKeyValueState(
                title: "Transaction Time",
                desc: getTimeFromDate(widget.param.createdAt) ?? "",
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Remark",
                        style: get12TextStyle()
                            .copyWith(color: ColorManager.kTextDark7)),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                            ClipboardData(text: widget.param.remark));

                        showCustomToast(
                            context: context,
                            description:
                                "Transaction Remark copied to clipbaord",
                            type: ToastType.success);
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * .35,
                              child: Text(
                                  capitalizeFirstString(
                                    widget.param.remark,
                                  ),
                                  maxLines: 3,
                                  softWrap: true,
                                  textAlign: TextAlign.right,
                                  style: get12TextStyle()),
                            ),
                            Icon(
                              Icons.copy,
                              size: 12,
                              color: ColorManager.kPrimary,
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
              widget.param.fee <= 0
                  ? SizedBox.shrink()
                  : CustomKeyValueState(
                      title: "Service Charge",
                      desc: formatCurrency(widget.param.fee)),
              //
              CustomKeyValueState(
                  title: "Amount", desc: formatCurrency(widget.param.amount)),

              CustomKeyValueState(
                  title: "Total",
                  desc: formatCurrency(widget.param.totalAmount)),
            ],
          ),
        ),
      ]);
    }

    // transfer
    if (widget.param.purpose == ServicePurpose.transfer) {
      res.addAll([
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
              // CustomKeyValueState(title: "Remark", desc: widget.param.remark),

              CustomKeyValueState(
                title: "Transaction ID",
                desc: widget.param.reference,
                descW: GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: widget.param.reference));

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
                desc: formatDateSlash(widget.param.createdAt) ?? "",
              ),

              CustomKeyValueState(
                title: "Transaction Time",
                desc: getTimeFromDate(widget.param.createdAt) ?? "",
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Remark",
                        style: get12TextStyle()
                            .copyWith(color: ColorManager.kTextDark7)),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                            ClipboardData(text: widget.param.remark));

                        showCustomToast(
                            context: context,
                            description:
                                "Transaction Remark copied to clipbaord",
                            type: ToastType.success);
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * .35,
                              child: Text(
                                  capitalizeFirstString(
                                    widget.param.remark,
                                  ),
                                  maxLines: 3,
                                  softWrap: true,
                                  textAlign: TextAlign.right,
                                  style: get12TextStyle()),
                            ),
                            Icon(
                              Icons.copy,
                              size: 12,
                              color: ColorManager.kPrimary,
                            ),
                          ]),
                    ),
                  ],
                ),
              ),

              //
              CustomKeyValueState(
                  title: "Amount", desc: formatCurrency(widget.param.amount)),
              CustomKeyValueState(
                  title: "Total",
                  desc: formatCurrency(widget.param.totalAmount)),
            ],
          ),
        ),
      ]);
    }

    //
    if (widget.param.purpose == ServicePurpose.withdrawal) {
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
                  title: "Transaction ID",
                  desc: widget.param.reference,
                  descW: GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                          ClipboardData(text: widget.param.reference));

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
                  desc: formatDateSlash(widget.param.createdAt) ?? "",
                ),
                CustomKeyValueState(
                  title: "Transaction Time",
                  desc: getTimeFromDate(widget.param.createdAt) ?? "",
                ),
                if (widget.param.provider.toLowerCase() != 'sudo') ...[
                  // CustomKeyValueState(
                  //     title: "Bank Name",
                  //     desc: widget.param.meta["bank_name"] ?? ''),
                  // CustomKeyValueState(
                  //     title: "Bank Account Number",
                  //     desc: widget.param.meta["account_number"] ?? "--"),
                  // CustomKeyValueState(
                  //     title: "Bank Account Name",
                  //     desc: widget.param.meta["account_name"] ?? "--"),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Remark",
                            style: get12TextStyle()
                                .copyWith(color: ColorManager.kTextDark7)),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: widget.param.remark));

                            showCustomToast(
                                context: context,
                                description:
                                    "Transaction Remark copied to clipbaord",
                                type: ToastType.success);
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 10,
                              children: [
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width * .35,
                                  child: Text(
                                      capitalizeFirstString(
                                        widget.param.remark,
                                      ),
                                      maxLines: 3,
                                      softWrap: true,
                                      textAlign: TextAlign.right,
                                      style: get12TextStyle()),
                                ),
                                Icon(
                                  Icons.copy,
                                  size: 12,
                                  color: ColorManager.kPrimary,
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                ],
                widget.param.fee <= 0
                    ? SizedBox.shrink()
                    : CustomKeyValueState(
                        title: "Service Charge",
                        desc: formatCurrency(widget.param.fee)),
                CustomKeyValueState(
                    title: "Amount", desc: formatCurrency(widget.param.amount)),
                CustomKeyValueState(
                    title: "Total Amount",
                    desc: formatCurrency(widget.param.totalAmount)),
              ],
            ),
          ),
        ],
      );
    }

    return res;
  }
}
