import 'package:flutter/material.dart';

/// 按钮
class KitButton extends StatefulWidget {
  const KitButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.style,
    this.alignment,
    this.margin,
    this.padding,
    this.onDoubleTap,
    this.onLongPress,
    this.onTapDown,
    this.onTapCancel,
    this.onHighlightChanged,
    this.onFocusChange,
    this.onHover,
    bool? ink,
    this.disabled = false,
    this.borderRadius = const BorderRadius.all(Radius.circular(6.0)),
    this.shadowColor,
    this.elevation = 4.0,
    this.backgroundColor,
    this.inkColor = Colors.white24,
    this.shadowAnimationDuration = const Duration(milliseconds: 100),
  })  : ink = ink ?? true,
        super(key: key);

  final Widget? child;
  final TextStyle? style;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final GestureTapCallback? onPressed;
  final GestureTapCallback? onDoubleTap;
  final GestureLongPressCallback? onLongPress;
  final GestureTapDownCallback? onTapDown;
  final GestureTapCancelCallback? onTapCancel;
  final ValueChanged<bool>? onHighlightChanged;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final bool ink;
  final bool disabled;
  final BorderRadius? borderRadius;
  final Color? shadowColor;
  final double elevation;
  final Color? backgroundColor;
  final Color? inkColor;
  final Duration shadowAnimationDuration;

  @override
  _KitButtonState createState() => _KitButtonState();
}

class _KitButtonState extends State<KitButton> with SingleTickerProviderStateMixin {
  late AnimationController _shadowController;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _shadowController = AnimationController(vsync: this, duration: widget.shadowAnimationDuration);
    _shadowAnimation = Tween(begin: widget.elevation, end: widget.elevation * 2).animate(_shadowController);
    _shadowController.addListener(_shadowListener);
  }

  @override
  void dispose() {
    _shadowController.removeListener(_shadowListener);
    _shadowController.dispose();
    super.dispose();
  }

  void _shadowListener() {
    setState(() {});
  }

  void _onHighlightChanged(b) {
    if (!widget.ink) return; // 没有水波纹则不执行动画
    b ? _shadowController.forward() : _shadowController.reverse();
    if (widget.onHighlightChanged != null) widget.onHighlightChanged!(b);
  }

  // 默认图标样式
  IconThemeData get _defaultIconThemeData {
    final ThemeData theme = Theme.of(context);
    IconThemeData data = theme.iconTheme;
    data = data.copyWith(color: theme.iconTheme.color);
    if (widget.disabled) data = data.copyWith(color: theme.disabledColor);
    return data;
  }

  // 默认文本样式
  TextStyle get _defTextStyle {
    final ThemeData theme = Theme.of(context);
    TextStyle style = theme.textTheme.bodyText2 ?? const TextStyle();
    style = style.copyWith(color: theme.buttonTheme.colorScheme?.outline);

    return style;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 4.0),
      child: Material(
        color: widget.backgroundColor ?? Theme.of(context).buttonTheme.colorScheme?.primary,
        borderRadius: widget.borderRadius,
        elevation: !widget.ink ? 0 : _shadowAnimation.value,
        shadowColor: !widget.ink ? Colors.transparent : widget.shadowColor,
        child: IgnorePointer(
          ignoring: widget.disabled,
          child: InkWell(
            onTap: widget.onPressed,
            onDoubleTap: widget.onDoubleTap,
            onLongPress: widget.onLongPress,
            onTapDown: widget.onTapDown,
            onTapCancel: widget.onTapCancel,
            onHighlightChanged: _onHighlightChanged,
            onHover: widget.onHover,
            splashColor: !widget.ink ? Colors.transparent : widget.inkColor,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            borderRadius: widget.borderRadius,
            onFocusChange: null,
            child: IconTheme(
              data: _defaultIconThemeData,
              child: DefaultTextStyle(
                style: widget.style ?? _defTextStyle,
                child: Container(
                  alignment: widget.alignment,
                  padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
