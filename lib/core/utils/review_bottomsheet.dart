import 'package:dataplug/core/model/core/review_model.dart';
import 'package:dataplug/presentation/misc/custom_components/transaction_review_item.dart';
import 'package:flutter/material.dart';

Future showReviewBottomShhet(BuildContext context,
    {required ReviewModel reviewDetails,
    bool isDismissible = false,
    bool isScrollControlled = true}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return TransactionReviewBottomSheetItem(reviewDetails: reviewDetails);
    },
    isScrollControlled: isScrollControlled,
    isDismissible: isDismissible,
    clipBehavior: Clip.none,
  );
}
