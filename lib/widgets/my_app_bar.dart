import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/dimens.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/util/theme_util.dart';

/// 自定义 AppBar
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar(
      {Key? key,
      this.backgroundColor,
      this.title = '',
      this.centerTitle = '',
      this.rightText = '',
      this.actionColor,
      this.backImg = 'assets/images/ic_back_black.png',
      this.backImgColor,
      this.onRightPressed,
      this.isBack = true})
      : super(key: key);

  final Color? backgroundColor;
  final String title;
  final String centerTitle;
  final String backImg;
  final Color? backImgColor;
  final String rightText;
  final Color? actionColor;
  final VoidCallback? onRightPressed;
  final bool isBack;

  @override
  Widget build(BuildContext context) {
    //  背景色
    final Color _backgroundColor = backgroundColor ?? context.backgroundColor;

    final SystemUiOverlayStyle _overlayStyle =
        ThemeData.estimateBrightnessForColor(_backgroundColor) == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark;

    final Widget back = isBack
        ? IconButton(
            onPressed: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              final isBack = await Navigator.maybePop(context);
              if (!isBack) {
                await SystemNavigator.pop();
              }
            },
            tooltip: 'Back',
            padding: const EdgeInsets.all(12.0),
            icon: Image.asset(
              backImg,
              color: backImgColor ?? ThemeUtil.getIconColor(context),
            ),
          )
        : Gaps.empty;

    final Widget right = rightText.isNotEmpty
        ? Positioned(
            right: 0.0,
            child: Theme(
              data: Theme.of(context).copyWith(
                buttonTheme: const ButtonThemeData(
                  buttonColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  minWidth: 60.0,
                ),
              ),
              child: TextButton(
                key: const Key('rightText'),
                onPressed: onRightPressed,
                child: Text(
                  rightText,
                  style: TextStyle(
                    fontSize: Dimens.font_sp14,
                    color: actionColor ?? (context.isDark ? ColorConst.dark_text : ColorConst.text),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    //  设置按下时的背景颜色
                    if (states.contains(MaterialState.pressed)) {
                      return ColorConst.bg_gray;
                    }
                    //  默认不使用背景颜色
                    return null;
                  }),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16)),
                ),
              ),
            ),
          )
        : Gaps.empty;

    final Widget titleWidget = Semantics(
      namesRoute: true,
      header: true,
      child: Container(
        alignment: centerTitle.isEmpty ? Alignment.centerLeft : Alignment.center,
        width: double.infinity,
        child: Text(
          title.isEmpty ? centerTitle : title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Dimens.font_sp18,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 48.0),
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _overlayStyle,
      child: Material(
        color: _backgroundColor,
        child: SafeArea(
          child: Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              titleWidget,
              back,
              right,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48.0);
}
