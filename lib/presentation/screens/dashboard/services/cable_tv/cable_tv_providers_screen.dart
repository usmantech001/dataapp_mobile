import 'package:dataplug/core/model/core/custom_network_image.dart';
import 'package:dataplug/core/providers/cable_tv_controller.dart';
import 'package:dataplug/core/providers/electricity_controller.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_input_field.dart';
import 'package:dataplug/presentation/misc/custom_components/error_widget.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

class CableTvProvidersScreen extends StatefulWidget {
  const CableTvProvidersScreen({super.key});

  @override
  State<CableTvProvidersScreen> createState() => _CableTvProvidersScreenState();
}

class _CableTvProvidersScreenState extends State<CableTvProvidersScreen> {
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
      context.read<CableTvController>().getCableTvProviders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cableTvController = context.watch<CableTvController>();
    //final fromReview = ModalRoute.of(context)?.settings.arguments as bool?;
    return Scaffold(
      appBar: CustomAppbar(title: 'Pay TV/Cable'),
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
              //textEditingController: firstnameController,
              onChanged: (_) {},
            ),
          ),
          Expanded(
              child: cableTvController.gettingProviders
                  ? Center(child: CircularProgressIndicator())
                  : cableTvController.providersErrMsg != null
                      ? Center(
                          child: CustomError(
                              errMsg: cableTvController.providersErrMsg!,
                              topPadding: 0,
                              onRefresh: () {
                                cableTvController.getCableTvProviders();
                              }),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          itemBuilder: (context, index) {
                            final provider =
                                cableTvController.tvServiceProviders[index];
                            return InkWell(
                              onTap: () {
                                cableTvController.onSelectProvider(provider);

                                Navigator.pushNamed(
                                    context, RoutesManager.cableTvPackages);
                              },
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    color: ColorManager.kWhite,
                                    borderRadius: BorderRadius.circular(16)),
                                child: Row(
                                  children: [
                                    CustomNetworkImage(
                                        imageUrl: provider.logo ?? ""),
                                    Gap(12),
                                    Text(
                                      provider.name,
                                      style: get16TextStyle().copyWith(
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => Gap(8),
                          itemCount:
                              cableTvController.tvServiceProviders.length))
        ],
      ),
    );
  }
}
