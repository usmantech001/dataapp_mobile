import 'package:dataplug/core/constants.dart';
import 'package:dataplug/core/model/core/cable_tv_plan.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_progress.dart';
import 'package:dataplug/presentation/misc/image_manager/image_manager.dart';
import 'package:flutter/material.dart';

import '../../../../../core/helpers/generic_helper.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../../misc/custom_components/custom_elements.dart';
import '../../../../misc/custom_components/custom_scaffold.dart';
import '../../../../misc/style_manager/styles_manager.dart';
import 'cable_tv_3.dart';
import 'misc/arg.dart';
import 'misc/cable_item.dart';

class CableTv2 extends StatefulWidget {
  final CableTvArg param;
  const CableTv2({super.key, required this.param});

  @override
  State<CableTv2> createState() => _CableTv2State();
}

class _CableTv2State extends State<CableTv2> {
  final spacer = const SizedBox(height: 40);

  ScrollController controller = ScrollController();

  int listLength = 0;

  @override
  void initState() {
    listLength = (widget.param.plans.length / 3).ceil();

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
                                  widget.param.provider.logo ?? "",
                                  width: 18,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Pay TV/Cable",
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
                margin: const EdgeInsets.only(top: 16),
                color: ColorManager.kBar2Color,
              ),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  controller: controller,
                  itemCount: listLength,
                  shrinkWrap: true,
                  itemBuilder: (context, idx) {
                    int startIndex = idx * 3;
                    int endIndex = (startIndex + 3 < widget.param.plans.length)
                        ? startIndex + 3
                        : widget.param.plans.length;

                    return buildItems(context,
                        dPs: widget.param.plans.sublist(startIndex, endIndex));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  moveNext(BuildContext context, {required CableTvPlan plan}) async {
    await GenericHelper.getDiscount(
      'tv',
      widget.param.provider.code,
      plan.amount,
      plan.code,
    ).then((value) async {
      print("Discount ::: ${value.toJson()}");
      widget.param.discount = value;
      showCustomBottomSheet(
        context: context,
        isDismissible: true,
        screen: CableTv3(arg: widget.param, plan: plan),
      );
    });
  }

  Widget buildItems(BuildContext context, {required List<CableTvPlan> dPs}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.kHorizontalScreenPadding, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: (dPs.length == 3)
            ? [
                Expanded(
                  flex: 1,
                  child: CableTvItem(
                    provider: widget.param.provider,
                    onTap: (_) => moveNext(context, plan: _),
                    plan: dPs[0],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: CableTvItem(
                    provider: widget.param.provider,
                    onTap: (_) => moveNext(context, plan: _),
                    plan: dPs[1],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: CableTvItem(
                    provider: widget.param.provider,
                    onTap: (_) => moveNext(context, plan: _),
                    plan: dPs[2],
                  ),
                ),
              ]
            : (dPs.length == 2)
                ? [
                    Expanded(
                      flex: 1,
                      child: CableTvItem(
                        provider: widget.param.provider,
                        onTap: (_) => moveNext(context, plan: _),
                        plan: dPs[0],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: CableTvItem(
                        provider: widget.param.provider,
                        onTap: (_) => moveNext(context, plan: _),
                        plan: dPs[1],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(flex: 1, child: SizedBox()),
                  ]
                : [
                    Expanded(
                      flex: 1,
                      child: CableTvItem(
                        provider: widget.param.provider,
                        onTap: (_) => moveNext(context, plan: _),
                        plan: dPs[0],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(flex: 1, child: SizedBox()),
                    const SizedBox(width: 10),
                    const Expanded(flex: 1, child: SizedBox()),
                  ],
      ),
    );
  }
}
