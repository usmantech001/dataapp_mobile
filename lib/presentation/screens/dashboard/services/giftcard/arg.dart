import '../../../../../core/model/core/breakdown.dart';

import '../../../../../core/model/core/giftcard_product_provider.dart';

class GiftcardArg {
  final GiftCardProduct product;
  final String amountInNGN;
  final GiftcardType type;
  final BreakdownInfo breakdown;
  final String category;
  final String quantity;
  final String amount;
  final String total;


  GiftcardArg({
    required this.amountInNGN,
    required this.category,
    required this.quantity,
    required this.product,
    required this.amount,
    required this.total,
    required this.type,
    required this.breakdown,
  });
}