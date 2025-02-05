import 'package:dot_cv_creator/layouts/cv_preivew_page.dart';
import 'package:dot_cv_creator/layouts/warper.dart';
import 'package:dot_cv_creator/layouts/from_widget.dart';
import 'package:dot_cv_creator/layouts/home_page.dart';
import 'package:dot_cv_creator/layouts/preivew_widget.dart';
import 'package:dot_cv_creator/save/export_page.dart';
import 'package:flutter/material.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'providers/locale_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(languageProvider);
    return Flexify(
      designWidth: 375,
      designHeight: 812,
      app: MaterialApp(
        debugShowCheckedModeBanner: false,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        locale: currentLanguage == AppLanguage.english
            ? const Locale('en')
            : const Locale('ar'),
        title: 'Dot CV Creator!',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/form': (context) => const FromWidget(),
          '/warp': (context) => const Warper(),
          '/preivew': (context) => const PreivewWidget(
                textStyle: TextStyle(),
                textColor: Colors.black87,
                backgroundColor: Colors.white70,
              ),
          '/preivew_screen': (context) => CvPreivewPage(
                textStyle: GoogleFonts.tajawal(),
                color: Colors.black87,
                backgroundColor: Colors.white70,
              ),
          '/export': (context) => const ExportPage(),
        },
      ),
    );
  }
}
