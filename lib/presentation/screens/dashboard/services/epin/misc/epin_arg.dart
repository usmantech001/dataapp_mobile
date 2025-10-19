import 'package:dataplug/core/model/core/e_pin_product.dart';
import '../../../../../../core/model/core/e_pin_provider.dart';
import '../../../../../../core/model/core/discount.dart';

class EPinArg {
  final EPinProvider provider;
  final EPinProduct epinProduct;
  final String number;
    final Discount discount;
  final EPinProductType ePinProductType;

  EPinArg({
    required this.provider,
    required this.epinProduct,
    required this.number,
    required this.discount,
    required this.ePinProductType,
  });
}

