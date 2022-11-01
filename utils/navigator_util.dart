import 'package:flutter/material.dart';

class NavigatorUtil {
  const NavigatorUtil._();

  // 回到首页
  static void replaceHome(BuildContext context) {
    Navigator.popUntil(context, (route) => route.settings.name == "/home");
    Navigator.popAndPushNamed(context, "/home");
  }

  // 跳转到某页
  static Future to(BuildContext context, Widget router) async {
    return await Navigator.push(context, MaterialPageRoute(builder: (_) => router));
  }
}
