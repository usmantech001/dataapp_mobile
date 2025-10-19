import 'package:dataplug/core/model/core/service_txn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/image_manager/image_manager.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';

import '../color_manager/color_manager.dart';
import '../custom_components/custom_scaffold.dart';

class TransactionStatus extends StatelessWidget {
  final ServiceTxn param;
  const TransactionStatus({super.key, required this.param});

  final spacer = const SizedBox(height: 40);

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
          padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // Use microtask to prevent navigator lock
             Future.delayed(Duration.zero, () {
  Navigator.of(context).pushNamedAndRemoveUntil(
    RoutesManager.dashboardWrapper,
    (route) => false,
  );
});
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: Text(
                      "Finish",
                      style: get14TextStyle().copyWith(
                          fontWeight: FontWeight.w600,
                          color: ColorManager.kPrimary),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 33),
              Image.asset(
                ImageManager.kBigSuccessIcon,
                width: 159,
                height: 159,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 35, bottom: 8),
                child: Text("Success", style: get18TextStyle()),
              ),
              Text(
                "Your transaction has been completed",
                style: get14TextStyle().copyWith(),
              ),
              const SizedBox(height: 38),
              CustomButton(
                text: "View Receipt",
                isActive: true,
                onTap: () async {
                  await Navigator.pushNamed(
                      context, RoutesManager.historyDetails,
                      arguments: param);
                  // Navigator.pop(context);
                },
                loading: false,
              )
            ],
          ),
        ),
      ),
    );
  }
}
