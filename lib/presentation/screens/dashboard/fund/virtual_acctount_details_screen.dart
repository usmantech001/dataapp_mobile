import 'dart:async';

import 'package:dataplug/core/enum.dart';
import 'package:dataplug/core/model/core/virtual_account_provider.dart';
import 'package:dataplug/core/providers/wallet_controller.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_snackbar.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/screens/dashboard/fund/widgets/virtual_acc_details_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class VirtualAcctountDetailsScreen extends StatefulWidget {
  const VirtualAcctountDetailsScreen({super.key});

  @override
  State<VirtualAcctountDetailsScreen> createState() =>
      _VirtualAcctountDetailsScreenState();
}

class _VirtualAcctountDetailsScreenState
    extends State<VirtualAcctountDetailsScreen> {
  late VirtualAccountDetails virtualAccountDetails;
  Timer? _timer;
  Duration remaining = Duration.zero;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    WidgetsBinding.instance.addPostFrameCallback((_) {
      virtualAccountDetails =
          ModalRoute.of(context)!.settings.arguments as VirtualAccountDetails;
      _startCountdown();
      isInitialized = true;
      setState(() {});
    });
    super.didChangeDependencies();
  }

  void _startCountdown() {
    remaining = virtualAccountDetails.expiredAt.difference(DateTime.now());

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final diff = virtualAccountDetails.expiredAt.difference(DateTime.now());

      if (diff.isNegative) {
        _timer?.cancel();
        setState(() => remaining = Duration.zero);
      } else {
        setState(() => remaining = diff);
      }
    });
  }

  String _format(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(d.inHours)}:${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletController = context.read<WalletController>();
     virtualAccountDetails =
          ModalRoute.of(context)!.settings.arguments as VirtualAccountDetails;
    return Scaffold(
      appBar: CustomAppbar(
        canPop: false,
        title: '${virtualAccountDetails.provider.toUpperCase()} Payment',
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            Text(
              'Fund your account by transferring ${walletController.amountController.text} to this virtual account',
            ),
            Gap(30),
            VirtualAccDetailsWidget(
              name: 'Account Number',
              value: virtualAccountDetails.accountNumber,
              isAccountNumber: true,
              onTap: () {
                Clipboard.setData(
                    ClipboardData(text: virtualAccountDetails.accountNumber));
                showCustomToast(
                  context: context,
                  description: 'Account number successfully copied',
                  type: ToastType.success,
                );
              },
            ),
            VirtualAccDetailsWidget(
              name: 'Bank Name',
              value: virtualAccountDetails.bankName,
              isAccountNumber: false,
            ),
            VirtualAccDetailsWidget(
              name: 'Account Name',
              value: virtualAccountDetails.accountName ?? "",
              isAccountNumber: false,
            ),
            Gap(40),
            CustomRichText(
              firstText: 'Account expires in ',
              secText: isInitialized
                  ? _format(remaining)
                  : '00:00', // 🔥 Live countdown
              firstTextColor: ColorManager.kBlack.withOpacity(0.6),
              secTextColor: ColorManager.kPrimary,
            ),
            Gap(20),
            CustomButton(
              isActive: true,
              loading: false,
              onTap: () {
                removeAllAndPushScreen(RoutesManager.bottomNav);
              },
              text: "Done",
            ),
          ],
        ),
      ),
    );
  }
}

class CustomRichText extends StatelessWidget {
  const CustomRichText(
      {super.key,
      required this.firstText,
      required this.secText,
      required this.firstTextColor,
      required this.secTextColor,
      this.fontSize,
      this.firstTextFontWeight,
      this.secTextFontWeight,
      this.onTap});
  final String firstText;
  final String secText;
  final Color firstTextColor;
  final Color secTextColor;
  final VoidCallback? onTap;
  final double? fontSize;
  final FontWeight? firstTextFontWeight;
  final FontWeight? secTextFontWeight;
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: firstText,
          style: TextStyle(
              color: firstTextColor,
              fontFamily: 'Aeonik',
              fontFamilyFallback: const ['Roboto', 'sans-serif'],
              fontSize: fontSize ?? 16.sp,
              fontWeight: firstTextFontWeight ?? FontWeight.w500),
        ),
        TextSpan(
            text: secText,
            style: TextStyle(
                fontFamily: 'Aeonik',
                fontFamilyFallback: const ['Roboto', 'sans-serif'],
                color: secTextColor,
                fontSize: fontSize ?? 16.sp,
                fontWeight: secTextFontWeight ?? FontWeight.w500),
            recognizer: TapGestureRecognizer()..onTap = onTap),
      ]),
    );
  }
}
