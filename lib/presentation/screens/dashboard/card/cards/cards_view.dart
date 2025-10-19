import 'dart:developer';
import 'dart:ui';

import 'package:dataplug/core/utils/utils.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../core/model/core/card_data.dart';
import '../../../../../core/model/core/card_transactions.dart';
import '../../../../../core/providers/card_provider.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../../misc/custom_components/custom_btn.dart';
import '../block_virtual_card.dart';
import '../create_card/select_card_currency.dart';
import '../unblock_virtual_card.dart';

class CardsView extends StatefulWidget {
  final List<CardData> cardList;

  const CardsView({super.key, required this.cardList});

  @override
  State<CardsView> createState() => _CardsViewState();
}

class _CardsViewState extends State<CardsView> {
  PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentIndex = 0;

  int _activeIndex = 0;

  Map<String, bool> _isBalanceVisibleMap = {};

  @override
  void initState() {
    super.initState();

    final cardProvider = Provider.of<CardProvider>(context, listen: false);
    cardProvider.getUsersCards().then((_) {
      if (cardProvider.cards.isNotEmpty) {
        if (cardProvider.cards.length == 1) {
          setState(() {
            _pageController = PageController(viewportFraction: 1);
          });
        }
        cardProvider.getUsersCardTransactions(
            id: cardProvider.cards[_activeIndex].id ?? '');
      }
    });
  }

  void onCardChange(int index) {
    setState(() {
      _activeIndex = index;
    });

    final cardProvider = Provider.of<CardProvider>(context, listen: false);
    final selectedCard = cardProvider.cards[index];
    cardProvider.getUsersCardTransactions(id: selectedCard.id ?? '');
  }

  void _toggleBalanceVisibility(String cardId) {
    setState(() {
      _isBalanceVisibleMap[cardId] = !(_isBalanceVisibleMap[cardId] ?? false);
    });
  }

  Future<void> refreshInfo() async {
    final cardProvider = Provider.of<CardProvider>(context, listen: false);
    cardProvider.getUsersCards();
    cardProvider.getUsersCards();
  }

