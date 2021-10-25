library animated_login;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'src/constants/enums/sign_up_modes.dart';
import 'src/models/social_login.dart';
import 'src/providers/providers_shelf.dart';
import 'src/responsiveness/dynamic_size.dart';
import 'src/utils/animation_helper.dart';
import 'src/utils/view_type_helper.dart';
import 'src/widgets/form_part.dart';
import 'src/widgets/welcome_components.dart';

export './src/constants/enums/sign_up_modes.dart';
export './src/models/models_shelf.dart';
export './src/providers/providers_shelf.dart';

/// Main widget creates the animated login screen
/// Wraps the main view with providers.
class AnimatedLogin extends StatefulWidget {
  const AnimatedLogin({
    this.loginTheme,
    this.loginTexts,
    this.socialLogins,
    this.onLogin,
    this.onSignup,
    this.onForgotPassword,
    this.animationCurve = const Cubic(0.85, 0.40, 0.40, 0.85),
    this.formWidthRatio = 60,
    this.animationDuration,
    this.formKey,
    this.formElementsSpacing,
    this.socialLoginsSpacing,
    this.checkError = true,
    this.showForgotPassword = true,
    this.showChangeActionTitle = true,
    this.showPasswordVisibility = true,
    this.nameController,
    this.emailController,
    this.passwordController,
    this.confirmPasswordController,
    this.actionButtonStyle,
    this.changeActionButtonStyle,
    this.welcomeHorizontalPadding,
    this.formHorizontalPadding,
    this.backgroundImage,
    this.logo,
    this.logoSize,
    this.signUpMode = SignUpModes.both,
    Key? key,
  }) : super(key: key);

  /// Custom LoginTheme data, colors and styles on the screen.
  final LoginTheme? loginTheme;

  /// Custom LoginTexts data, texts on the screen.
  final LoginTexts? loginTexts;

  /// List of social login options that will be provided.
  final List<SocialLogin>? socialLogins;

  /// Login callback that will be called after login button pressed.
  final LoginCallback? onLogin;

  /// Signup callback that will be called after signup button pressed.
  final SignupCallback? onSignup;

  /// Callback that will be called after on tap of forgot password text.
  final ForgotPasswordCallback? onForgotPassword;

  /// Custom animation curve that will be used for animations.
  final Curve animationCurve;

  /// Ratio of width of the form to the width of the screen.
  final double formWidthRatio;

  /// The duration of the animations.
  final Duration? animationDuration;

  /// The optional custom form key, if not provided will be created locally.
  final GlobalKey<FormState>? formKey;

  /// The spacing between the elements of form.
  final double? formElementsSpacing;

  /// The spacing between the social login options.
  final double? socialLoginsSpacing;

  /// Indicates whether the login screen should handle errors,
  /// show error messages returned from the in a dialog.
  final bool checkError;

  /// Indicates whether the forgot password option will be enabled.
  final bool showForgotPassword;

  /// Indicates whether the change action title should be displayed.
  final bool showChangeActionTitle;

  /// Indicates whether the user can show the password text without obscuring.
  final bool showPasswordVisibility;

  /// Optional TextEditingController for name input field.
  final TextEditingController? nameController;

  /// Optional TextEditingController for email input field.
  final TextEditingController? emailController;

  /// Optional TextEditingController for password input field.
  final TextEditingController? passwordController;

  /// Optional TextEditingController for confirm password input field.
  final TextEditingController? confirmPasswordController;

  /// Custom button style for action button (login/signup).
  final ButtonStyle? actionButtonStyle;

  /// Custom button style for change action button that will switch auth mode.
  final ButtonStyle? changeActionButtonStyle;

  /// Horizontal padding of the welcome part widget.
  final EdgeInsets? welcomeHorizontalPadding;

  /// Horizontal padding of the form part widget.
  final EdgeInsets? formHorizontalPadding;

  /// Full asset image path for background of the welcome part.
  final String? backgroundImage;

  /// Full asset image path for the logo.
  final String? logo;

  /// Size of the logo in the welcome part
  final Size? logoSize;

  /// Enum to determine which text form fields should be displayed in addition
  /// to the email and password fields: Name / Confirm Password / Both
  final SignUpModes signUpMode;

  @override
  State<AnimatedLogin> createState() => _AnimatedLoginState();
}

