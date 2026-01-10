import 'package:dataplug/core/model/core/custom_network_image.dart';
import 'package:dataplug/core/providers/electricity_controller.dart';
import 'package:dataplug/core/providers/epin_controller.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_input_field.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

class EpinProductsScreen extends StatefulWidget {
  const EpinProductsScreen({super.key});

  @override
  State<EpinProductsScreen> createState() => _EpinProductsScreenState();
}

class _EpinProductsScreenState extends State<EpinProductsScreen> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      context.read<EpinController>().getEPinProducts();
    });
  }
  @override
  Widget build(BuildContext context) {
    final ePinController = context.watch<EpinController>();
    final fromReview = ModalRoute.of(context)?.settings.arguments as bool?;
    return Scaffold(
      appBar: CustomAppbar(title: 'E-PIN Products'),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 24),
            child: CustomInputField(
              formHolderName: "Select E-PIN products",
              hintText: "Search",
              textInputAction: TextInputAction.next,
              suffixIcon: Icon(LucideIcons.search, color: ColorManager.kGreyColor.withValues(alpha: .7),),
              //textEditingController: firstnameController,
              onChanged: (_) {},
            ),
          ),
          Expanded(child: ePinController.gettingProducts? Center(child: CircularProgressIndicator()): ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            itemBuilder: (context, index){
              final product = ePinController.ePinProducts[index];
            return InkWell(
              onTap: (){
                ePinController.onSelectProduct(product);
                // if(fromReview!=null){

                // }
                  Navigator.pushNamed(context, RoutesManager.purchaseEPin);
                
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorManager.kWhite,
                  borderRadius: BorderRadius.circular(16)
                ),
                child: Row(
                  children: [
                    CustomNetworkImage(imageUrl: product.logo??""),
                      Gap(12),
                      Text(product.name, style: get16TextStyle().copyWith(fontWeight: FontWeight.w400),)
                  ],
                ),
              ),
            );
          }, separatorBuilder: (context, index)=> Gap(8), itemCount: ePinController.ePinProducts.length))
        ],
      ),
    );
  }
}
