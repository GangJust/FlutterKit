import 'package:flutter/cupertino.dart';

class RenderUtil {
  const RenderUtil._();

  static RenderBox? renderBox(BuildContext context) => context.findRenderObject() as RenderBox?;

  static Offset? getOffset(BuildContext context) {
    return renderBox(context)?.localToGlobal(Offset.zero);
  }

  static Size? getSize(BuildContext context) {
    return renderBox(context)?.size;
  }
}
