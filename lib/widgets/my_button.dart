import 'package:flutter/material.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/dimens.dart';
import 'package:hello_flutter/util/theme_util.dart';

/// 默认字号 18，白字蓝底，高度 48
class MyButton extends StatelessWidget {
  const MyButton({
    Key? key,
    this.text = '',
    this.fontSize = Dimens.font_sp18,
    this.textColor,
    this.disabledTextColor,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.minHeight = 40.0,
    this.minWidth = double.infinity,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.radius = 2.0,
    this.side = BorderSide.none,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final double fontSize;
  final Color? textColor;
  final Color? disabledTextColor;
  final Color? backgroundColor;
  final Color? disabledBackgroundColor;
  final double? minHeight;
  final double? minWidth;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry padding;
  final double radius;
  final BorderSide side;

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDark;
    return TextButton(
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize),
        ),
        onPressed: onPressed,
        style: ButtonStyle(
          // 文字颜色
          foregroundColor: MaterialStateProperty.resolveWith(
            (states) {
              if (states.contains(MaterialState.disabled)) {
                return disabledTextColor ??
                    (isDark ? ColorConst.dark_text_disabled : ColorConst.text_disabled);
              }
              return textColor ?? (isDark ? ColorConst.dark_button_text : Colors.white);
            },
          ),
          // 背景颜色
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return disabledBackgroundColor ??
                  (isDark ? ColorConst.dark_button_disabled : ColorConst.button_disabled);
            }
            return backgroundColor ?? (isDark ? ColorConst.dark_app_main : ColorConst.app_main);
          }),
          // 水波纹
          overlayColor: MaterialStateProperty.resolveWith((states) {
            return (textColor ?? (isDark ? ColorConst.dark_button_text : Colors.white))
                .withOpacity(0.12);
          }),
          // 按钮最小大小
          minimumSize: (minWidth == null || minHeight == null)
              ? null
              : MaterialStateProperty.all<Size>(Size(minWidth!, minHeight!)),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(padding),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          side: MaterialStateProperty.all<BorderSide>(side),
        ));
  }
}
