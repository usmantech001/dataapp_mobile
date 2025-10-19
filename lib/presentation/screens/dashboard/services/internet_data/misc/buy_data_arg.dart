import '../../../../../../core/enum.dart';
import '../../../../../../core/model/core/data_plans.dart';
import '../../../../../../core/model/core/data_provider.dart';
import '../../../../../../core/model/core/discount.dart';

class BuyDataArg {
  final DataProvider dataProvider;
  final String phone;
    Discount? discount;
    final bool isPorted;
  final DataPurchaseType dataPurchaseType;
  final List<DataPlan> dataPlans;
  DataPlan? selectedPlan;

  BuyDataArg({
    required this.dataProvider,
    required this.phone,
    required this.dataPurchaseType,
    required this.dataPlans,
    required this.isPorted,
     this.discount,
    this.selectedPlan,
  });
}