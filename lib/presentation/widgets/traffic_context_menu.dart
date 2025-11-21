import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reqproxy/core/models/traffic_item.dart';
import 'package:reqproxy/presentation/widgets/reqable_custom_menu.dart';

class TrafficContextMenu extends StatelessWidget {
  final List<TrafficItem> selectedItems;
  final Function(List<TrafficItem>) onDelete;
  final VoidCallback? onMenuClosed;

  const TrafficContextMenu({
    super.key,
    required this.selectedItems,
    required this.onDelete,
    this.onMenuClosed,
  });

  void _copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
    onMenuClosed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final firstItem = selectedItems.isNotEmpty ? selectedItems.first : null;
    final bool canCopy = firstItem != null;

    final List<ReqableCustomMenuItem> items = [
      // 复制cURL
      ReqableCustomMenuItem(
        label: '复制cURL',
        shortcut: 'Ctrl+Shift+C',
        onPressed: !canCopy ? null : () => _copy('curl "${firstItem!.url}"'),
      ),
      // 复制 >
      ReqableCustomMenuItem(
        label: '复制',
        subItems: [
          ReqableCustomMenuItem(label: 'URL', shortcut: 'Ctrl+C', onPressed: !canCopy ? null : () => _copy(firstItem!.url)),
          ReqableCustomMenuItem(label: '域名', onPressed: !canCopy ? null : () => _copy(firstItem!.uri.host)),
          ReqableCustomMenuItem(label: '路径', onPressed: !canCopy ? null : () => _copy(firstItem!.uri.path)),
          const ReqableCustomMenuItem.divider(),
          ReqableCustomMenuItem(label: '服务器IP', onPressed: !canCopy ? null : () => _copy(firstItem!.serverIp)),
          ReqableCustomMenuItem(label: '客户端IP', onPressed: !canCopy ? null : () => _copy(firstItem!.clientIp)),
          ReqableCustomMenuItem(label: '服务器地址', onPressed: () {}),
          ReqableCustomMenuItem(label: '客户端地址', onPressed: () {}),
          const ReqableCustomMenuItem.divider(),
          ReqableCustomMenuItem(label: '行', onPressed: () {}),
          const ReqableCustomMenuItem.divider(),
          ReqableCustomMenuItem(label: '备注', onPressed: () {}),
        ],
      ),
      // 选择 >
      ReqableCustomMenuItem(
        label: '选择',
        subItems: [
          ReqableCustomMenuItem(label: '全选', shortcut: 'Ctrl+A', onPressed: () {}),
          ReqableCustomMenuItem(label: '反选', shortcut: 'Ctrl+Shift+I', onPressed: () {}),
          const ReqableCustomMenuItem.divider(),
          ReqableCustomMenuItem(label: '相同域名', onPressed: () {}),
          ReqableCustomMenuItem(label: '相同路径', onPressed: () {}),
          ReqableCustomMenuItem(label: '相同URL', onPressed: () {}),
          const ReqableCustomMenuItem.divider(),
          ReqableCustomMenuItem(label: '复用连接', onPressed: () {}),
          const ReqableCustomMenuItem.divider(),
          ReqableCustomMenuItem(label: '分部内容', onPressed: () {}),
        ],
      ),
      // 查看 >
      ReqableCustomMenuItem(
        label: '查看',
        subItems: [
          ReqableCustomMenuItem(label: '新窗口打开', shortcut: 'Ctrl+N', onPressed: () {}),
          ReqableCustomMenuItem(label: '浏览器打开', onPressed: () {}),
          const ReqableCustomMenuItem.divider(),
          ReqableCustomMenuItem(label: 'URL', shortcut: 'Ctrl+U', onPressed: () {}),
          ReqableCustomMenuItem(label: '生成代码', shortcut: 'Alt+S', onPressed: () {}),
          ReqableCustomMenuItem(label: '二维码', shortcut: 'Alt+U', onPressed: () {}),
        ],
      ),
      // 对比 >
      ReqableCustomMenuItem(
        label: '对比',
        subItems: [
          ReqableCustomMenuItem(label: '对比两者', shortcut: 'Ctrl+Y', onPressed: () {}),
          ReqableCustomMenuItem(label: '添加到对比池', shortcut: 'Ctrl+Shift+Y', onPressed: () {}),
          const ReqableCustomMenuItem.divider(),
        ],
      ),
      // 导出 >
      ReqableCustomMenuItem(
        label: '导出',
        subItems: [
          ReqableCustomMenuItem(label: '请求', onPressed: () {}),
          ReqableCustomMenuItem(label: '请求(原始)', onPressed: () {}),
          ReqableCustomMenuItem(label: '请求头', onPressed: () {}),
          ReqableCustomMenuItem(label: '请求体', onPressed: () {}),
          ReqableCustomMenuItem(label: '请求体(原始)', onPressed: () {}),
          const ReqableCustomMenuItem.divider(),
          ReqableCustomMenuItem(label: '响应', onPressed: () {}),
          ReqableCustomMenuItem(label: '响应(原始)', onPressed: () {}),
          ReqableCustomMenuItem(label: '响应头', onPressed: () {}),
          ReqableCustomMenuItem(label: '响应体', onPressed: () {}),
          ReqableCustomMenuItem(label: '响应体(原始)', onPressed: () {}),
          const ReqableCustomMenuItem.divider(),
          ReqableCustomMenuItem(label: '请求 + 响应', onPressed: () {}),
          ReqableCustomMenuItem(label: '请求(原始) + 响应(原始)', onPressed: () {}),
          const ReqableCustomMenuItem.divider(),
          ReqableCustomMenuItem(label: '会话', onPressed: () {}),
          ReqableCustomMenuItem(label: '会话(原始)', onPressed: () {}),
          const ReqableCustomMenuItem.divider(),
          ReqableCustomMenuItem(label: '分部内容', onPressed: () {}),
          const ReqableCustomMenuItem.divider(),
          ReqableCustomMenuItem(label: '结构', onPressed: () {}),
          ReqableCustomMenuItem(label: 'CSV', onPressed: () {}),
          ReqableCustomMenuItem(label: 'HAR', onPressed: () {}),
        ],
      ),
      // 编辑
      ReqableCustomMenuItem(
        label: '编辑',
        shortcut: 'Ctrl+Shift+Enter',
        onPressed: () {},
      ),
      // 重发 >
      ReqableCustomMenuItem(
        label: '重发',
        subItems: [
          ReqableCustomMenuItem(label: '1 次', shortcut: 'Ctrl+Enter', onPressed: () {}),
          ReqableCustomMenuItem(label: '2 次', onPressed: () {}),
          ReqableCustomMenuItem(label: '3 次', onPressed: () {}),
          ReqableCustomMenuItem(label: '4 次', onPressed: () {}),
          ReqableCustomMenuItem(label: '5 次', onPressed: () {}),
          ReqableCustomMenuItem(label: '自定义', onPressed: () {}),
        ],
      ),
      // 添加备注
      ReqableCustomMenuItem(
        label: '添加备注',
        onPressed: () {},
      ),
      // SSL代理 >
      ReqableCustomMenuItem(
        label: 'SSL代理',
        subItems: [
          ReqableCustomMenuItem(label: '新建', onPressed: () {}),
        ],
      ),
      // 镜像
      ReqableCustomMenuItem(
        label: '镜像',
        onPressed: () {},
      ),
      // 网关 >
      ReqableCustomMenuItem(
        label: '网关',
        subItems: [
          ReqableCustomMenuItem(label: '仅允许', onPressed: () {}),
          ReqableCustomMenuItem(label: '静默', onPressed: () {}),
          ReqableCustomMenuItem(label: '屏蔽请求', onPressed: () {}),
          ReqableCustomMenuItem(label: '屏蔽响应', onPressed: () {}),
          ReqableCustomMenuItem(label: '挂起请求', onPressed: () {}),
          ReqableCustomMenuItem(label: '挂起响应', onPressed: () {}),
        ],
      ),
      // 脚本
      ReqableCustomMenuItem(
        label: '脚本',
        onPressed: () {},
      ),
      // 重写 >
      ReqableCustomMenuItem(
        label: '重写',
        subItems: [
          ReqableCustomMenuItem(label: '重定向URL', onPressed: () {}),
          ReqableCustomMenuItem(label: '替换请求', onPressed: () {}),
          ReqableCustomMenuItem(label: '替换响应', onPressed: () {}),
          ReqableCustomMenuItem(label: '修改请求', onPressed: () {}),
          ReqableCustomMenuItem(label: '修改响应', onPressed: () {}),
        ],
      ),
      // 断点
      ReqableCustomMenuItem(
        label: '断点',
        onPressed: () {},
      ),
      const ReqableCustomMenuItem.divider(),
      // 高亮 >
      ReqableCustomMenuItem(
        label: '高亮',
        subItems: [
          ReqableCustomMenuItem(label: '红色', shortcut: 'Alt+1', onPressed: () {}),
          ReqableCustomMenuItem(label: '黄色', shortcut: 'Alt+2', onPressed: () {}),
          ReqableCustomMenuItem(label: '绿色', shortcut: 'Alt+3', onPressed: () {}),
          ReqableCustomMenuItem(label: '蓝色', shortcut: 'Alt+4', onPressed: () {}),
          ReqableCustomMenuItem(label: '青色', shortcut: 'Alt+5', onPressed: () {}),
          ReqableCustomMenuItem(label: '划线', shortcut: 'Alt+-', onPressed: () {}),
          const ReqableCustomMenuItem.divider(),
          ReqableCustomMenuItem(label: '标记已阅', isChecked: true, onPressed: () {}),
          const ReqableCustomMenuItem.divider(),
          ReqableCustomMenuItem(label: '重置', shortcut: 'Alt+0', onPressed: () {}),
          ReqableCustomMenuItem(label: '自动', onPressed: () {}),
        ],
      ),
      // 书签 >
      ReqableCustomMenuItem(
        label: '书签',
        subItems: [
          ReqableCustomMenuItem(label: '添加域名', onPressed: () {}),
          ReqableCustomMenuItem(label: '添加路径', onPressed: () {}),
        ],
      ),
      // 添加到 >
      ReqableCustomMenuItem(
        label: '添加到',
        subItems: [
          ReqableCustomMenuItem(label: 'API集合', shortcut: 'Ctrl+I', onPressed: () {}),
          ReqableCustomMenuItem(label: '新会话', onPressed: () {}),
          ReqableCustomMenuItem(label: '我的收藏', onPressed: () {}),
        ],
      ),
      // 删除
      ReqableCustomMenuItem(
        label: '删除',
        shortcut: 'Delete',
        onPressed: selectedItems.isEmpty ? null : () => onDelete(selectedItems),
      ),
    ];

    return ReqableCustomMenu(
      items: items,
      onMenuClosed: onMenuClosed,
    );
  }
}
