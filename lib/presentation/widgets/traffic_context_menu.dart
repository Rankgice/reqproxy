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
  void _copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  @override
  Widget build(BuildContext context) {
    final firstItem = widget.selectedItems.isNotEmpty ? widget.selectedItems.first : null;
    final bool canCopy = firstItem != null;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 250),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CustomMenuItem(
              label: '复制cURL',
              shortcut: 'Ctrl+Shift+C',
              onPressed: !canCopy
                  ? null
                  : () {
                      _copy('curl "${firstItem!.url}"');
                    },
            ),
            _CustomMenuItem(
              label: '复制',
              hasSubmenu: true,
              onPressedContext: !canCopy ? null : (ctx) => _showSubmenu(ctx, []), // TODO: Add copy items
            ),
            _CustomMenuItem(
              label: '选择',
              hasSubmenu: true,
              onPressedContext: (ctx) {
                _showSubmenu(
                  ctx,
                  [
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
                  ],
                );
              },
            ),
            _CustomMenuItem(
              label: '查看',
              hasSubmenu: true,
              onPressedContext: (ctx) => _showSubmenu(ctx, []),
            ),
            _CustomMenuItem(
              label: '对比',
              hasSubmenu: true,
              onPressedContext: (ctx) => _showSubmenu(ctx, []),
            ),
            const _MenuDivider(),
            _CustomMenuItem(
              label: '导出',
              hasSubmenu: true,
              onPressedContext: (ctx) => _showSubmenu(ctx, []),
            ),
            const _MenuDivider(),
            _CustomMenuItem(
              label: '编辑',
              shortcut: 'Ctrl+Shift+Enter',
              onPressed: () {},
            ),
            _CustomMenuItem(
              label: '重发',
              hasSubmenu: true,
              onPressedContext: (ctx) => _showSubmenu(ctx, []),
            ),
            _CustomMenuItem(
              label: '添加备注',
              onPressed: () {},
            ),
            const _MenuDivider(),
            _CustomMenuItem(
              label: 'SSL代理',
              hasSubmenu: true,
              onPressedContext: (ctx) => _showSubmenu(ctx, []),
            ),
            const _MenuDivider(),
            _CustomMenuItem(
              label: '镜像',
              onPressed: () {},
            ),
            _CustomMenuItem(
              label: '网关',
              hasSubmenu: true,
              onPressedContext: (ctx) => _showSubmenu(ctx, []),
            ),
            _CustomMenuItem(
              label: '脚本',
              onPressed: () {},
            ),
            _CustomMenuItem(
              label: '重写',
              hasSubmenu: true,
              onPressedContext: (ctx) => _showSubmenu(ctx, []),
            ),
            _CustomMenuItem(
              label: '断点',
              onPressed: () {},
            ),
            const _MenuDivider(),
            _CustomMenuItem(
              label: '高亮',
              hasSubmenu: true,
              onPressedContext: (ctx) => _showSubmenu(ctx, []),
            ),
            _CustomMenuItem(
              label: '书签',
              hasSubmenu: true,
              onPressedContext: (ctx) => _showSubmenu(ctx, []),
            ),
            const _MenuDivider(),
            _CustomMenuItem(
              label: '添加到',
              hasSubmenu: true,
              onPressedContext: (ctx) => _showSubmenu(ctx, []),
            ),
            _CustomMenuItem(
              label: '删除',
              shortcut: 'Delete',
              onPressed: widget.selectedItems.isEmpty
                  ? null
                  : () => widget.onDelete(widget.selectedItems),
            ),
          ],
        ),
      ),
    );
  }

  void _showSubmenu(BuildContext itemContext, List<PopupMenuEntry> items) {
    if (items.isEmpty) return;

    final RenderBox renderBox = itemContext.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    // Calculate position: to the right of the item, aligned with top
    final RelativeRect position = RelativeRect.fromLTRB(
      offset.dx + size.width,
      offset.dy,
      offset.dx + size.width + 200, // Arbitrary right bound, showMenu handles constraints
      offset.dy + size.height + items.length * 40.0, // Estimate height
    );

    showMenu(
      context: context,
      position: position,
      items: items,
      color: const Color(0xFF2B2B2B),
      elevation: 8,
    );
  }
}

class _CustomMenuItem extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final void Function(BuildContext)? onPressedContext;
  final String? shortcut;
  final bool hasSubmenu;

  const _CustomMenuItem({
    required this.label,
    this.onPressed,
    this.onPressedContext,
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
    final bool isDisabled = widget.onPressed == null && widget.onPressedContext == null;

    return MouseRegion(
      onEnter: (_) {
        if (!isDisabled) setState(() => _isHovered = true);
      },
      onExit: (_) {
        if (!isDisabled) setState(() => _isHovered = false);
      },
      child: GestureDetector(
        onTap: () {
          if (isDisabled) return;
          if (widget.onPressed != null) {
            widget.onPressed!();
          } else if (widget.onPressedContext != null) {
            widget.onPressedContext!(context);
          }
        },
        child: Container(
          color: _isHovered ? const Color(0xFFFF9800) : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                Text(
                  widget.shortcut!,
                  style: TextStyle(
                    color: isDisabled ? Colors.grey : (_isHovered ? Colors.white : Colors.grey),
                    fontSize: 12,
                  ),
                ),
              if (widget.hasSubmenu)
                Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: isDisabled ? Colors.grey : Colors.white,
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

class _SubmenuItem extends PopupMenuItem {
  _SubmenuItem({
    required String label,
    required VoidCallback onPressed,
    String? shortcut,
  }) : super(
          onTap: onPressed,
          height: 32,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 13, color: Colors.white)),
              if (shortcut != null)
                Text(shortcut, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        );
}

class _SubmenuDivider extends PopupMenuDivider {
  const _SubmenuDivider() : super(height: 1);
}
