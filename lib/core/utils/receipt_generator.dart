import 'dart:io';
import 'dart:typed_data';

import 'package:dataplug/core/model/core/review_model.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

Future<Uint8List> generateReceiptPdfFromModel(ReceiptModel model) async {
  final geistRegular = pw.Font.ttf(
  await rootBundle.load(
    'assets/fonts/Geist/static/Geist-Regular.ttf',
  ),
);

final geistMedium = pw.Font.ttf(
  await rootBundle.load(
    'assets/fonts/Geist/static/Geist-Medium.ttf',
  ),
);

final geistBold = pw.Font.ttf(
  await rootBundle.load(
    'assets/fonts/Geist/static/Geist-Bold.ttf',
  ),
);

  final pdf = pw.Document(
    theme: pw.ThemeData.withFont(
    base: geistRegular,
    bold: geistBold,
    fontFallback: [
      pw.Font.symbol()
    ],
  
  ),
  );
  pw.MemoryImage logoImage;

  final bytes =
      await rootBundle.load('assets/images/dataplug-logo-text.png');
  logoImage = pw.MemoryImage(bytes.buffer.asUint8List());

  const brandColor = PdfColor.fromInt(0xFF00B875);
  const bgColor = PdfColor.fromInt(0xFFF5F6FA);

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.zero,
      build: (context) {
        return pw.Container(
          color: bgColor,
          padding: const pw.EdgeInsets.all(24),
          child: pw.Center(
            child: pw.Container(
              width: 380,
              padding: const pw.EdgeInsets.all(24),
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                borderRadius: pw.BorderRadius.circular(20),
              ),
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  // Header
                  pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Image(logoImage, height: 28),
                  ),

                  pw.SizedBox(height: 20),

                  // Status Badge
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#E8FAF8'),
                      borderRadius: pw.BorderRadius.circular(30),
                    ),
                    child: pw.Text(
                      'SUCCESS',
                      
                      style: pw.TextStyle(
                        color: brandColor,
                        fontSize: 12,
                        font: geistRegular,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),

                  pw.SizedBox(height: 16),

                  // Amount
                  pw.Text(
                    '\$₦${model.amount}',
                    style: pw.TextStyle(
                      fontSize: 34,
                      font: geistRegular,
                      fontWeight: pw.FontWeight.bold,
                      color: brandColor,
                    ),
                  ),

                  pw.SizedBox(height: 6),

                  pw.Text(
                    model.shortInfo,
                    style: pw.TextStyle(
                      fontSize: 13,
                      font: geistRegular,
                      color: PdfColors.grey700,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),

                  pw.SizedBox(height: 24),

                  // Summary Card
                  pw.Container(
                    padding: const pw.EdgeInsets.all(16),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#FAFAFA'),
                      borderRadius: pw.BorderRadius.circular(12),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Transaction Details',
                          style: pw.TextStyle(
                            fontSize: 14,
                            font: geistRegular,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),

                        pw.SizedBox(height: 10),
                        _pdfDashedDivider(),
                        pw.SizedBox(height: 12),

                        ...model.summaryItems.map(
                          (item) =>
                              _pdfSummaryRow(item.title, item.name, geistRegular),
                        ),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 24),

                  // Footer
                  pw.Text(
                    'Powered by DataPlug',
                    style: pw.TextStyle(
                      fontSize: 10,
                      font: geistRegular,
                      color: PdfColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );

  return pdf.save();
}


pw.Widget _pdfSummaryRow(String title, String value, pw.Font font) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 6),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 12,
            color: PdfColors.grey700,
            font: font,
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}


pw.Widget _pdfDashedDivider() {
  return pw.LayoutBuilder(
    builder: (context, constraints) {
      final dashWidth = 5.0;
      final dashSpace = 3.0;
      final count = (constraints!.maxWidth / (dashWidth + dashSpace)).floor();
      return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: List.generate(count, (_) {
          return pw.Container(
            width: dashWidth,
            height: 1,
            color: PdfColors.grey,
          );
        }),
      );
    },
  );
}

//  Future<String> savePdfFile(Uint8List pdfBytes, String transId) async {
//     final directory = await getApplicationDocumentsDirectory();
//     final file = File('${directory.path}/Transaction Receipt-$transId.pdf');
//     await file.writeAsBytes(pdfBytes);
//     await OpenFile.open(file.path);
//     return file.path;
//   }

// Function to save PDF bytes to a temporary file and share using share_plus
  Future<void> sharePdf(Uint8List pdfBytes, String transId) async {
    // Generate the PDF bytes.
    //Uint8List pdfBytes = await generatePdf();

    // Get temporary directory to save the PDF file.
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/Transaction Receipt-$transId.pdf';
    final file = File(filePath);

    // Write PDF bytes to the file.
    await file.writeAsBytes(pdfBytes, flush: true);

    // Use share_plus to share the file.
    await Share.shareXFiles([XFile(filePath)]);
  }