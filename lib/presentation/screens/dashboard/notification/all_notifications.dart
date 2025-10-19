import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_empty_state.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_scaffold.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../../core/helpers/user_helper.dart';
import '../../../../core/model/core/app_notification.dart';
import '../../../../gen/assets.gen.dart';
import '../../../misc/custom_components/custom_back_icon.dart';
import '../../../misc/custom_components/loading.dart';
import '../../../misc/shimmers/square_shimmer.dart';
import 'misc/notification_tile.dart';

class AllNotifications extends StatefulWidget {
  const AllNotifications({super.key});

  @override
  State<AllNotifications> createState() => _AllNotificationsState();
}

class _AllNotificationsState extends State<AllNotifications> {
  ScrollController controller = ScrollController();

  List<AppNotification> dataList = [];

  @override
  void initState() {
    fetchData(isRefresh: true);
    controller.addListener(pagination);
    super.initState();
  }

  bool paginatedLoading = false;
  void pagination() async {
    if ((controller.position.pixels == controller.position.maxScrollExtent &&
        !paginatedLoading)) {
      if (controller.position.userScrollDirection == ScrollDirection.reverse) {
        fetchData(isRefresh: false);
      }
    }
  }

  bool loading = true;
  int current_page = 1;
  int per_page = 15;
  Future<void> fetchData({required bool isRefresh}) async {
    if (paginatedLoading) return;

    if (!isRefresh) setState(() => paginatedLoading = true);

    await UserHelper.getNotification("$per_page",
            filter: isRefresh ? "&page=1" : "&page=$current_page")
        .then((value) {
      if (isRefresh) {
        dataList = value;
        current_page = 2;
      } else {
        dataList.addAll(value);
        current_page = current_page + 1;
      }
    }).catchError((_) {});
    paginatedLoading = false;
    if (mounted) setState(() => loading = false);
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
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 15),
                      child: const BackIcon(),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Text("Notification",
                          textAlign: TextAlign.center,
                          style: get18TextStyle())),
                  const Expanded(flex: 1, child: SizedBox()),
                ],
              ),
              customDivider(height: 1, margin: const EdgeInsets.only(top: 16)),

              loading
                  ? buildLoading()
                  : Expanded(
                      child: RefreshIndicator(
                        color: ColorManager.kPrimary,
                        onRefresh: () => fetchData(isRefresh: true),
                        child: dataList.isEmpty
                            ? ListView(
                                children: [
                                  const SizedBox(height: 100),
                                  CustomEmptyState(
                                    image: Assets.images.kNotificationIcon.path,
                                    imgHeight: 81,
                                    imgWidth: 81,
                                    title: "You have no notifications yet",
                                    btnTitle: "btnTitle",
                                    onTap: () {},
                                    showBTn: false,
                                  ),
                                ],
                              )
                            : ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                controller: controller,
                                padding:
                                    const EdgeInsets.only(bottom: 30, top: 25),
                                itemCount: dataList.length,
                                itemBuilder: (__, int i) => NotificationTile(
                                  param: dataList[i],
                                  onTap: (_) => setState(() => _.read = true),
                                ),
                              ),
                      ),
                    ),
              paginatedLoading
                  ? const Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: SquareShimmer(height: 35, width: double.infinity))
                  : const SizedBox()

              // const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
