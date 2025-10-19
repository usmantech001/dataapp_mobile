import '../../../presentation/misc/custom_components/custom_dropdown_btn.dart';

class GiftcardCategoryProviderResponse
    extends BaseCustomDropdownButtonFormFieldList {
  final String message;
  final List<GiftcardCategory> data;

  final Meta meta;

  GiftcardCategoryProviderResponse({
    required this.message,
    required this.data,
    required this.meta,
  });

  factory GiftcardCategoryProviderResponse.fromMap(Map<String, dynamic> json) {
    return GiftcardCategoryProviderResponse(
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => GiftcardCategory.fromJson(item))
          .toList(),
      meta: Meta.fromJson(json['meta']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }

  @override
  String toString() {
    return 'GiftcardCategoryResponse(message: $message, data: $data, meta: $meta)';
  }

  @override
  bool hasIcon() => false;

  @override
  String toIcon() => "";

  @override
  String toName() => "";
}

class GiftcardCategory extends BaseCustomDropdownButtonFormFieldList {
  final int id;
  final String name;
  final String icon;
  final String? saleTerm;
  final String? purchaseTerm;
  final bool saleActivated;
  final bool purchaseActivated;
  final String createdAt;
  final String? deletedAt;
  final int giftCardsCount;
  final List<Country> countries;

  GiftcardCategory({
    required this.id,
    required this.name,
    required this.icon,
    this.saleTerm,
    this.purchaseTerm,
    required this.saleActivated,
    required this.purchaseActivated,
    required this.createdAt,
    this.deletedAt,
    required this.giftCardsCount,
    required this.countries,
  });

  factory GiftcardCategory.fromJson(Map<String, dynamic> json) {
    return GiftcardCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      icon: json['icon'] ?? "",
      saleTerm: json['sale_term'] ?? "",
      purchaseTerm: json['purchase_term'] ?? "",
      saleActivated: json['sale_activated'] ?? false,
      purchaseActivated: json['purchase_activated'] ?? false,
      createdAt: json['created_at'] ?? "",
      deletedAt: json['deleted_at'] ?? "",
      giftCardsCount: json['gift_cards_count'] ?? 0,
      countries: (json['countries'] as List?)
              ?.map((item) => Country.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'sale_term': saleTerm,
      'purchase_term': purchaseTerm,
      'sale_activated': saleActivated,
      'purchase_activated': purchaseActivated,
      'created_at': createdAt,
      'deleted_at': deletedAt,
      'gift_cards_count': giftCardsCount,
      'countries': countries.map((item) => item.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'GiftcardCategory(id: $id, name: $name, icon: $icon, saleTerm: $saleTerm, '
        'purchaseTerm: $purchaseTerm, saleActivated: $saleActivated, '
        'purchaseActivated: $purchaseActivated, createdAt: $createdAt, '
        'deletedAt: $deletedAt, giftCardsCount: $giftCardsCount, countries: $countries)';
  }

  @override
  bool hasIcon() => true;

  @override
  String toIcon() => icon ?? "";

  @override
  String toName() => name;
}

class Country extends BaseCustomDropdownButtonFormFieldList {
  final int id;
  final String name;
  final String code;
  final String iso2;
  final String iso3;
  final String phoneCode;
  final String region;
  final String emoji;
  final String emojiCode;
  final String capital;
  final String currency;
  final String currencyName;
  final String currencySymbol;
  final String longitude;
  final String latitude;
  final String flagUrl;
  final bool canDoAirtime;
  final String? airtimeActivatedAt;
  final String createdAt;

  Country({
    required this.id,
    required this.name,
    required this.code,
    required this.iso2,
    required this.iso3,
    required this.phoneCode,
    required this.region,
    required this.emoji,
    required this.emojiCode,
    required this.capital,
    required this.currency,
    required this.currencyName,
    required this.currencySymbol,
    required this.longitude,
    required this.latitude,
    required this.flagUrl,
    required this.canDoAirtime,
    this.airtimeActivatedAt,
    required this.createdAt,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      name: json['name'] ?? "",
      code: json['code'] ?? "",
      iso2: json['iso2'] ?? "",
      iso3: json['iso3'] ?? "",
      phoneCode: json['phone_code'] ?? "",
      region: json['region'] ?? "",
      emoji: json['emoji'] ?? "",
      emojiCode: json['emoji_code'] ?? "",
      capital: json['capital'] ?? "",
      currency: json['currency'] ?? "",
      currencyName: json['currency_name'] ?? "",
      currencySymbol: json['currency_symbol'] ?? "",
      longitude: json['longitude'] ?? "",
      latitude: json['latitude'] ?? "",
      flagUrl: json['flag_url'] ?? "",
      canDoAirtime: json['can_do_airtime'] ?? "",
      airtimeActivatedAt: json['airtime_activated_at'] ?? "",
      createdAt: json['created_at'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'iso2': iso2,
      'iso3': iso3,
      'phone_code': phoneCode,
      'region': region,
      'emoji': emoji,
      'emoji_code': emojiCode,
      'capital': capital,
      'currency': currency,
      'currency_name': currencyName,
      'currency_symbol': currencySymbol,
      'longitude': longitude,
      'latitude': latitude,
      'flag_url': flagUrl,
      'can_do_airtime': canDoAirtime,
      'airtime_activated_at': airtimeActivatedAt,
      'created_at': createdAt,
    };
  }

  @override
  String toString() {
    return 'Country(id: $id, name: $name, code: $code, iso2: $iso2, iso3: $iso3, '
        'phoneCode: $phoneCode, region: $region, emoji: $emoji, emojiCode: $emojiCode, '
        'capital: $capital, currency: $currency, currencyName: $currencyName, '
        'currencySymbol: $currencySymbol, longitude: $longitude, latitude: $latitude, '
        'flagUrl: $flagUrl, canDoAirtime: $canDoAirtime, airtimeActivatedAt: $airtimeActivatedAt, '
        'createdAt: $createdAt)';
  }

  @override
  bool hasIcon() => false;

  @override
  String toIcon() => "";

  @override
  String toName() => name;
}

class Meta {
  final int page;
  final int perPage;
  final int total;

  Meta({
    required this.page,
    required this.perPage,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: json['page'],
      perPage: json['per_page'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'per_page': perPage,
      'total': total,
    };
  }

  @override
  String toString() {
    return 'Meta(page: $page, perPage: $perPage, total: $total)';
  }
}
