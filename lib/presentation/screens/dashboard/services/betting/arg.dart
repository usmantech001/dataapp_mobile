import '../../../../../core/model/core/betting_provider.dart';
import '../../../../../core/model/core/discount.dart';

class BettingArg {
  final BettingProvider provider;
  final String name;
  final String number;
  final String amount;
  final Discount discount;

  BettingArg({
    required this.provider,
    required this.name,
    required this.number,
    required this.amount,
    required this.discount,
  });
}
