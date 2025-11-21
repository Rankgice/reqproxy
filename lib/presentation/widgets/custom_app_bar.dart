import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:reqproxy/presentation/widgets/top_menu_bar.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(30);
}

class _CustomAppBarState extends State<CustomAppBar> with WindowListener {
  bool _isMaximized = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _getMaximized();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  void _getMaximized() async {
    _isMaximized = await windowManager.isMaximized();
    setState(() {});
  }

  @override
  void onWindowMaximize() {
    setState(() {
      _isMaximized = true;
    });
  }

  @override
  void onWindowUnmaximize() {
    setState(() {
      _isMaximized = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        windowManager.startDragging();
      },
      onDoubleTap: () async {
        if (await windowManager.isMaximizable()) {
          if (_isMaximized) {
            windowManager.unmaximize();
          } else {
            windowManager.maximize();
          }
        }
      },
      child: Container(
        color: Theme.of(context).appBarTheme.backgroundColor,
        child: _buildMenuBar(context),
      ),
    );
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          const Expanded(child: TopMenuBar()),
          const Spacer(),
          _buildWindowControls(context),
        ],
      ),
    );
  }

  Widget _buildWindowControls(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.minimize),
          onPressed: () => windowManager.minimize(),
          iconSize: 16,
        ),
        IconButton(
          icon: Icon(_isMaximized ? Icons.fullscreen_exit : Icons.fullscreen),
          onPressed: () async {
            if (await windowManager.isMaximizable()) {
              if (_isMaximized) {
                windowManager.unmaximize();
              } else {
                windowManager.maximize();
              }
            }
          },
          iconSize: 16,
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => windowManager.close(),
          iconSize: 16,
        ),
      ],
    );
  }
}
