import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

displayLoader(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      barrierColor: ColorManager.kBlack.withOpacity(0.3),
      context: context,
      builder: (context) => AbegPayLoadingIndicator()
      );
}

class AbegPayLoadingIndicator extends StatefulWidget {
  const AbegPayLoadingIndicator({Key? key}) : super(key: key);

  @override
  State<AbegPayLoadingIndicator> createState() => _AbegPayLoadingIndicatorState();
}

class _AbegPayLoadingIndicatorState extends State<AbegPayLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Container(
            //   width: 50.w,
            //   height: 50.h,
            //   decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     color: ColorManager.kPrimaryLight, 
            //   ),
            // ),
            Image.asset(
              'assets/images/app-logo.png', 
              width: 35.w,
              height: 35.h,
            ),
          ],
        ),
      ),
    );
  }
}
