import 'package:dataplug/core/model/core/discount.dart';
import 'package:dataplug/core/model/core/operator_provider.dart';

import '../../../../../core/model/core/country.dart';

class InternationalAirtimeArg {
  final OperatorProvider provider;
  final String amountInNGN;
  final String amountInCurrrency;
  Discount? discount;
  final Country country;
  final String emailAddress;

  final String phoneNumber;



  InternationalAirtimeArg({
    required this.amountInNGN,
    required this.amountInCurrrency,
    required this.country,
    required this.emailAddress,
   this.discount,
    required this.phoneNumber,
    required  this.provider,
  });
}