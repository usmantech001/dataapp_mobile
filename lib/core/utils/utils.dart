import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagekit/imagekit.dart';
import 'package:intl/intl.dart';

import '../../presentation/misc/custom_snackbar.dart';
import '../constants.dart';
import '../enum.dart';

String enumToString(val) => val.toString().split(".").last;

T? enumFromString<T>(Iterable<T?> values, String? value) {
  if (value == null) {
    return null;
  } else {
    for (var enumd in values) {
      if (enumd.toString().split(".").last == value) return enumd;
    }
    return null;
  }
}

String capitalize(String? s) {
  if (s == null || s == '') return '';
  if (s.length < 1) return '';

  String ss = '';
  List<String> ws = s.split(" ");
  for (int i = 0; i < ws.length; i++) {
    if (ws[i].length < 1) {
      ss += " ";
      break;
    }
    ss += " " +
        ws[i].substring(0, 1).toUpperCase() +
        ws[i].substring(1).toLowerCase();
  }
  return ss.trim();
}

String capitalizeFirstString(String? s) {
  if (s == null || s == '') return '';
  if (s.isEmpty) return '';
  return s.substring(0, 1).toUpperCase() + s.substring(1).toLowerCase();
}

String obscureEmail(String email) {
  if (email.split("@").first.length > 3) {
    var hiddenEmail = "";
    for (int i = 0; i < email.split("").length; i++) {
      if (i > 2 && i < email.indexOf("@")) {
        hiddenEmail += "*";
      } else {
        hiddenEmail += email[i];
      }
    }
    return hiddenEmail;
  } else {
    return "${email.split("@").first}****";
  }
}

String throwHttpError(res) {
  return res["message"] ??
      res["error"] ??
      "An error occured. please try again.";
}

String truncateWithEllipsis(int cutoff, String myString,
    {int ellipsCount = 3}) {
  return (myString.length <= cutoff)
      ? myString
      : '${myString.substring(0, cutoff)}${generateDots(ellipsCount)}';
}

String generateDots(int len) {
  String res = "";
  for (int i = 0; i < len; i++) {
    res = "$res.";
  }
  return res;
}
  String formatToken(String token) {
    // Remove any spaces just in case
    token = token.replaceAll(' ', '');

    // Split into groups of 4
    final buffer = StringBuffer();
    for (int i = 0; i < token.length; i++) {
      buffer.write(token[i]);
      if ((i + 1) % 4 == 0 && i != token.length - 1) {
        buffer.write(' ');
      }
    }
    return buffer.toString();
  }
extension WithKey on Widget {
  Widget withKey(Key key) => KeyedSubtree(key: key, child: this);
}

Future<File?> selectImage(ImageSource imageSource) async {
  final XFile? pickedFile =
      await ImagePicker().pickImage(source: imageSource, imageQuality: 2);
  if (pickedFile == null) return null;
  return File(pickedFile.path);
}

bool isValidNetwork(String phoneNumber, String selectedISP) {
  List<String> airtelPrefix = [
    '0802', '0808', '0708', '0812', '0701', '0902',
    '0901', '0907', '0912', '0911', '0904'
  ];
  List<String> mobile9Prefix = ['0809', '0818', '0817', '0909', '0908'];
  List<String> gloPrefix = [
    '0805', '0807', '0705', '0815', '0811', '0905', '0915'
  ];
  List<String> mtnPrefix = [
    '0803', '0806', '0703', '0810', '0813', '0814',
    '0816', '0903', '0906', '0704', '0706', '0913', '0702', '0916'
  ];

  phoneNumber = phoneNumber.replaceAll(RegExp(r'\s+'), '');
  phoneNumber = phoneNumber.replaceFirst(RegExp(r'^\+?234'), '0');

  String prefix = phoneNumber.length >= 4 ? phoneNumber.substring(0, 4) : '';

  List<String> validPrefixes;
  switch (selectedISP.toLowerCase()) {
    case 'airtel':
      validPrefixes = airtelPrefix;
      break;
    case '9mobile':
      validPrefixes = mobile9Prefix;
      break;
    case 'glo':
      validPrefixes = gloPrefix;
      break;
    case 'mtn':
      validPrefixes = mtnPrefix;
      break;
    default:
      return false;
  }

  return validPrefixes.contains(prefix) ||
      validPrefixes.contains(prefix.substring(1));
}


