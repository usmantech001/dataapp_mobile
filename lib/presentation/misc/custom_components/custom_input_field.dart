import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../color_manager/color_manager.dart';
import '../style_manager/styles_manager.dart';

class CustomInputField extends StatefulWidget {
  const CustomInputField({
    Key? key,
    this.textEditingController,
    this.textInputAction,
    this.textInputType,
    this.focusNode,
    this.onSubmitted,
    this.validator,
    this.hintText,
    this.forceRefresh,
    this.decoration,
    this.obscureText,
    this.readOnly,
    this.style,
    this.onFieldSubmitted,
    this.cursorColor,
    this.inputFormatters,
    this.onChanged,
    this.isPasswordField = false,
    this.suffixConstraints,
    this.suffixIcon,
    this.prefixIcon,
    this.hintStyle,
    this.onTap,
    this.autofillHints,
    this.formHolderName,
    this.prefixIconConstraints,
    this.enabled,
    this.maxLength,
    this.counterText,
    this.maxLines,
  }) : super(key: key);
  final bool? enabled;
  final int? maxLength;
  final String? formHolderName;
  final TextEditingController? textEditingController;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final TextInputType? textInputType;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final String? hintText;
  final bool? obscureText;
  final bool? readOnly;
  final String? counterText;
  final Function? forceRefresh;
  final InputDecoration? decoration;
  final TextStyle? style;
  final ValueChanged<String>? onFieldSubmitted;
  final Color? cursorColor;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final bool? isPasswordField;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final BoxConstraints? suffixConstraints;
  final BoxConstraints? prefixIconConstraints;
  final TextStyle? hintStyle;
  final Function? onTap;
  final Iterable<String>? autofillHints;
  @override
  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool isVisible = false;
  bool _showVisibility = true;

  BorderRadius borderRadius = BorderRadius.circular(19);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.formHolderName != null
            ? Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  widget.formHolderName!,
                  style: get14TextStyle().copyWith(
                      fontWeight: FontWeight.w400,
                      color: ColorManager.kFadedTextColor),
                ),
              )
            : const SizedBox(),
        TextFormField(
          style: get16TextStyle().copyWith(fontWeight: FontWeight.w500),
          enabled: widget.enabled,
          autofillHints: widget.autofillHints,
          inputFormatters: widget.inputFormatters ?? [],
          maxLength: widget.maxLength,
          cursorColor:
              widget.cursorColor ?? ColorManager.kTextColor.withOpacity(0.25),
          focusNode: widget.focusNode,
          controller: widget.textEditingController,
          textInputAction: widget.textInputAction,
          maxLines: widget.maxLines ?? 1,
          onTap: () {
            if (widget.onTap != null) widget.onTap!();
          },
          onChanged: (args) {
            if (args.length > 1) {
              setState(() => isVisible = true);
            } else if (args.isEmpty) {
              setState(() => isVisible = false);
            } else if (widget.textEditingController!.text.isEmpty) {
              setState(() => isVisible = false);
            }
            if (widget.forceRefresh != null) widget.forceRefresh!();
            if (widget.onChanged != null) widget.onChanged!(args);
          },
          obscureText: widget.isPasswordField! ? _showVisibility : false,
          readOnly: widget.readOnly ?? false,
          decoration: widget.decoration ??
              InputDecoration(
                counterText: widget.counterText,
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: widget.suffixIcon ??
                      SizedBox(
                        child: widget.isPasswordField!
                            ? GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  setState(
                                      () => _showVisibility = !_showVisibility);
                                },
                                child: Icon(
                                  _showVisibility
                                      ? LucideIcons.eye
                                      : LucideIcons.eyeOff,
                                  color: ColorManager.kSmallText,
                                  size: 19,
                                ),
                              )
                            : const SizedBox(),
                      ),
                ),
                prefixIcon: widget.prefixIcon,
                suffixIconConstraints: widget.suffixConstraints ??
                    const BoxConstraints(minHeight: 0, minWidth: 0),
                prefixIconConstraints: widget.prefixIconConstraints ??
                    const BoxConstraints(minHeight: 0, minWidth: 0),
                filled: true,
                fillColor: ColorManager.kWhite,
                contentPadding: const EdgeInsets.only(
                    top: 17, bottom: 17, left: 16, right: 7),
                enabledBorder: OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide(
                      color: ColorManager.kFormInactiveBorder, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide(
                    width: 0.57,
                    color: ColorManager.kTextColor,
                  ),
                ),
                hintText: widget.hintText,
                hintStyle: widget.hintStyle ?? getHintTextStyle(),
                errorStyle:
                    getHintTextStyle().copyWith(color: ColorManager.kError),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide(color: ColorManager.kError),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide(color: ColorManager.kError),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide(
                    color: ColorManager.kFormInactiveBorder,
                  ),
                ),
              ),
          onFieldSubmitted: widget.onFieldSubmitted ?? (_) {},
          validator: (val) {
            if (widget.validator != null) return widget.validator!(val);
            return null;
          },
          keyboardType: widget.textInputType,
        ),
      ],
    );
  }
}
