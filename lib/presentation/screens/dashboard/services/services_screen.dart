import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/screens/dashboard/home/widgets/service_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'All Services',
        canPop: Navigator.canPop(context)? true: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 24.h),
        child: Column(
          spacing: 16.h,
          children: [
            ServiceContainer(title: 'Bills', serviceTypes: [
              ServiceTypeContainer(
                name: 'Data',
                iconPath: 'data-icon',
                onTap: () => pushNamed(RoutesManager.buyData),
              ),
              ServiceTypeContainer(
                  name: 'Airtime',
                  iconPath: 'airtime-icon',
                  onTap: () =>
                      Navigator.pushNamed(context, RoutesManager.buyAirtime1)),
              ServiceTypeContainer(
                  name: 'Electricity',
                  iconPath: 'electricity-icon',
                  onTap: () => Navigator.pushNamed(
                      context, RoutesManager.electricityProviders)),
              ServiceTypeContainer(
                  name: 'TV/Cable',
                  iconPath: 'cable-icon',
                  onTap: () => Navigator.pushNamed(
                      context, RoutesManager.cableTvProviders)),
              ServiceTypeContainer(
                  name: 'Betting',
                  iconPath: 'betting-icon',
                  onTap: () => Navigator.pushNamed(
                      context, RoutesManager.bettingProviders)),
              ServiceTypeContainer(name: 'E-Pin', 
              iconPath: 'epin-icon',
              onTap: ()=> pushNamed(RoutesManager.epinProviders)),
            ]),
            ServiceContainer(title: 'Wallet Activities', serviceTypes: [
              ServiceTypeContainer(name: 'Withdraw', 
              iconPath: 'withdraw-green',
              onTap: () {}),
              ServiceTypeContainer(
                  name: 'Transfer',
                  iconPath: 'transfer-green',
                  onTap: () =>
                      Navigator.pushNamed(context, RoutesManager.buyAirtime1)),
              ServiceTypeContainer(name: 'Top Up', 
              iconPath: 'topup-green',
              onTap: () {}),
            ]),
            ServiceContainer(title: 'Others', serviceTypes: [
               ServiceTypeContainer(
                                      name: 'Int\'t Data',
                                      iconPath: 'intl-data-icon',
                                       onTap: ()=>  pushNamed(RoutesManager.intlDataCountries)),
                                  ServiceTypeContainer(
                                      name: 'Int\'t Airtime', 
                                      iconPath: 'intl-airtime-icon',
                                      onTap: ()=> Navigator.pushNamed(context, RoutesManager.intlAirtimeCountries)),
                                  ServiceTypeContainer(
                                      name: 'GiftCard', 
                                      iconPath: 'giftcard-icon',
                                      onTap: ()=> Navigator.pushNamed(context, RoutesManager.giftcardCategory)),
            ]),
          ],
        ),
      ),
    );
  }
}
