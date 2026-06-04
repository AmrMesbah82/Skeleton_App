import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
//Youssef Ashraf
///Helper Class resbonsible for sharing images for printing docs or sharing widgets as images (Qr)

abstract class ShareHelper {
  ///used for sharing widgets as Images
  static printDoc(
    List<List<dynamic>> data,
    List<String> headers,
  ) async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return pw.ClipRRect(
            verticalRadius: 8,
            horizontalRadius: 8,
            child: pw.Table(
              defaultColumnWidth: const pw.FlexColumnWidth(),
              border: pw.TableBorder.symmetric(
                outside: pw.BorderSide.none,
              ),
              children: [
                // Header
                pw.TableRow(
                  verticalAlignment: pw.TableCellVerticalAlignment.middle,
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#2D2D2D'),
                  ),
                  children: headers.map((header) {
                    return pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      child: pw.Text(
                        header,
                        style: const pw.TextStyle(
                          fontSize: 16,
                          color: PdfColors.white,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    );
                  }).toList(),
                ),
                ...List.generate(data.length, (rowIndex) {
                  final row = data[rowIndex];
                  return pw.TableRow(
                      verticalAlignment: pw.TableCellVerticalAlignment.middle,
                      decoration: pw.BoxDecoration(
                          color: rowIndex % 2 == 0
                              ? PdfColor.fromHex('#F5F5F5')
                              : PdfColors.white),
                      children: List.generate(
                        row.length,
                        (index) {
                          final isApproved = row[index] == 'Approved'.tr;
                          final isRejected = row[index] == 'Rejected'.tr;
                          final isPending = row[index] == 'Pending'.tr;
                          final isLink = row[index].startsWith('http');
                          return pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 6.0,
                            ),
                            child: index == 0
                                ? pw.Container(
                                    constraints: const pw.BoxConstraints(
                                      maxHeight: 32,
                                      maxWidth: 32,
                                    ),
                                    margin: const pw.EdgeInsets.symmetric(
                                      horizontal: 4.0,
                                    ),
                                    decoration: pw.BoxDecoration(
                                      borderRadius: pw.BorderRadius.circular(8),
                                    ),
                                  )
                                : pw.Text(
                                    row[index],
                                    style: pw.TextStyle(
                                      fontSize: 14,
                                      color: isRejected
                                          ? PdfColor.fromHex('#DF1C1C')
                                          : isApproved
                                              ? PdfColor.fromHex('#008000')
                                              : isPending
                                                  ? PdfColor.fromHex('#FF814A')
                                                  : isLink
                                                      ? PdfColors.blue
                                                      : PdfColor.fromHex(
                                                          '#2D2D2D'),
                                    ),
                                    textAlign: pw.TextAlign.center,
                                  ),
                          );
                        },
                      ));
                }),
              ],
            ),
          );
        },
      ),
    );
/*    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());*/
    // await Printing.sharePdf(
    //     bytes: await doc.save(), filename: 'my-document.pdf');
  }
}
