import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dataplug/core/constants.dart';
import 'package:dataplug/core/model/core/giftcard_txn.dart';
import 'package:dataplug/core/model/core/service_txn.dart';
import 'package:dataplug/core/utils/utils.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_container.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_scaffold.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';

import '../../../../../core/enum.dart';
import '../../../../../core/providers/generic_provider.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../misc/custom_components/custom_back_icon.dart';
import '../../../misc/custom_components/custom_key_value_state.dart';
import '../../../misc/custom_snackbar.dart';
import '../../../misc/image_manager/image_manager.dart';


class GiftcardHistoryDetails extends StatefulWidget {
  final GiftcardTxn param;
  const GiftcardHistoryDetails({super.key, required this.param});

  @override
  State<GiftcardHistoryDetails> createState() => _GiftcardHistoryDetailsState();
}

class _GiftcardHistoryDetailsState extends State<GiftcardHistoryDetails> {
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

  void reportTransaction(
      Map<String, dynamic> transactionDetails, String supportEmail) async {
    final String subject = "Transaction Issue Report";
    final String email = supportEmail; // Replace with actual support email

    final String transactionBody = "Transaction Report:\n\n"
        "Transaction ID: ${widget.param.reference}\n"
        "Status: ${widget.param.status}\n"
        "Type: ${widget.param.trade_type}\n"
        "Transaction Date: ${formatDateSlash(widget.param.created_at)}\n"
        "Transaction Time: ${getTimeFromDate(widget.param.created_at)}\n"
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
    GenericProvider genericProvider = Provider.of<GenericProvider>(context);

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
          child: SingleChildScrollView(
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
                          onTap: () {
                            Navigator.pop(
                              context,
                              // RoutesManager.dashboardWrapper
                              // (Route<dynamic> route) => false
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Image.asset(ImageManager.kTxnReceiptIcon, width: 43),
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

                Screenshot(
                  controller: screenshotController,
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                               decoration: BoxDecoration(color: Colors.white),
                        height: MediaQuery.sizeOf(context).height * 0.5,
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(
                              sigmaX: 1, sigmaY: 1), // Apply blur
                          // child: Image.asset(
                          //   Assets.images.dataplugIcon.path,
                          //   fit: BoxFit.cover,
                          //   opacity: const AlwaysStoppedAnimation(
                          //       0.2), // Adjust transparency
                          // ),
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 0, bottom: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // (widget.param.purpose == null ||
                                //         widget.param.purpose == ServicePurpose.withdrawal ||
                                //         widget.param.purpose == ServicePurpose.deposit ||
                                //         widget.param.purpose == ServicePurpose.transfer)
                                //     ?
                                const SizedBox(),
                                // : loadNetworkImage(
                                //     widget.param.meta?.provider?.logo ?? "",
                                //     borderRadius: BorderRadius.circular(50),
                                //     width: 24),
                                const SizedBox(width: 4),
                                Text("Giftcard",
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
                                              widget.param.payable_amount)),
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
                                color: ColorManager
                                    .getGiftcardAndCryptoStatusTextColor(
                                        widget.param.status ??
                                            GiftcardAndCryptoTxnStatus.pending),
                                size: 17,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                capitalizeFirstString(enumToString(
                                    widget.param.status ?? Status.pending)),
                                style: get14TextStyle().copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: ColorManager
                                      .getGiftcardAndCryptoStatusTextColor(
                                          widget.param.status ??
                                              GiftcardAndCryptoTxnStatus
                                                  .pending),
                                ),
                              )
                            ],
                          ),
                          ListView(
                            shrinkWrap: true,
                            controller: controller,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            children: children(),
                          ),
                       
