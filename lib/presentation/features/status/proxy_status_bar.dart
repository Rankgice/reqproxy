import 'package:flutter/material.dart';

class ProxyStatusBar extends StatelessWidget {
  const ProxyStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          // Left side
          const Icon(Icons.circle, color: Colors.green, size: 14),
          const SizedBox(width: 8),
          const Text('Proxying on 192.168.2.190:9000'),
          const SizedBox(width: 4),
          IconButton(icon: const Icon(Icons.edit_outlined), iconSize: 16, onPressed: () {}),
          IconButton(icon: const Icon(Icons.copy_outlined), iconSize: 16, onPressed: () {}),
          IconButton(icon: const Icon(Icons.qr_code), iconSize: 16, onPressed: () {}),
          const Spacer(),
          // Right side
          IconButton(icon: const Icon(Icons.memory), iconSize: 18, tooltip: 'Rewrite', onPressed: () {}),
          IconButton(icon: const Icon(Icons.shield_outlined), iconSize: 18, tooltip: 'Map Remote', onPressed: () {}),
          IconButton(icon: const Icon(Icons.block), iconSize: 18, tooltip: 'Breakpoint', onPressed: () {}),
          IconButton(icon: const Icon(Icons.description_outlined), iconSize: 18, tooltip: 'Script', onPressed: () {}),
          IconButton(icon: const Icon(Icons.airplanemode_active_outlined), iconSize: 18, tooltip: 'No Proxy', onPressed: () {}),
          IconButton(icon: const Icon(Icons.shield), iconSize: 18, tooltip: 'TLS Decryption', onPressed: () {}),
          const VerticalDivider(),
          TextButton.icon(
            icon: const Icon(Icons.pause, size: 18),
            label: const Text('暂停'),
            onPressed: () {},
          ),
          IconButton(icon: const Icon(Icons.delete_outline), iconSize: 18, tooltip: 'Clear', onPressed: () {}),
        ],
      ),
    );
  }
}
