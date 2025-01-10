import 'package:dot_cv_creator/providers/statenotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//final cvProvider =
//    StateNotifierProvider<CvNotifier, CvModal>((ref) => CvNotifier());

class CvPreivewPage extends ConsumerWidget {
  const CvPreivewPage(
      {super.key,
      required this.textStyle,
      required this.color,
      required this.backgroundColor});

  final TextStyle textStyle;
  final Color color; //
  final Color backgroundColor; // لون الخلفية

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cv = ref.watch(cvProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(cv.name),
      ),
    );
  }
}
