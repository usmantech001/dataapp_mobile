import 'package:flutter/material.dart';

import '../color_manager/color_manager.dart';
import '../shimmers/square_shimmer.dart';

Widget buildLoading({
  int? itemCount,
  bool wrapWithExpanded = true,
  EdgeInsetsGeometry? padding,
  double height = 70,
}) {
  Widget child = ListView.separated(
    shrinkWrap: true,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 15),
      separatorBuilder: ((context, index) => const SizedBox(height: 25)),
      itemCount: itemCount ?? 235,
      itemBuilder: (_, int i) =>
          SquareShimmer(width: double.infinity, height: height));

  return wrapWithExpanded ? Expanded(child: child) : child;
}

Widget buildLoader({double? height, double? width}) {
  return SizedBox(
    height: height ?? 12,
    width: width ?? 12,
    child: CircularProgressIndicator(
      strokeWidth: 1.8,
      valueColor: AlwaysStoppedAnimation<Color>(ColorManager.kPrimary),
    ),
  );
}
