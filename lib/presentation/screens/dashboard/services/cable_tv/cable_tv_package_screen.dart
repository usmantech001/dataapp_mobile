import 'package:dataplug/core/model/core/custom_network_image.dart';
import 'package:dataplug/core/providers/cable_tv_controller.dart';
import 'package:dataplug/core/providers/electricity_controller.dart';
import 'package:dataplug/core/utils/utils.dart';
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

class CableTvPackageScreen extends StatefulWidget {
  const CableTvPackageScreen({super.key});

  @override
  State<CableTvPackageScreen> createState() => _CableTvPackageScreenState();
}

class _CableTvPackageScreenState extends State<CableTvPackageScreen> {
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
      context.read<CableTvController>().getCableTvPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cableTvController = context.watch<CableTvController>();
    
    //final fromReview = ModalRoute.of(context)?.settings.arguments as bool?;
    return Scaffold(
      appBar: CustomAppbar(title: 'Pay TV/Cable Package'),
      body: Padding(
        padding: EdgeInsets.only(top: 24.h),
        child: Column(
          children: [
             ToggleSelectorWidget(
                  tabIndex: cableTvController.currentTabIndex,
                  tabText: cableTvController.cableTvTypes,
             
                  onTap: (index) {
                    cableTvController.onCableTvTypeChange(index);
                  },
                ),
            Expanded(
                child: cableTvController.gettingPlans
                    ? Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        itemBuilder: (context, index) {
                          final plan = cableTvController.tvPlans[index];
                          return InkWell(
                            onTap: () {
                              cableTvController.onSelectPlan(plan);
                       
                              Navigator.pushNamed(context, RoutesManager.cableTv);
                            },
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: ColorManager.kWhite,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          width: 150.w,
                                          child: Text(
                                            plan.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: get14TextStyle().copyWith(
                                                fontWeight: FontWeight.w400),
                                          )),
                                          Text('${plan.duration} month', style: get18TextStyle(),)
                                    ],
                                  ),
                                  Text('${formatCurrency(plan.amount)}', style: get18TextStyle().copyWith(color: ColorManager.kPrimary),)
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Gap(8),
                        itemCount: cableTvController.tvPlans.length))
          ],
        ),
      ),
    );
  }
}
