import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/core/model/core/giftcard_category_provider.dart';
import 'package:dataplug/core/model/core/giftcard_product_provider.dart';
import 'package:dataplug/core/model/core/giftcard_txn.dart';

class GiftcardRepo {
  
  Future<GiftcardCategoryProviderResponse> getGiftcardCategories(
      {String? search, required int page}) async {
    return await ServicesHelper.getGiftcardCategories(
        search: search, page: page);
  }

  Future<GiftcardProductResponse> getGiftcardProducts(
      {required String categoryId, required String countryId}) async {
    return await ServicesHelper.getGiftcardProduct(
        categoryId: categoryId, countryId: countryId);
  }

  Future<GiftcardTxn> buyGiftcard({
    required int giftcardId,
    required String amount,
    required String cardType,
    required String pin,
    required int quantity,
  }) async {
    return await ServicesHelper.buyGiftcard(
        giftcardId: giftcardId,
        amount: amount,
        cardType: cardType,
        pin: pin,
        quantity: quantity);
  }
}