                          Gap(24),
                        ],
                      ),
                    ],
                  ),
                ),

                //
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
                        Icon(Icons.share, size: 16, color: ColorManager.kWhite)
                      ],
                    ),
                  ),
                ),
                Gap(24),
                GestureDetector(
                  onTap: () {
                    // takeScreenshotAndShare();
                    reportTransaction(widget.param.toMap(),
                        genericProvider.supportEmail.toString());
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

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData getIconData() {
    switch (widget.param.status ?? GiftcardAndCryptoTxnStatus.pending) {
      case GiftcardAndCryptoTxnStatus.approved:
        return CupertinoIcons.check_mark_circled_solid;

      case GiftcardAndCryptoTxnStatus.declined:
        return Icons.cancel;

      case GiftcardAndCryptoTxnStatus.transferred:
        return CupertinoIcons.arrow_2_circlepath_circle_fill;

      case GiftcardAndCryptoTxnStatus.pending ||
            GiftcardAndCryptoTxnStatus.partially_approved:
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
                title: "Transaction ID",
                desc: widget.param.reference ?? "",
                descW: GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: widget.param.reference ?? ""));

                    showCustomToast(
                        context: context,
                        description: "Transaction ID copied to clipbaord",
                        type: ToastType.success);
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      spacing: 10,
                      children: [
                        Text(widget.param.reference ?? "",
                            style: get12TextStyle()),
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
                desc: formatDateSlash(widget.param.created_at) ?? "",
              ),

              CustomKeyValueState(
                title: "Transaction Time",
                desc: getTimeFromDate(widget.param.created_at) ?? "",
              ),

              // CustomKeyValueState(
              //   title: "Transaction Type",
              //   desc: capitalize(widget.param.trade_type.name ?? ""),
              // ),
              CustomKeyValueState(
                title: "Giftcard Category",
                desc: widget.param.gift_card?.category?.name ?? "",
              ),
              CustomKeyValueState(
                title: "Giftcard Product",
                desc: widget.param.gift_card?.name ?? "",
              ),

              CustomKeyValueState(
                title: "Rate",
                desc: formatCurrency(widget.param.rate),
              ),

              CustomKeyValueState(
                title: "Unit",
                desc: widget.param.quantity.toString(),
              ),

              CustomKeyValueState(
                  title: "Giftcard Amount",
                  desc: formatCurrency(widget.param.amount,
                      code: widget.param.gift_card?.currency ?? "")),
              CustomKeyValueState(
                title: "Giftcard Number",
                desc: widget.param.cards.first.cardNumber,
              ),

              widget.param.cards.isNotEmpty
                  ? Column(
                      children:
                          List.generate(widget.param.cards.length, (index) {
                        final card = widget.param.cards[index];
                        return Column(
                          children: [
                            CustomKeyValueState(
                              title: "Giftcard Number ${widget.param.cards.length > 1 ? (index + 1).toString() : ''}",
                              desc: card.cardNumber ?? "",
                              descW: GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                      text: card.cardNumber ?? ""));

                                  showCustomToast(
                                      context: context,
                                      description:
                                          "Card Number ID copied to clipbaord",
                                      type: ToastType.success);
                                },
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    spacing: 10,
                                    children: [
                                      Text(card.cardNumber ?? "",
                                          style: get12TextStyle()),
                                      Icon(
                                        Icons.copy,
                                        size: 12,
                                        color: ColorManager.kPrimary,
                                      ),
                                    ]),
                              ),
                            ),
                             CustomKeyValueState(
                              title: "Giftcard Pin ${widget.param.cards.length > 1 ? (index + 1).toString() : ''}",
                              desc: card.cardNumber ?? "",
                              descW: GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                      text: card.pinCode ?? ""));

                                  showCustomToast(
                                      context: context,
                                      description:
                                          "Card pin ID copied to clipbaord",
                                      type: ToastType.success);
                                },
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    spacing: 10,
                                    children: [
                                      Text(card.pinCode ?? "",
                                          style: get12TextStyle()),
                                      Icon(
                                        Icons.copy,
                                        size: 12,
                                        color: ColorManager.kPrimary,
                                      ),
                                    ]),
                              ),
                            ),
                          ],
                        );
                      }),
                    )
                  : SizedBox.shrink(),
              CustomKeyValueState(
                title: "Amount In Naira",
                desc: formatCurrency(widget.param.ngn_amount, code: "NGN"),
              ),
              CustomKeyValueState(
                  title: "Service Charge",
                  desc: formatCurrency(widget.param.service_charge,
                      code: widget.param.gift_card?.currency ?? "")),

              // widget.param.discount <= 0
              //     ? SizedBox.shrink()
              //     : CustomKeyValueState(
              //         title: "Discount",
              //         desc: formatCurrency(widget.param.discount),
              //       ),
              // widget.param.fee <= 0
              //     ? SizedBox.shrink()
              //     : CustomKeyValueState(
              //         title: "Service Charge",
              //         desc: formatCurrency(widget.param.fee),
              //       ),

              //
            ],
          ),
        ),
        Gap(24),
        // GestureDetector(
        //   onTap: () {
        //     takeScreenshotAndShare();
        //   },
        //   child: Container(
        //     height: 50,
        //     alignment: Alignment.center,
        //     width: double.infinity,
        //     padding: const EdgeInsets.symmetric(vertical: 0),
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(10),
        //         color: ColorManager.kPrimary),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       spacing: 10,
        //       children: [
        //         Text("Share",
        //             style: get18TextStyle()
        //                 .copyWith(color: ColorManager.kWhite)),
        //         Icon(Icons.share, size: 16, color: ColorManager.kWhite)
        //       ],
        //     ),
        //   ),
        // ),
        // Gap(24),
        // GestureDetector(
        //   onTap: () {
        //     // takeScreenshotAndShare();
        //     reportTransaction(widget.param.toMap());
        //   },
        //   child: Container(
        //     height: 50,
        //     alignment: Alignment.center,
        //     width: double.infinity,
        //     padding: const EdgeInsets.symmetric(vertical: 0),
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(10),
        //         color: ColorManager.kError),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       spacing: 10,
        //       children: [
        //         Text("Report Transaction",
        //             style: get18TextStyle()
        //                 .copyWith(color: ColorManager.kWhite)),
        //         Icon(Icons.support, size: 16, color: ColorManager.kWhite)
        //       ],
        //     ),
        //   ),
        // )
      ],
    );
    return res;
  }

  String formatToken(String token) {
    // Remove any spaces just in case
    token = token.replaceAll(' ', '');

    // Split into groups of 4
    final buffer = StringBuffer();
    for (int i = 0; i < token.length; i++) {
      buffer.write(token[i]);
      if ((i + 1) % 4 == 0 && i != token.length - 1) {
        buffer.write(' ');
      }
    }
    return buffer.toString();
  }
}
