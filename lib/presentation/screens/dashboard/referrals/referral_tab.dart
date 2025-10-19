import 'package:dataplug/core/constants.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/screens/dashboard/referrals/earning/earnings.dart';
import 'package:dataplug/presentation/screens/dashboard/referrals/referral/referral.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../../core/providers/user_provider.dart';
import '../../../misc/custom_components/segment.dart';
import '../../../misc/segment.dart';
import '../../../misc/style_manager/styles_manager.dart';

class ReferralTab extends StatefulWidget {
  const ReferralTab({super.key});

  @override
  State<ReferralTab> createState() => _ReferralTabState();
}

class _ReferralTabState extends State<ReferralTab> {
  int groupValue = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).updateReferralsInfo();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, Widget> segmentWidgets = <int, Widget>{
      0: buildSegment("Refer", active: groupValue == 0),
      1: buildSegment("Earnings", active: groupValue == 1),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 22, bottom: 25, left: 32, right: 32),
          // alignment: Alignment.center,
          width: double.maxFinite,
          child: CupertinoSlidingSegmentedControlAlt<int>(
            backgroundColor: ColorManager.kSlideBgColor,
            thumbColor: ColorManager.kWhite,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
            groupValue: groupValue,
            children: segmentWidgets,
            onValueChanged: (value) {
              _pageController.animateToPage(value!,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.linear);
              setState(() => groupValue = value);
            },
          ),
        ),

        //
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Constants.kHorizontalScreenPadding),
            child: PageView(
              onPageChanged: (index) {
                setState(() => groupValue = index);
              },
              controller: _pageController,
              children: const [ReferralMeta(), Earnings()],
            ),
          ),
        )
      ],
    );
  }
}




