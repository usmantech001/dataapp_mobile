import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../core/providers/user_provider.dart';
import '../../gen/assets.gen.dart';
import 'color_manager/color_manager.dart';
import 'route_manager/routes_manager.dart';

class CustomNotificationBell extends StatelessWidget {
  final double? size;
  final Color? borderColor;
  final Color? iconColor;
  final Color? bgColor;

  const CustomNotificationBell(
      {super.key, this.size, this.borderColor, this.iconColor, this.bgColor});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        await Navigator.pushNamed(context, RoutesManager.allNotifications);
        userProvider.checkUnreadNotification().catchError((_) {});
      },
      child: CircleAvatar(
        radius: 20.r,
        backgroundColor: ColorManager.kWhite,
        child: Badge(
          child: Icon(LucideIcons.bell, size: 20, color: ColorManager.kBlack,),
        ))
     
    );
  }
}
