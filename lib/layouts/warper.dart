import 'package:dot_cv_creator/layouts/from_widget.dart';
import 'package:dot_cv_creator/layouts/preivew_widget.dart';
import 'package:dot_cv_creator/save/export.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Warper extends StatelessWidget {
  const Warper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.warper__title),
        actions: [
          TextButton(
              onPressed: () {
                Flexify.go(
                  const ExportPage(),
                );
              },
              child: Text(AppLocalizations.of(context)!
                  .warper__view_and_download_your_cv_btn))
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
