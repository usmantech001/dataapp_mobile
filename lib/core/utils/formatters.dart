import 'package:intl/intl.dart';

String formatCurrency(
  num? amount, {
  String? locale,
  bool showSymbol = true,
  String? symbol,
  int? decimal,
}) {
  // Convert the integer to a double and divide by 100 to include cents
  final double amountInNaira = (amount ?? 0) / 1;

  // Use NumberFormat to format the double with commas and two decimal places
  final formatter = NumberFormat.currency(
    locale: locale ?? 'en_NG',
    symbol: showSymbol ? symbol ?? '₦' : '',
    decimalDigits: decimal ?? 2,
  );

  return formatter.format(amountInNaira);
}



String formatUseableAmount(String amount){
  final useableAmount = amount.replaceAll('₦', '').replaceAll(',', '');
  return useableAmount;
}
