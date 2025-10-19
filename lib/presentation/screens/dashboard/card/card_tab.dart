import 'dart:developer';

import 'package:dataplug/core/providers/card_provider.dart';
import 'package:dataplug/core/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/screens/dashboard/card/create_card/select_card_currency.dart';
import 'package:provider/provider.dart';

import '../../../../gen/assets.gen.dart';
import '../../../misc/custom_components/custom_bottom_sheet.dart';
import '../home/generate_account_widget.dart';
import 'card_web_view.dart';
import 'cards/cards_view.dart';

class CardTab extends StatefulWidget {
  const CardTab({super.key});

  @override
  State<CardTab> createState() => _CardTabState();
}

class _CardTabState extends State<CardTab> {
  bool isFront = true;

  Widget _buildCheckItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: ColorManager.kPrimary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(Icons.check, size: 14, color: ColorManager.kPrimary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Color(0xFF3B3B3B)),
          ),
        ),
      ],
    );
  }

  Widget _buildCardBack() {
    return _buildCard(
      gradient: const LinearGradient(
        colors: [Color(0xFF043A38), Color(0xFF12C0B9)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      cardNumber: '211 **** **** ****',
      logo: Assets.images.verveLogo.image(width: 60, height: 40),
      currency: 'Naira Card (₦)',
      flag: Assets.images.ngnFlag.image(width: 24, height: 24),
    );
  }

  Widget _buildCardFront() {
    return _buildCard(
      gradient: const LinearGradient(
        colors: [Color(0xFF000000), Color(0xFF085A57)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      cardNumber: '5211 **** **** ****',
      logo: Assets.images.mastercardLogo.image(width: 40, height: 24),
      currency: 'Dollar Card (\$)',
      flag: Assets.images.usdflag.image(width: 24, height: 24),
    );
  }

  Widget _buildCard({
    required Gradient gradient,
    required String cardNumber,
    required Widget logo,
    required String currency,
    required Widget flag,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 180,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: gradient,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Assets.images.dataApplogo11.image(width: 24, height: 24),
              Row(
                children: [
                  flag,
                  const SizedBox(width: 6),
                  Text(
                    currency,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                cardNumber,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  letterSpacing: 3,
                ),
              ),
              logo,
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSupportedPartners() {
    final logos = [
      Assets.images.netflixlogo.image(width: 82),
      Assets.images.ebaylogo.image(width: 72),
      Assets.images.alixpress.image(width: 82),
      Assets.images.spotify.image(width: 82),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          logos.length,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 16),
            child: logos[index],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<CardProvider>().getUsersCards();
    // Initial state setup if needed
  }

    void _generateStaticAccountBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => GenerateAccountBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    CardProvider provider = Provider.of<CardProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);

    final cards = provider.cards;
    log(cards.length.toString(), name: "Card");
    return provider.cards.isNotEmpty
        ? CardsView(
            cardList: cards,
          )
        : Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(thickness: .5),
                    const SizedBox(height: 8),
                    const Text(
                      'Cards',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937)),
                    ),
                    const SizedBox(height: 16),

                    // Card flipping view
                    SizedBox(
                      height: 200,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isFront = !isFront;
                          });
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: isFront
                              ? [
                                  AnimatedPositioned(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    top: 0,
                                    left: 0,
                                    child: _buildCardBack(),
                                  ),
                                  AnimatedPositioned(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    top: 26,
                                    left: 10,
                                    child: _buildCardFront(),
                                  ),
                                ]
                              : [
                                  AnimatedPositioned(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    top: 0,
                                    left: 0,
                                    child: _buildCardFront(),
                                  ),
                                  AnimatedPositioned(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    top: 26,
                                    left: 10,
                                    child: _buildCardBack(),
                                  ),
                                ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 70),

                    const SizedBox(height: 24),
                    const Text(
                      'Create a Virtual Card &\nGet it Instantly',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildCheckItem('Faster Online Payments'),
                    const SizedBox(height: 12),
                    _buildCheckItem('Extremely Secure'),
                    const SizedBox(height: 12),
                    _buildCheckItem('Accepted Globally'),
                    const SizedBox(height: 42),

                    const Text(
                      'SUPPORTED PARTNERS',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3B3B3B),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 22),
                    _buildSupportedPartners(),
                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          
                          if (userProvider.user.bvn_verified && userProvider.user.bvn_validated) {
                            showCustomBottomSheet(
                              context: context,
                              isDismissible: true,
                              screen: const SelectCardCurrency(),
                            );
                          } else{
                          _generateStaticAccountBottomSheet(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2CC9CC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Create my virtual card',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
  }
}
