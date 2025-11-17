import 'package:flutter/material.dart';
import 'package:reqproxy/presentation/widgets/nav_icon_button.dart';

class LeftSideNavBar extends StatefulWidget {
  const LeftSideNavBar({super.key});

  @override
  State<LeftSideNavBar> createState() => _LeftSideNavBarState();
}

class _LeftSideNavBarState extends State<LeftSideNavBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      color: Theme.of(context).canvasColor,
      child: Column(
        children: [
          const SizedBox(height: 10),
          NavIconButton(
            icon: Icons.radar,
            isSelected: _selectedIndex == 0,
            onPressed: () => setState(() => _selectedIndex = 0),
          ),
          NavIconButton(
            icon: Icons.folder_copy_outlined,
            isSelected: _selectedIndex == 1,
            onPressed: () => setState(() => _selectedIndex = 1),
          ),
          NavIconButton(
            icon: Icons.rule,
            isSelected: _selectedIndex == 2,
            onPressed: () => setState(() => _selectedIndex = 2),
          ),
          NavIconButton(
            icon: Icons.description,
            isSelected: _selectedIndex == 3,
            onPressed: () => setState(() => _selectedIndex = 3),
          ),
          NavIconButton(
            icon: Icons.history,
            isSelected: _selectedIndex == 4,
            onPressed: () => setState(() => _selectedIndex = 4),
          ),
          NavIconButton(
            icon: Icons.sync_alt,
            isSelected: _selectedIndex == 5,
            onPressed: () => setState(() => _selectedIndex = 5),
          ),
          const Spacer(),
          NavIconButton(
            icon: Icons.person_outline,
            isSelected: _selectedIndex == 6,
            onPressed: () => setState(() => _selectedIndex = 6),
          ),
          NavIconButton(
            icon: Icons.settings_outlined,
            isSelected: _selectedIndex == 7,
            onPressed: () => setState(() => _selectedIndex = 7),
          ),
          const Divider(),
          NavIconButton(
            icon: Icons.qr_code,
            isSelected: _selectedIndex == 8,
            onPressed: () => setState(() => _selectedIndex = 8),
          ),
          NavIconButton(
            icon: Icons.grid_view,
            isSelected: _selectedIndex == 9,
            onPressed: () => setState(() => _selectedIndex = 9),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
