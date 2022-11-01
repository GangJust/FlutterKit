import 'package:flutter/material.dart';

/// 默认 [InputDecoration]
InputDecoration kitInputDecoration({int? maxLines}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    border: const OutlineInputBorder(borderSide: BorderSide.none),
    focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
    alignLabelWithHint: true,
    constraints: BoxConstraints(
      maxHeight: maxLines == null || maxLines == 1 ? 38.0 : double.infinity,
      minHeight: 38.0,
    ),
  );
}
