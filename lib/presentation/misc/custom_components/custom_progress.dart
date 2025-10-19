import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';

class CustomProgress extends StatelessWidget {
  final int value;
  final double valuePerct;
  const CustomProgress(
      {super.key, required this.value, required this.valuePerct});

  @override
  Widget build(BuildContext context) {
    // return const Placeholder();
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.4,
            value: valuePerct,
            backgroundColor: ColorManager.kPrimaryLight,
            valueColor: AlwaysStoppedAnimation<Color>(ColorManager.kPrimary),
          ),
        ),
        Center(
          child: Text(
            '$value',
            style: get14TextStyle().copyWith(
                color: ColorManager.kPrimary, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
