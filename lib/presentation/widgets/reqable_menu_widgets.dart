import 'package:flutter/material.dart';
import 'package:reqproxy/presentation/theme/reqable_menu_theme.dart';

export 'package:reqproxy/presentation/theme/reqable_menu_theme.dart';

class ReqableSubmenuButton extends StatelessWidget {
  final Widget child;
  final List<Widget> menuChildren;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  const ReqableSubmenuButton({
    super.key,
    required this.child,
    required this.menuChildren,
    this.leadingIcon,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SubmenuButton(
      style: ReqableMenuTheme.itemStyle,
      menuStyle: ReqableMenuTheme.menuStyle,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      menuChildren: menuChildren,
      child: child,
    );
  }
}

class ReqableMenuItemButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final MenuSerializableShortcut? shortcut;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  const ReqableMenuItemButton({
    super.key,
    required this.child,
    this.onPressed,
    this.shortcut,
    this.leadingIcon,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      style: ReqableMenuTheme.itemStyle,
      onPressed: onPressed,
      shortcut: shortcut,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      child: child,
    );
  }
}
