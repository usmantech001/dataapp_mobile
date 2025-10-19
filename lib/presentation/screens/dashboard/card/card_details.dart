import 'dart:developer';

import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/core/providers/user_provider.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_scaffold.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:dataplug/presentation/screens/dashboard/card/block_virtual_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../../core/enum.dart';
import '../../../../core/model/core/card_data.dart';
import '../../../../core/utils/utils.dart';
import '../../../../gen/assets.gen.dart';
import '../../../misc/custom_components/custom_back_icon.dart';
import '../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../misc/custom_components/custom_btn.dart';
import '../../../misc/custom_components/custom_container.dart';
import '../../../misc/custom_components/custom_key_value_state.dart';
import '../../../misc/custom_snackbar.dart';
import '../../../misc/route_manager/routes_manager.dart';
import 'card_web_view.dart';
import 'cards/cards_view.dart';

class CardDetails extends StatefulWidget {
  final CardData cardData;
  const CardDetails({super.key, required this.cardData});

  @override
  State<CardDetails> createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  final spacer = const SizedBox(height: 20);

  bool _isBalanceVisible = true;

  @override
  Widget build(BuildContext context) {
       UserProvider userProvider = Provider.of<UserProvider>(context);
    final card = widget.cardData;
    return CustomScaffold(
      backgroundColor: ColorManager.kPrimary,
      body: SafeArea(
        bottom: false,
        child: Container(
          height: MediaQuery.of(context).size.height,
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
                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: BackIcon(),
                    ),
                    Expanded(
                      child: Text(
                        "${card.currency.toUpperCase()} Card",
                        textAlign: TextAlign.center,
                        style: get18TextStyle(),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
                customDivider(
                    height: 1, margin: const EdgeInsets.only(top: 16)),
                Gap(26),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: card.currency == 'USD'
                          ? [Color(0xFF000000), Color(0xFF085A57)]
                          : [Color(0xFF043A38), Color(0xFF12C0B9)],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Assets.images.dataApplogo11
                              .image(width: 24, height: 24),
                          Row(
                            children: [
                              card.currency == 'USD'
                                  ? Assets.images.usdflag
                                      .image(width: 24, height: 24)
                                  : Assets.images.ngnFlag
                                      .image(width: 24, height: 24),
                              const SizedBox(width: 6),
                              Text(
                                card.currency.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 35),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    letterSpacing: 3,
                                  ),
                                  children: [
                                    const TextSpan(text: '**** **** **** '),
                                    TextSpan(text: card.last4),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                card.nameOnCard.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          card.brand.toLowerCase() == 'mastercard'
                              ? Assets.images.mastercardLogo.image(width: 50)
                              : card.brand.toLowerCase() == 'visa'
                                  ? Assets.images.visaLogo
                                      .image(width: 50, height: 30)
                                  : Assets.images.verveLogo
                                      .image(width: 60, height: 30),
                        ],
                      ),
                      Gap(34),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: ColorManager.kWhite.withValues(alpha: .3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _isBalanceVisible
                                      ? "${formatNumber(num.parse(card.balance))} ${card.currency}"
                                      : "**** ${card.currency}",
                                  style: TextStyle(
                                      color: ColorManager.kWhite,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isBalanceVisible =
                                            !_isBalanceVisible;
                                      });
                                    },
                                    child: Assets.icons.eye
                                        .svg(width: 24, height: 24)),
                              ],
                            ),
                            Text("Card Balance",
                                style: TextStyle(
                                    color: ColorManager.kWhite,
                                    fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ActionButton(
                        icon: Assets.icons.walletAdd.svg(
                            colorFilter: ColorFilter.mode(
                                ColorManager.kPrimary, BlendMode.srcIn)),
                        label: 'Fund Card',
                        backgroundColor: const Color(0xFFD9F3F3),
                        onTap: () {
                          if (card.currency.toUpperCase() == "NGN") {
                            Navigator.pushNamed(
                                context, RoutesManager.fundNairaCard,
                                arguments: card.id);
                          } else {
                            Navigator.pushNamed(
                                context, RoutesManager.fundDollarCard,
                                arguments: card.id);
                          }
                        },
                      ),
                      Gap(10),
                      ActionButton(
                        icon: Assets.icons.sendSqaure2.svg(),
                        label: 'Withdraw',
                        backgroundColor: const Color(0xFFD9F3F3),
                        onTap: () {
                          if (card.currency.toUpperCase() == "NGN") {
                            Navigator.pushNamed(
                                context, RoutesManager.withdrawNairaCard,
                                arguments: card.id);
                          } else {
                            Navigator.pushNamed(
                                context, RoutesManager.withdrawDollarCard,
                                arguments: card.id);
                          }
                        },
                      ),
                      Gap(10),
                      ActionButton(
                        icon: Assets.icons.forbidden.svg(),
                        label: 'Freeze Card',
                        backgroundColor: const Color(0xFFD9F3F3),
                        onTap: () => showCustomBottomSheet(
                          context: context,
                          isDismissible: true,
                          screen: BlockVirtualCardView(id: card.id),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                CustomContainer(
                  borderRadiusSize: 32,
                  header: Text("Card Details", style: get14TextStyle()),
                  margin: EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 20),
                  child: Column(
                    children: [
                      _buildCopyRow("Card Holder Name", card.nameOnCard.isEmpty ? "${userProvider.user.firstname} ${userProvider.user.lastname}" ??"": card.nameOnCard),
                      // _buildCopyRow("Card Number", card.maskedNumber),
                      // _buildCopyRow("CVV", ),
                      _buildCopyRow("Expiry Date",
                          "${card.expiryMonth}/${card.expiryYear}"),
                      _buildCopyRow("Card Issuer", card.brand),
          
                      // view card number and cvv CTA
                      CustomKeyValueState(
                        title: "View Card Number",
                        desc: "",
                        descW: GestureDetector(
                          onTap: () async {
                            // generate card token and navigate to web view
          
                            // generate token
                            // For demonstration, using a static token
                            String token =
                                await ServicesHelper.generateCardToken(
                                    cardId: card.id);
                            log(token, name: "Card Token");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CardWebView(
                                    cardId: card.cardId, cardToken: token),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("View", style: get12TextStyle()),
                              SizedBox(width: 10),
                              Icon(Icons.visibility,
                                  size: 12, color: ColorManager.kPrimary),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (card.currency == "USD") ...[
                  CustomContainer(
                    borderRadiusSize: 32,
                    header: Text("Billing Address", style: get14TextStyle()),
                    margin: EdgeInsets.all(16),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    child: Column(
                      children: [
                        _buildCopyRow("Street", card.billingDetails.line1),
                        _buildCopyRow("City", card.billingDetails.city),
                        _buildCopyRow(
                            "Postal Code", card.billingDetails.postalCode),
                                       _buildCopyRow(
                            "Country", card.billingDetails.country),
                      ],
                    ),
                  ),
                ],
                spacer,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCopyRow(String title, String value) {
    return CustomKeyValueState(
      title: title,
      desc: "",
      descW: GestureDetector(
        onTap: () {
          Clipboard.setData(ClipboardData(text: value));
          showCustomToast(
              context: context,
              description: "Text copied to clipboard",
              type: ToastType.success);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(value, style: get12TextStyle()),
            SizedBox(width: 10),
            Icon(Icons.copy, size: 12, color: ColorManager.kPrimary),
          ],
        ),
      ),
    );
  }
}
