import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/animated_dialog_theme.dart';
import '../../../providers/login_theme.dart';
import '../../../responsiveness/dynamic_size.dart';
import 'base_dialog.dart';

class PlatformDialog with BaseDialog {
  /// Mobile specific alert dialog.
  const PlatformDialog({
    this.contentText,
    this.actionText,
    this.willPop = true,
    this.isDismissible = true,
    this.action,
    this.content,
    this.title,
    this.contentPaddingFactor = 3,
  });

  final String? contentText;
  final bool willPop;
  final bool isDismissible;
  final Widget? content;
  final Widget? title;
  final AsyncCallback? action;
  final double contentPaddingFactor;
  final String? actionText;

  Widget build(BuildContext context) =>
      Platform.isIOS ? _iosDialog(context) : _androidDialog(context);

  Widget _iosDialog(BuildContext context) => CupertinoAlertDialog(
        title: title,
        content: _getContent(context),
        actions: _getButtons(context, isIOS: true),
      );

  Widget _androidDialog(BuildContext context) {
    final AnimatedDialogTheme dialogTheme =
        context.read<LoginTheme>().dialogTheme ?? const AnimatedDialogTheme();
    return AlertDialog(
      shape: dialogTheme.shape ??
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: dialogTheme.elevation ?? 5,
      backgroundColor:
          dialogTheme.backgroundColor ?? Colors.white.withOpacity(.9),
      title: title,
      content: Padding(
        padding: dialogTheme.contentPadding ??
            EdgeInsets.all(
                DynamicSize(context).responsiveSize * contentPaddingFactor),
        child: _getContent(context),
      ),
      actions: _getButtons(context),
    );
  }

  Widget _getContent(BuildContext context) =>
      getContent(context, contentText: contentText, content: content);

  List<Widget> _getButtons(BuildContext context, {bool isIOS = false}) =>
      getButtons(
        context,
        action: action,
        actionText: actionText,
        willPop: willPop,
        isIOS: isIOS,
      );
}
