import 'package:flutter/material.dart';

class ReqableCustomMenuItem {
  final String label;
  final String? shortcut;
  final VoidCallback? onPressed;
  final List<ReqableCustomMenuItem>? subItems;
  final bool isChecked;
  final bool isDivider;

  const ReqableCustomMenuItem({
    required this.label,
    this.shortcut,
    this.onPressed,
    this.subItems,
    this.isChecked = false,
    this.isDivider = false,
  });

  const ReqableCustomMenuItem.divider()
      : label = '',
        shortcut = null,
        onPressed = null,
        subItems = null,
        isChecked = false,
        isDivider = true;
}

class ReqableCustomMenu extends StatefulWidget {
  final List<ReqableCustomMenuItem> items;
  final VoidCallback? onMenuClosed;

  const ReqableCustomMenu({
    super.key,
    required this.items,
    this.onMenuClosed,
  });

  @override
  State<ReqableCustomMenu> createState() => _ReqableCustomMenuState();
}

class _ReqableCustomMenuState extends State<ReqableCustomMenu> {
  OverlayEntry? _submenuEntry;

  void _closeSubmenu() {
    _submenuEntry?.remove();
    _submenuEntry = null;
  }

  void _openSubmenu(BuildContext itemContext, List<ReqableCustomMenuItem> items) {
    _closeSubmenu();

    final RenderBox renderBox = itemContext.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;
    final Rect parentRect = offset & size;
    final Size screenSize = MediaQuery.of(context).size;

    _submenuEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          CustomSingleChildLayout(
            delegate: _SubmenuLayoutDelegate(
              parentRect: parentRect,
              screenSize: screenSize,
            ),
            child: ReqableCustomMenu(
              items: items,
              onMenuClosed: () {
                _closeSubmenu();
                widget.onMenuClosed?.call();
              },
            ),
          ),
        ],
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
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 220), // Slightly wider to accommodate shortcuts
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
            children: widget.items.map((item) {
              if (item.isDivider) {
                return const _MenuDivider();
              }
              return _CustomMenuItemWidget(
                item: item,
                onHover: (ctx) {
                  if (item.subItems != null && item.subItems!.isNotEmpty) {
                    _openSubmenu(ctx, item.subItems!);
                  } else {
                    _closeSubmenu();
                  }
                },
                onPressed: () {
                  if (item.subItems == null || item.subItems!.isEmpty) {
                    _closeSubmenu();
                    widget.onMenuClosed?.call();
                    item.onPressed?.call();
                  }
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _CustomMenuItemWidget extends StatefulWidget {
  final ReqableCustomMenuItem item;
  final Function(BuildContext) onHover;
  final VoidCallback onPressed;

  const _CustomMenuItemWidget({
    required this.item,
    required this.onHover,
    required this.onPressed,
  });

  @override
  State<_CustomMenuItemWidget> createState() => _CustomMenuItemWidgetState();
}

class _CustomMenuItemWidgetState extends State<_CustomMenuItemWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.item.onPressed == null && (widget.item.subItems == null || widget.item.subItems!.isEmpty);
    final bool hasSubmenu = widget.item.subItems != null && widget.item.subItems!.isNotEmpty;

    return MouseRegion(
      onEnter: (_) {
        if (!isDisabled) {
          setState(() => _isHovered = true);
          widget.onHover(context);
        }
      },
      onExit: (_) {
        if (!isDisabled) setState(() => _isHovered = false);
      },
      child: GestureDetector(
        onTap: isDisabled ? null : widget.onPressed,
        child: Container(
          color: _isHovered ? const Color(0xFFFF9800) : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
               if (widget.item.isChecked)
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(Icons.check, size: 16, color: Colors.white),
                )
              else
                 // Keep alignment consistent even if no check
                 // But wait, the original context menu had different alignment for top level vs sub items?
                 // Looking at the original code:
                 // _CustomMenuItem (top level) didn't have check support in the code I saw, but _SubmenuItem did.
                 // _SubmenuItem had `if (widget.isChecked) ... else SizedBox(width: 24)`
                 // Let's try to be smart. If any item in the menu has a check, we might want to reserve space.
                 // For now, let's just add the check if it's there.
                 // Actually, the screenshot shows top level items don't have checks usually.
                 // But let's support it.
                 const SizedBox(width: 0), 
              
              Expanded(
                child: Text(
                  widget.item.label,
                  style: TextStyle(
                    color: isDisabled ? Colors.grey : Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
              if (widget.item.shortcut != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    widget.item.shortcut!,
                    style: TextStyle(
                      color: isDisabled ? Colors.grey : (_isHovered ? Colors.white : Colors.grey),
                      fontSize: 12,
                    ),
                  ),
                ),
              if (hasSubmenu)
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

class _SubmenuLayoutDelegate extends SingleChildLayoutDelegate {
  final Rect parentRect;
  final Size screenSize;

  _SubmenuLayoutDelegate({
    required this.parentRect,
    required this.screenSize,
  });

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints.loose(screenSize);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double dx = parentRect.right;
    double dy = parentRect.top;

    if (dx + childSize.width > screenSize.width) {
      dx = parentRect.left - childSize.width;
    }

    if (dy + childSize.height > screenSize.height) {
      dy = screenSize.height - childSize.height;
    }

    if (dx < 0) dx = 0;
    if (dy < 0) dy = 0;

    return Offset(dx, dy);
  }

  @override
  bool shouldRelayout(_SubmenuLayoutDelegate oldDelegate) {
    return parentRect != oldDelegate.parentRect || screenSize != oldDelegate.screenSize;
  }
}
