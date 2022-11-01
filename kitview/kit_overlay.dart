import 'package:flutter/material.dart';

import '../../utils/render_util.dart';

enum KitOverlayAlignment {
  topCenter,
  topLeft,
  topRight,
  bottomCenter,
  bottomLeft,
  bottomRight,
}

enum KitOverlayScaleType {
  scaleX,
  scaleY,
  scale,
}

class KitOverlay extends StatefulWidget {
  const KitOverlay({
    Key? key,
    required this.child,
    required this.overlaySize,
    required this.overlayChild,
    this.alignment = KitOverlayAlignment.topCenter,
    this.scaleType = KitOverlayScaleType.scale,
    this.overlayOffset = Offset.zero,
    this.elevation = 4.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
  }) : super(key: key);

  // 子控件
  final Widget child;

  // 悬浮控件大小
  final Size overlaySize;

  // 悬浮控件
  final Widget overlayChild;

  // 显示位置
  final KitOverlayAlignment alignment;

  // 缩放类型
  final KitOverlayScaleType scaleType;

  // 偏移量
  final Offset overlayOffset;

  final double elevation;

  final BorderRadius borderRadius;

  @override
  State<KitOverlay> createState() => _KitOverlayState();
}

class _KitOverlayState extends State<KitOverlay> with SingleTickerProviderStateMixin {
  // 动画控制器
  late AnimationController _controller;
  late Animation<Offset> _animation;

  // 弹层控制
  bool _onShowOverlay = false;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _controller.addListener(() {
      _overlayEntry?.markNeedsBuild(); // 通过它更新弹层内容
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _overlayEntry?.dispose();
    super.dispose();
  }

  // 路由弹出监听(返回按键)
  Future<bool> _onWillPop() async {
    if (_overlayEntry != null || _onShowOverlay) {
      _toggleColorCover();
      return false;
    }
    return true;
  }

  // 切换颜色遮罩
  void _toggleColorCover() {
    _onShowOverlay = !_onShowOverlay;
    if (_onShowOverlay) {
      _overlayEntry = _createOverlayView();
      Overlay.of(context)?.insert(_overlayEntry!);
      _controller.forward();
    } else {
      _controller.reverse().then((value) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    }
    setState(() {});
  }

  // 获取偏移位置 - 结束
  Offset _getOffset(
    Size overlaySize,
    Size objSize,
    Offset objOffset,
    Offset overlayOffset,
    KitOverlayAlignment alignment,
  ) {
    double dx;
    double dy;
    switch (alignment) {
      case KitOverlayAlignment.topCenter:
        dx = objOffset.dx + objSize.width / 2 - overlaySize.width / 2;
        dy = objOffset.dy - overlaySize.height;
        return Offset(dx, dy) - overlayOffset;
      case KitOverlayAlignment.topLeft:
        dx = objOffset.dx;
        dy = objOffset.dy - overlaySize.height;
        return Offset(dx, dy) - overlayOffset;
      case KitOverlayAlignment.topRight:
        dx = objOffset.dx + objSize.width - overlaySize.width;
        dy = objOffset.dy - overlaySize.height;
        return Offset(dx, dy) - overlayOffset;
      case KitOverlayAlignment.bottomCenter:
        dx = objOffset.dx + objSize.width / 2 - overlaySize.width / 2;
        dy = objOffset.dy + objSize.height;
        return Offset(dx, dy) + overlayOffset;
      case KitOverlayAlignment.bottomLeft:
        dx = objOffset.dx;
        dy = objOffset.dy + objSize.height;
        return Offset(dx, dy) + overlayOffset;
      case KitOverlayAlignment.bottomRight:
        dx = objOffset.dx + objSize.width - overlaySize.width;
        dy = objOffset.dy + objSize.height;
        return Offset(dx, dy) + overlayOffset;
    }
  }

  // 获取缩放位置
  Alignment _getScaleAlignment(KitOverlayAlignment alignment) {
    switch (alignment) {
      case KitOverlayAlignment.topCenter:
        return Alignment.center; // 居中显示，则从中间放大(造成一个缓缓打开的假象)
      case KitOverlayAlignment.topLeft:
        return Alignment.bottomLeft; // 左上角显示，则从左下角放大(造成一个缓缓打开的假象)
      case KitOverlayAlignment.topRight:
        return Alignment.bottomRight; // 右上角显示，则从右下角放大(造成一个缓缓打开的假象)
      case KitOverlayAlignment.bottomCenter:
        return Alignment.center; // 居中显示，则从中间放大(造成一个缓缓打开的假象)
      case KitOverlayAlignment.bottomLeft:
        return Alignment.topLeft; // 左下角显示，则从左上角放大(造成一个缓缓打开的假象)
      case KitOverlayAlignment.bottomRight:
        return Alignment.topRight; // 右下角显示，则从右上角放大(造成一个缓缓打开的假象)
    }
  }

  // 创建弹层控件
  OverlayEntry _createOverlayView() {
    Offset offset = RenderUtil.getOffset(context) ?? Offset.zero;
    Size size = RenderUtil.getSize(context) ?? Size.zero;
    Offset begin = _getOffset(widget.overlaySize, size, offset, widget.overlayOffset, widget.alignment);
    Offset end = _getOffset(widget.overlaySize, size, offset, widget.overlayOffset, widget.alignment);
    _animation = Tween<Offset>(begin: begin, end: end).animate(_controller);

    return OverlayEntry(
      builder: (_) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () => _toggleColorCover(),
              child: Container(color: Colors.transparent),
            ),
            Positioned(
              left: _animation.value.dx,
              top: _animation.value.dy,
              height: widget.overlaySize.height,
              width: widget.overlaySize.width,
              child: Transform.scale(
                scaleX: widget.scaleType == KitOverlayScaleType.scaleX ? _controller.value : null,
                scaleY: widget.scaleType == KitOverlayScaleType.scaleY ? _controller.value : null,
                scale: widget.scaleType == KitOverlayScaleType.scale ? _controller.value : null,
                alignment: _getScaleAlignment(widget.alignment),
                child: Material(
                  elevation: widget.elevation,
                  borderRadius: widget.borderRadius,
                  color: Colors.white,
                  child: widget.overlayChild,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
        onTap: _toggleColorCover,
        child: widget.child,
      ),
    );
  }
}
