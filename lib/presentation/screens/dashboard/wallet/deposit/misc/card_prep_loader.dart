// import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// // import 'package:flutterwave_standard/core/flutterwave.dart';
// // import 'package:flutterwave_standard/models/requests/customer.dart';
// // import 'package:flutterwave_standard/models/requests/customizations.dart';
// // import 'package:flutterwave_standard/models/responses/charge_response.dart';
// import 'package:provider/provider.dart';

// import '../../../../../../core/constants.dart';
// import '../../../../../../core/enum.dart';
// import '../../../../../../core/helpers/service_helper.dart';
// import '../../../../../../core/model/core/user.dart';
// import '../../../../../../core/model/core/virtual_account_provider.dart';
// import '../../../../../../core/providers/user_provider.dart';
// import '../../../../../misc/color_manager/color_manager.dart';
// import '../../../../../misc/custom_snackbar.dart';
// import '../deposit_3.dart';

// class CardPrepLoader extends StatefulWidget {
//   final Deposit3Arg deposit3Arg;
//   final VirtualAccProviderPaymentOptions providerOption;
//   const CardPrepLoader(
//       {super.key, required this.deposit3Arg, required this.providerOption});

//   @override
//   State<CardPrepLoader> createState() => _CardPrepLoaderState();
// }

// class _CardPrepLoaderState extends State<CardPrepLoader> {
//   //

//   @override
//   void initState() {
//     super.initState();
//     fetchInfo();
//   }

//   Future<void> fetchInfo() async {
//     await ServicesHelper.fundWallet(
//       provider: widget.deposit3Arg.provider.name,
//       amount: widget.deposit3Arg.amount,
//       method: widget.providerOption.code,
//     ).then((dt) {
//       UserProvider userProvider =
//           Provider.of<UserProvider>(context, listen: false);
//       handleCard(dt, userProvider: userProvider);

//       //
//     }).catchError((err) {
//       if (mounted) {
//         showCustomToast(context: context, description: err.toString());
//       }
//       Navigator.pop(context);
//     });
//   }

//   Future handleCard(dt, {required UserProvider userProvider}) async {
//     User user = userProvider.user;
//     final Customer customer = Customer(
//       name: "${user.firstname} ${user.lastname}",
//       phoneNumber: "${user.phone_code}${user.phone}",
//       email: user.email ?? "",
//     );

//     final Flutterwave flutterwave = Flutterwave(
//       context: context,
//       publicKey: dt["public_key"] ?? "",
//       currency: "NGN",
//       redirectUrl: Constants.kBaseurl,
//       txRef: dt["reference"] ?? "",
//       amount: dt["amount"].toString(),
//       customer: customer,
//       paymentOptions: "card",
//       customization: Customization(title: "Complete Payment"),
//       isTestMode:
//           (dt["public_key"] ?? "").toString().toLowerCase().contains("test")
//               ? true
//               : false,
//     );

//     final ChargeResponse response = await flutterwave.charge();

//     if (response.status == "cancelled") {
//       showCustomToast(context: context, description: "Payment cancelled!");
//       Navigator.pop(context);
//       return;
//     }

//     await userProvider.updateUserInfo();
//     showCustomToast(
//       context: context,
//       description:
//           "Payment completed, we'll send a notification when it's confirmed!",
//       type: ToastType.success,
//     );
//     Navigator.pop(context);
//     Navigator.pop(context);
//     Navigator.pop(context);
//     Navigator.pop(context);
//   }

//   //
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 350,
//       color: ColorManager.kWhite,
//       padding: const EdgeInsets.symmetric(
//           horizontal: Constants.kHorizontalScreenPadding),
//       child: Column(
//         children: [
//           Align(
//             alignment: Alignment.centerRight,
//             child: GestureDetector(
//               behavior: HitTestBehavior.translucent,
//               onTap: () => Navigator.pop(context),
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 2, top: 20),
//                 child: Icon(CupertinoIcons.xmark,
//                     size: 20, color: ColorManager.kTextDark7),
//               ),
//             ),
//           ),

//           Padding(
//             padding: const EdgeInsets.only(top: 20, bottom: 35),
//             child: Text(
//               "Seting up card payment",
//               style: get16TextStyle().copyWith(fontWeight: FontWeight.w400),
//             ),
//           ),
//           Center(
//             child: SizedBox(
//               height: 100,
//               width: 100,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2.0,
//                 valueColor: AlwaysStoppedAnimation<Color>(
//                   ColorManager.kPrimary,
//                 ),
//               ),
//             ),
//           )

//           //
//         ],
//       ),
//     );
//   }
// }
