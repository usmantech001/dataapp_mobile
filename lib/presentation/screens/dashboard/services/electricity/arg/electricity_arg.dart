import 'package:dataplug/core/model/core/electricity_provider.dart';

import '../../../../../../core/model/core/discount.dart';

class ElectricityArg {
  final ElectricityProvider electricityProvider;
  final num amount;
  final ElectricityMeterType meterType;
  final String meterNumber;
  final String meterName;
  final String meterAddress;
  final String phone;
  final Discount discount;

  ElectricityArg(
      {required this.electricityProvider,
      required this.amount,
      required this.meterType,
      required this.meterNumber,
      required this.phone,
      required this.meterName,
      required this.meterAddress,
      required this.discount});
}
