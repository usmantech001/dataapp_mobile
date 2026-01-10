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

class GiftcardProductsScreen extends StatefulWidget {
  const GiftcardProductsScreen({super.key});

  @override
  State<GiftcardProductsScreen> createState() =>
      _GiftcardProductsScreenState();
}

class _GiftcardProductsScreenState extends State<GiftcardProductsScreen> {
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
      context.read<GiftcardController>().getGiftcardProducts();
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
            
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: CustomInputField(
                formHolderName: "Select Giftcard Product",
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
                child: giftCardController.gettingProducts
                    ? Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        itemBuilder: (context, index) {
                          final product = giftCardController.products[index];
                          return InkWell(
                            onTap: () {
                              giftCardController.onSelectProduct(product);
                              // if(fromReview!=null){

                              // }
                               Navigator.pushNamed(context, RoutesManager.buyGiftCard);
                            },
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: ColorManager.kWhite,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Row(
                                children: [
                                  CustomNetworkImage(imageUrl: product.logo),
                                  Gap(12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: get16TextStyle()
                                            .copyWith(fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                       product.minAmount!=null? "Rate: ${product.buyRate!.toStringAsFixed(1)} Range: \$ ${product.minAmount} - \$ ${product.maxAmount}" :  "Rate: ${product.buyRate!.toStringAsFixed(1)}",
                                        style: get16TextStyle()
                                            .copyWith(fontWeight: FontWeight.w400, color: ColorManager.kGreyColor.withValues(alpha: .5)),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Gap(8),
                        itemCount: giftCardController.products.length))
          ],
        ),
      ),
    );
  }
}
