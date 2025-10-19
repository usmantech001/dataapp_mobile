import 'package:dataplug/core/providers/card_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/helpers/service_helper.dart';
import '../../../../core/model/core/card_data.dart';
import '../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../misc/custom_snackbar.dart';
import '../../../misc/transaction_pin/transaction_pin.dart';

class BlockVirtualCardView extends StatelessWidget {
  final String id;
  const BlockVirtualCardView({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    CardProvider provider = Provider.of<CardProvider>(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 80),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Freeze Virtual Card',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFF2E2E3A),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Are you sure you want to freeze this virtual card?',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE5E7EB),
                    foregroundColor: const Color(0xFF4B5563),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    elevation: 0,
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async{
                    createTransaction(BuildContext context,
                        {required String transaction_pin}) async {
                      try {
                        CardData _ = await ServicesHelper.toggleCardStatus(
                          id: id,
                          method: "PUT",
                          pin: transaction_pin,
                        );

                        // await Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => CardHistoryDetails(
                        //               param: _,
                        //             )));

                          await provider.getUsersCards();
                        Navigator.pop(context);
                        Navigator.pop(context);

                      } catch (err) {
                        showCustomToast(
                            context: context, description: err.toString());
                      }}

                      //
                      await showCustomBottomSheet(
                          context: context,
                          screen: TransactionPin(funcCall: createTransaction));
                  
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF14B8A6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    elevation: 0,
                  ),
                  child: const Text('Proceed'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}