import 'package:flutter/material.dart';

class BottomStatusBar extends StatelessWidget {
  const BottomStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.splitscreen), iconSize: 16, tooltip: '上下布局', onPressed: () {}),
          IconButton(icon: const Icon(Icons.vertical_split), iconSize: 16, tooltip: '左右布局', onPressed: () {}),
          const Spacer(),
          const Text('共 754 项 (选择 1 项)', style: TextStyle(fontSize: 12)),
          const Spacer(),
          TextButton.icon(
            icon: const Icon(Icons.cloud_upload_outlined, size: 16),
            label: const Text('新版本', style: TextStyle(fontSize: 12)),
            onPressed: () {},
          ),
          const Icon(Icons.vpn_key_outlined, size: 16),
          const SizedBox(width: 8),
          const Text('激活', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