  @override
  Widget build(BuildContext context) {
    final cardProvider = Provider.of<CardProvider>(context);
    final cards = cardProvider.cards;
    final cardTransactions = cardProvider.cardTransactions;

    if (cards.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () => refreshInfo(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    'Cards',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: ['USD', 'NGN'].map((currency) {
                          final isActive = widget
                                  .cardList[_currentIndex].currency
                                  .toUpperCase() ==
                              currency;
                          return GestureDetector(
                            onTap: () {},
                            child: Text(
                              currency,
                              style: TextStyle(
                                color: isActive ? Colors.black : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      // Row(
                      //   children: [
                      //     Text(
                      //       'USD',
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.w700,
                      //           color: _currentIndex == 1 ? Colors.grey : null),
                      //     ),
                      //     Gap(10),
                      //     Text(
                      //       'NGN',
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.w700,
                      //           color: _currentIndex == 0 ? Colors.grey : null),
                      //     ),
                      //   ],
                      // ),
                      GestureDetector(
                        onTap: () {
                          showCustomBottomSheet(
                            context: context,
                            isDismissible: true,
                            screen: const SelectCardCurrency(),
                          );
                        },
                        child: Text('Create New Card',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: ColorManager.kPrimary,
                                decoration: TextDecoration.underline,
                                decorationColor: ColorManager.kPrimary)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 220, // Adjust as needed
                  child: PageView.builder(
                    padEnds: false,
                    controller: _pageController,
                    itemCount: widget.cardList.length,
                    itemBuilder: (context, index) =>
                        buildCard(widget.cardList[index]),
                    onPageChanged: (index) {
                      setState(() => _currentIndex = index);
                      onCardChange(index);
                    },
                  ),
                ),
                if (widget.cardList[_currentIndex].active != 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CustomButton(
                      text: "Unfreeze Card",
                      isActive: true,
                      onTap: () async {
                        showCustomBottomSheet(
                          context: context,
                          isDismissible: true,
                          screen: UnblockVirtualCardView(
                            id: widget.cardList[_currentIndex].id,
                          ), // You can use another screen for "Unblock"
                        );
                      },
                      loading: false,
                    ),
                  ),
                const SizedBox(height: 12),
                Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: widget.cardList.length,
                    effect: ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: Colors.black.withValues(alpha: .3),
                      dotColor: Colors.grey,
                    ),
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
                          log(widget.cardList[_currentIndex].currency);
                          if (widget.cardList[_currentIndex].currency
                                  .toUpperCase() ==
                              "NGN") {
                            Navigator.pushNamed(
                                context, RoutesManager.fundNairaCard,
                                arguments: widget.cardList[_currentIndex].id);
                          } else {
                            Navigator.pushNamed(
                                context, RoutesManager.fundDollarCard,
                                arguments: widget.cardList[_currentIndex].id);
                          }
                        },
                      ),
                      Gap(10),
                      ActionButton(
                        icon: Assets.icons.sendSqaure2.svg(),
                        label: 'Withdraw',
                        backgroundColor: const Color(0xFFD9F3F3),
                        onTap: () {
                          if (widget.cardList[_currentIndex].currency
                                  .toUpperCase() ==
                              "NGN") {
                            Navigator.pushNamed(
                                context, RoutesManager.withdrawNairaCard,
                                arguments: widget.cardList[_currentIndex].id);
                          } else {
                            Navigator.pushNamed(
                                context, RoutesManager.withdrawDollarCard,
                                arguments: widget.cardList[_currentIndex].id);
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
                                screen: BlockVirtualCardView(
                                    id: widget.cardList[_currentIndex].id),
                              ))
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Card Transaction History',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              // color: ColorManager.kPrimary,
                              decoration: TextDecoration.underline,
                              decorationColor: ColorManager.kWhite)),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Assets.icons.clipboardText.svg(),
                                Gap(10),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, RoutesManager.cardTransactions,
                                        arguments:
                                            widget.cardList[_currentIndex].id);
                                  },
                                  child: Row(
                                    children: [
                                      Text("See all",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: ColorManager.kPrimary,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  ColorManager.kPrimary)),
                                      Gap(10),
                                      Assets.icons.forwardArrow.svg(
                                          colorFilter: ColorFilter.mode(
                                              ColorManager.kPrimary,
                                              BlendMode.srcIn))
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
         
                cardTransactions.isEmpty
                    ? const Center(child: Text("No transactions"))
                    : ListView.separated(
                        padding: EdgeInsets.all(16),
                        separatorBuilder: (context, index) => Gap(16),
                        itemCount: cardTransactions.length > 5
                            ? 5
                            : cardTransactions.length,
                        shrinkWrap: true,
                        itemBuilder: (_, index) {
                          final txn = cardTransactions[index];
                          return TransactionItem(
                            txn: txn,
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard(CardData card) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Stack(
          children: [
            Container(
              height: card.active == 1 ? 200 : null,
              margin: const EdgeInsets.symmetric(horizontal: 8),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Assets.images.dataApplogo11.image(width: 24, height: 24),
                      Row(
                        children: [
                          card.currency == 'USD'
                              ? Assets.images.usdflag
                                  .image(width: 24, height: 24)
                              : Assets.images.ngnFlag
                                  .image(width: 24, height: 24),
                          const SizedBox(width: 6),
                          Text(
                            card.currency,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (_isBalanceVisibleMap[card.id ?? ''] ?? false)
                            ? formatCurrency(num.parse(card.balance),
                                code: card.currency)
                            : '****',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 24),
                      ),
                      GestureDetector(
                        onTap: () => _toggleBalanceVisibility(card.id ?? ''),
                        child: Icon(
                          (_isBalanceVisibleMap[card.id ?? ''] ?? true)
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white70,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, RoutesManager.cardDetails,
                            arguments: card),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          child: const Text(
                            'View Details',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            card.nameOnCard.toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12),
                          ),
                          const SizedBox(height: 6),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  letterSpacing: 3),
                              children: [
                                const TextSpan(text: '**** **** **** '),
                                TextSpan(
                                  text: card.last4,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Blur & Cover if card is inactive
            if (card.active != 1)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
          ],
        ),

        // Blocked info message
        if (card.active != 1)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ColorManager.kPrimary.withValues(alpha: .21),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: ColorManager.kBlack, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "You have blocked this ${card.currency.toUpperCase()} card",
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class ActionButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final Color backgroundColor;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 3),
                Text(
                  label,
                  style: TextStyle(
                    color: ColorManager.kBlack.withValues(alpha: .5),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final CardTransaction txn;

  const TransactionItem({
    super.key,
    required this.txn,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutesManager.cardHistoryDetails,
            arguments: txn);
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              Assets.images.kVirtualCard2.path,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  txn.narration ?? "Card Transaction",
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  '${DateFormat('dd/MM/yyyy').format(txn.date)} - ${DateFormat('hh:mm a').format(txn.date)}',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${txn.currency} ${formatNumber(txn.amount)}',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                capitalize(txn.status ?? ""),
                style: TextStyle(
                  color: const Color(0xFF00B84A),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
