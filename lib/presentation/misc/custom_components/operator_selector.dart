
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class OperatorSelector extends StatelessWidget {
  const OperatorSelector(
      {super.key,
      required this.name,
      required this.logo,
      required this.isSelected,
      required this.onTap});
  final String name, logo;
  final bool isSelected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 86,
                // height: 86,
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: isSelected
                      ? ColorManager.kPrimary.withValues(alpha: .05)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(
                    color: isSelected
                        ? ColorManager.kPrimary
                        : ColorManager.kGreyColor.withValues(alpha: .08),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    loadNetworkImage(
                      logo,
                      width: 24,
                      height: 24,
                      borderRadius: BorderRadius.circular(78),
                    ),
                    Gap(6),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: get14TextStyle().copyWith(
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: ColorManager.kFadedTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Positioned(
                  top: 5,
                  right: -5,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: ColorManager.kPrimary,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class OperatorSelectorShimmer extends StatelessWidget {
  const OperatorSelectorShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
        
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: 86,
                height: 86,
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
                // child: Column(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                   
                //   ],
                // ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
