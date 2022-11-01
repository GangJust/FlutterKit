import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/math_util.dart';

Future showKitDialog({
  required BuildContext context,
  required Widget dialog,
  bool barrierDismissible = false,
  String? barrierLabel = "kitDialog",
  Color barrierColor = const Color(0x80000000),
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Duration duration = const Duration(milliseconds: 200),
  RouteTransitionsBuilder transitionsBuilder = defaultDialogAnimation,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    barrierColor: barrierColor,
    pageBuilder: (ctx, anim1, anim2) => dialog,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    transitionDuration: duration,
    transitionBuilder: (ctx, anim1, anim2, child) => transitionsBuilder(context, anim1, anim2, child),
  );
}

/// 需要getx，若未依赖getx，请注释掉该方法
Future showGetKitDialog({
  required Widget dialog,
  bool barrierDismissible = false,
  String? barrierLabel = "kitDialog",
  Color barrierColor = const Color(0x80000000),
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Duration duration = const Duration(milliseconds: 200),
  RouteTransitionsBuilder transitionsBuilder = defaultDialogAnimation,
}) {
  return Get.generalDialog(
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    barrierColor: barrierColor,
    pageBuilder: (ctx, anim1, anim2) => dialog,
    routeSettings: routeSettings,
    transitionDuration: duration,
    transitionBuilder: (ctx, anim1, anim2, child) => transitionsBuilder(ctx, anim1, anim2, child),
  );
}

/// 从目标缩放展示dialog
/// 特别注意的是 context 不能使用 [RouteTransitionsBuilder] 提供的 context
/// 需要使用响应目标的 context 若使用 [RouteTransitionsBuilder] 提供的 context
/// 则从屏幕中心开始
Widget targetScaleDialogAnimation(BuildContext context, Animation<double> anim1, Animation<double> anim2, Widget child) {
  final media = MediaQuery.of(context);

  RenderBox? renderBox = context.findRenderObject() as RenderBox?; // 控件对象
  Offset objOffset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero; // 控件位置
  Size objSize = renderBox?.size ?? Size.zero; // 控件大小
  Offset centerOffset = Offset(media.size.width / 2, media.size.height / 2); // 屏幕中心
  // dialog居中显示(即屏幕中央为Offset(0,0)), 由控件位置减去屏幕中心即可大致得到 dialog 的相对位置
  Offset offset = objOffset - centerOffset;
  // 以下做法可以获得目标控件中心位置
  offset = Offset(offset.dx + objSize.width / 2, offset.dy + objSize.height / 2);

  return Transform.translate(
    offset: Tween<Offset>(begin: offset, end: Offset.zero).animate(anim1).value,
    child: Transform.scale(
      scale: anim1.value,
      child: child,
    ),
  );
}

/// 从目标缩放旋转展示dialog
/// 特别注意的是 context 不能使用 [RouteTransitionsBuilder] 提供的 context
/// 需要使用响应目标的 context 若使用 [RouteTransitionsBuilder] 提供的 context
/// 则从屏幕中心开始
Widget targetRotateDialogAnimation(BuildContext context, Animation<double> anim1, Animation<double> anim2, Widget child) {
  // 随机顺/逆时针旋转
  var randRotate = math.Random().nextInt(360) % 36 == 0 ? 360 : -360;
  return targetScaleDialogAnimation(
    context,
    anim1,
    anim2,
    Transform.rotate(
      angle: MathUtil.angleToRadian(anim1.value * randRotate),
      child: child,
    ),
  );
}

/// 底部向上显示dialog
Widget bottomTransformDialogAnimation(BuildContext context, Animation<double> anim1, Animation<double> anim2, Widget child) {
  final media = MediaQuery.of(context);

  return Transform.translate(
    offset: Tween<Offset>(begin: Offset(0, media.size.height), end: Offset.zero).animate(anim1).value,
    child: child,
  );
}

/// 顶部向下显示dialog
Widget topTransformDialogAnimation(BuildContext context, Animation<double> anim1, Animation<double> anim2, Widget child) {
  final media = MediaQuery.of(context);

  return Transform.translate(
    offset: Tween<Offset>(begin: Offset(0, -media.size.height), end: Offset.zero).animate(anim1).value,
    child: child,
  );
}

/// 左边向右显示dialog
Widget leftTransformDialogAnimation(BuildContext context, Animation<double> anim1, Animation<double> anim2, Widget child) {
  final media = MediaQuery.of(context);

  return Transform.translate(
    offset: Tween<Offset>(begin: Offset(-media.size.width, 0), end: Offset.zero).animate(anim1).value,
    child: child,
  );
}

/// 右边向左显示dialog
Widget rightTransformDialogAnimation(BuildContext context, Animation<double> anim1, Animation<double> anim2, Widget child) {
  final media = MediaQuery.of(context);

  return Transform.translate(
    offset: Tween<Offset>(begin: Offset(media.size.width, 0), end: Offset.zero).animate(anim1).value,
    child: child,
  );
}

/// 横向张开
Widget horizontalDialogAnimation(BuildContext context, Animation<double> anim1, Animation<double> anim2, Widget child) {
  return Transform.scale(
    scaleX: anim1.value,
    child: child,
  );
}

/// 垂直张开
Widget verticalDialogAnimation(BuildContext context, Animation<double> anim1, Animation<double> anim2, Widget child) {
  return Transform.scale(
    scaleY: anim1.value,
    child: child,
  );
}

