import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AmountSuggestion extends StatelessWidget {
  const AmountSuggestion(
      {super.key, this.selectedAmount, required this.onSelect, required this.suggestedAmounts});

  final List<String> suggestedAmounts;
  final String? selectedAmount;
  final Function(String) onSelect;
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2.5,
      children: List.generate(suggestedAmounts.length, (index) {
        return GestureDetector(
         onTap: (){
          onSelect(suggestedAmounts[index]);
         },
          child: Container(
            alignment: Alignment.center,
            //width: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: selectedAmount == suggestedAmounts[index]
                    ? ColorManager.kPrimary.withValues(alpha: 0.1)
                    : ColorManager.kWhite,
                border: Border.all(
                    color:selectedAmount == suggestedAmounts[index]
                        ? ColorManager.kPrimary
                        : ColorManager.kWhite)),
            child: Text(
              '₦${suggestedAmounts[index]}',
              style: get14TextStyle().copyWith(
                fontFamily: GoogleFonts.roboto().fontFamily,
                color: selectedAmount == suggestedAmounts[index]
                    ? ColorManager.kPrimary
                    : ColorManager.kGreyColor.withValues(alpha: .5),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }),
    );
  }
}
