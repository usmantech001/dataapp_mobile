import 'package:dataplug/core/model/core/custom_network_image.dart';
import 'package:dataplug/core/providers/electricity_controller.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_input_field.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

class ElectricityProvidersScreen extends StatefulWidget {
  const ElectricityProvidersScreen({super.key});

  @override
  State<ElectricityProvidersScreen> createState() =>
      _ElectricityProvidersScreenState();
}

class _ElectricityProvidersScreenState
    extends State<ElectricityProvidersScreen> {
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
      context.read<ElectricityController>().getElectricityProviders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final electricityController = context.watch<ElectricityController>();
    final fromReview = ModalRoute.of(context)?.settings.arguments as bool?;
    return Scaffold(
      appBar: CustomAppbar(title: 'Electricity Provider'),
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
              textEditingController: electricityController.searchController,
              onChanged: (query) {
                electricityController.filterProviders(query);
              },
            ),
          ),
          Expanded(
              child: electricityController.gettingProviders
                  ? Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      itemBuilder: (context, index) {
                        final provider = electricityController
                                .searchController.text.isNotEmpty
                            ? electricityController
                                .filteredElectricityProviders[index]
                            : electricityController.electricityProviders[index];
                        return InkWell(
                          onTap: () {
                            electricityController.onSelectProvider(provider);
                            Navigator.pushNamed(
                                context, RoutesManager.buyElectricity);
                          },
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: ColorManager.kWhite,
                                borderRadius: BorderRadius.circular(16)),
                            child: Row(
                              children: [
                                CustomNetworkImage(imageUrl: provider.logo),
                                Gap(12),
                                Text(
                                  provider.name,
                                  style: get16TextStyle()
                                      .copyWith(fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Gap(8),
                      itemCount: electricityController
                              .searchController.text.isNotEmpty
                          ? electricityController
                              .filteredElectricityProviders.length
                          : electricityController.electricityProviders.length))
        ],
      ),
    );
  }
}
