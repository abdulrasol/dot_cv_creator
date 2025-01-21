import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';

Widget mediaQuery(BoxConstraints boxConstraint, Widget widget) {
  if (boxConstraint.maxWidth < 480) {}
  // tablets
  if (boxConstraint.maxWidth < 768) {
    return SizedBox(width: boxConstraint.maxWidth * 0.7, child: widget);
  }
  // small laptops => 768px – 1024px
  if (boxConstraint.maxWidth < 1024) {
    return SizedBox(width: (boxConstraint.maxWidth / 2) * 0.9, child: widget);
  } else {
    return SizedBox(width: 230.rs, child: widget);
  }
}
