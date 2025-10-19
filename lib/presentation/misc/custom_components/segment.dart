import 'package:flutter/material.dart';

import '../style_manager/styles_manager.dart';

Widget buildSegment(String text, {required bool active}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
    child: Center(
      child: Text(
        text,
        style: get14TextStyle().copyWith(
          fontWeight: active ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    ),
  );
}
