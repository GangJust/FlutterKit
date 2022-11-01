import 'package:flutter/material.dart';

class KitToggle extends StatefulWidget {
  const KitToggle({
    Key? key,
    required this.firstChild,
    this.secondChild,
    this.toggle = false,
  }) : super(key: key);

  final Widget firstChild;
  final Widget? secondChild;
  final bool toggle;

  @override
  State<KitToggle> createState() => _KitToggleState();
}

class _KitToggleState extends State<KitToggle> {
  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      alignment: Alignment.center,
      firstChild: widget.firstChild,
      secondChild: widget.secondChild ?? const SizedBox(),
      crossFadeState: widget.toggle ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 200),
    );
  }
}
