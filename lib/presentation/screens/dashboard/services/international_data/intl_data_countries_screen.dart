import 'package:dataplug/core/providers/intl_airtime_controller.dart';
import 'package:dataplug/core/providers/intl_data_controller.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_input_field.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

class IntlDataCountriesScreen extends StatefulWidget {
  const IntlDataCountriesScreen({super.key});

  @override
  State<IntlDataCountriesScreen> createState() =>
      _IntlDataCountriesScreenState();
}

class _IntlDataCountriesScreenState
    extends State<IntlDataCountriesScreen> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IntlDataController>().getIntlDataCountries();
    });
  }

  @override
  Widget build(BuildContext context) {
    final intlDataController = context.watch<IntlDataController>();
    final fromReview = ModalRoute.of(context)?.settings.arguments as bool?;
    return Scaffold(
      appBar: CustomAppbar(title: 'International Data'),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 24),
            child: CustomInputField(
              formHolderName: "Select Service Provider",
              hintText: "Search",
              textInputAction: TextInputAction.next,
              suffixIcon: Icon(
                LucideIcons.search,
                color: ColorManager.kGreyColor.withValues(alpha: .7),
              ),
               textEditingController: intlDataController.searchController,
              onChanged: (query) {
                intlDataController.filterCountries(query);
              },
            ),
          ),
          Expanded(
              child: intlDataController.gettingCountries
                  ? Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      itemBuilder: (context, index) {
                        final country =intlDataController
                                .searchController.text.isNotEmpty
                            ? intlDataController
                                .filteredIntlDataCountries[index]:
                            intlDataController.intlDataCountries[index];
                        return InkWell(
                          onTap: () {
                            intlDataController.onSelectCountry(country);
                            // if(fromReview!=null){

                            // }
                            Navigator.pushNamed(
                                context, RoutesManager.buyIntlData);
                          },
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: ColorManager.kWhite,
                                borderRadius: BorderRadius.circular(16)),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: loadNetworkImage(
                                    country.flagUrl ?? "",
                                    width: 30.h,
                                    height: 30.w,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                ),
                               //CustomNetworkImage(imageUrl: country.flagUrl??""),
                                Gap(12),
                                Text(
                                  country.name ?? "",
                                  style: get16TextStyle()
                                      .copyWith(fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Gap(8),
                      itemCount:intlDataController
                                .searchController.text.isNotEmpty
                            ? intlDataController
                                .filteredIntlDataCountries.length:
                            intlDataController.intlDataCountries.length))
        ],
      ),
    );
  }
}
