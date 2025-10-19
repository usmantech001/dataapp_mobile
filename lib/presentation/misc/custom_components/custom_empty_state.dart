import 'package:flutter/cupertino.dart';

import '../image_manager/image_manager.dart';
import '../style_manager/styles_manager.dart';
import 'custom_btn.dart';
import 'custom_container.dart';

class CustomEmptyState extends StatelessWidget {
  final String? title;
  final String? image;
  final String btnTitle;
  final Function onTap;
  final bool showBTn;
  final double imgWidth;
  final double imgHeight;
  const CustomEmptyState(
      {super.key,
      this.title,
      this.image,
      required this.btnTitle,
      required this.onTap,
      this.showBTn = true,
      this.imgWidth = 120,
      this.imgHeight = 130});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset( image ?? ImageManager.kEmptyState,
            width: imgWidth, height: imgHeight),
        CustomContainer(
          header: const SizedBox(height: 10, width: 85),
          width: double.infinity,
          margin: const EdgeInsets.only(top: 27),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title ?? "Nothing to see here yet",
                  textAlign: TextAlign.center, style: get14TextStyle()),
              const SizedBox(height: 20),
              if (showBTn)
                SizedBox(
                  width: 187,
                  child: CustomButton(
                    text: btnTitle,
                    isActive: true,
                    onTap: () => onTap(),
                    loading: false,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
