import 'package:flutter/material.dart';
import '../color_manager/color_manager.dart';

import '../style_manager/styles_manager.dart';
import 'custom_btn.dart';

class SuccessPopup extends StatelessWidget {
  final String? title;
  final String? desc;
  final Function onTap;

  const SuccessPopup({Key? key, this.title, this.desc, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: ColorManager.kWhite,
      contentPadding: const EdgeInsets.only(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6), // Adjust the radius as needed
      ),
      content: SizedBox(
        height: 310,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            // Container(
            //     margin: const EdgeInsets.only(top: 27),
            //     padding: const EdgeInsets.all(17),
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(50),
            //       color: ColorManager.kSuccessAlt,
            //     ),
            //     child: Image.asset(ImageManager.kBoldCheck,
            //         width: 30, height: 30)),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 13),
              child: Text(title ?? "Success!", style: get18TextStyle()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                desc ?? "Your  transaction has been processed successfully!",
                textAlign: TextAlign.center,
                style:
                    get14TextStyle().copyWith(letterSpacing: .5, height: 1.45),
              ),
            ),
            const Spacer(),
            CustomButton(
              text: "Done",
              isActive: true,
              onTap: () async {
                Navigator.pop(context);
                onTap();
              },
              loading: false,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(6),
              ),
            )
          ],
        ),
      ),
    );
  }
}
