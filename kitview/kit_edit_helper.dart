import 'package:flutter/material.dart';

/// 默认 [InputDecoration]
InputDecoration kitInputDecoration({int? maxLines, double height = 40.0}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    border: const OutlineInputBorder(borderSide: BorderSide.none),
    focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
    alignLabelWithHint: true,
    constraints: BoxConstraints(
      maxHeight: maxLines == null || maxLines == 1 ? height : double.infinity,
      minHeight: height,
    ),
  );
}
