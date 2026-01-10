import 'package:dataplug/core/providers/keypad_provider.dart';
import 'package:dataplug/core/utils/custom_image.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/image_manager/image_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomKeyPadInputBox extends StatelessWidget {
  const CustomKeyPadInputBox({super.key});

  @override
  Widget build(BuildContext context) {
    final keypadController = context.watch<KeypadProvider>();
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            return Container(
              height: 54,
              width: 54,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color:index < keypadController.enteredPin.length?ColorManager.kPrimary.withValues(alpha: .09): ColorManager.kWhite,
                  border: Border.all(
                      color: index < keypadController.enteredPin.length?ColorManager.kPrimary: ColorManager.kGreyColor.withValues(alpha: .12))),
              child: Text(
                 index < keypadController.enteredPin.length
                    ? '•'
                    //keypadController.enteredPin[index]
                    : '',
                    style: get20TextStyle(
                      
                    ).copyWith(color: ColorManager.kPrimary),
               
              ),
            );
          })),
    );
  }
}


class CustomKeyPad extends StatelessWidget {
  const CustomKeyPad(
      {super.key,
      required this.onPinComplete,
      required this.onSuccessfulBiometric});
  final Function(String) onPinComplete;
  final Function(String) onSuccessfulBiometric;
  @override
  Widget build(BuildContext context) {
    final keypadController = context.watch<KeypadProvider>();
    // final biometricController = context.read<BiometricController>();
    // final user = getIt<StorageController>().getUserDetails();
    return Column(
      children: [
        for (int i = 0; i < 3; i++)
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Row(
              spacing: 6,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(3, (index) {
                String value = (1 + 3 * i + index).toString();
                return PinButton(
                    value: value,
                    onTap: () {
                      keypadController.addPin(value, onPinComplete);
                    });
              }),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(top: 30),
          child:
              Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            PinButton(
                //imgPath: ImageManager.kFaceIcon,
                value: '',
                bgColor: ColorManager.kWhite,
                //bgColor: ColorManager.kPrimary.withValues(alpha:  0.1),
                onTap: () {
                  
                }) ,
            PinButton(
                value: '0',
                onTap: () {
                  keypadController.addPin('0', onPinComplete);
                }),
            PinButton(
                imgPath: 'assets/icons/erase-icon.svg',
               // imgColor: ColorManager.kBlack,
               value: '',
               bgColor: ColorManager.kWhite,
                onTap: () {
                  keypadController.deletePin();
                }),
          ]),
        )
      ],
    );
  }
}

class PinButton extends StatelessWidget {
  const PinButton(
      {super.key,
      this.value,
      required this.onTap,
      this.imgPath,
      this.bgColor,
      this.imgColor});
  final String? value;
  final VoidCallback onTap;
  final Color? bgColor;
  final String? imgPath;
  final Color? imgColor;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
         color: bgColor?? ColorManager.kGreyF8,
         borderRadius: BorderRadius.circular(8.5)
          ),
          child: imgPath != null
              ? svgImage(
                  imgPath:  imgPath!,
                  height: 25,
                  width: 25,
                  //color: imgColor ?? ColorManager.kPrimary
                  )
              : Text(
                   value!,
                  style: get24TextStyle().copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 23
                  ),
                ),
        ),
      ),
    );
  }
}