/// 默认dialog显示
Widget defaultDialogAnimation(BuildContext context, Animation<double> anim1, Animation<double> anim2, Widget child) {
  return Transform.scale(
    scale: anim1.value,
    child: child,
  );
}

class KitDialog extends StatelessWidget {
  final Widget? title;
  final EdgeInsets titlePadding;
  final Widget? subtitle;
  final EdgeInsets subtitlePadding;
  final Widget? content;
  final EdgeInsets contentPadding;
  final Widget? cancel;
  final Widget? confirm;
  final EdgeInsets bottomButtonWidgetPadding;
  final GestureTapCallback? cancelCallBack;
  final GestureTapCallback? confirmCallBack;
  final Radius radius;
  final bool showButtonsBorder;
  final bool reverseColor;
  final EdgeInsets insetPadding;

  const KitDialog({
    Key? key,
    this.title,
    EdgeInsets? titlePadding,
    this.subtitle,
    EdgeInsets? subtitlePadding,
    this.content,
    EdgeInsets? contentPadding,
    this.cancel,
    this.confirm,
    EdgeInsets? bottomButtonWidgetPadding,
    this.cancelCallBack,
    this.confirmCallBack,
    Radius? radius,
    bool? showButtonsBorder,
    bool? reverseColor,
    EdgeInsets? insetPadding,
  })  : titlePadding = titlePadding ?? const EdgeInsets.only(top: 8.0),
        subtitlePadding = subtitlePadding ?? EdgeInsets.zero,
        contentPadding = contentPadding ?? const EdgeInsets.all(12.0),
        bottomButtonWidgetPadding = bottomButtonWidgetPadding ?? const EdgeInsets.all(8.0),
        radius = radius ?? const Radius.circular(8.0),
        showButtonsBorder = showButtonsBorder ?? false,
        reverseColor = reverseColor ?? false,
        insetPadding = insetPadding ?? const EdgeInsets.symmetric(horizontal: 64.0, vertical: 24.0),
        super(key: key);

  Widget _buildTitleWidget(ThemeData themeData) {
    if (title == null) return const SizedBox(width: 0, height: 0);

    return Container(
      padding: titlePadding,
      child: Material(
        color: themeData.cardColor,
        textStyle: themeData.textTheme.titleMedium,
        child: title,
      ),
    );
  }

  Widget _buildSubtitleWidget(ThemeData themeData) {
    if (subtitle == null) return const SizedBox(width: 0, height: 0);

    return Container(
      padding: subtitlePadding,
      child: Material(
        color: themeData.cardColor,
        textStyle: themeData.textTheme.caption,
        child: subtitle,
      ),
    );
  }

  Widget _buildContentWidget(ThemeData themeData) {
    if (content == null) return const SizedBox(width: 0, height: 0);

    return Container(
      padding: contentPadding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      child: content,
    );
  }

  Widget _buildCancelWidget(ThemeData themeData) {
    var textStyle = reverseColor
        ? themeData.textTheme.button?.copyWith(color: themeData.textTheme.bodyText2?.color)
        : themeData.textTheme.button?.copyWith(color: themeData.colorScheme.secondary);
    var borderRadius = BorderRadius.only(bottomLeft: radius);
    var border = showButtonsBorder ? Border(top: BorderSide(color: themeData.dividerColor, width: 0.2)) : Border();
    if (confirm == null) {
      textStyle = themeData.textTheme.button?.copyWith(color: themeData.colorScheme.secondary);
      borderRadius = BorderRadius.only(bottomLeft: radius, bottomRight: radius);
    }

    return Material(
      color: themeData.cardColor,
      borderRadius: borderRadius,
      textStyle: textStyle,
      child: InkWell(
        borderRadius: borderRadius,
        child: Container(
          alignment: Alignment.center,
          padding: bottomButtonWidgetPadding,
          decoration: BoxDecoration(border: border),
          child: cancel,
        ),
        onTap: cancelCallBack,
      ),
    );
  }

  Widget _buildConfirmWidget(ThemeData themeData) {
    var textStyle = !reverseColor
        ? themeData.textTheme.button?.copyWith(color: themeData.textTheme.bodyText2?.color)
        : themeData.textTheme.button?.copyWith(color: themeData.colorScheme.secondary);
    var _borderRadius = BorderRadius.only(bottomRight: radius);
    var _border = showButtonsBorder ? Border(top: BorderSide(color: themeData.dividerColor, width: 0.2)) : Border();
    if (cancel == null) {
      textStyle = themeData.textTheme.button?.copyWith(color: themeData.colorScheme.secondary);
      _borderRadius = BorderRadius.only(bottomRight: radius, bottomLeft: radius);
    }

    return Material(
      color: themeData.cardColor,
      borderRadius: _borderRadius,
      textStyle: textStyle,
      child: InkWell(
        borderRadius: _borderRadius,
        child: Container(
          alignment: Alignment.center,
          padding: bottomButtonWidgetPadding,
          decoration: BoxDecoration(border: _border),
          child: confirm,
        ),
        onTap: confirmCallBack,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: insetPadding,
      child: Material(
        color: themeData.cardColor,
        borderRadius: BorderRadius.all(radius),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitleWidget(themeData),
            _buildSubtitleWidget(themeData),
            _buildContentWidget(themeData),
            Row(
              children: [
                cancel == null ? const SizedBox(width: 0) : Expanded(child: _buildCancelWidget(themeData)),
                confirm == null ? const SizedBox(width: 0) : Expanded(child: _buildConfirmWidget(themeData)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
