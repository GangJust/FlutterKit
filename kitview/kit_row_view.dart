import 'package:flutter/material.dart';

class KitRowView extends StatelessWidget {
  const KitRowView({
    Key? key,
    required this.firstChild,
    required this.secondChild,
    this.firstDecoration,
    this.secondDecoration,
    this.firstFlex = 1,
    this.secondFlex = 3,
    this.separate,
  }) : super(key: key);

  final Widget firstChild;
  final Widget secondChild;
  final Decoration? firstDecoration;
  final Decoration? secondDecoration;
  final int firstFlex;
  final int secondFlex;
  final Widget? separate;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: firstFlex,
          fit: FlexFit.tight,
          child: Container(
            decoration: firstDecoration,
            child: Material(
              color: Colors.transparent,
              child: firstChild,
            ),
          ),
        ),
        separate ?? const SizedBox(),
        Flexible(
          flex: secondFlex,
          fit: FlexFit.tight,
          child: Container(
            decoration: secondDecoration,
            child: Material(
              color: Colors.transparent,
              child: secondChild,
            ),
          ),
        ),
      ],
    );
  }
}
