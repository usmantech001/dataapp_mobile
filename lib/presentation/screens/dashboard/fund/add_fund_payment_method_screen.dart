import 'package:dataplug/core/providers/wallet_controller.dart';
import 'package:dataplug/core/utils/app-loader.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_snackbar.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:dataplug/presentation/screens/dashboard/fund/widgets/funding_method_provider_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AddFundPaymentMethodScreen extends StatelessWidget {
  const AddFundPaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WalletController>().getVirtualAccountProviders();
    });
    return Consumer<WalletController>(
      builder: (context, walletController, child) {
        return Scaffold(
          appBar: CustomAppbar(title: 'Fund account'),
          bottomNavigationBar: CustomBottomNavBotton(text: 'Proceed', onTap: () {
          if(walletController.virtualAccProviders.isNotEmpty){
            displayLoader(context);
            walletController.fundWallet(onSuccess: (details){
              //popScreen();
              removeAllAndPushScreen(RoutesManager.virtualAcctountDetails, arguments: details);
            }, onError: (err) {
              popScreen();
              showCustomToast(context: context, description: err.toString());
            },);
          }
          }),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: walletController.gettingVirtualAccsProvider
                ? const Center(child: CircularProgressIndicator())
                : !walletController.gettingVirtualAccsProvider &&
                        walletController.virtualAccProviderErrMsg != null
                    ? Center(
                        child: Text(walletController.virtualAccProviderErrMsg!),
                      )
                    : Column(
                        children: [
                          Text(
                            'Please select your preferred funding method',
                            style: get14TextStyle().copyWith(
                                color: ColorManager.kBlack.withOpacity(0.8)),
                          ),
                          Column(
                            children: List.generate(
                                walletController.virtualAccProviders.length,
                                (index) {
                              final provider =
                                  walletController.virtualAccProviders[index];
                              return FundingMethodWidget(
                                name: provider.name ?? "",
                                imgPath: provider.logo ?? "",
                                isSelected:
                                    walletController.selectedFundingMethodIndex ==
                                            index
                                        ? true
                                        : false,
                                onTap: () {
                                  walletController.onSelectFundingMethod(index);
                                },
                              );
                            }),
                          ),
                        ],
                      ),
          ),
        );
      }
    );
  }
}
