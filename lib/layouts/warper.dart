import 'package:dot_cv_creator/layouts/from_widget.dart';
import 'package:dot_cv_creator/layouts/preivew_widget.dart';
import 'package:dot_cv_creator/save/export1.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Warper extends StatelessWidget {
  const Warper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Begin Crafting Your Professional CV'),
        actions: [
          TextButton(
              onPressed: () {
                Flexify.go(
                  const ExportPage(),
                );
              },
              child: const Text('View and Download Your CV'))
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constrains) {
          if (constrains.maxWidth < 768) {
            return const FromWidget();
          } else {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  flex: 1,
                  child: FromWidget(),
                ),
                Expanded(
                  flex: 3,
                  child: PreivewWidget(
                    textStyle: GoogleFonts.tajawal(),
                    textColor: Colors.black87,
                    backgroundColor: Colors.white70,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
