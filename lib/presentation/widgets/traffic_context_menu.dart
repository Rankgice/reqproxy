import 'package:flutter/material.dart';
import 'package:context_menus/context_menus.dart';

class TrafficContextMenu extends StatefulWidget {
  const TrafficContextMenu({super.key});

  @override
  State<TrafficContextMenu> createState() => _TrafficContextMenuState();
}

class _TrafficContextMenuState extends State<TrafficContextMenu> with ContextMenuStateMixin {
  @override
  Widget build(BuildContext context) {
    return cardBuilder.call(
      context,
      [
        buttonBuilder.call(
          context,
          ContextMenuButtonConfig(
            '复制cURL',
            onPressed: () => handlePressed(context, () {}),
            shortcutLabel: 'Ctrl+Shift+C',
          ),
        ),
        SubmenuButton(
          menuChildren: <Widget>[
            buttonBuilder.call(context, ContextMenuButtonConfig('URL', onPressed: () => handlePressed(context, () {}))),
            buttonBuilder.call(context, ContextMenuButtonConfig('Host', onPressed: () => handlePressed(context, () {}))),
            buttonBuilder.call(context, ContextMenuButtonConfig('Body', onPressed: () => handlePressed(context, () {}))),
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
            onPressed: () => handlePressed(context, () {}),
            shortcutLabel: 'Delete',
          ),
        ),
      ],
    );
  }
}
