import 'package:dataplug/presentation/misc/custom_components/summary_item.dart';
import 'package:flutter/material.dart';

class ReviewModel {
  List<SummaryItem> summaryItems;
  Function(String) onPinCompleted;
  String amount;
  String? shortInfo;
  String? providerName;
  String? logo;
  String? providerType;
  VoidCallback? onChangeProvider;

  ReviewModel(
      {required this.summaryItems,
      required this.amount,
       this.shortInfo,
       this.providerName,
      this.providerType,
      this.logo,
      required this.onPinCompleted,
      this.onChangeProvider
      });
}

class ReceiptModel {
  List<SummaryItem> summaryItems;
  String amount;
  String shortInfo;
  String? providerName;
  String? logo;
  String? providerType;

  ReceiptModel(
      {required this.summaryItems,
      required this.amount,
      required this.shortInfo,
       this.providerName,
      this.providerType,
      this.logo,
      });
}
