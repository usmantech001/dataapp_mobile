enum NotificationType { error, warning, success, neutral }

enum DashboardTabs { home, services, history, referrals, settings, cards }

enum EmailVerificationType { signp, login, twoFA, passordReset, pinUpdate }

enum ToastType { error, success }

enum LoginProvider { password, google, apple }

enum ImageType { link, file }

enum Status { successful, pending, failed, reversed }

enum CashFlowType { credit, debit }

enum ServicePurpose {
  withdrawal,
  transfer,
  deposit,
  data,
  airtime,
  betting,
  tvSubscription,
  internationalAirtime,
  internationalData,
  education,
  electricity,
  na,
  virtualCard
}

enum Gender { male, female }

enum DataPurchaseType { direct, sme, awoof, cg, coupon, gifting}

// enum BiometricType { login, transaction }
enum ReferralStatus { all, active, inactive }

enum GiftCardTradeType { buy, sell }

enum InternationalPurchaseType { airtime, data }

enum GiftCardDenominationType { range, fixed }

enum GiftCardType { virtual, physical }

enum GiftcardAndCryptoTxnStatus {
  approved,
  partially_approved,
  pending,
  declined,
  transferred
}
