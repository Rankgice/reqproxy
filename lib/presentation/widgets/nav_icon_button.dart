import 'package:flutter/material.dart';

class NavIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isSelected;

  const NavIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      color: isSelected ? Theme.of(context).colorScheme.primary : null,
    );
  }
}
