class FundCardSummaryArg {
  final String id;
  final String type;
  final num fundingAmount;
  final num amountInNaira;
  final num exchangeRate; // Assuming a fixed exchange rate for simplicity


  FundCardSummaryArg({
    required this.id,
    required this.type,
    required this.fundingAmount,
    required this.amountInNaira,
    required this.exchangeRate,

  });
}