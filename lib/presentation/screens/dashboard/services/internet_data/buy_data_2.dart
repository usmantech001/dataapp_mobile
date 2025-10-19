import 'dart:developer';

import 'package:dataplug/core/constants.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_progress.dart';
import 'package:dataplug/presentation/misc/image_manager/image_manager.dart';
import 'package:flutter/material.dart';

import '../../../../../core/enum.dart';
import '../../../../../core/helpers/generic_helper.dart';
import '../../../../../core/model/core/data_plans.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../../misc/custom_components/custom_elements.dart';
import '../../../../misc/custom_components/custom_scaffold.dart';
import '../../../../misc/style_manager/styles_manager.dart';
import 'buy_data_3.dart';
import 'misc/buy_data_arg.dart';
import 'misc/internet_data_item.dart';

class BuyData2 extends StatefulWidget {
  final BuyDataArg param;
  const BuyData2({super.key, required this.param});

  @override
  State<BuyData2> createState() => _BuyData2State();
}

class _BuyData2State extends State<BuyData2> {
  final spacer = const SizedBox(height: 40);

  ScrollController controller = ScrollController();

  int listLength = 0;

  @override
  void initState() {
    listLength = (widget.param.dataPlans.length / 3).ceil();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: ColorManager.kPrimary,
      body: SafeArea(
        bottom: false,
        child: Container(
          decoration: BoxDecoration(
            color: ColorManager.kWhite,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.only(left: 15, top: 15),
                      alignment: Alignment.centerLeft,
                      child: const BackIcon(),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            const SizedBox(width: 50, height: 48),
                            Image.asset(ImageManager.kBuyData2, width: 44),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: SizedBox(
                                child: loadNetworkImage(
                                  widget.param.dataProvider.logo ?? "",
                                  width: 18,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Buy Data",
                          textAlign: TextAlign.center,
                          style: get18TextStyle(),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: CustomProgress(value: 2, valuePerct: .89),
                    ),
                  ),
                ],
              ),

              //
              customDivider(
                height: 1,
                margin: const EdgeInsets.only(top: 16, bottom: 0),
                color: ColorManager.kBar2Color,
              ),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  controller: controller,
                  itemCount: listLength,
                  itemBuilder: (context, idx) {
                    int startIndex = idx * 3;
                    int endIndex =
                        (startIndex + 3 < widget.param.dataPlans.length)
                            ? startIndex + 3
                            : widget.param.dataPlans.length;

                    return buildItems(context,
                        dPs: widget.param.dataPlans
                            .sublist(startIndex, endIndex));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  moveNext(BuildContext context, {required DataPlan dataPlan}) async {
    log( dataPlan.amount.toString() ?? "",);
    await GenericHelper.getDiscount(
      'data',
      widget.param.dataProvider.code,
      dataPlan.amount,
      dataPlan.code,
    ).then((value) async {
      widget.param.discount = value;
      print("Discount ::: ${value.toJson()}");
     await showCustomBottomSheet(
        context: context,
        isDismissible: true,
        screen: BuyData3(arg: widget.param, dataPlan: dataPlan),
      );
    });
  }

  Widget buildItems(BuildContext context, {required List<DataPlan> dPs}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.kHorizontalScreenPadding, vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: (dPs.length == 3)
                ? [
                    Expanded(
                      flex: 1,
                      child: InternetDataItem(
                        onTap: () => moveNext(context, dataPlan: dPs[0]),
                        plan: dPs[0],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: InternetDataItem(
                        onTap: () => moveNext(context, dataPlan: dPs[1]),
                        plan: dPs[1],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: InternetDataItem(
                        onTap: () => moveNext(context, dataPlan: dPs[2]),
                        plan: dPs[2],
                      ),
                    ),
                  ]
                : (dPs.length == 2)
                    ? [
                        Expanded(
                          flex: 1,
                          child: InternetDataItem(
                            onTap: () => moveNext(context, dataPlan: dPs[0]),
                            plan: dPs[0],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: InternetDataItem(
                            onTap: () => moveNext(context, dataPlan: dPs[1]),
                            plan: dPs[1],
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(flex: 1, child: SizedBox()),
                      ]
                    : [
                        Expanded(
                          flex: 1,
                          child: InternetDataItem(
                              onTap: () => moveNext(context, dataPlan: dPs[0]),
                              plan: dPs[0]),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(flex: 1, child: SizedBox()),
                        const SizedBox(width: 10),
                        const Expanded(flex: 1, child: SizedBox()),
                      ],
          ),
        ],
      ),
    );
  }
}
