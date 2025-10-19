import 'package:dataplug/core/model/core/discount.dart';

import '../../../../../../core/model/core/airtime_provider.dart';

class AirtimeArg {
  final AirtimeProvider airtimeProvider;
  final num amount;
  final String phone;
  final Discount discount;
  final bool  is_ported;

  AirtimeArg({
    required this.airtimeProvider,
    required this.amount,
    required this.phone,
    required this.discount,
    required this.is_ported,
  });
}
