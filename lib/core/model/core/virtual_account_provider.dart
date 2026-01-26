class VirtualAccountProvider {
  final String name;
  final String logo;
  // final bool isPermanent;
  final List<VirtualAccProviderPaymentOptions> payment_options;

  VirtualAccountProvider({
    required this.name,
    required this.logo,
    // required this.isPermanent,
    required this.payment_options,
  });

  factory VirtualAccountProvider.fromMap(Map<String, dynamic> map) {
    return VirtualAccountProvider(
      name: map["name"].toString(),
      logo: map["logo"].toString(),
      payment_options: (map["payment_options"] as List)
          .map((e) => VirtualAccProviderPaymentOptions.fromMap(e))
          .toList(),
    );
  }
}

class VirtualAccProviderPaymentOptions {
  final String name;
  final String code;
  final String logo;

  VirtualAccProviderPaymentOptions({
    required this.name,
    required this.code,
    required this.logo,
  });

  factory VirtualAccProviderPaymentOptions.fromMap(Map<String, dynamic> map) {
    return VirtualAccProviderPaymentOptions(
      name: map["name"].toString(),
      logo: map["logo"].toString(),
      code: map["code"].toString(),
    );
  }
}


class VirtualAccountDetails {
  final String id;
  final int userId;
  final String provider;
  final String bankCode;
  final String bankName;
  final String customerName;
  final String accountName;
  final String accountNumber;
  final String type;
  final DateTime expiredAt;
  final DateTime createdAt;

  VirtualAccountDetails({
    required this.id,
    required this.userId,
    required this.provider,
    required this.bankCode,
    required this.bankName,
    required this.customerName,
    required this.accountName,
    required this.accountNumber,
    required this.type,
    required this.expiredAt,
    required this.createdAt,
  });

  factory VirtualAccountDetails.fromJson(Map<String, dynamic> json) {
    return VirtualAccountDetails(
      id: json['id'],
      userId: json['user_id'],
      provider: json['provider'],
      bankCode: json['bank_code'],
      bankName: json['bank_name'],
      customerName: json['customer_name'],
      accountName: json['account_name'],
      accountNumber: json['account_number'],
      type: json['type'],
      expiredAt: DateTime.parse(json['expired_at']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'provider': provider,
      'bank_code': bankCode,
      'bank_name': bankName,
      'customer_name': customerName,
      'account_name': accountName,
      'account_number': accountNumber,
      'type': type,
      'expired_at': expiredAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
