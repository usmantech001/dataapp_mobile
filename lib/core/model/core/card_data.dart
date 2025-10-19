class CardData {
  final String id;
  final String cardId;
  final String purpose;
  final String nameOnCard;
  final String last4;
  final String maskedNumber;
  final String expiryMonth;
  final String expiryYear;
  final String currency;
  final String type;
  final String brand;
  final String balance;
  final int active;
  final BillingDetails billingDetails;
  final Transaction transaction;

  CardData({
    required this.id,
    required this.cardId,
    required this.purpose,
    required this.nameOnCard,
    required this.last4,
    required this.maskedNumber,
    required this.expiryMonth,
    required this.expiryYear,
    required this.currency,
    required this.type,
    required this.brand,
    required this.balance,
    required this.active,
    required this.billingDetails,
    required this.transaction,
  });

  factory CardData.fromJson(Map<String, dynamic> json) {
    return CardData(
      id: json['id'].toString() ?? "",
      cardId: json['card_id'] ?? '',
      purpose: json['purpose'] ?? '',
      nameOnCard: json['name_on_card'] ?? '',
      last4: json['last4'] ?? '',
      maskedNumber: json['masked_number'] ?? '',
      expiryMonth: json['expiry_month'] ?? '',
      expiryYear: json['expiry_year'] ?? '',
      currency: json['currency'] ?? '',
      type: json['type'] ?? '',
      brand: json['brand'] ?? '',
      balance: json['balance'] ?? '',
      active: json['active'] ?? 0,
      billingDetails: BillingDetails.fromJson(json['billing_details'] ?? {}),
      transaction: Transaction.fromJson(json['transaction'] ?? {}),
    );
  }
}

class BillingDetails {
  final String city;
  final String line1;
  final String? line2;
  final String state;
  final String country;
  final String postalCode;

  BillingDetails({
    required this.city,
    required this.line1,
    this.line2,
    required this.state,
    required this.country,
    required this.postalCode,
  });

  factory BillingDetails.fromJson(Map<String, dynamic> json) {
    return BillingDetails(
      city: json['city'] ?? '',
      line1: json['line1'] ?? '',
      line2: json['line2'] ?? "",
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      postalCode: json['postal_code'] ?? '',
    );
  }
}

class Transaction {
  final String id;
  final String reference;
  final String? providerReference;
  final double amount;
  final double discount;
  final double fee;
  final double totalAmount;
  final String type;
  final String provider;
  final String remark;
  final String purpose;
  final String status;
  final Meta meta;
  final String createdAt;
  final double balanceBefore;
  final double balanceAfter;
  final String? proof;
  final String? reviewProof;
  final dynamic user;

  Transaction({
    required this.id,
    required this.reference,
    this.providerReference,
    required this.amount,
    required this.discount,
    required this.fee,
    required this.totalAmount,
    required this.type,
    required this.provider,
    required this.remark,
    required this.purpose,
    required this.status,
    required this.meta,
    required this.createdAt,
    required this.balanceBefore,
    required this.balanceAfter,
    this.proof,
    this.reviewProof,
    this.user,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'].toString() ?? '',
      reference: json['reference'] ?? '',
      providerReference: json['provider_reference'],
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      fee: (json['fee'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      type: json['type'] ?? '',
      provider: json['provider'] ?? '',
      remark: json['remark'] ?? '',
      purpose: json['purpose'] ?? '',
      status: json['status'] ?? '',
      meta: Meta.fromJson(json['meta'] ?? {}),
      createdAt: json['created_at'] ?? '',
      balanceBefore: (json['balance_before'] as num?)?.toDouble() ?? 0.0,
      balanceAfter: (json['balance_after'] as num?)?.toDouble() ?? 0.0,
      proof: json['proof'],
      reviewProof: json['review_proof'],
      user: json['user'],
    );
  }
}

class Meta {
  final double balanceAfter;
  final double balanceBefore;

  Meta({
    required this.balanceAfter,
    required this.balanceBefore,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      balanceAfter: (json['balance_after'] as num?)?.toDouble() ?? 0.0,
      balanceBefore: (json['balance_before'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
