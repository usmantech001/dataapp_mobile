import 'package:dataplug/presentation/misc/custom_components/custom_empty_state.dart';
import 'package:flutter/material.dart';

import '../../../../../core/enum.dart';
import '../../../../../core/helpers/user_helper.dart';
import '../../../../../core/model/core/referral.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_back_icon.dart';

import '../../../../misc/custom_components/custom_elements.dart';
import '../../../../misc/custom_components/custom_scaffold.dart';
import '../../../../misc/custom_components/loading.dart';
import '../../../../misc/custom_snackbar.dart';
import '../../../../misc/shimmers/square_shimmer.dart';
import '../../../../misc/style_manager/styles_manager.dart';
import 'earning_tile.dart';

class EarningList extends StatefulWidget {
  final ReferralStatus param;
  const EarningList({super.key, required this.param});

  @override
  State<EarningList> createState() => _EarningListState();
}

class _EarningListState extends State<EarningList> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() => loading = true);
      fetchData();
    });

    controller.addListener(pagination);
    super.initState();
  }

//
  bool loading = false;
  List<Referral> referrals = [];
  int current_page = 1;
  int per_page = 120;
  Future<void> fetchData() async {
    await UserHelper.getReferrals("$per_page",
            status: widget.param, filter: "&page=$current_page")
        .then((value) {
      if (value.isNotEmpty) {
        referrals.addAll(value);
        current_page = current_page + 1;
      }
    }).catchError((err) {
      showCustomToast(context: context, description: err.toString());
    });
    paginatedLoading = false;
    loading = false;
    if (mounted) setState(() {});
  }

  bool paginatedLoading = false;
  void pagination() async {
    if ((controller.position.pixels == controller.position.maxScrollExtent &&
        !paginatedLoading)) {
      setState(() => paginatedLoading = true);
      fetchData();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  //
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
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.only(left: 15),
                      alignment: Alignment.centerLeft,
                      child: const BackIcon(),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text("Total Referrals",
                        textAlign: TextAlign.center, style: get18TextStyle()),
                  ),
                  const Expanded(flex: 1, child: SizedBox()),
                ],
              ),

              //

              //
              customDivider(
                height: 1,
                margin: const EdgeInsets.only(top: 16),
                color: ColorManager.kBar2Color,
              ),

              loading
                  ? buildLoading(height: 45)
                  : Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => fetchData(),
                        child: referrals.isEmpty
                            ? ListView(children: [
                                CustomEmptyState(
                                    btnTitle: "", onTap: () {}, showBTn: false)
                              ])
                            : ListView.builder(
                                controller: controller,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 25),
                                itemCount: referrals.length,
                                itemBuilder: (_, index) =>
                                    EarningTile(param: referrals[index]),
                              ),
                      ),
                    ),

              //
              paginatedLoading
                  ? const Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: SquareShimmer(height: 50, width: double.infinity))
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
