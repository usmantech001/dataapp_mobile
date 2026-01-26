import 'dart:io';
import 'dart:typed_data';

import 'package:dataplug/core/model/core/review_model.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

Future<Uint8List> generateReceiptPdfFromModel(ReceiptModel model) async {
  final pdf = pw.Document();
  pw.MemoryImage? logoImage;

   final bytes = await rootBundle.load('assets/images/dataplug-logo-text.png');
    logoImage = pw.MemoryImage(bytes.buffer.asUint8List());

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Center(
          child: pw.Container(
            padding: const pw.EdgeInsets.all(24),
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: pw.BorderRadius.circular(16),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                // Icon
                pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Image(logoImage!, height: 32)
                )
                ,
                pw.Container(
                  height: 70,
                  width: 70,
                  decoration: pw.BoxDecoration(
                    shape: pw.BoxShape.circle,
                    color: PdfColor.fromHex('#E8FAF8'),
                  ),
                  child: pw.Center(
                    child: logoImage != null
                        ? pw.Image(logoImage!, height: 32)
                        : pw.Icon(pw.IconData(0xe227)),
                  ),
                ),

                pw.SizedBox(height: 16),

                pw.Text(
                  'Transaction Receipt',
                  style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                ),

                pw.SizedBox(height: 8),

                pw.Text(
                  '₦${model.amount}',
                  style: pw.TextStyle(fontSize: 32, fontWeight: pw.FontWeight.bold),
                ),

                pw.SizedBox(height: 10),

                pw.Text(
                  model.shortInfo,
                  style: pw.TextStyle(fontSize: 14),
                ),

                pw.SizedBox(height: 20),

                // Summary
                pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Text(
                    'Summary',
                    style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                  ),
                ),

                pw.SizedBox(height: 8),
                _pdfDashedDivider(),

                pw.SizedBox(height: 12),

                ...model.summaryItems.map(
                  (item) => _pdfSummaryRow(item.title, item.name),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );

  return pdf.save();
}

pw.Widget _pdfSummaryRow(String title, String value) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 6),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(title, style: const pw.TextStyle(fontSize: 12)),
        pw.Text(value, style:  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
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