String getNetwork(String phoneNumber) {
  List<String> airtelPrefix = [
    '0802', '0808', '0708', '0812', '0701', '0902',
    '0901', '0907', '0912', '0911', '0904'
  ];
  List<String> mobile9Prefix = ['0809', '0818', '0817', '0909', '0908'];
  List<String> gloPrefix = [
    '0805', '0807', '0705', '0815', '0811', '0905', '0915'
  ];
  List<String> mtnPrefix = [
    '0803', '0806', '0703', '0810', '0813', '0814',
    '0816', '0903', '0906', '0704', '0706', '0913', '0702', '0916'
  ];

  // Normalize number
  phoneNumber = phoneNumber.replaceAll(RegExp(r'\s+'), '');
  phoneNumber = phoneNumber.replaceFirst(RegExp(r'^\+?234'), '0');

  String prefix = phoneNumber.length >= 4 ? phoneNumber.substring(0, 4) : '';

  if (mtnPrefix.contains(prefix)) return 'mtn';
  if (airtelPrefix.contains(prefix)) return 'airtel';
  if (gloPrefix.contains(prefix)) return 'glo';
  if (mobile9Prefix.contains(prefix)) return '9mobile';

  return 'unknown network';
}



// Future<File?> selectImage(ImageSource imageSource) async {
//   // Request permission
//   final status = await Permission.photos.request();

//   if (status.isDenied) {
//     print("Permission Denied");
//     return null;
//   } else if (status.isPermanentlyDenied) {
//     openAppSettings(); // Open app settings for the user to enable permission
//     return null;
//   }

//   // Pick the image
//   final XFile? pickedFile =
//       await ImagePicker().pickImage(source: imageSource, imageQuality: 2);
//   if (pickedFile == null) return null;
//   return File(pickedFile.path);
// }

Future<String> uploadImageToImageKit(File image) async {
  final imagekit = ImageKit.getInstance();
  const config = Configuration(
      publicKey: Constants.IMAGEKIT_PUBLIC_KEY,
      urlEndpoint: Constants.IMAGEKIT_URL_ENDPOINT,
      authenticationEndpoint: Constants.IMAGEKIT_SIGNATURE);
  imagekit.setConfig(config);

  ImageKitResponse data = await imagekit.upload(image);

  return data.url;
}

Future<List<String>> uploadImagesToImageKit(List<File> images) async {
  final imagekit = ImageKit.getInstance();
  const config = Configuration(
      publicKey: Constants.IMAGEKIT_PUBLIC_KEY,
      urlEndpoint: Constants.IMAGEKIT_URL_ENDPOINT,
      authenticationEndpoint: Constants.IMAGEKIT_SIGNATURE);
  imagekit.setConfig(config);

  //
  List<Future<ImageKitResponse>> futures = [];

  images.forEach((el) => futures.add(imagekit.upload(el)));

  List<ImageKitResponse> uploadedImagesResponse = await Future.wait(futures);
  return uploadedImagesResponse.map((e) => e.url).toList();
}

// String formatNumber(num? value, {int decimalDigits = 2, bool short = false}) {
//   if (value == null) return "--";

//   NumberFormat formatter;
//   if (short) {
//     // return value.toStringAsFixed(0);
//      if (value == value.roundToDouble()) {
//     formatter  = NumberFormat("0").format(value);}
//     formatter = NumberFormat.compact();
//   } else {
//     formatter = NumberFormat.currency(decimalDigits: decimalDigits, symbol: "");
//   }
//   return formatter.format(value);
// }

String formatNumber(num? value, {int decimalDigits = 2, bool short = false}) {
  if (value == null) return "--";

  if (short) {
    // If the value has no decimal part, show as integer
   if (value == value.roundToDouble()) {
      return NumberFormat.decimalPattern().format(value); // e.g., 1,000
    }else {
      return NumberFormat("0.00").format(value);
    }
  } else {
    // Use currency-like formatting without symbol
    return NumberFormat.currency(
      decimalDigits: decimalDigits,
      symbol: "",
    ).format(value);
  }
}


  String formatDiscountPercentage(double amount, double discount) {
    if (amount == 0) {
      throw ArgumentError("Amount cannot be zero.");
    }



    double percentage = (discount / amount) * 100;

    return percentage >= 1
        ? percentage.toStringAsFixed(0)
        : percentage.toStringAsFixed(1);
  }

