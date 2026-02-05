import 'package:dataplug/core/enum.dart';
import 'package:dataplug/core/helpers/user_helper.dart';
import 'package:dataplug/core/model/core/user.dart';
import 'package:dataplug/core/providers/user_provider.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_snackbar.dart';
import 'package:dataplug/presentation/screens/dashboard/settings/misc/settings_icon_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PushNotificationScreen extends StatelessWidget {
  const PushNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: CustomAppbar(title: 'Notification'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 24.h),
        child: SettingsIconTab(
          text: 'Push Notifications',
          shortDesc: 'Instant alerts that keep you informed.',
          img: '',
          onTap: () => null,
          suffix: Transform.scale(
            transformHitTests: false,
            scale: .65,
            child: CupertinoSwitch(
              activeColor: ColorManager.kPrimary,
              value: userProvider.user!.notifications_enabled ?? false,
              onChanged: (_) async {
                try {
                  User user = await UserHelper.toggleNotification();
                  userProvider.updateUser(user);
                  showCustomToast(
                    context: context,
                    description: "Push Notification toggled successfully",
                    type: ToastType.success,
                  );
                } catch (e) {
                  showCustomToast(
                    context: context,
                    description: "Push Notification toggled failed",
                    type: ToastType.error,
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
