


import '../../../../../core/model/core/country.dart';
import '../../../../../core/model/core/operator_provider.dart';
import '../../../../../core/model/core/operator_type_provider.dart';
import 'package:dataplug/core/model/core/discount.dart';

class InternationalDataArg {
  final OperatorProvider provider;
  final OperatorTypeProvider providerType;
  final String amountInNGN;
  final String amountInCurrrency;
  final Country country;
  Discount? discount;
  final String emailAddress;
  final String phoneNumber;

  InternationalDataArg({
    required this.amountInNGN,
    required this.amountInCurrrency,
    required this.country,
    required this.emailAddress,
    required this.providerType,
    this.discount,
    required this.phoneNumber,
    required  this.provider,
  });
}