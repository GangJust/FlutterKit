import 'package:flutter/material.dart';

/// 清除滚动阴影的通用属性
class KitCancelShadowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    if (getPlatform(context) == TargetPlatform.android || getPlatform(context) == TargetPlatform.fuchsia) {
      return GlowingOverscrollIndicator(
        child: child,
        showLeading: false,
        showTrailing: false,
        axisDirection: axisDirection,
        color: Theme.of(context).colorScheme.secondary,
      );
    } else {
      return child;
    }
  }
}

