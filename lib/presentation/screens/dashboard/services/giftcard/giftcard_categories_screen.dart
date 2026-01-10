import 'package:dataplug/core/model/core/custom_network_image.dart';
import 'package:dataplug/core/providers/electricity_controller.dart';
import 'package:dataplug/core/providers/giftcard_controller.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_input_field.dart';
import 'package:dataplug/presentation/misc/custom_components/toggle_selector_widget.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

class GiftcardCategoriesScreen extends StatefulWidget {
  const GiftcardCategoriesScreen({super.key});

  @override
  State<GiftcardCategoriesScreen> createState() =>
      _GiftcardCategoriesScreenState();
}

class _GiftcardCategoriesScreenState extends State<GiftcardCategoriesScreen> {
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
      context.read<GiftcardController>().getGiftcardCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final giftCardController = context.watch<GiftcardController>();
    //final fromReview = ModalRoute.of(context)?.settings.arguments as bool?;
    return Scaffold(
      appBar: CustomAppbar(title: 'Buy GiftCard'),
      body: Padding(
        padding: EdgeInsets.only(top: 24.h),
        child: Column(
          children: [
            ToggleSelectorWidget(
              tabIndex: giftCardController.currentTypeTabIndex,
              tabText: giftCardController.giftCardTypes,
         
              onTap: (index) {
                giftCardController.onChangeTypeIndex(index);
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 24),
              child: CustomInputField(
                formHolderName: "Select Giftcard category",
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
                child: giftCardController.gettingCategories
                    ? Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        itemBuilder: (context, index) {
                          final category = giftCardController.categories[index];
                          return InkWell(
                            onTap: () {
                              giftCardController.onSelectCategory(category);
                              // if(fromReview!=null){

                              // }
                              print(category.countries);
                              Navigator.pushNamed(
                                  context, RoutesManager.giftcardCountries,
                                  arguments: category.countries);
                            },
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: ColorManager.kWhite,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Row(
                                children: [
                                  CustomNetworkImage(imageUrl: category.icon),
                                  Gap(12),
                                  Text(
                                    category.name,
                                    style: get16TextStyle()
                                        .copyWith(fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Gap(8),
                        itemCount: giftCardController.categories.length))
          ],
        ),
      ),
    );
  }
}
