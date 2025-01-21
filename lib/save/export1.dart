import 'dart:typed_data';
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:dot_cv_creator/layouts/preivew_widget.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class ExportPage extends StatefulWidget {
  const ExportPage({
    super.key,
  });

  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  final GlobalKey _globalKey = GlobalKey();

  Uint8List? _cvImage;
  final controller = RoundedLoadingButtonController();
  final fontControllerBtn = RoundedLoadingButtonController();
  final fontType = [
    GoogleFonts.cairo(),
    GoogleFonts.tajawal(),
    GoogleFonts.notoSansLao(),
    GoogleFonts.openSans(),
    GoogleFonts.lora(),
    GoogleFonts.merriweather(),
    GoogleFonts.montserrat(),
    GoogleFonts.raleway(),
    GoogleFonts.sourceSans3(),
    GoogleFonts.ptSerif(),
    GoogleFonts.playfairDisplay(),
    GoogleFonts.nunito(),
    GoogleFonts.roboto(),
  ];
  var selectedFont = GoogleFonts.tajawal(); // Default selected font
  Color backgroundColor = Colors.white70; // Default selected font
  Color textColor = Colors.grey.shade800; // Default selected font

  // WidgetsToImageController to access widget
  WidgetsToImageController imageController = WidgetsToImageController();
// to save image bytes of widget
  Uint8List? bytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Export CV (Save and Download)"),
        actions: [
          IconButton(
            onPressed: () async {
              bytes = await imageController.capture();

              _downloadImage();
            },
            icon: const Icon(Icons.download),
          ),
          10.horizontalSpace,
        ],
      ),
      body: Column(
        children: [
          Wrap(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Personalize Your CV'),
              40.horizontalSpace,
              TextButton.icon(
                onPressed: () async {
                  await fontTypeDialog(context);
                },
                label: const Text('Pick a Font Style'),
                icon: const Icon(FontAwesome.font),
              ),
              TextButton.icon(
                onPressed: () async {
                  await colorDialog(context);
                },
                label: const Text('Pick Your CV Colors'),
                icon: const Icon(Icons.color_lens),
              ),
            ],
          ),
          10.verticalSpace,
          Expanded(
            child: Center(
              child: RepaintBoundary(
                key: _globalKey,
                child: AspectRatio(
                  aspectRatio: 1 / 1.4142, // A4 Ratio
                  child: WidgetsToImage(
                    controller: imageController,
                    child: PreivewWidget(
                      textStyle: selectedFont,
                      textColor: textColor,
                      backgroundColor: backgroundColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> fontTypeDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            shadowColor: Colors.purple,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                //  width: double.minPositive,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Select a Font for Your CV'),
                    5.verticalSpace,
                    const Divider(),
                    Wrap(
                      spacing: 3,
                      runSpacing: 3,
                      children: fontType.map((TextStyle font) {
                        return TextButton(
                          onPressed: () {
                            setState(() {
                              selectedFont = font;
                            });
                          },
                          child: Text(
                            '${font.fontFamily!.split('_')[0]} font',
                            style: font, // Apply the font style here
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  Future<dynamic> colorDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            shadowColor: Colors.purple,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                //  width: double.minPositive,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Select Text and Background Colors'),
                    const Divider(),
                    5.verticalSpace,
                    const Text('Select a Color for Text'),
                    12.verticalSpace,
                    MaterialColorPicker(
                        onColorChange: (Color color) {
                          setState(() {
                            textColor = color;
                          });
                        },
                        selectedColor: Colors.red),
                    const Divider(),
                    5.verticalSpace,
                    const Text('Select a Background Shade'),
                    12.verticalSpace,
                    MaterialColorPicker(
                        onColorChange: (Color color) {
                          setState(() {
                            backgroundColor = color;
                          });
                        },
                        selectedColor: Colors.red),
                  ],
                ),
              ),
            ));
      },
    );
  }

  Future<void> _exportAsImage() async {
    try {
      final RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      if (boundary.debugNeedsPaint) {
        await Future.delayed(const Duration(milliseconds: 20));
        return _exportAsImage();
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 8.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List imageBytes = byteData!.buffer.asUint8List();

      setState(() {
        _cvImage = imageBytes;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error exporting image: $e")),
      );
    }
  }

  Future<void> _downloadImage() async {
    final blob = html.Blob([bytes]);

    // إنشاء URL للـ blob
    final url = html.Url.createObjectUrlFromBlob(blob);

    // إنشاء عنصر a للتنزيل
    final anchor = html.AnchorElement()
      ..href = url
      ..download = 'resume.png' // اسم الملف عند التنزيل
      ..style.display = 'none';

    // إضافة العنصر للصفحة
    html.document.body?.children.add(anchor);

    // تشغيل النقر تلقائياً
    anchor.click();

    // إزالة العنصر
    anchor.remove();

    // تحرير URL
    html.Url.revokeObjectUrl(url);
  }
}
