class Referral {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final num? amount;
  final DateTime? created_at;
  final bool paid;
  final bool active;
  final String avatar;

  Referral({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.created_at,
    required this.amount,
    required this.paid,
    required this.active,
    required this.avatar,
  });

  factory Referral.fromMap(Map<String, dynamic> map) {
    return Referral(
      id: map["id"].toString(),
      avatar: map["referred"]["avatar"] ?? "",
      firstname: map["referred"]["firstname"] ?? "NA",
      lastname: map["referred"]["lastname"] ?? "NA",
      email: map["referred"]["email"] ?? "NA",
      created_at: DateTime.tryParse(map["created_at"]),
      amount: map["amount"] ?? 0,
      paid: map["paid"] ?? false,
      active: map['status'].toString().toLowerCase() == "1" ? true : false,
    );
  }
}

class ReferralInfo {
  final String refCode;
  final String totalEarnings;
  final String totalReferrals;

  ReferralInfo(
      {required this.refCode,
      required this.totalEarnings,
      required this.totalReferrals});

  factory ReferralInfo.fromJson(Map<String, dynamic> json) {
    return ReferralInfo(
        refCode: json['ref_code'].toString(),
        totalEarnings: json['total_earnings'].toString(),
        totalReferrals: json['total_referrals'].toString());
  }
}
