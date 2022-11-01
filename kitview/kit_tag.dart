import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/math_util.dart';

abstract class KitTag extends StatelessWidget {
  const KitTag({Key? key}) : super(key: key);
}

/// 颜色标签
class KitColorTag extends KitTag {
  const KitColorTag({
    Key? key,
    required this.tag,
    this.style,
    this.backgroundColor,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.shape = BoxShape.rectangle,
    this.border,
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
  }) : super(key: key);

  final String tag;
  final TextStyle? style;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BoxShape shape;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // 默认字体样式
    final _defaultStyle = style ??
        textTheme.caption?.copyWith(
          color: backgroundColor == Colors.transparent ? textTheme.caption?.color : Colors.white,
        );
    final _defaultBackgroundColor = Colors.primaries[MathUtil.randInt(Colors.primaries.length)];

    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        shape: shape,
        border: border ?? Border.all(color: _defaultBackgroundColor, width: 1),
        color: backgroundColor ?? _defaultBackgroundColor,
        borderRadius: borderRadius,
      ),
      child: Text(tag, style: _defaultStyle),
    );
  }
}

/// 标签视图
typedef KitTagSelectedCallback = void Function(int index);
typedef KitTagBuilder = KitTag Function(int index);

class KitTagView extends StatelessWidget {
  const KitTagView({
    Key? key,
    required this.children,
    this.onSelected,
    this.onLongSelected,
    this.horizontalSpace = 6.0,
    this.verticalSpace = 4.0,
  }) : super(key: key);

  final List<KitTag> children;
  final KitTagSelectedCallback? onSelected;
  final KitTagSelectedCallback? onLongSelected;
  final double horizontalSpace;
  final double verticalSpace;

  KitTagView.build({
    Key? key,
    required int count,
    required KitTagBuilder builder,
    this.onSelected,
    this.onLongSelected,
    this.horizontalSpace = 6.0,
    this.verticalSpace = 4.0,
  })  : children = List.generate(count, (index) => builder(index)),
        super(key: key);

  Widget _outerContainer(Widget child, [VoidCallback? onTap, VoidCallback? onLongPress]) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: horizontalSpace / 2,
          vertical: verticalSpace / 2,
        ),
        child: child,
      ),
    );
  }

  List<Widget> get _buildChildren {
    // 添加手势、添加间距
    var newChildren = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      newChildren.add(
        _outerContainer(
          children[i],
          () => onSelected != null ? onSelected!(i) : null,
          () => onLongSelected != null ? onLongSelected!(i) : null,
        ),
      );
    }
    return newChildren;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: _buildChildren,
    );
  }
}

/// 文本标签
class KitTextTag extends StatefulWidget {
  const KitTextTag({
    Key? key,
    required this.tags,
    this.prefixText = "#",
    this.helperText = "无标签文本提示.",
    this.onHelperTap,
    this.gapText = ",\t",
    this.gapSpacing = 4.0,
    this.gapColor,
    this.onSelected,
    this.onLongSelected,
    this.selectedColor,
    this.style,
    this.lineHeight = 1.8,
  }) : super(key: key);

  final List<String> tags;
  final String prefixText;
  final String helperText;
  final VoidCallback? onHelperTap;
  final String gapText;
  final double gapSpacing;
  final Color? gapColor;
  final KitTagSelectedCallback? onSelected;
  final KitTagSelectedCallback? onLongSelected;
  final Color? selectedColor;
  final TextStyle? style;
  final double lineHeight;

  @override
  State<KitTextTag> createState() => _KitTextTagState();
}

class _KitTextTagState extends State<KitTextTag> {
  bool _onPressed = false;
  int _onPressedIndex = -1;
  Timer? _onLongPressedTimer;
  bool _longPressedSuccess = false;

  // 按下监听
  void _onPressedHandler(bool pressed, int index) {
    _onPressed = pressed;
    _onPressedIndex = index;
    setState(() {});
  }

  @override
  void dispose() {
    _onLongPressedTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Text.rich(
      _buildTextSpan(themeData),
      style: widget.style ?? themeData.textTheme.bodyText2,
    );
  }

  TapGestureRecognizer _recognizer(int index) {
    return TapGestureRecognizer()
      ..onTap = () {
        // 回调单击事件, 如果单击事件存在 并且 长按事件未被响应
        if (widget.onSelected != null && !_longPressedSuccess) {
          SystemSound.play(SystemSoundType.click); // 播放单击声
          widget.onSelected!(index);
        }
        _longPressedSuccess = false; // 事件结束, 重置长按事件
      }
      ..onTapDown = (details) {
        _onPressedHandler(true, index);
        _onLongPressedTimer = Timer(const Duration(milliseconds: 500), () {
          _longPressedSuccess = true; // 成功响应长按事件
          HapticFeedback.vibrate(); // 震动反馈
          // 回调长按事件, 如果长按事件存在
          if (widget.onLongSelected != null) {
            widget.onLongSelected!(index);
          }
        });
      }
      ..onTapUp = (details) {
        _onPressedHandler(false, -1);
        _onLongPressedTimer?.cancel();
      }
      ..onTapCancel = () {
        _onPressedHandler(false, -1);
        _onLongPressedTimer?.cancel();
      };
  }

  /// 间隔文本
  TextSpan _gapTextSpan(ThemeData data) {
    return TextSpan(
      text: widget.gapText,
      style: (widget.style ?? data.textTheme.bodyText2)?.copyWith(
        color: widget.gapColor ?? data.textTheme.bodyText2?.color?.withOpacity(0.5),
        letterSpacing: widget.gapSpacing,
      ),
    );
  }

  /// 标签文本
  TextSpan _tagTextSpan(int index, String tag, ThemeData data) {
    return TextSpan(
      text: "${widget.prefixText}$tag",
      recognizer: _recognizer(index),
      style: (widget.style ?? data.textTheme.bodyText2)?.copyWith(
        color: (_onPressed && _onPressedIndex == index) && (widget.onSelected != null)
            ? (widget.selectedColor ?? data.primaryColor.withOpacity(0.5))
            : data.primaryColor,
        height: widget.lineHeight,
      ),
    );
  }

  /// 构建tag文本组
  TextSpan _buildTextSpan(ThemeData data) {
    // 如果标签为空, 则构建一个提示信息。
    if (widget.tags.isEmpty) {
      return TextSpan(
        text: widget.helperText,
        style: data.textTheme.bodyText2?.copyWith(
          color: data.textTheme.bodyText2?.color?.withOpacity(0.5),
          height: widget.lineHeight,
        ),
        recognizer: TapGestureRecognizer()..onTap = widget.onHelperTap,
      );
    }

    var textSpans = <TextSpan>[];
    for (var i = 0; i < widget.tags.length; i++) {
      textSpans.add(_tagTextSpan(i, widget.tags[i], data));
      if (i == widget.tags.length - 1) continue;
      textSpans.add(_gapTextSpan(data));
    }
    textSpans.add(const TextSpan(text: " ")); // 末尾添加一个空字符, 避免过长点击
    return TextSpan(children: textSpans);
  }
}
