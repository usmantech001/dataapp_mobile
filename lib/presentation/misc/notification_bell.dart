import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      child: Stack(
        children: [
          Image.asset(Assets.images.notification.path,
              width:  22.5, height: 22.5,),
          const SizedBox(height: 10, width: 30),
          if (userProvider.unreadNotificationAvailable)
            Positioned(
              top: 0,
              right: 3.5,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: iconColor ?? ColorManager.kBar2Color),
                height: 9,
                width: 9,
              ),
            ),
        ],
      ),
    );
  }
}
