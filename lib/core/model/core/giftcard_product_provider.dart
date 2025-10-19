import 'package:dataplug/core/model/core/giftcard_category_provider.dart';
import 'package:intl/intl.dart';

import '../../../presentation/misc/custom_components/custom_dropdown_btn.dart';



class GiftcardProductResponse  extends BaseCustomDropdownButtonFormFieldList{
  final String message;
  final List<GiftCardProduct> data;


  final Meta meta;

  GiftcardProductResponse({
    required this.message,
    required this.data,
    required this.meta,
  });

  factory GiftcardProductResponse.fromMap(Map<String, dynamic> json) {
    return GiftcardProductResponse(
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => GiftCardProduct.fromJson(item))
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

class GiftCardProduct extends BaseCustomDropdownButtonFormFieldList{
  final int id;
  final int countryId;
  final int categoryId;
  final String name;
  final String logo;
  final String denominationType;
  final String currency;
  final double senderFee;
  final double? minAmount;
  final double? maxAmount;
  final double? minAmountNgn;
  final double? maxAmountNgn;
  final List<double>? priceList;
  final List<double>? ngnPriceList;
  final Map<String, double>? mappedPriceList;
  final String status;
  final bool preorder;
  final Country? country;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final double? sellRate;
  final double? buyRate;

  GiftCardProduct({
    required this.id,
    required this.countryId,
    required this.categoryId,
    required this.name,
    required this.logo,
    required this.denominationType,
    required this.currency,
    required this.senderFee,
    this.minAmount,
    this.maxAmount,
    this.minAmountNgn,
    this.maxAmountNgn,
    this.priceList,
    this.country,
    this.ngnPriceList,
    this.mappedPriceList,
    required this.status,
    required this.preorder,
    required this.createdAt,
    this.deletedAt,
    this.sellRate,
    this.buyRate,
  });

  factory GiftCardProduct.fromJson(Map<String, dynamic> json) {
    return GiftCardProduct(
         id: json['id'] ?? 0, // Provide default values
    countryId: json['country_id'] ?? 0,
    categoryId: json['category_id'] ?? 0,
    name: json['name'] ?? '',
    logo: json['logo'] ?? '',
    denominationType: json['denomination_type'] ?? '',
    currency: json['currency'] ?? '',
    senderFee: (json['sender_fee'] ?? 0).toDouble(),
    minAmount: json['min_amount']?.toDouble(),
    maxAmount: json['max_amount']?.toDouble(),
    minAmountNgn: json['min_amount_ngn']?.toDouble(),
    maxAmountNgn: json['max_amount_ngn']?.toDouble(),

    priceList: (json['price_list'] as List?)
        ?.map((e) => (e as num).toDouble())
        .toList(),
    ngnPriceList: (json['ngn_price_list'] as List?)
        ?.map((e) => (e as num).toDouble())
        .toList(),
    mappedPriceList: (json['mapped_price_list'] as Map?)
        ?.map((key, value) => MapEntry(key, (value as num).toDouble())),

    status: json['status'] ?? '',
    preorder: json['preorder'] ?? false,
    createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),

    deletedAt: json['deleted_at'] != null
        ? DateTime.tryParse(json['deleted_at'])
        : null,

    // Null-safe country parsing
    country: json['country'] != null
        ? Country.fromJson(json['country'])
        : null,

    sellRate: json['sell_rate']?.toDouble(),
    buyRate: json['buy_rate']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country_id': countryId,
      'category_id': categoryId,
      'name': name,
      'logo': logo,
      'denomination_type': denominationType,
      'currency': currency,
      'sender_fee': senderFee,
      'min_amount': minAmount,
      'max_amount': maxAmount,
      'min_amount_ngn': minAmountNgn,
      'max_amount_ngn': maxAmountNgn,
      'price_list': priceList,
      'ngn_price_list': ngnPriceList,
      'mapped_price_list': mappedPriceList,
      'status': status,
      'preorder': preorder,
      'created_at': createdAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'sell_rate': sellRate,
      'buy_rate': buyRate,
    };
  }

      @override
  bool hasIcon() => true;

  @override
  String toIcon() => logo ?? "";

  @override
  String toName() => "$name (Rate: ${NumberFormat.currency(locale: 'en_NG', symbol: '₦').format(buyRate)}   Min:${NumberFormat.simpleCurrency(locale: 'en_NG', name: currency, decimalDigits: 0).format(minAmount ?? priceList?.first ?? 0)}  Max:${NumberFormat.simpleCurrency(locale: 'en_NG', name: currency, decimalDigits: 0).format(maxAmount ?? priceList?.last ?? 0)})";
  // String toName() => "$name";
}



class GiftcardType extends BaseCustomDropdownButtonFormFieldList {
  final String type;

  GiftcardType(this.type);

  //
  @override
  String toIcon() => "";

  @override
  String toName() => type;

  @override
  bool hasIcon() => false;
}