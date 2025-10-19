import 'dart:developer';

import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/core/model/core/card_rate.dart';
import 'package:flutter/material.dart';

import '../model/core/card_data.dart';
import '../model/core/card_service_fee.dart';
import '../model/core/card_transactions.dart';

class CardProvider with ChangeNotifier {
  // cards
  List<CardData> _cards = [];
  List<CardData> get cards => _cards;
  Future<void> getUsersCards() async {
    await ServicesHelper.getUsersCards().then((value) {
      _cards = value;
      notifyListeners();
    }).catchError((_) {
      // Optionally log the error
      print("Error fetching user cards: $_");
    });
  }

  List<CardTransaction> _cardtrasactions = [];
  List<CardTransaction> get cardTransactions => _cardtrasactions;
  Future<void> getUsersCardTransactions({required String id}) async {
    await ServicesHelper.getUsersCardTransactions(id: id).then((value) {
      _cardtrasactions = value;
      notifyListeners();
    }).catchError((_) {
      // Optionally log the error
      print("Error fetching user card transations: $_");
    });
  }

  // card service fee
  CardServiceFee? _serviceFee;
  CardServiceFee? get serviceFee => _serviceFee;

  Future<CardServiceFee?> getCardServiceFee({required String currency}) async {
    try {
      final result = await ServicesHelper.getCardServideFee(currency: currency);
      _serviceFee = result;
      notifyListeners();
      return _serviceFee;
    } catch (e) {
      // Optionally log the error
      print("Error fetching referral term: $e");
      return null;
    }
  }

  // card service fee
  CardServiceFee? _minimumAmount;
  CardServiceFee? get minimumAmount => _minimumAmount;

  Future<CardServiceFee?> getMinimumAmount({required String currency}) async {
    try {
      final result = await ServicesHelper.getMinimumAmount(currency: currency);
      _minimumAmount = result;
      notifyListeners();
      return _minimumAmount;
    } catch (e) {
      // Optionally log the error
      print("Error fetching referral term: $e");
      return null;
    }
  }

  // card rate
  CardRate? _cardRate;
  CardRate? get cardRate => _cardRate;

  Future<CardRate?> getCardRate({required String currency}) async {
    try {
      final result = await ServicesHelper.getCardRate(currency: currency);
      _cardRate = result;
      log(result!.currency.toString());
      log(result.rate.toString());
      notifyListeners();
      return _cardRate;
    } catch (e) {
      // Optionally log the error
      print("Error fetching referral term: $e");
      return null;
    }
  }
}
