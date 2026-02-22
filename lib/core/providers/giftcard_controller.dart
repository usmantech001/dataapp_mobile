import 'package:dataplug/core/model/core/giftcard_category_provider.dart';
import 'package:dataplug/core/model/core/giftcard_product_provider.dart';
import 'package:dataplug/core/model/core/giftcard_txn.dart';
import 'package:dataplug/core/repository/giftcard_repo.dart';
import 'package:flutter/material.dart';

class GiftcardController extends ChangeNotifier {
  GiftcardRepo giftcardRepo;

  GiftcardController({required this.giftcardRepo});

  final List<String> giftCardTypes = ['Virtual', 'Physical'];

  List<GiftcardCategory> categories = [];
  List<GiftCardProduct> products = [];

  bool gettingCategories = false;
  bool gettingProducts = false;

  String? categoryErrMsg;
  String? productErrMsg;

  GiftcardCategory? selectedCategory;
  GiftCardProduct? selectedProduct;
  Country? selectedCountry;

  

  int currentTypeTabIndex = 0;

  int giftcardQuantity = 1;

  num totalAmount = 0;
  num rate = 0;

  final giftcardQuantityController = TextEditingController();
  final giftcardAmountController = TextEditingController();

  void initializeAmount() {
    giftcardQuantity = 1;
    rate = selectedProduct!.buyRate ?? 0;

    totalAmount = rate * 1;
    giftcardAmountController.clear();
    notifyListeners();
  }

  void onSelectAmount(String amount) {
    giftcardAmountController.text = amount;
    calculateAmount();
    notifyListeners();
  }

  void calculateAmount() {
    num amount = giftcardAmountController.text.isEmpty
        ? 1
        : num.parse(giftcardAmountController.text);
    totalAmount = rate * giftcardQuantity * amount;
    print('..the total amount is $totalAmount');
    notifyListeners();
  }

  void quantityIncrementDecrement(bool isIncrement) {
    if (isIncrement) {
      giftcardQuantity++;
      calculateAmount();
      notifyListeners();
    } else {
      if (giftcardQuantity >= 2) {
        giftcardQuantity--;
        calculateAmount();
        notifyListeners();
      }
    }
  }

  void onSelectCategory(GiftcardCategory category) {
    selectedCategory = category;
  }

  void onSelectProduct(GiftCardProduct product) {
    selectedProduct = product;
  }

  void onSelectCountry(Country country) {
    selectedCountry = country;
  }

  void onChangeTypeIndex(int index) {
    currentTypeTabIndex = index;
    notifyListeners();
  }

  Future<void> getGiftcardCategories() async {
    gettingCategories = true;
    categoryErrMsg = null;
    notifyListeners();
    try {
      final response = await giftcardRepo.getGiftcardCategories(page: 1);
      categories.addAll(response.data);
      gettingCategories = false;
      notifyListeners();
    } catch (e) {
      categoryErrMsg = e.toString();
      gettingCategories = false;
      print('..failed to get categories ${e.toString()}');
      notifyListeners();
    }
  }

  Future<void> getGiftcardProducts() async {
    gettingProducts = true;
    productErrMsg = null;
    products = [];
    notifyListeners();
    try {
      final response = await giftcardRepo.getGiftcardProducts(
          categoryId: selectedCategory!.id.toString(),
          countryId: selectedCountry!.id.toString());
      products.addAll(response.data);
      print('...giftcard data ${response.data[0].toJson()}');
      gettingProducts = false;
      notifyListeners();
    } catch (e) {
      productErrMsg = e.toString();
      gettingProducts = false;
      notifyListeners();
    }
  }

  Future<void> buyGiftCard(String pin,
      {Function(GiftcardTxn)? onSuccess, Function(String)? onError}) async {
    try {
      final response = await giftcardRepo.buyGiftcard(
          giftcardId: selectedProduct!.id,
          amount: giftcardAmountController.text.trim(),
          cardType: currentTypeTabIndex == 0?'virtual' : 'physical',
          pin: pin,
          quantity: int.parse(giftcardQuantity.toString()));
      onSuccess?.call(response);
      print('...giftcard success $response');
    } catch (e, s) {
      print('...err $s');
      onError?.call(e.toString());
    }
  }
}
