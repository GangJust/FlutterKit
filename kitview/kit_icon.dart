import 'package:flutter/material.dart';

import '../utils/math_util.dart';
import 'kit_button.dart';

enum KitToggleIconType { first, second }

typedef OnToggleIconTypeChange = void Function(KitToggleIconType type);

/// 图标切换控件
class KitToggleIcon extends StatefulWidget {
  const KitToggleIcon({
    Key? key,
    required this.firstIcon,
    required this.secondIcon,
    this.size = 24.0,
    this.firstColor,
    this.secondColor,
    this.type = KitToggleIconType.first,
    this.onToggle,
    this.hasAnimate = 0,
    this.duration = const Duration(milliseconds: 50),
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  final IconData firstIcon;
  final IconData secondIcon;
  final double size;
  final Color? firstColor;
  final Color? secondColor;
  final KitToggleIconType? type;
  final OnToggleIconTypeChange? onToggle;

  /// 0: 不执行动画, 1: 执行缩放动画, 2: 执行旋转抖动动画
  final int hasAnimate;
  final Duration duration;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  State<KitToggleIcon> createState() => _KitToggleIconState();
}

class _KitToggleIconState extends State<KitToggleIcon> with TickerProviderStateMixin {
  late KitToggleIconType _type;
  late OnToggleIconTypeChange _onToggle;

  // 颜色动画
  late AnimationController _colorController;
  late Animation<Color?> _colorAnimation;

  // 缩放动画
  int _scaleCount = 0;
  late AnimationController _scaleController;
  late Animation<double?> _scaleAnimation;

  // 旋转抖动动画
  int _shakeCount = 0;
  late AnimationController _shakeController;
  late Animation<double?> _shakeAnimation;

  void _onChangeTap() {
    _type = _type == KitToggleIconType.second ? KitToggleIconType.first : KitToggleIconType.second;
    _startAnimation();
    _onToggle(_type);
    //setState(() {});
  }

  void _startAnimation() {
    // 默认执行颜色动画
    _type == KitToggleIconType.second ? _colorController.forward() : _colorController.reverse();

    //如果未开启动画, 以下动画不予执行
    if (widget.hasAnimate == 0) {
      return;
    } else if (widget.hasAnimate == 1) {
      _scaleCount = 0;
      _type == KitToggleIconType.second ? _scaleController.forward() : _scaleController.reverse();
    } else if (widget.hasAnimate == 2) {
      _shakeCount = 0;
      _type == KitToggleIconType.second ? _shakeController.forward() : _shakeController.reverse();
    }
  }

  void _initAnimation() {
    //
    _colorController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _colorAnimation = ColorTween(begin: widget.firstColor, end: widget.secondColor).animate(_colorController);
    _colorController.addListener(_colorAnimationListener);
    //
    _scaleController = AnimationController(vsync: this, duration: widget.duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 1.2).animate(_scaleController);
    _scaleController.addStatusListener(_scaleStatusAnimationListener);

    //
    _shakeController = AnimationController(vsync: this, duration: widget.duration);
    _shakeAnimation = Tween<double>(begin: 0, end: 30).animate(_shakeController);
    _shakeController.addStatusListener(_shakeStatusAnimationListener);
  }

  void _colorAnimationListener() {
    setState(() {});
  }

  void _scaleStatusAnimationListener(AnimationStatus status) {
    if (_scaleCount++ >= 5) {
      _scaleController.reset();
    } else if (status == AnimationStatus.completed) {
      _scaleController.reverse();
    } else if (status == AnimationStatus.dismissed) {
      _scaleController.forward();
    }
    setState(() {});
  }

  void _shakeStatusAnimationListener(AnimationStatus status) {
    if (_shakeCount++ >= 5) {
      _shakeController.reset();
    } else if (status == AnimationStatus.completed) {
      _shakeController.reverse();
    } else if (status == AnimationStatus.dismissed) {
      _shakeController.forward();
    }
    setState(() {});
  }

  void _clearAnimation() {
    //
    _colorController.removeListener(_colorAnimationListener);
    _colorController.stop();
    _colorController.dispose();
    //
    _scaleController.removeStatusListener(_scaleStatusAnimationListener);
    _scaleController.stop();
    _scaleController.dispose();
    //
    _shakeController.removeStatusListener(_shakeStatusAnimationListener);
    _shakeController.stop();
    _shakeController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _type = widget.type ?? KitToggleIconType.first;
    _onToggle = widget.onToggle ?? (type) {};

    _initAnimation();
  }

  @override
  void dispose() {
    _clearAnimation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KitButton(
      onPressed: _onChangeTap,
      backgroundColor: Colors.transparent,
      ink: false,
      margin: widget.margin,
      padding: EdgeInsets.zero,
      child: Transform.scale(
        scale: _scaleAnimation.value,
        child: Transform.rotate(
          angle: MathUtil.angleToRadian(_shakeAnimation.value ?? 0),
          child: KitIcon(
            icon: _type == KitToggleIconType.first ? widget.firstIcon : widget.secondIcon,
            color: _colorAnimation.value,
            size: widget.size,
            padding: widget.padding,
          ),
        ),
      ),
    );
  }
}

/// 图标控件
class KitIcon extends StatelessWidget {
  const KitIcon({
    Key? key,
    required this.icon,
    this.color,
    this.size = 24.0,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  final IconData icon;
  final Color? color;
  final double? size;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: Icon(
        icon,
        color: color,
        size: size,
      ),
    );
  }
}