String formatCurrency(num? value,
    {int decimalDigits = 2, bool short = false, String code = "NGN"}) {
  if (value == null) {
    return "-";
  }

  if (short) {
    return NumberFormat.compactCurrency(
            symbol: getCurrencySymbol(code), decimalDigits: decimalDigits)
        .format(value);
  } else {
    return NumberFormat.currency(
            decimalDigits: decimalDigits, symbol: getCurrencySymbol(code))
        .format(value);
  }
}

String? formatDateShortWithTime(DateTime? dateTime) {
  try {
    final DateFormat formatter = DateFormat("MMM d, yyyy • hh:mm a");
    return formatter.format(dateTime!);
  } catch (_) {
    return null;
  }
}

String? formatDateShort(DateTime? dateTime) {
  try {
    final DateFormat formatter = DateFormat("dd MMM, yyyy");
    return formatter.format(dateTime!);
  } catch (_) {
    return null;
  }
}

String getCurrencySymbol(String currencyName, {bool useFullName = false}) {
  currencyName = (currencyName.trim().contains("-"))
      ? currencyName.split("-").last.toUpperCase()
      : currencyName.toUpperCase();
  String currencySymbol = '';
  String fullName = '';
  switch (currencyName) {
    case 'NGN':
    case 'NGA':
    case 'NG':
      fullName = "naira";
      currencySymbol = "\u20A6";
      break;
    case 'GBP':
      fullName = "pound";
      currencySymbol = NumberFormat().simpleCurrencySymbol("GBP");
      break;
    case 'EUR':
      fullName = "euro";
      currencySymbol = NumberFormat().simpleCurrencySymbol("EUR");
      break;
    case 'KES':
      fullName = "shilling";
      currencySymbol = NumberFormat().simpleCurrencySymbol("KES");
      break;
    case 'GHS':
      fullName = "cedi";
      currencySymbol = NumberFormat().simpleCurrencySymbol("GHS");
      break;
    case 'ZMW':
      fullName = "kwacha";
      currencySymbol = NumberFormat().simpleCurrencySymbol("ZMW");
      break;
    case 'UGX':
      fullName = "shilling";
      currencySymbol = NumberFormat().simpleCurrencySymbol("UGX");
      break;
    case 'RWF':
      fullName = "franc";
      currencySymbol = NumberFormat().simpleCurrencySymbol("RWF");
      break;
    case 'XOF':
      fullName = "franc";
      currencySymbol = NumberFormat().simpleCurrencySymbol("XOF");
      break;
    case 'TZS':
      fullName = "shilling";
      currencySymbol = NumberFormat().simpleCurrencySymbol("TZS");
      break;
    case 'USD':
    case 'US':
      fullName = 'dollar';
      currencySymbol = NumberFormat().simpleCurrencySymbol("USD");
      break;
    default:
      fullName = currencyName;
      currencySymbol = NumberFormat().simpleCurrencySymbol(currencyName);
      break;
  }

  return useFullName ? fullName : currencySymbol;
}

Future<List<File>?> selectMultipleImages(ImageSource imageSource) async {
  // final List<XFile?> pickedFile =await ImagePicker.pickImaag
  final List<XFile>? pickedFile =
      await ImagePicker().pickMultiImage(imageQuality: 25);
  if (pickedFile == null) return null;
  return pickedFile.map((el) => File(el.path)).toList();
}

Future<void> copyToClipboard(BuildContext context, String text,
    {String? successMsg}) async {
  await Clipboard.setData(ClipboardData(text: text)).then((_) {
    showCustomToast(
        context: context,
        description: successMsg ?? "Text copied to clipboard successfully.",
        type: ToastType.success);
  });
}

//

String? getTimeFromDate(DateTime? date) {
  try {
    return DateFormat('hh:mm a').format(date!);
  } catch (_) {
    return null;
  }
}

String? formatDateSlash(DateTime? dateTime) {
  try {
    final DateFormat formatter = DateFormat("dd/MM/yyyy");
    return formatter.format(dateTime!);
  } catch (_) {
    return null;
  }
}

bool isSmallScreen(BuildContext context) {
  return MediaQuery.of(context).size.height <= Constants.kSmallScreenHeight;
}

// num calBalAfterTxn(UserProvider userProvider, {required String amount}) {
//   try {
//     num val = userProvider.user!.wallet_balance -
//         (num.tryParse(amount.replaceAll(",", "")) ?? 0);
//     return val;
//   } catch (_) {
//     return 0;
//   }
// }

num? parseNum(String val) {
  return num.tryParse(val.replaceAll(",", ""));
}

