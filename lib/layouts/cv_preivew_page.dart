import 'package:dot_cv_creator/layouts/preivew_widget.dart';
import 'package:dot_cv_creator/save/export_page.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';

class CvPreivewPage extends StatelessWidget {
  const CvPreivewPage({
    super.key,
    required this.textStyle,
    required this.color,
    required this.backgroundColor,
  });
  final TextStyle textStyle;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          OutlinedButton(
              onPressed: () async {
                Flexify.go(
                  const ExportPage(),
                );
              },
              child: const Text('Save'))
        ],
      ),
      body: PreivewWidget(
        textStyle: textStyle,
        textColor: color,
        backgroundColor: backgroundColor,
      
      ),
    );
  }
}
