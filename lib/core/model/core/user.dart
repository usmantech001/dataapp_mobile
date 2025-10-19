class User {
  final String? id;
  final String? firstname;
  final String? lastname;
  final String? fullName;
  final String? email;
  final String? phone_code;
  final String? phone;
  final String? username;
  final String? gender;
  final String? ref_code;
  final String? avatar;
  final String? country;
  final String? state;
  final String? status;
  final String? created_at;
  final String? deleted_at;
  final bool email_verified;
  final bool pin_activated;
  final bool bvn_verified;
  final bool bvn_validated;
  final bool transaction_biometric_activated;
  final bool two_factor_enabled;
  final num wallet_balance;

  User({
    this.id,
    this.fullName,
    this.firstname,
    this.lastname,
    this.email,
    this.username,
    this.avatar,
    this.created_at,
    this.deleted_at,
    this.ref_code,
    this.country,
    this.gender,
    this.phone,
    this.phone_code,
    this.state,
    this.status,
    this.email_verified = false,
    this.pin_activated = false,
    this.bvn_verified = false,
    this.bvn_validated = false,
    this.transaction_biometric_activated = false,
    this.two_factor_enabled = false,
    this.wallet_balance = 0,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map["id"].toString(),
      firstname: map["firstname"],
      lastname: map["lastname"],
      fullName: map['fullName'],
      email: map["email"],
      username: map["username"],
      avatar: "${map["avatar"]}?v=${DateTime.now().millisecondsSinceEpoch}",
      phone: map['phone'],
      country: map['country'],
      gender: map['gender'],
      state: map['state'],
      status: map['status'],
      phone_code: map['phone_code'],
      created_at: map["created_at"],
      deleted_at: map["deleted_at"],
      ref_code: map["ref_code"],
      email_verified: map["email_verified"] ?? false,
      pin_activated: map["pin_activated"] ?? false,
      bvn_verified: map["bvn_verified"] ?? false,
          bvn_validated: map["bvn_validated"] ?? false,
      transaction_biometric_activated:
          map["transaction_biometric_activated"] ?? false,
      two_factor_enabled: map['two_factor_enabled'] ?? false,
      wallet_balance: map["wallet"] == null
          ? 0
          : (num.tryParse("${map["wallet"]["balance"]}") ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'phone': phone,
      'phone_code': phone_code,
      'username': username,
      'gender': gender,
      'ref_code': ref_code,
      'avatar': avatar,
      'status': status,
      'created_at': created_at,
      'email_verified': email_verified,
      'pin_activated': pin_activated,
      'bvn_verified': bvn_verified,
      'country': country,
      'state': state,
      'transaction_biometric_activated': transaction_biometric_activated,
      'two_factor_enabled': two_factor_enabled,
      'wallet_balance': wallet_balance,
      // TODO:: uncomment
      // 'auth_type': auth_type,
      // 'countryObj': countryObj == null ? null : countryObj?.toMap(),
      // 'login_biometric_activated': login_biometric_activated,
    };
  }
}
