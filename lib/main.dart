import 'package:dot_cv_creator/layouts/form_page.dart';
import 'package:dot_cv_creator/layouts/home_page.dart';
import 'package:dot_cv_creator/layouts/preivew_page.dart';
import 'package:flutter/material.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Flexify(
      designWidth: 375,
      designHeight: 812,
      app: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dot CV Creator!',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/form',
        routes: {
          '/': (context) => const HomePage(),
          '/form': (context) => const FormPage(),
          //'/preview': (context) => const CvPreivewPage(),
        },
      ),
    );
  }
}
