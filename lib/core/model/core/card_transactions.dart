class CardTransaction {
  final int id;
  final String reference;
  final double amount;
  final String currency;
  final String narration;
  final String type;
  final String status;
  final DateTime date;
  final Merchant merchant;
  final Meta meta;

  CardTransaction({
    required this.id,
    required this.reference,
    required this.amount,
    required this.currency,
    required this.narration,
    required this.type,
    required this.status,
    required this.date,
    required this.merchant,
    required this.meta,
  });

  factory CardTransaction.fromJson(Map<String, dynamic> json) {
    return CardTransaction(
      id: json['id'] ?? 0,
      reference: json['reference'] ?? "",
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? "",
      narration: json['narration'] ?? "",
      type: json['type'] ?? "",
      status: json['status'] ?? "",
      date: DateTime.tryParse(json['date'] ?? "") ?? DateTime.now(),
      merchant: Merchant.fromJson(json['merchant'] ?? {}),
      meta: Meta.fromJson(json['meta'] ?? {}),
    );
  }
}

class Merchant {
  final String name;
  final String city;
  final String country;

  Merchant({
    required this.name,
    required this.city,
    required this.country,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      name: json['name'] ?? "",
      city: json['city'] ?? "",
      country: json['country'] ?? "",
    );
  }
}

class Meta {
  final double amount;
  final String status;
  final String currency;
  final String narration;
  final String reference;
  final String responseCode;
  final String responseMessage;
  final String paymentReference;
  final FeeDetails feeDetails;

  Meta({
    required this.amount,
    required this.status,
    required this.currency,
    required this.narration,
    required this.reference,
    required this.responseCode,
    required this.responseMessage,
    required this.paymentReference,
    required this.feeDetails,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    final nested = json['meta'] ?? {};
    return Meta(
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? "",
      currency: json['currency'] ?? "",
      narration: json['narration'] ?? "",
      reference: json['reference'] ?? "",
      responseCode: json['response_code'] ?? "",
      responseMessage: json['response_message'] ?? "",
      paymentReference: json['payment_reference'] ?? "",
      feeDetails: FeeDetails.fromJson(json['fee_details'] ?? {})
    );
  }
}


class FeeDetails {
  final String feeType;
  final num feeAmount;
  final num totalAmount;
  final num baseAmount;
  final String feeCurrency;


  FeeDetails({
    required this.feeAmount,
    required this.totalAmount,
    required this.feeCurrency,
    required this.feeType,
    required this.baseAmount,
 
  });

  factory FeeDetails.fromJson(Map<String, dynamic> json) {
   
    return FeeDetails(
      feeType: json['fee_type'] ?? "",
      totalAmount: json['total_amount'] ?? 0,
      baseAmount: json['base_amount'] ?? 0,
      feeAmount: json['fee_amount'] ?? 0,
      feeCurrency: json['fee_currency'] ?? "",
  
    );
  }
}
