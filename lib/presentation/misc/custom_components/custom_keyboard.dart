import 'package:flutter/material.dart';

import '../color_manager/color_manager.dart';
import '../style_manager/styles_manager.dart';

class CustomAppLockKeyboard extends StatelessWidget {
  final ValueSetter<String> onTextInput;
  final VoidCallback onBackspace;
  final Widget? widget;

  const CustomAppLockKeyboard(
      {super.key,
      required this.onTextInput,
      required this.onBackspace,
      this.widget});

  void _textInputHandler(String text) => onTextInput.call(text);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double spaceBetween = size.width - (70 * 3);
    spaceBetween /= 8;

    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildRowOne(),
          SizedBox(height: spaceBetween),
          buildRowTwo(),
          SizedBox(height: spaceBetween),
          buildRowThree(),
          SizedBox(height: spaceBetween),
          buildRowFour(),
        ],
      ),
    );
  }

  Widget buildRowOne() {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _AppLockTextKey(
            text: '1',
            onTextInput: _textInputHandler,
          ),
          _AppLockTextKey(
            text: '2',
            onTextInput: _textInputHandler,
          ),
          _AppLockTextKey(
            text: '3',
            onTextInput: _textInputHandler,
          ),
        ],
      ),
    );
  }

  Widget buildRowTwo() {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _AppLockTextKey(
            text: '4',
            onTextInput: _textInputHandler,
          ),
          _AppLockTextKey(
            text: '5',
            onTextInput: _textInputHandler,
          ),
          _AppLockTextKey(
            text: '6',
            onTextInput: _textInputHandler,
          ),
        ],
      ),
    );
  }

  Widget buildRowThree() {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _AppLockTextKey(
            text: '7',
            onTextInput: _textInputHandler,
          ),
          _AppLockTextKey(
            text: '8',
            onTextInput: _textInputHandler,
          ),
          _AppLockTextKey(
            text: '9',
            onTextInput: _textInputHandler,
          ),
        ],
      ),
    );
  }

  Widget buildRowFour() {
    return SizedBox(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _AppLockTextKey(
            onTextInput: _textInputHandler,
            widget: widget!,
            isWidget: true,
          ),
          _AppLockTextKey(
            text: '0',
            onTextInput: _textInputHandler,
          ),
          _AppLockBackspaceKey(onBackspace: () => onBackspace()),
        ],
      ),
    );
  }
}

class _AppLockTextKey extends StatelessWidget {
  const _AppLockTextKey({
    this.text,
    this.onTextInput,
    this.widget,
    this.isWidget = false,
  });

  final String? text;
  final ValueSetter<String>? onTextInput;
  final Widget? widget;
  final bool? isWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget == null
            ? ColorManager.kDividerColor.withOpacity(.5)
            : Colors.transparent,
      ),
      child: InkWell(
        onTap: () => isWidget == false ? onTextInput!.call(text!) : () {},
        borderRadius: BorderRadius.circular(50),
        splashColor: widget == null ? ColorManager.kBlack : Colors.transparent,
        highlightColor:
            widget == null ? ColorManager.kBlack : Colors.transparent,
        child: isWidget!
            ? widget!
            : Center(
                child: Text(text ?? "--",
                    textAlign: TextAlign.center,
                    style: get18TextStyle()
                        .copyWith(color: ColorManager.kTextColor))),
      ),
    );
  }
}

class _AppLockBackspaceKey extends StatelessWidget {
  const _AppLockBackspaceKey({
    required this.onBackspace,
  });

  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: 70,
      child: InkWell(
        onTap: () => onBackspace.call(),
        borderRadius: BorderRadius.circular(50),
        child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorManager.kDividerColor.withOpacity(.5)),
          child: Icon(Icons.backspace_outlined, color: ColorManager.kTextColor),
        ),
      ),
    );
  }
}
