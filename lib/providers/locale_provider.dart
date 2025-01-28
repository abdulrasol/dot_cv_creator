import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui' as ui; //

// قائمة اللغات المدعومة
enum AppLanguage { english, arabic }

// Provider لإدارة حالة اللغة
final languageProvider = StateProvider<AppLanguage>(
  (ref) => ui.PlatformDispatcher.instance.locale.languageCode == 'en'
      ? AppLanguage.english
      : AppLanguage.arabic,
);
