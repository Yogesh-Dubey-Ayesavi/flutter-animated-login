import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../decorations/text_styles.dart';
import '../../../models/animated_dialog_theme.dart';
import '../../../providers/login_texts.dart';
import '../../../providers/login_theme.dart';
import '../../../responsiveness/dynamic_size.dart';
import '../../texts/base_text.dart';

/// Base dialog widget for platform specific dialogs.
mixin BaseDialog {
  Widget getContent(
    BuildContext context, {
    required Widget? content,
    required String? contentText,
  }) {
    final DynamicSize dynamicSize = DynamicSize(context);
    final AnimatedDialogTheme dialogTheme =
        context.read<LoginTheme>().dialogTheme ?? const AnimatedDialogTheme();
    return content ??
        ConstrainedBox(
          constraints: dialogTheme.contentBoxConstraints ??
              BoxConstraints.loose(
                Size(dynamicSize.width * 50, dynamicSize.height * 60),
              ),
          child: Text(
            contentText ?? context.read<LoginTexts>().dialogButtonText,
            style: TextStyles(context)
                .dialogTextStyle()
                .merge(dialogTheme.contentTextStyle),
            textAlign: dialogTheme.contentTextAlign ?? TextAlign.center,
          ),
        );
  }

  List<Widget> getButtons(
    BuildContext context, {
    required String? actionText,
    required bool willPop,
    required AsyncCallback? action,
    bool isIOS = false,
  }) {
    final AnimatedDialogTheme dialogTheme =
        context.read<LoginTheme>().dialogTheme ?? const AnimatedDialogTheme();
    return <Widget>[
      if (actionText != null)
        Padding(
          padding: dialogTheme.actionsPadding ?? _getButtonPadding(context),
          child: isIOS
              ? CupertinoDialogAction(
                  onPressed: () async =>
                      _rightButtonAction(context, willPop, action),
                  child: _buttonText(
                      actionText, dialogTheme.actionTextStyle, context),
                )
              : InkWell(
                  onTap: () async =>
                      _rightButtonAction(context, willPop, action),
                  child: _buttonText(
                      actionText, dialogTheme.actionTextStyle, context),
                ),
        ),
    ];
  }

  Future<void> _rightButtonAction(
      BuildContext context, bool willPop, AsyncCallback? action) async {
    if (willPop) Navigator.of(context).pop();
    if (action != null) await action();
  }

  Widget _buttonText(String actionText, TextStyle? customTextStyle,
          BuildContext context) =>
      BaseText(actionText,
          style: TextStyles(context)
              .subtitleTextStyle(color: Theme.of(context).primaryColor)
              .merge(customTextStyle));

  EdgeInsets _getButtonPadding(BuildContext context) => EdgeInsets.only(
        right: DynamicSize(context).width * 1.2,
        bottom: DynamicSize(context).height * 1,
      );
}
