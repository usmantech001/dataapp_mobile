import 'package:dataplug/core/model/core/user_bank.dart';
import 'package:dataplug/core/utils/custom_image.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../misc/color_manager/color_manager.dart';
import '../../../../../misc/custom_components/custom_container.dart';
import '../../../../../misc/image_manager/image_manager.dart';
import '../../../../../misc/style_manager/styles_manager.dart';

class BankCard extends StatelessWidget {
  final Widget? header;
  final Widget? footer;
  final bool showDelete;
  final bool showNextArrow;
  final bool showBankIcon;
  final VoidCallback onTap;
  final Function? onDelete;
  final UserBank userBank;

  const BankCard(
      {super.key,
      required this.header,
      required this.footer,
      this.showDelete = true,
      this.showNextArrow = false,
      this.showBankIcon = false,
      required this.onTap,
      this.onDelete,
      required this.userBank});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 15, bottom: 14),
            decoration: BoxDecoration(
              color: ColorManager.kGreyF8,
              borderRadius: BorderRadius.circular(16.r)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 60.h,
                          width: 60.w,
                          
                          margin: const EdgeInsets.only(right: 4, bottom: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: ColorManager.kPrimary.withValues(alpha: .08),
                          ),
                          padding:  EdgeInsets.all(20.r),
                          child: svgImage(imgPath: 'assets/icons/bank-icon.svg', width: 20.w, height: 20.h,),
                        ),
                        if (showBankIcon)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(35),
                                  color: Colors.white),
                              child: loadNetworkImage(userBank.bank?.icon ?? "",
                                  borderRadius: BorderRadius.circular(35), width: 20),
                            ),
                          )
                      ],
                    ),
                      
                    SizedBox(width: showBankIcon ? 12 : 10),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userBank.bank_name,
                              style: get16TextStyle().copyWith(fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                              
                              maxLines: 1),
                          const SizedBox(height: 3),
                          RichText(
                              text: TextSpan(
                            style: get14TextStyle()
                                .copyWith(fontWeight: FontWeight.w400, color: ColorManager.kGreyColor.withValues(alpha: .7)),
                            children: [
                              TextSpan(text: userBank.account_number),
                              TextSpan(
                                text: " | ",
                                style: TextStyle(color: ColorManager.kBar2Color),
                              ),
                              TextSpan(text: userBank.account_name)
                            ],
                          )),
                        ],
                      ),
                    ),
                    
                    //
                      
                   // 
                  ],
                ),
                //if (showNextArrow)
                      Icon(Icons.keyboard_arrow_right_sharp,
                          color: ColorManager.kBarColor, size: 30,)
              ],
            ),
          ),
          if (showDelete)
            Positioned(
              right: 10,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (onDelete != null) onDelete!();
                },
                child: Image.asset(ImageManager.kDeleteIcon, width: 24),
              ),
            )
        ],
      ),
    );
  }
}
