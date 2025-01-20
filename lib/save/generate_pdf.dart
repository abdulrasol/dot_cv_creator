import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

final pdf = pw.Document();

class GeneratePdf {
  final Uint8List image;

  GeneratePdf(this.image);

  Future<Uint8List> generate() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Image(pw.MemoryImage(image));
        },
      ),
    ); // Page
    return await pdf.save();
  }
}
