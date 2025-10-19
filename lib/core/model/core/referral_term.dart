class ReferralTerm {
  final String body;

  ReferralTerm({required this.body});

  factory ReferralTerm.fromJson(Map<String, dynamic> json) {
    return ReferralTerm(body: json['body']);
  }
}
