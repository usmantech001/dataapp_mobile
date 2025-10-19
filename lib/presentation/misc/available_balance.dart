import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/user_provider.dart';
import '../../core/utils/utils.dart';
import 'custom_components/custom_check_confirmed.dart';

class AvailableBalance extends StatelessWidget {
  const AvailableBalance({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return CustomCheckConfirmed(
        text:
            "AVAILABLE BALANCE: ${formatNumber(userProvider.user.wallet_balance)} NGN",
        showCheck: false);
  }
}
