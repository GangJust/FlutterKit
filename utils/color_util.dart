import 'package:flutter/material.dart';

class ColorUtil {
  const ColorUtil._();

  /// 返回一个 MaterialColor 样式的颜色列表
  static MaterialColor mColor(Color color) {
    return MaterialColor(
      color.value,
      <int, Color>{
        50: _getColor(color.value, "66"),
        100: _getColor(color.value, "77"),
        200: _getColor(color.value, "88"),
        300: _getColor(color.value, "99"),
        400: _getColor(color.value, "AA"),
        500: _getColor(color.value, "BB"),
        600: _getColor(color.value, "CC"),
        700: _getColor(color.value, "DD"),
        800: _getColor(color.value, "EE"),
        900: _getColor(color.value, "FF"),
      },
    );
  }

  /// 对具有Color格式的字符串解析为Color
  static Color parse(String htmlColor) {
    try {
      if (htmlColor.indexOf("0x") == 0 && htmlColor.length == 10) {
        //print("htmlColor: $htmlColor, indexOf('0x'): ${htmlColor.indexOf("0x")}");
        return Color(int.parse(htmlColor));
      } else if (htmlColor.indexOf("0x") == 0 && htmlColor.length == 8) {
        //print("htmlColor: $htmlColor, indexOf('0x'): ${htmlColor.indexOf("0x")}");
        htmlColor = htmlColor.replaceFirst("0x", "");
        htmlColor = "0xFF$htmlColor";
        return Color(int.parse(htmlColor));
      } else if (htmlColor.indexOf("#") == 0 && htmlColor.length == 7) {
        //print("htmlColor: $htmlColor, indexOf('#'): ${htmlColor.indexOf("#")}");
        htmlColor = htmlColor.replaceFirst("#", "");
        htmlColor = "0xFF$htmlColor";
        return Color(int.parse(htmlColor));
      } else if (htmlColor.indexOf("#") == 0 && htmlColor.length == 9) {
        //print("htmlColor: $htmlColor, indexOf('#'): ${htmlColor.indexOf("#")}");
        htmlColor = htmlColor.replaceFirst("#", "");
        htmlColor = "0x$htmlColor";
        return Color(int.parse(htmlColor));
      }
    } catch (e) {
      throw Exception("\nColor parsing error, please check if the color code is correct! \nError message:$e");
    }

    return Colors.transparent;
  }

  static Color _getColor(int colorValue, String hexAlpha) {
    return Color(colorValue).withAlpha(int.parse(hexAlpha, radix: 16));
  }
}
