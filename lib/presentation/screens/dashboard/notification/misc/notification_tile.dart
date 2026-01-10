import 'package:cached_network_image/cached_network_image.dart';
import 'package:dataplug/core/constants.dart';
import 'package:dataplug/core/model/core/app_notification.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

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
        //margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(
            horizontal: Constants.kHorizontalScreenPadding, vertical: 10),
        color: param.read ? null : ColorManager.kPrimary.withValues(alpha: .06),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundColor: ColorManager.kGreyE5,
              child: Text(
                '${param.title.split(' ').first[0]} ${param.title.split(' ').first[1].toUpperCase()}',
                style: get20TextStyle().copyWith(color: ColorManager.kPrimary, wordSpacing: -2),
              ),
            ),
            Gap(12.w),
            Flexible(
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
                 
                ],
              ),
            ),
            //Spacer(),
            Gap(20),
            Text(
              param.time.toUpperCase(),
              style: get14TextStyle().copyWith(
                fontWeight: FontWeight.w400,
                color: ColorManager.kTextDark7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
