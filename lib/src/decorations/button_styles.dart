import 'package:flutter/material.dart';

/// [ButtonStyles] class collects all button styles in one file.
class ButtonStyles {
  const ButtonStyles(this.context);
  final BuildContext context;

  /// Gives rounded style to the button with the optional [borderRadius].
  /// If no radius provided, uses default value as 30 radius.
  /// Takes additional optional parameters to further customize the style.
  ButtonStyle roundedStyle({
    Color? backgroundColor,
    Color? borderColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    double? borderWidth,
    double? width,
    double? height,
  }) =>
      ButtonStyle(
        padding: _all<EdgeInsets?>(padding),
        backgroundColor: _all<Color>(backgroundColor ?? Colors.white),
        fixedSize: _all<Size>(
            Size(width ?? double.maxFinite, height ?? double.maxFinite)),
        minimumSize: _all<Size>(Size.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: _all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius:
                borderRadius ?? const BorderRadius.all(Radius.circular(30)),
            side: BorderSide(
              color: borderColor ?? Theme.of(context).primaryColor,
              width: borderWidth ?? 2.0,
            ),
          ),
        ),
      );

  /// Text button style to give it custom padding.
  ButtonStyle textButtonStyle({
    EdgeInsets? padding,
  }) =>
      ButtonStyle(padding: _all<EdgeInsets?>(padding));

  /// Returns [MaterialStateProperty] form of given [value] as [T] type.
  MaterialStateProperty<T> _all<T>(T value) => MaterialStateProperty.all(value);
}