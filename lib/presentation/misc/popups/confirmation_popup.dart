import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:flutter/material.dart';

import '../color_manager/color_manager.dart';
import '../style_manager/styles_manager.dart';

class ConfirmationPopup extends StatefulWidget {
  final String? title;
  final String? desc;
  final Function? onCancel;
  final String? cancelText;
  final String? proceedText;
  final Function onProceed;

  const ConfirmationPopup({
    Key? key,
    this.title,
    this.desc,
    this.onCancel,
    required this.onProceed,
    this.cancelText,
    this.proceedText,
  }) : super(key: key);

  @override
  _ConfirmationPopupState createState() => _ConfirmationPopupState();
}

class _ConfirmationPopupState extends State<ConfirmationPopup> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        backgroundColor: ColorManager.kWhite,
        content: SizedBox(
          height: 290,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.title ?? "Delete your Account",
                    style: get16TextStyle().copyWith(),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child:
                        const Icon(Icons.cancel_outlined, color: Colors.black),
                  )
                ],
              ),

              //  Spacer
              const SizedBox(height: 44),

              // Desc
              Text(
                  widget.desc ??
                      "Are you sure you want to\ndelete of your account",
                  textAlign: TextAlign.center,
                  style: get14TextStyle().copyWith()),

              const Spacer(),

              //Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CustomButton(
                      onTap: () async {
                        widget.onCancel == null
                            ? Navigator.pop(context)
                            : await widget.onCancel!();
                      },
                      text: widget.cancelText ?? "Cancel",
                      isActive: true,
                      loading: false,
                      // width: 150,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: CustomButton(
                      backgroundColor: ColorManager.kError.withOpacity(0.1),
                      onTap: () async {
                        await widget.onProceed();
                      },
                      text: widget.proceedText ?? "Log Out",
                      textColor: ColorManager.kError,
                      isActive: true,
                      loading: false,
                      // width: 150,
                    ),
                  ),
                ],
              ),

              Container(
                width: 90,
                height: 4,
                margin: const EdgeInsets.only(top: 42),
                decoration: BoxDecoration(
                  color: const Color(0xffC4C4C4),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
                     SizedBox(height: 24,),
            ],
          ),
        ),
      ),
    );
  }
}