class _AnimatedLoginState extends State<AnimatedLogin> {
  /// Background color of whole screen for mobile view,
  /// of welcome part for web view.
  late Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    backgroundColor = widget.loginTheme?.backgroundColor ??
        Theme.of(context).primaryColor.withOpacity(.8);
    final LoginTheme loginTheme = widget.loginTheme ?? LoginTheme()
      ..isLandscape = ViewTypeHelper(context).isLandscape;
    return MultiProvider(
      providers: <ChangeNotifierProvider<dynamic>>[
        ChangeNotifierProvider<LoginTexts>.value(
          value: widget.loginTexts ?? LoginTexts(),
        ),
        ChangeNotifierProvider<LoginTheme>.value(value: loginTheme),
        ChangeNotifierProvider<Auth>(
          create: (BuildContext context) => Auth(
            onForgotPassword: widget.onForgotPassword,
            onLogin: widget.onLogin,
            onSignup: widget.onSignup,
            socialLogins: widget.socialLogins,
          ),
        ),
      ],
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          WidgetsBinding.instance!.addPostFrameCallback((_) => context
              .read<LoginTheme>()
              .setIsLandscape(ViewTypeHelper(context).isLandscape));
          return SafeArea(
            child: _View(
              backgroundColor: backgroundColor,
              animationCurve: widget.animationCurve,
              formWidthRatio: widget.formWidthRatio,
              animationDuration: widget.animationDuration,
              formKey: widget.formKey,
              formElementsSpacing: widget.formElementsSpacing,
              socialLoginsSpacing: widget.socialLoginsSpacing,
              checkError: widget.checkError,
              showForgotPassword: widget.showForgotPassword,
              showChangeActionTitle: widget.showChangeActionTitle,
              showPasswordVisibility: widget.showPasswordVisibility,
              nameController: widget.nameController,
              emailController: widget.emailController,
              passwordController: widget.passwordController,
              confirmPasswordController: widget.confirmPasswordController,
              actionButtonStyle: widget.actionButtonStyle,
              changeActionButtonStyle: widget.changeActionButtonStyle,
              welcomeHorizontalPadding: widget.welcomeHorizontalPadding,
              formHorizontalPadding: widget.formHorizontalPadding,
              backgroundImage: widget.backgroundImage,
              logo: widget.logo,
              logoSize: widget.logoSize,
              signUpMode: widget.signUpMode,
            ),
          );
        }),
      ),
    );
  }
}

/// Draws the main view of the screen by using
/// [FormPart], [LogoAndTexts], [ChangeActionTitle] and [ChangeActionButton]
class _View extends StatefulWidget {
  const _View({
    required this.backgroundColor,
    required this.animationCurve,
    this.formWidthRatio = 60,
    this.animationDuration,
    this.formKey,
    this.formElementsSpacing,
    this.socialLoginsSpacing,
    this.checkError = true,
    this.showForgotPassword = true,
    this.showChangeActionTitle = true,
    this.showPasswordVisibility = true,
    this.nameController,
    this.emailController,
    this.passwordController,
    this.confirmPasswordController,
    this.actionButtonStyle,
    this.changeActionButtonStyle,
    this.welcomeHorizontalPadding,
    this.formHorizontalPadding,
    this.backgroundImage,
    this.logo,
    this.logoSize,
    this.signUpMode = SignUpModes.both,
    Key? key,
  }) : super(key: key);

  final Curve animationCurve;
  final double formWidthRatio;
  final Duration? animationDuration;
  final GlobalKey<FormState>? formKey;
  final double? formElementsSpacing;
  final double? socialLoginsSpacing;
  final bool checkError;
  final bool showForgotPassword;
  final bool showChangeActionTitle;
  final bool showPasswordVisibility;
  final TextEditingController? nameController;
  final TextEditingController? emailController;
  final TextEditingController? passwordController;
  final TextEditingController? confirmPasswordController;
  final ButtonStyle? actionButtonStyle;
  final ButtonStyle? changeActionButtonStyle;
  final EdgeInsets? welcomeHorizontalPadding;
  final EdgeInsets? formHorizontalPadding;
  final String? backgroundImage;
  final String? logo;
  final Size? logoSize;
  final SignUpModes signUpMode;
  final Color backgroundColor;

  @override
  __ViewState createState() => __ViewState();
}

class __ViewState extends State<_View> with SingleTickerProviderStateMixin {
  /// Dynamic size object to give responsive size values.
  late DynamicSize dynamicSize;

  /// Main animation controller for the transition animations.
  late final AnimationController animationController;

  /// Transition animation that will change the location of the welcome part.
  late Animation<double> welcomeTransitionAnimation;

  /// Custom LoginTheme data, colors and styles on the screen.
  late final LoginTheme loginTheme = context.read<LoginTheme>();

  /// Custom LoginTexts data, texts on the screen.
  late final LoginTexts loginTexts = context.read<LoginTexts>();

  /// Checks whether the animation has passed the middle point.
  bool isReverse = true;

