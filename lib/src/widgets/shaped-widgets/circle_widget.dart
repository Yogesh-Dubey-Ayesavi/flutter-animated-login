import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/login_theme.dart';
import '../../responsiveness/dynamic_size.dart';

/// Provides a circle button with custom stylings.
/// Shapes the button as circle with the given height/width.
class CircleWidget extends StatelessWidget {
  const CircleWidget({
    required this.child,
    this.widthFactor = 13,
    this.borderWidthFactor,
    this.onTap,
    this.color,
    Key? key,
  }) : super(key: key);
  final Widget child;
  final double widthFactor;
  final Function()? onTap;
  final double? borderWidthFactor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final DynamicSize dynamicSize = DynamicSize(context);
    return SizedBox(
      width: dynamicSize.responsiveSize * widthFactor,
      height: dynamicSize.responsiveSize * widthFactor,
      child: RawMaterialButton(
        onPressed: onTap,
        hoverColor: context.read<LoginTheme>().socialLoginHoverColor ??
            (color?.withOpacity(.7) ??
                Theme.of(context).primaryColorLight.withOpacity(.7)),
        shape: _buttonShape(context),
        padding: EdgeInsets.all(dynamicSize.responsiveSize * widthFactor / 4),
        elevation: 3,
        child: child,
      ),
    );
  }

  /// Returns the border style of the button.
  ShapeBorder _buttonShape(BuildContext context) => CircleBorder(
        side: context.read<LoginTheme>().socialLoginBorder ??
            BorderSide(
              color: color ?? Colors.black54,
              width: DynamicSize(context).width * (borderWidthFactor ?? .2),
            ),
      );
}