import 'package:dataplug/core/constants.dart';
import 'package:dataplug/core/model/core/app_notification.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/cupertino.dart';

import '../../../../misc/route_manager/routes_manager.dart';

class NotificationTile extends StatelessWidget {
  final AppNotification param;
  final Function(AppNotification) onTap;
  const NotificationTile({super.key, required this.param, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.pushNamed(context, RoutesManager.notificationDetail,
            arguments: param);
        onTap(param);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(
            horizontal: Constants.kHorizontalScreenPadding, vertical: 10),
        color: param.read ? null : ColorManager.kNotificationUnread,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 44,
              width: 44,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: ColorManager.kPrimaryLight,
              ),
              child: Icon(CupertinoIcons.bell_fill,
                  size: 18, color: ColorManager.kPrimary),
            ),

            //
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(param.title,
                      style: get16TextStyle()
                          .copyWith(fontWeight: FontWeight.w400)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      param.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: get14TextStyle().copyWith(
                          color: ColorManager.kTextDark7, height: 1.1),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        param.date.replaceAll("-", "/").toUpperCase(),
                        style: get14TextStyle().copyWith(
                          fontWeight: FontWeight.w400,
                          color: ColorManager.kTextDark7,
                        ),
                      ),
                      customDivider(
                        width: .5,
                        height: 13,
                        color: ColorManager.kBarColor,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                      ),
                      Text(
                        param.time.toUpperCase(),
                        style: get14TextStyle().copyWith(
                          fontWeight: FontWeight.w400,
                          color: ColorManager.kTextDark7,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
