import 'package:flutter/material.dart';

import '../../responsiveness/dynamic_size.dart';

/// Base icon with custom parameters
/// Wraps [Icon] with [FittedBox], and gives some paddings.
class BaseIcon extends StatelessWidget {
  final IconData iconData;
  final double sizeFactor;
  final Color? color;
  final EdgeInsets? padding;
  const BaseIcon(
    this.iconData, {
    required this.sizeFactor,
    this.color,
    this.padding,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DynamicSize dynamicSize = DynamicSize(context);
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Padding(
        padding: _getPadding(context, dynamicSize),
        child: Icon(iconData,
            size: dynamicSize.responsiveSize * sizeFactor, color: color),
      ),
    );
  }

  EdgeInsets _getPadding(BuildContext context, DynamicSize dynamicSize) =>
      padding ?? EdgeInsets.symmetric(horizontal: dynamicSize.width * .8);
}