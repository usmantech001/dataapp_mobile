import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_empty_state.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_scaffold.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return Scaffold(
      appBar: CustomAppbar(title: 'Notification'),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 24.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      NotificationFilter(text: 'All', isSelected: true, onTap: () {
                      },),
                     NotificationFilter(text: 'Unread (0)', onTap: (){}),
                    ],
                  ),
                  Text('Mark all as read', style: get14TextStyle().copyWith(color: ColorManager.kGreyColor.withValues(alpha: .7)),)
                ],
              ),
            ),
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
                              padding: const EdgeInsets.only(
                                bottom: 30,
                              ),
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
    );
  }
}

class NotificationFilter extends StatelessWidget {
  const NotificationFilter(
      {super.key, required this.text, this.isSelected = false, required this.onTap});
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
        decoration: BoxDecoration(
            color: isSelected ? ColorManager.kPrimary : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r)),
        child: Text(
          text,
          style: get14TextStyle().copyWith(
              color: isSelected
                  ? ColorManager.kWhite
                  : ColorManager.kGreyColor.withValues(alpha: .7)),
        ),
      ),
    );
  }
}
