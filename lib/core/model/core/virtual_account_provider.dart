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
