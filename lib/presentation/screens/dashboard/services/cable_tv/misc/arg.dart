import '../../../../../../core/model/core/cable_tv_plan.dart';
import '../../../../../../core/model/core/cable_tv_provider.dart';
import '../../../../../../core/model/core/discount.dart';

class CableTvArg {
  final CableTvProvider provider;
  final List<CableTvPlan> plans;
  final String number;
      Discount? discount;
  final CableTvType type;

  CableTvArg({
    required this.provider,
    required this.plans,
    required this.number,
    required this.type,
    this.discount,
  });
}
