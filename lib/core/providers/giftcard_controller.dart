import 'package:dataplug/core/model/core/giftcard_category_provider.dart';
import 'package:dataplug/core/model/core/giftcard_product_provider.dart';
import 'package:dataplug/core/repository/giftcard_repo.dart';
import 'package:flutter/material.dart';

class GiftcardController extends ChangeNotifier{
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

  String? selectedCardType;

  int currentTypeTabIndex = 0;

  int giftcardQuantity = 1;

  final giftcardQuantityController = TextEditingController();
  final giftcardAmountController = TextEditingController();

  void quantityIncrementDecrement(bool isIncrement){
    if(isIncrement){
      giftcardQuantity++;
      notifyListeners();
    }else{
      if(giftcardQuantity>=2){
        giftcardQuantity--;
      notifyListeners();
      }
      
    }
  }

  void onSelectCategory(GiftcardCategory category){
    selectedCategory = category;
  }

  void onSelectProduct(GiftCardProduct product){
    selectedProduct = product;
  }

  void onSelectCountry(Country country){
    selectedCountry = country;
  }

  void onChangeTypeIndex(int index){
   currentTypeTabIndex = index;
   notifyListeners();
  }

  Future<void> getGiftcardCategories() async{
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

   Future<void> getGiftcardProducts() async{
    gettingProducts = true;
    productErrMsg = null;
    notifyListeners();
    try {
     final response = await giftcardRepo.getGiftcardProducts(categoryId: selectedCategory!.id.toString(), countryId: selectedCountry!.id.toString());
     products.addAll(response.data);
      gettingProducts = false;
      notifyListeners();
    } catch (e) {
      productErrMsg = e.toString();
      gettingProducts = false;
      notifyListeners();
    }
  }

  Future<void> buyGiftCard(String pin, {Function(String)? onError}) async{
    try {
      final response = await giftcardRepo.buyGiftcard(giftcardId: selectedProduct!.id, amount: giftcardAmountController.text.trim(), cardType: selectedCardType!, pin: pin, quantity: int.parse(giftcardQuantityController.text));
    } catch (e) {
      onError?.call(e.toString());
    }
  }

}