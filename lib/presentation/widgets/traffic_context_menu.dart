import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reqproxy/core/models/traffic_item.dart';

class TrafficContextMenu extends StatefulWidget {
  final List<TrafficItem> selectedItems;
  final Function(List<TrafficItem>) onDelete;

  const TrafficContextMenu({
    super.key,
    required this.selectedItems,
    required this.onDelete,
  });

  @override
  State<TrafficContextMenu> createState() => _TrafficContextMenuState();
}

class _TrafficContextMenuState extends State<TrafficContextMenu> {
  OverlayEntry? _submenuEntry;
  final LayerLink _layerLink = LayerLink();

  void _copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
    _closeSubmenu();
  }

  void _closeSubmenu() {
    _submenuEntry?.remove();
    _submenuEntry = null;
  }

  void _openSubmenu(BuildContext itemContext, List<Widget> items) {
    _closeSubmenu();

    final RenderBox renderBox = itemContext.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    _submenuEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx + size.width,
        top: offset.dy,
        child: Material(
          color: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 250),
            decoration: BoxDecoration(
              color: const Color(0xFF2B2B2B),
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: items,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_submenuEntry!);
  }

  @override
  void dispose() {
    _closeSubmenu();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firstItem = widget.selectedItems.isNotEmpty ? widget.selectedItems.first : null;
    final bool canCopy = firstItem != null;

    return CompositedTransformTarget(
      link: _layerLink,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 280),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2B2B2B),
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 复制cURL
                _CustomMenuItem(
                  label: '复制cURL',
                  shortcut: 'Ctrl+Shift+C',
                  onPressed: !canCopy ? null : () => _copy('curl "${firstItem!.url}"'),
                  onHover: (_) => _closeSubmenu(),
                ),
                // 复制 >
                _CustomMenuItem(
                  label: '复制',
                  hasSubmenu: true,
                  onHover: (ctx) => !canCopy ? _closeSubmenu() : _openSubmenu(ctx, [
                    _SubmenuItem(label: 'URL', shortcut: 'Ctrl+C', onPressed: () => _copy(firstItem!.url)),
                    _SubmenuItem(label: '域名', onPressed: () => _copy(firstItem!.uri.host)),
                    _SubmenuItem(label: '路径', onPressed: () => _copy(firstItem!.uri.path)),
                    const _SubmenuDivider(),
                    _SubmenuItem(label: '服务器IP', onPressed: () => _copy(firstItem!.serverIp)),
                    _SubmenuItem(label: '客户端IP', onPressed: () => _copy(firstItem!.clientIp)),
                    _SubmenuItem(label: '服务器地址', onPressed: () {}),
                    _SubmenuItem(label: '客户端地址', onPressed: () {}),
                    const _SubmenuDivider(),
                    _SubmenuItem(label: '行', onPressed: () {}),
                    const _SubmenuDivider(),
                    _SubmenuItem(label: '备注', onPressed: () {}),
                  ]),
                ),
                // 选择 >
                _CustomMenuItem(
                  label: '选择',
                  hasSubmenu: true,
                  onHover: (ctx) => _openSubmenu(ctx, [
                    _SubmenuItem(label: '全选', shortcut: 'Ctrl+A', onPressed: () {}),
                    _SubmenuItem(label: '反选', shortcut: 'Ctrl+Shift+I', onPressed: () {}),
                    const _SubmenuDivider(),
                    _SubmenuItem(label: '相同域名', onPressed: () {}),
                    _SubmenuItem(label: '相同路径', onPressed: () {}),
                    _SubmenuItem(label: '相同URL', onPressed: () {}),
                    const _SubmenuDivider(),
                    _SubmenuItem(label: '复用连接', onPressed: () {}),
                    const _SubmenuDivider(),
                    _SubmenuItem(label: '分部内容', onPressed: () {}),
                  ]),
                ),
                // 查看 >
                _CustomMenuItem(
                  label: '查看',
                  hasSubmenu: true,
                  onHover: (ctx) => _openSubmenu(ctx, [
                    _SubmenuItem(label: '新窗口打开', shortcut: 'Ctrl+N', onPressed: () {}),
                    _SubmenuItem(label: '浏览器打开', onPressed: () {}),
                    const _SubmenuDivider(),
                    _SubmenuItem(label: 'URL', shortcut: 'Ctrl+U', onPressed: () {}),
                    _SubmenuItem(label: '生成代码', shortcut: 'Alt+S', onPressed: () {}),
                    _SubmenuItem(label: '二维码', shortcut: 'Alt+U', onPressed: () {}),
                  ]),
                ),
                // 对比 >
                _CustomMenuItem(
                  label: '对比',
                  hasSubmenu: true,
                  onHover: (ctx) => _openSubmenu(ctx, [
                    _SubmenuItem(label: '对比两者', shortcut: 'Ctrl+Y', onPressed: () {}),
                    _SubmenuItem(label: '添加到对比池', shortcut: 'Ctrl+Shift+Y', onPressed: () {}),
                    const _SubmenuDivider(),
                  ]),
                ),
                // 导出 >
                _CustomMenuItem(
                  label: '导出',
                  hasSubmenu: true,
                  onHover: (ctx) => _openSubmenu(ctx, [
                    _SubmenuItem(label: '请求', onPressed: () {}),
                    _SubmenuItem(label: '请求(原始)', onPressed: () {}),
                    _SubmenuItem(label: '请求头', onPressed: () {}),
                    _SubmenuItem(label: '请求体', onPressed: () {}),
                    _SubmenuItem(label: '请求体(原始)', onPressed: () {}),
                    const _SubmenuDivider(),
                    _SubmenuItem(label: '响应', onPressed: () {}),
                    _SubmenuItem(label: '响应(原始)', onPressed: () {}),
                    _SubmenuItem(label: '响应头', onPressed: () {}),
                    _SubmenuItem(label: '响应体', onPressed: () {}),
                    _SubmenuItem(label: '响应体(原始)', onPressed: () {}),
                    const _SubmenuDivider(),
                    _SubmenuItem(label: '请求 + 响应', onPressed: () {}),
                    _SubmenuItem(label: '请求(原始) + 响应(原始)', onPressed: () {}),
                    const _SubmenuDivider(),
                    _SubmenuItem(label: '会话', onPressed: () {}),
                    _SubmenuItem(label: '会话(原始)', onPressed: () {}),
                    const _SubmenuDivider(),
                    _SubmenuItem(label: '分部内容', onPressed: () {}),
                    const _SubmenuDivider(),
                    _SubmenuItem(label: '结构', onPressed: () {}),
                    _SubmenuItem(label: 'CSV', onPressed: () {}),
                    _SubmenuItem(label: 'HAR', onPressed: () {}),
                  ]),
                ),
                // 编辑
                _CustomMenuItem(
                  label: '编辑',
                  shortcut: 'Ctrl+Shift+Enter',
                  onPressed: () {},
                  onHover: (_) => _closeSubmenu(),
                ),
                // 重发 >
                _CustomMenuItem(
                  label: '重发',
                  hasSubmenu: true,
                  onHover: (ctx) => _openSubmenu(ctx, [
                    _SubmenuItem(label: '1 次', shortcut: 'Ctrl+Enter', onPressed: () {}),
                    _SubmenuItem(label: '2 次', onPressed: () {}),
                    _SubmenuItem(label: '3 次', onPressed: () {}),
                    _SubmenuItem(label: '4 次', onPressed: () {}),
                    _SubmenuItem(label: '5 次', onPressed: () {}),
                    _SubmenuItem(label: '自定义', onPressed: () {}),
                  ]),
                ),
                // 添加备注
                _CustomMenuItem(
                  label: '添加备注',
                  onPressed: () {},
                  onHover: (_) => _closeSubmenu(),
                ),
                // SSL代理 >
                _CustomMenuItem(
                  label: 'SSL代理',
                  hasSubmenu: true,
                  onHover: (ctx) => _openSubmenu(ctx, [
                    _SubmenuItem(label: '新建', onPressed: () {}),
                  ]),
                ),
                // 镜像
                _CustomMenuItem(
                  label: '镜像',
                  onPressed: () {},
                  onHover: (_) => _closeSubmenu(),
                ),
                // 网关 >
                _CustomMenuItem(
                  label: '网关',
                  hasSubmenu: true,
                  onHover: (ctx) => _openSubmenu(ctx, [
                    _SubmenuItem(label: '仅允许', onPressed: () {}),
                    _SubmenuItem(label: '静默', onPressed: () {}),
                    _SubmenuItem(label: '屏蔽请求', onPressed: () {}),
                    _SubmenuItem(label: '屏蔽响应', onPressed: () {}),
                    _SubmenuItem(label: '挂起请求', onPressed: () {}),
                    _SubmenuItem(label: '挂起响应', onPressed: () {}),
                  ]),
                ),
                // 脚本
                _CustomMenuItem(
                  label: '脚本',
                  onPressed: () {},
                  onHover: (_) => _closeSubmenu(),
                ),
                // 重写 >
                _CustomMenuItem(
                  label: '重写',
                  hasSubmenu: true,
                  onHover: (ctx) => _openSubmenu(ctx, [
                    _SubmenuItem(label: '重定向URL', onPressed: () {}),
                    _SubmenuItem(label: '替换请求', onPressed: () {}),
                    _SubmenuItem(label: '替换响应', onPressed: () {}),
                    _SubmenuItem(label: '修改请求', onPressed: () {}),
                    _SubmenuItem(label: '修改响应', onPressed: () {}),
                  ]),
                ),
                // 断点
                _CustomMenuItem(
                  label: '断点',
                  onPressed: () {},
                  onHover: (_) => _closeSubmenu(),
                ),
                const _MenuDivider(),
                // 高亮 >
                _CustomMenuItem(
                  label: '高亮',
                  hasSubmenu: true,
                  onHover: (ctx) => _openSubmenu(ctx, [
                    _SubmenuItem(label: '红色', shortcut: 'Alt+1', onPressed: () {}),
                    _SubmenuItem(label: '黄色', shortcut: 'Alt+2', onPressed: () {}),
                    _SubmenuItem(label: '绿色', shortcut: 'Alt+3', onPressed: () {}),
                    _SubmenuItem(label: '蓝色', shortcut: 'Alt+4', onPressed: () {}),
                    _SubmenuItem(label: '青色', shortcut: 'Alt+5', onPressed: () {}),
                    _SubmenuItem(label: '划线', shortcut: 'Alt+-', onPressed: () {}),
                    const _SubmenuDivider(),
                    _SubmenuItem(label: '标记已阅', isChecked: true, onPressed: () {}),
                    const _SubmenuDivider(),
                    _SubmenuItem(label: '重置', shortcut: 'Alt+0', onPressed: () {}),
                    _SubmenuItem(label: '自动', onPressed: () {}),
                  ]),
                ),
                // 书签 >
                _CustomMenuItem(
                  label: '书签',
                  hasSubmenu: true,
                  onHover: (ctx) => _openSubmenu(ctx, [
                    _SubmenuItem(label: '添加域名', onPressed: () {}),
                    _SubmenuItem(label: '添加路径', onPressed: () {}),
                  ]),
                ),
                // 添加到 >
                _CustomMenuItem(
                  label: '添加到',
                  hasSubmenu: true,
                  onHover: (ctx) => _openSubmenu(ctx, [
                    _SubmenuItem(label: 'API集合', shortcut: 'Ctrl+I', onPressed: () {}),
                    _SubmenuItem(label: '新会话', onPressed: () {}),
                    _SubmenuItem(label: '我的收藏', onPressed: () {}),
                  ]),
                ),
                // 删除
                _CustomMenuItem(
                  label: '删除',
                  shortcut: 'Delete',
                  onPressed: widget.selectedItems.isEmpty
                      ? null
                      : () => widget.onDelete(widget.selectedItems),
                  onHover: (_) => _closeSubmenu(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomMenuItem extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final Function(BuildContext)? onHover;
  final String? shortcut;
  final bool hasSubmenu;

  const _CustomMenuItem({
    required this.label,
    this.onPressed,
    this.onHover,
    this.shortcut,
    this.hasSubmenu = false,
  });

  @override
  State<_CustomMenuItem> createState() => _CustomMenuItemState();
}

class _CustomMenuItemState extends State<_CustomMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.onPressed == null && widget.onHover == null;

    return MouseRegion(
      onEnter: (_) {
        if (!isDisabled) {
          setState(() => _isHovered = true);
          if (widget.onHover != null) {
            widget.onHover!(context);
          }
        }
      },
      onExit: (_) {
        if (!isDisabled) setState(() => _isHovered = false);
      },
      child: GestureDetector(
        onTap: () {
          if (isDisabled) return;
          if (widget.onPressed != null) {
            widget.onPressed!();
          }
        },
        child: Container(
          color: _isHovered ? const Color(0xFFFF9800) : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    color: isDisabled ? Colors.grey : Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
              if (widget.shortcut != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    widget.shortcut!,
                    style: TextStyle(
                      color: isDisabled ? Colors.grey : (_isHovered ? Colors.white : Colors.grey),
                      fontSize: 12,
                    ),
                  ),
                ),
              if (widget.hasSubmenu)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: isDisabled ? Colors.grey : Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuDivider extends StatelessWidget {
  const _MenuDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFF3E3E3E),
    );
  }
}

class _SubmenuItem extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final String? shortcut;
  final bool isChecked;

  const _SubmenuItem({
    required this.label,
    required this.onPressed,
    this.shortcut,
    this.isChecked = false,
  });

  @override
  State<_SubmenuItem> createState() => _SubmenuItemState();
}

class _SubmenuItemState extends State<_SubmenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          color: _isHovered ? const Color(0xFFFF9800) : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              if (widget.isChecked)
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(Icons.check, size: 16, color: Colors.white),
                )
              else
                const SizedBox(width: 24), // Placeholder for check icon
              Expanded(
                child: Text(
                  widget.label,
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                ),
              ),
              if (widget.shortcut != null)
                Text(
                  widget.shortcut!,
                  style: TextStyle(
                    fontSize: 12,
                    color: _isHovered ? Colors.white : Colors.grey,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubmenuDivider extends StatelessWidget {
  const _SubmenuDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFF3E3E3E),
    );
  }
}
