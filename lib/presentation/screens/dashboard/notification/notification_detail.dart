import 'package:dataplug/core/constants.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_scaffold.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/user_helper.dart';
import '../../../../core/model/core/app_notification.dart';
import '../../../misc/custom_components/custom_back_icon.dart';

class NotificationDetail extends StatefulWidget {
  final AppNotification param;
  const NotificationDetail({super.key, required this.param});

  @override
  State<NotificationDetail> createState() => _NotificationDetailState();
}

class _NotificationDetailState extends State<NotificationDetail> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UserHelper.markNotificationAsRead(widget.param.id)
          .then((_) {})
          .catchError((_) {});
    });
    super.initState();
  }

  final spacer = const SizedBox(height: 30);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Message'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 24.h),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                
                          
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                        
                      //
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.param.title,
                              style: get16TextStyle()
                                  .copyWith(fontWeight: FontWeight.w400)),
                          Row(
                            children: [
                              Text(
                                widget.param.date
                                    .replaceAll("-", "/")
                                    .toUpperCase(),
                                style: get14TextStyle().copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: ColorManager.kTextDark7,
                                ),
                              ),
                              customDivider(
                                width: .5,
                                height: 13,
                                color: ColorManager.kBarColor,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 6),
                              ),
                              Text(
                                widget.param.time.toUpperCase(),
                                style: get14TextStyle().copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: ColorManager.kTextDark7,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                        
                      //
                    ],
                  ),
                          
                  const SizedBox(height: 9),
                  Text(
                    widget.param.message,
                    style: get14TextStyle().copyWith(height: 1.6),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTile(String text, {EdgeInsetsGeometry? margin}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        //
      },
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: ColorManager.kBar2Color),
          borderRadius: BorderRadius.circular(19),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 22),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(text,
                  style:
                      get14TextStyle().copyWith(fontWeight: FontWeight.w500)),
            ),
            Icon(Icons.chevron_right, color: ColorManager.kBarColor)
          ],
        ),
      ),
    );
  }
}
