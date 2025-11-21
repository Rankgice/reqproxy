import 'package:flutter/material.dart';

class ReqableMenuTheme {
  static const Color backgroundColor = Color(0xFF2B2B2B);
  static const Color hoverColor = Color(0xFFFF9800);
  static const Color textColor = Colors.white;
  static const Color disabledTextColor = Colors.grey;
  static const Color dividerColor = Color(0xFF3E3E3E);
  static const double borderRadius = 4.0;

  static final List<BoxShadow> shadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.5),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static MenuStyle get barStyle => MenuStyle(
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        elevation: MaterialStateProperty.all(0),
        padding: MaterialStateProperty.all(EdgeInsets.zero),
      );

  static MenuStyle get menuStyle => MenuStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColor),
        elevation: MaterialStateProperty.all(0), // We might need to handle shadow manually or let elevation do it
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 4)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      );

  static ButtonStyle get itemStyle => ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.hovered) || states.contains(MaterialState.focused)) {
            return hoverColor;
          }
          return Colors.transparent;
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return disabledTextColor;
          }
          return textColor;
        }),
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 16, vertical: 6)),
        textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 13)),
        overlayColor: MaterialStateProperty.all(Colors.transparent), // Disable default overlay
        iconColor: MaterialStateProperty.resolveWith((states) {
           if (states.contains(MaterialState.disabled)) {
            return disabledTextColor;
          }
          return textColor;
        }),
      );
}
