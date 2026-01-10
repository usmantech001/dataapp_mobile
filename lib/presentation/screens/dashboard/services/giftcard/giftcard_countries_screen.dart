import 'package:dataplug/core/model/core/custom_network_image.dart';
import 'package:dataplug/core/model/core/giftcard_category_provider.dart';
import 'package:dataplug/core/providers/electricity_controller.dart';
import 'package:dataplug/core/providers/giftcard_controller.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_input_field.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

class GiftcardCountriesScreen extends StatefulWidget {
  const GiftcardCountriesScreen({super.key});

  @override
  State<GiftcardCountriesScreen> createState() =>
      _GiftcardCountriesScreenState();
}

class _GiftcardCountriesScreenState extends State<GiftcardCountriesScreen> {
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
      // context.read<GiftcardController>().getG();
    });
  }

  @override
  Widget build(BuildContext context) {
    final giftCardController = context.read<GiftcardController>();
    List<Country> giftCardCountries =
        ModalRoute.of(context)?.settings.arguments as List<Country>;

    return Scaffold(
      appBar: CustomAppbar(title: 'Buy GiftCard'),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 24),
            child: CustomInputField(
              formHolderName: "Select Country",
              hintText: "Search",
              textInputAction: TextInputAction.next,
              suffixIcon: Icon(
                LucideIcons.search,
                color: ColorManager.kGreyColor.withValues(alpha: .7),
              ),
              //textEditingController: firstnameController,
              onChanged: (_) {},
            ),
          ),
          Expanded(
              child: ListView.separated(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      itemBuilder: (context, index) {
                        final country =
                            giftCardCountries[index];
                        return InkWell(
                          onTap: () {
                            giftCardController.onSelectCountry(country);
                            // if(fromReview!=null){

                            // }
                            Navigator.pushNamed(
                                context, RoutesManager.giftcardProducts);
                          },
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: ColorManager.kWhite,
                                borderRadius: BorderRadius.circular(16)),
                            child: Row(
                              children: [
                                CustomNetworkImage(imageUrl: country.flagUrl??""),
                                Gap(12),
                                Text(
                                  country.name??"",
                                  style: get16TextStyle()
                                      .copyWith(fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Gap(8),
                      itemCount:
                          giftCardCountries.length),
                          ),
        ],
      ),
    );
  }
}
