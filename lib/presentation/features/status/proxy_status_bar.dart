import 'package:flutter/material.dart';

class ProxyStatusBar extends StatefulWidget {
  const ProxyStatusBar({super.key});

  @override
  State<ProxyStatusBar> createState() => _ProxyStatusBarState();
}

class _ProxyStatusBarState extends State<ProxyStatusBar> {
  bool _isPaused = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF3E3E3E))),
      ),
      child: Row(
        children: [
          // Left side
          const Icon(Icons.circle, color: Colors.green, size: 12),
          const SizedBox(width: 8),
          const Text('Proxying on 192.168.2.190:9000', style: TextStyle(fontSize: 13)),
          const SizedBox(width: 8),
          Tooltip(
            message: '检测到多个ip',
            child: Icon(Icons.warning_amber_rounded, color: Colors.yellow[700], size: 18),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined), 
            iconSize: 18, 
            tooltip: '修改端口号', 
            onPressed: () {}
          ),
          IconButton(
            icon: const Icon(Icons.terminal), 
            iconSize: 18, 
            tooltip: '代理终端（alt+T）', 
            onPressed: () {}
          ),
          IconButton(
            icon: const Icon(Icons.smartphone), 
            iconSize: 18, 
            tooltip: '手机协同配置', 
            onPressed: () {}
          ),
          
          const Spacer(),
          
          // Right side
          IconButton(
            icon: const Icon(Icons.compare_arrows, color: Colors.grey), 
            iconSize: 18, 
            tooltip: '镜像已禁用(Ctrl+Shift+M)', 
            onPressed: () {}
          ),
          IconButton(
            icon: const Icon(Icons.router, color: Colors.green), 
            iconSize: 18, 
            tooltip: '网关已启用(Ctrl+Shift+G)', 
            onPressed: () {}
          ),
          IconButton(
            icon: const Icon(Icons.edit_note, color: Colors.grey), 
            iconSize: 18, 
            tooltip: '重写已禁用(Ctrl+Shift+K)', 
            onPressed: () {}
          ),
          IconButton(
            icon: const Icon(Icons.bug_report_outlined, color: Colors.grey), 
            iconSize: 18, 
            tooltip: '断点已禁用(Ctrl+Shift+B)', 
            onPressed: () {}
          ),
          IconButton(
            icon: const Icon(Icons.code, color: Colors.grey), 
            iconSize: 18, 
            tooltip: '脚本已禁用(Ctrl+Shift+P)', 
            onPressed: () {}
          ),
          IconButton(
            icon: const Icon(Icons.visibility_off_outlined, color: Colors.grey), 
            iconSize: 18, 
            tooltip: '无痕模式已关闭（F10）', 
            onPressed: () {}
          ),
          IconButton(
            icon: const Icon(Icons.bolt, color: Colors.grey), 
            iconSize: 18, 
            tooltip: '极速模式已关闭(F9)', 
            onPressed: () {}
          ),
          IconButton(
            icon: const Icon(Icons.desktop_windows_outlined, color: Colors.grey), 
            iconSize: 18, 
            tooltip: '系统代理未设置（F12）', 
            onPressed: () {}
          ),
          IconButton(
            icon: const Icon(Icons.shield, color: Colors.green), 
            iconSize: 18, 
            tooltip: 'SSL已启用', 
            onPressed: () {}
          ),
          
          const SizedBox(width: 8),
          
          // Debug/Pause Toggle
          TextButton.icon(
            style: TextButton.styleFrom(
              backgroundColor: _isPaused ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
              foregroundColor: _isPaused ? Colors.green : Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause, size: 16),
            label: Text(_isPaused ? '调试' : '暂停'),
            onPressed: () {
              setState(() {
                _isPaused = !_isPaused;
              });
            },
          ),
          const SizedBox(width: 8),
          IconButton(icon: const Icon(Icons.delete_outline), iconSize: 18, tooltip: 'Clear', onPressed: () {}),
        ],
      ),
    );
  }
}
