import 'package:dataplug/core/constants.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_scaffold.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return CustomScaffold(
      backgroundColor: ColorManager.kPrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            Expanded(
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
                          flex: 3,
                          child: Column(
                            children: [
                              //
                              Text("Message",
                                  textAlign: TextAlign.center,
                                  style: get18TextStyle()),
                            ],
                          ),
                        ),
                        const Expanded(flex: 1, child: SizedBox()),
                      ],
                    ),

                    //

                    //
                    customDivider(
                      height: 1,
                      margin: const EdgeInsets.only(top: 16, bottom: 24),
                      color: ColorManager.kBar2Color,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Constants.kHorizontalScreenPadding),
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
                          ),

                          //
                        ],
                      ),
                    ),

                    const SizedBox(height: 9),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        children: [
                          Text(
                            widget.param.message,
                            style: get14TextStyle().copyWith(height: 1.6),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
