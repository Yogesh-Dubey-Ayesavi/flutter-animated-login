import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/login_theme.dart';
import '../responsiveness/dynamic_size.dart';
import '../widgets/icons/base_icon.dart';
import 'text_styles.dart';

/// [InputDeco] class collects all input decorations in one file.
class InputDeco {
  /// Initializes dynamicSize and theme fields after got the context.
  InputDeco(this.context) {
    dynamicSize = DynamicSize(context);
  }
  final BuildContext context;
  late final DynamicSize dynamicSize;

  /// [InputDecoration] for the text form fields in the login screen.
  /// Both "CustomTextFormField" and "ObscuredTextFormField" uses this deco.
  InputDecoration loginDeco({
    String? hintText,
    String? labelText,
    double? paddingFactor,
    IconData? prefixIcon,
    Widget? prefixWidget,
  }) {
    final LoginTheme loginTheme = context.read<LoginTheme>();
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(
        vertical: dynamicSize.height * (loginTheme.isLandscape ? 3.3 : 3),
      ).copyWith(
        right: dynamicSize.width *
            (paddingFactor ?? (loginTheme.isLandscape ? 1 : 3)),
        left: dynamicSize.width * (loginTheme.isLandscape ? 1 : 2.5),
      ),
      fillColor: loginTheme.formFieldBackgroundColor ??
          loginTheme.backgroundColor?.withOpacity(.8) ??
          Colors.white54,
      hoverColor: loginTheme.formFieldHoverColor ??
          Theme.of(context).primaryColorLight.withOpacity(.1),
      hintText: hintText,
      hintStyle:
          TextStyles(context).hintTextStyle().merge(loginTheme.hintTextStyle),
      labelText: loginTheme.isLandscape
          ? loginTheme.showLabelTexts
              ? hintText
              : null
          : null,
      labelStyle:
          TextStyles(context).hintTextStyle().merge(loginTheme.hintTextStyle),
      errorMaxLines: 1,
      errorStyle:
          TextStyles(context).errorTextStyle().merge(loginTheme.errorTextStyle),
      enabledBorder: loginTheme.enabledBorder ??
          _getOutlineBorder(
              loginTheme.enabledBorderColor, loginTheme.isLandscape,
              widthFactor: .4),
      focusedBorder: loginTheme.focusedBorder ??
          _getOutlineBorder(
              loginTheme.focusedBorderColor, loginTheme.isLandscape),
      focusedErrorBorder: loginTheme.focusedErrorBorder ??
          _getOutlineBorder(
              loginTheme.focusedErrorBorderColor, loginTheme.isLandscape),
      errorBorder: loginTheme.errorBorder ??
          _getOutlineBorder(
              loginTheme.errorBorderColor ?? Colors.red, loginTheme.isLandscape,
              widthFactor: .4),
      prefixIcon:
          prefixWidget ?? getPrefixIcon(prefixIcon, loginTheme.isLandscape),
      filled: true,
    );
  }

  /// Returns the prefix icon if there is any provided.
  Widget? getPrefixIcon(IconData? prefixIcon, bool isLandscape) {
    final bool isLandscape = context.read<LoginTheme>().isLandscape;
    return prefixIcon == null
        ? null
        : Padding(
            padding: EdgeInsets.only(
              left: dynamicSize.width * (isLandscape ? .6 : 2.6),
              right: isLandscape ? 0 : dynamicSize.width * 1.6,
            ),
            child: BaseIcon(prefixIcon, sizeFactor: 7),
          );
  }

  /// Default function returns [OutlineInputBorder] with some common values.
  /// Takes [color] and [widthFactor] as parameters to specialize each border.
  OutlineInputBorder _getOutlineBorder(Color? color, bool isLandscape,
          {double widthFactor = .62}) =>
      OutlineInputBorder(
        borderRadius: context.read<LoginTheme>().formFieldBorderRadius ??
            const BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(
          width: DynamicSize(context).responsiveSize * widthFactor,
          color: color ??
              (isLandscape
                  ? Theme.of(context).primaryColorLight
                  : Colors.white),
        ),
      );
}