  bool isLandscape = true;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration ?? const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isLandscape = context.watch<LoginTheme>().isLandscape;
    dynamicSize = DynamicSize(context);
    _initializeAnimations();
    return AnimatedBuilder(
      animation: animationController,
      builder: (_, __) => isLandscape ? _webView : _mobileView,
    );
  }

  Widget get _webView => Stack(
        children: <Widget>[
          Container(color: widget.backgroundColor),
          _animatedWebWelcome,
          _formPart,
        ],
      );

  Widget get _mobileView => Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(
            vertical: dynamicSize.height * 2.5,
            horizontal: dynamicSize.width * 7,
          ),
          children: <Widget>[
            _welcomeAnimationWrapper(_logoAndTexts),
            _formPart,
            SizedBox(height: dynamicSize.height * 2.5),
            if (widget.showChangeActionTitle)
              _welcomeAnimationWrapper(
                ChangeActionTitle(
                  isReverse: isReverse,
                  showButtonText: true,
                  animate: () => animate(context),
                ),
              ),
          ],
        ),
      );

  Widget _welcomeAnimationWrapper(Widget child) => Transform.translate(
        offset: Offset(dynamicSize.width * welcomeTransitionAnimation.value, 0),
        child: child,
      );

  Widget get _animatedWebWelcome => Transform.translate(
        offset: Offset(dynamicSize.width * welcomeTransitionAnimation.value, 0),
        child: Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            image: widget.backgroundImage == null
                ? null
                : DecorationImage(
                    image: AssetImage(widget.backgroundImage!),
                    fit: BoxFit.cover,
                  ),
          ),
          width: dynamicSize.width * (100 - widget.formWidthRatio),
          height: dynamicSize.height * 100,
          child: _webWelcomeComponents(context),
        ),
      );

  Widget _webWelcomeComponents(BuildContext context) => Padding(
        padding: widget.welcomeHorizontalPadding ??
            DynamicSize(context).medHighHorizontalPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _logoAndTexts,
            SizedBox(height: DynamicSize(context).height * 7),
            if (widget.showChangeActionTitle)
              ChangeActionTitle(isReverse: isReverse),
            SizedBox(height: DynamicSize(context).height * 2),
            _changeActionButton,
          ],
        ),
      );

  Widget get _logoAndTexts => LogoAndTexts(
        logo: widget.logo,
        logoSize: widget.logoSize,
        isReverse: isReverse,
      );

  Widget get _changeActionButton => ChangeActionButton(
        isReverse: isReverse,
        animate: () => animate(context),
        changeActionButtonStyle: widget.changeActionButtonStyle,
      );

  Widget get _formPart => FormPart(
        backgroundColor: widget.backgroundColor,
        animationController: animationController,
        formWidthRatio: widget.formWidthRatio,
        animationCurve: widget.animationCurve,
        formKey: widget.formKey,
        formElementsSpacing: widget.formElementsSpacing,
        socialLoginsSpacing: widget.socialLoginsSpacing,
        checkError: widget.checkError,
        showForgotPassword: widget.showForgotPassword,
        actionButtonStyle: widget.actionButtonStyle,
        formHorizontalPadding: widget.formHorizontalPadding,
        showPasswordVisibility: widget.showPasswordVisibility,
        nameController: widget.nameController,
        emailController: widget.emailController,
        passwordController: widget.passwordController,
        confirmPasswordController: widget.confirmPasswordController,
        signUpMode: widget.signUpMode,
      );

  void animate(BuildContext context) {
    animationController.isCompleted
        ? animationController.reverse()
        : animationController.forward();
    Provider.of<Auth>(context, listen: false).switchAuth();
  }

  void _initializeAnimations() {
    /// Initializes the transition animation from 0 to form part's width ratio
    /// with custom animation curve and animation controller.
    welcomeTransitionAnimation = isLandscape
        ? Tween<double>(begin: 0, end: widget.formWidthRatio).animate(
            CurvedAnimation(
              parent: animationController,
              curve: widget.animationCurve,
            ),
          )
        : AnimationHelper(
            animationController: animationController,
            animationCurve: widget.animationCurve,
          ).tweenSequenceAnimation(-110, 20);

    welcomeTransitionAnimation.addListener(() {
      if (isLandscape) {
        isReverse =
            welcomeTransitionAnimation.value <= widget.formWidthRatio / 2;
      } else if (_forwardCheck) {
        isReverse = !isReverse;
      }
    });
  }

  bool get _forwardCheck => isLandscape
      ? welcomeTransitionAnimation.value <= widget.formWidthRatio / 2
      : welcomeTransitionAnimation.value <= -100 && _statusCheck;

  bool get _statusCheck =>
      (welcomeTransitionAnimation.status == AnimationStatus.forward &&
          isReverse) ||
      (welcomeTransitionAnimation.status == AnimationStatus.reverse &&
          !isReverse);
}