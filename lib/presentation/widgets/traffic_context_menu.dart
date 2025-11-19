import 'package:flutter/material.dart';
import 'package:context_menus/context_menus.dart';
import 'package:flutter/services.dart';
import 'package:reqproxy/core/models/traffic_item.dart';

class TrafficContextMenu extends StatefulWidget {
  final List<TrafficItem> selectedItems;
  final Function(List<TrafficItem>) onDelete;
  const TrafficContextMenu({super.key, required this.selectedItems, required this.onDelete});

  @override
  State<TrafficContextMenu> createState() => _TrafficContextMenuState();
}

class _TrafficContextMenuState extends State<TrafficContextMenu> with ContextMenuStateMixin {
  void _copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
    // TODO: Find the correct way to close the context menu.
    // close(); 
  }

  @override
  Widget build(BuildContext context) {
    final firstItem = widget.selectedItems.isNotEmpty ? widget.selectedItems.first : null;
    final bool canCopy = firstItem != null;

    return cardBuilder.call(
      context,
      [
        buttonBuilder.call(
          context,
          ContextMenuButtonConfig(
            '复制cURL',
            onPressed: !canCopy
                ? null
                : () => handlePressed(context, () {
                      // TODO: Implement cURL generation
                      _copy('curl "${firstItem.url}"');
                    }),
            shortcutLabel: 'Ctrl+Shift+C',
          ),
        ),
        SubmenuButton(
          menuChildren: <Widget>[
            buttonBuilder.call(
                context,
                ContextMenuButtonConfig('URL',
                    onPressed: !canCopy ? null : () => handlePressed(context, () => _copy(firstItem.url)))),
            buttonBuilder.call(
                context,
                ContextMenuButtonConfig('Host',
                    onPressed: !canCopy ? null : () => handlePressed(context, () => _copy(firstItem.uri.host)))),
            buttonBuilder.call(
                context,
                ContextMenuButtonConfig('Body',
                    onPressed: !canCopy
                        ? null
                        : () => handlePressed(context, () {
                              // TODO: Implement body copy
                              _copy('Body not implemented yet');
                            }))),
          ],
          child: const Text('复制'),
        ),
        SubmenuButton(
          menuChildren: <Widget>[
            buttonBuilder.call(context, ContextMenuButtonConfig('全部', onPressed: () => handlePressed(context, () {}))),
            buttonBuilder.call(context, ContextMenuButtonConfig('反选', onPressed: () => handlePressed(context, () {}))),
          ],
          child: const Text('选择'),
        ),
        buttonBuilder.call(context, ContextMenuButtonConfig('查看', onPressed: () => handlePressed(context, () {}))),
        buttonBuilder.call(context, ContextMenuButtonConfig('对比', onPressed: () => handlePressed(context, () {}))),
        const Divider(),
        buttonBuilder.call(context, ContextMenuButtonConfig('导出', onPressed: () => handlePressed(context, () {}))),
        const Divider(),
        buttonBuilder.call(
          context,
          ContextMenuButtonConfig(
            '编辑',
            onPressed: () => handlePressed(context, () {}),
            shortcutLabel: 'Ctrl+Shift+Enter',
          ),
        ),
        buttonBuilder.call(context, ContextMenuButtonConfig('重发', onPressed: () => handlePressed(context, () {}))),
        buttonBuilder.call(context, ContextMenuButtonConfig('添加备注', onPressed: () => handlePressed(context, () {}))),
        const Divider(),
        buttonBuilder.call(context, ContextMenuButtonConfig('SSL代理', onPressed: () => handlePressed(context, () {}))),
        const Divider(),
        buttonBuilder.call(context, ContextMenuButtonConfig('镜像', onPressed: () => handlePressed(context, () {}))),
        buttonBuilder.call(context, ContextMenuButtonConfig('网关', onPressed: () => handlePressed(context, () {}))),
        buttonBuilder.call(context, ContextMenuButtonConfig('脚本', onPressed: () => handlePressed(context, () {}))),
        buttonBuilder.call(context, ContextMenuButtonConfig('重写', onPressed: () => handlePressed(context, () {}))),
        buttonBuilder.call(context, ContextMenuButtonConfig('断点', onPressed: () => handlePressed(context, () {}))),
        const Divider(),
        buttonBuilder.call(context, ContextMenuButtonConfig('高亮', onPressed: () => handlePressed(context, () {}))),
        buttonBuilder.call(context, ContextMenuButtonConfig('书签', onPressed: () => handlePressed(context, () {}))),
        const Divider(),
        buttonBuilder.call(context, ContextMenuButtonConfig('添加到', onPressed: () => handlePressed(context, () {}))),
        buttonBuilder.call(
          context,
          ContextMenuButtonConfig(
            '删除',
            onPressed: widget.selectedItems.isEmpty
                ? null
                : () => handlePressed(context, () => widget.onDelete(widget.selectedItems)),
            shortcutLabel: 'Delete',
          ),
        ),
      ],
    );
  }
}
