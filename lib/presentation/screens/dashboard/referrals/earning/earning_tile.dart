import 'package:dataplug/core/model/core/referral.dart';
import 'package:dataplug/core/utils/utils.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/image_manager/image_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';

class EarningTile extends StatelessWidget {
  final Referral param;
  const EarningTile({super.key, required this.param});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 44,
            width: 44,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: ColorManager.kPrimaryLight,
            ),
            child: Center(
              child: loadNetworkImage(
                param.avatar,
                width: 30,
                height: 30,
                errorDefaultImage: ImageManager.kProfileFallBack,
                borderRadius: BorderRadius.circular(0),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${param.firstname} ${param.lastname}",
                    style: get14TextStyle()),
                const SizedBox(height: 4),
                Text(
                  "Joined ${formatDateSlash(param.created_at)}",
                  style: get14TextStyle()
                      .copyWith(color: ColorManager.kTextDark.withOpacity(.75)),
                )

                //
              ],
            ),
          ),

          //
          Text(
            param.active ? "Active" : "Inactive",
            style: get14TextStyle().copyWith(
              fontWeight: FontWeight.w500,
              color: param.active ? ColorManager.kSuccess : ColorManager.kError,
            ),
          )
        ],
      ),
    );
  }
}
