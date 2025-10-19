import 'package:dataplug/core/providers/card_provider.dart';
import 'package:dataplug/core/utils/utils.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_scaffold.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../misc/custom_components/custom_back_icon.dart';
import 'giftcard_transactions.dart';

// for TransactionItem

class AllGiftCardTransactions extends StatefulWidget {

  const AllGiftCardTransactions({super.key});

  @override
  State<AllGiftCardTransactions> createState() => _AllGiftCardTransactionsState();
}

class _AllGiftCardTransactionsState extends State<AllGiftCardTransactions> {
  final spacer = const SizedBox(height: 20);

  @override
  void initState() {
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {


    return CustomScaffold(
      backgroundColor: ColorManager.kPrimary,
      body: SafeArea(
        bottom: false,
        child: Container(
          decoration: BoxDecoration(
            color: ColorManager.kWhite,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.only(top: 20, ),
          child: Column(
            children: [
              // Top header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: BackIcon(),
                  ),
                  Expanded(
                    child: Text(
                      "Gift Card Transaction History",
                      textAlign: TextAlign.center,
                      style: get18TextStyle(),
                    ),
                  ),
                  const SizedBox(width: 40), // placeholder for symmetry
                ],
              ),
              customDivider(height: 1, margin: const EdgeInsets.only(top: 16)),
          
              Expanded(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GiftcardTxnView(hideAppBar: true),
              )),
              // Expanded(
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 16),
              //     child: transactions.isEmpty
              //         ? const Center(child: Text("No transactions found"))
              //         : ListView.builder(
              //             itemCount: transactions.length,
              //             itemBuilder: (context, index) {
              //               final txn = transactions[index];
              //               final date = txn.date;
              //               final formattedDate = DateFormat('dd/MM/yyyy').format(date);
              //               final formattedTime = DateFormat('hh:mm a').format(date);

              //               return Padding(
              //                 padding: const EdgeInsets.only(bottom: 20),
              //                 child: TransactionItem(
              //                   txn: txn,
              //                 ),
              //               );
              //             },
              //           ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
