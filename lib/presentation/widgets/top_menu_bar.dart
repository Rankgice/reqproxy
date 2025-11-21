import 'package:flutter/material.dart';
import 'package:reqproxy/presentation/widgets/reqable_custom_menu.dart';

class TopMenuBar extends StatelessWidget {
  const TopMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TopMenuButton(
          label: '文件',
          items: [
            ReqableCustomMenuItem(label: '新建HTTP', shortcut: 'Ctrl+T', onPressed: () {}),
            ReqableCustomMenuItem(label: '新建WebSocket', onPressed: () {}),
            const ReqableCustomMenuItem.divider(),
            ReqableCustomMenuItem(label: '打开文件', shortcut: 'Ctrl+O', onPressed: () {}),
            ReqableCustomMenuItem(label: '打开最近', onPressed: null), // Disabled
            ReqableCustomMenuItem(label: '从剪切板打开', shortcut: 'Shift+Ctrl+O', onPressed: () {}),
            const ReqableCustomMenuItem.divider(),
            ReqableCustomMenuItem(label: '关闭Tab', shortcut: 'Ctrl+W', onPressed: () {}),
            ReqableCustomMenuItem(label: '关闭全部Tab', shortcut: 'Shift+Ctrl+W', onPressed: () {}),
            const ReqableCustomMenuItem.divider(),
            ReqableCustomMenuItem(label: '退出Reqable', onPressed: () {}),
          ],
        ),
        _TopMenuButton(
          label: '工具',
          items: [
            ReqableCustomMenuItem(label: 'SSL代理', shortcut: 'Ctrl+Alt+P', onPressed: () {}),
            const ReqableCustomMenuItem.divider(),
            ReqableCustomMenuItem(label: '镜像', shortcut: 'Alt+M', onPressed: () {}),
            ReqableCustomMenuItem(label: '网关', shortcut: 'Alt+G', onPressed: () {}),
            ReqableCustomMenuItem(label: '重写', shortcut: 'Alt+K', onPressed: () {}),
            ReqableCustomMenuItem(label: '断点', shortcut: 'Alt+B', onPressed: () {}),
            ReqableCustomMenuItem(label: '脚本', shortcut: 'Alt+P', onPressed: () {}),
            const ReqableCustomMenuItem.divider(),
            ReqableCustomMenuItem(label: '脚本环境', onPressed: () {}),
            const ReqableCustomMenuItem.divider(),
            ReqableCustomMenuItem(label: '网络限制', shortcut: 'Alt+J', onPressed: () {}),
            ReqableCustomMenuItem(label: '报告服务器', onPressed: () {}),
            ReqableCustomMenuItem(label: '代理终端', shortcut: 'Alt+T', onPressed: () {}),
            const ReqableCustomMenuItem.divider(),
            ReqableCustomMenuItem(
              label: '解码',
              subItems: [
                ReqableCustomMenuItem(label: 'Base64', onPressed: () {}),
                ReqableCustomMenuItem(label: 'URL', onPressed: () {}),
                ReqableCustomMenuItem(label: 'JWT', onPressed: () {}),
              ],
            ),
            ReqableCustomMenuItem(
              label: '编码',
              subItems: [
                ReqableCustomMenuItem(label: 'Base64', onPressed: () {}),
                ReqableCustomMenuItem(label: 'URL', onPressed: () {}),
              ],
            ),
            ReqableCustomMenuItem(
              label: '消息摘要',
              subItems: [
                ReqableCustomMenuItem(label: 'MD5', onPressed: () {}),
                ReqableCustomMenuItem(label: 'SHA-1', onPressed: () {}),
                ReqableCustomMenuItem(label: 'SHA-224', onPressed: () {}),
                ReqableCustomMenuItem(label: 'SHA-256', onPressed: () {}),
                ReqableCustomMenuItem(label: 'SHA-384', onPressed: () {}),
                ReqableCustomMenuItem(label: 'SHA-512', onPressed: () {}),
                ReqableCustomMenuItem(label: 'SHA-512/224', onPressed: () {}),
                ReqableCustomMenuItem(label: 'SHA-512/256', onPressed: () {}),
              ],
            ),
            ReqableCustomMenuItem(
              label: '加密',
              subItems: [
                ReqableCustomMenuItem(label: 'AES - CBC', onPressed: () {}),
                ReqableCustomMenuItem(label: 'AES - CFB', onPressed: () {}),
                ReqableCustomMenuItem(label: 'AES - CTR', onPressed: () {}),
                ReqableCustomMenuItem(label: 'AES - ECB', onPressed: () {}),
                ReqableCustomMenuItem(label: 'AES - OFB', onPressed: () {}),
                ReqableCustomMenuItem(label: 'AES - SIC', onPressed: () {}),
                ReqableCustomMenuItem(label: 'AES - GCM', onPressed: () {}),
              ],
            ),
            ReqableCustomMenuItem(
              label: '解密',
              subItems: [
                ReqableCustomMenuItem(label: 'AES - CBC', onPressed: () {}),
                ReqableCustomMenuItem(label: 'AES - CFB', onPressed: () {}),
                ReqableCustomMenuItem(label: 'AES - CTR', onPressed: () {}),
                ReqableCustomMenuItem(label: 'AES - ECB', onPressed: () {}),
                ReqableCustomMenuItem(label: 'AES - OFB', onPressed: () {}),
                ReqableCustomMenuItem(label: 'AES - SIC', onPressed: () {}),
                ReqableCustomMenuItem(label: 'AES - GCM', onPressed: () {}),
              ],
            ),
            ReqableCustomMenuItem(
              label: '视图',
              subItems: [
                ReqableCustomMenuItem(label: 'JSON', onPressed: () {}),
                ReqableCustomMenuItem(label: 'XML', onPressed: () {}),
                ReqableCustomMenuItem(label: 'Hex', onPressed: () {}),
                ReqableCustomMenuItem(label: '图片', onPressed: () {}),
                ReqableCustomMenuItem(label: '色彩', onPressed: () {}),
              ],
            ),
            const ReqableCustomMenuItem.divider(),
            ReqableCustomMenuItem(
              label: '更多',
              subItems: [
                ReqableCustomMenuItem(label: '时间戳', onPressed: () {}),
                ReqableCustomMenuItem(label: 'UUID', onPressed: () {}),
                ReqableCustomMenuItem(label: '二维码', onPressed: () {}),
              ],
            ),
          ],
        ),
        _TopMenuButton(
          label: '视图',
          items: [
            ReqableCustomMenuItem(label: '工作台', shortcut: 'F1', onPressed: () {}),
            ReqableCustomMenuItem(label: '集合', shortcut: 'F2', onPressed: () {}),
            ReqableCustomMenuItem(label: '环境变量', shortcut: 'F3', onPressed: () {}),
            ReqableCustomMenuItem(label: '历史', shortcut: 'F4', onPressed: () {}),
            ReqableCustomMenuItem(label: '工具箱', shortcut: 'F5', onPressed: () {}),
            const ReqableCustomMenuItem.divider(),
            ReqableCustomMenuItem(label: '展开侧边栏', shortcut: 'Shift+Ctrl+[', onPressed: () {}),
            ReqableCustomMenuItem(label: '垂直布局', shortcut: 'Shift+Ctrl+]', onPressed: () {}),
            ReqableCustomMenuItem(label: '禅模式', shortcut: 'Shift+Ctrl+\\', onPressed: () {}),
            const ReqableCustomMenuItem.divider(),
            ReqableCustomMenuItem(label: '放大', shortcut: 'Ctrl+=', onPressed: () {}),
            ReqableCustomMenuItem(label: '缩小', shortcut: 'Ctrl+-', onPressed: () {}),
            ReqableCustomMenuItem(label: '重置缩放', onPressed: () {}),
          ],
        ),
        _TopMenuButton(
          label: '代理',
          items: [
            ReqableCustomMenuItem(label: '系统代理', shortcut: 'F12', onPressed: () {}),
            ReqableCustomMenuItem(label: '自动启用', isChecked: true, onPressed: () {}),
            const ReqableCustomMenuItem.divider(),
            ReqableCustomMenuItem(label: 'Web 代理', isChecked: true, onPressed: () {}),
            ReqableCustomMenuItem(label: 'Socks 代理', onPressed: () {}),
            const ReqableCustomMenuItem.divider(),
            ReqableCustomMenuItem(
              label: '代理规则',
              isChecked: true,
              subItems: [
                ReqableCustomMenuItem(label: 'ip:port', isChecked: true, onPressed: () {}),
                ReqableCustomMenuItem(label: 'http=http://ip:port;https=http://ip:p...', onPressed: () {}),
                ReqableCustomMenuItem(label: 'http=ip:port;https=ip:port', onPressed: () {}),
              ],
            ),
            ReqableCustomMenuItem(
              label: '配置回环',
              isChecked: true,
              subItems: const [], // Empty as per screenshot
            ),
            const ReqableCustomMenuItem.divider(),
            ReqableCustomMenuItem(
              label: '二级代理',
              isChecked: true,
              subItems: [
                ReqableCustomMenuItem(label: '禁用', onPressed: () {}),
                ReqableCustomMenuItem(label: 'clash', isChecked: true, onPressed: () {}),
                ReqableCustomMenuItem(label: '新建配置', onPressed: () {}),
                ReqableCustomMenuItem(label: '管理配置', onPressed: () {}),
              ],
            ),
            ReqableCustomMenuItem(
              label: '反向代理',
              subItems: [
                ReqableCustomMenuItem(label: '启用', onPressed: () {}),
                ReqableCustomMenuItem(label: '新建配置', onPressed: () {}),
                ReqableCustomMenuItem(label: '管理配置', onPressed: () {}),
              ],
            ),
            const ReqableCustomMenuItem.divider(),
            ReqableCustomMenuItem(
              label: '访问控制',
              subItems: [
                ReqableCustomMenuItem(label: '启用', onPressed: () {}),
                ReqableCustomMenuItem(label: '新建', onPressed: () {}),
                ReqableCustomMenuItem(label: '管理配置', onPressed: () {}),
              ],
            ),
          ],
        ),
        _TopMenuButton(
          label: '证书',
          items: [
            ReqableCustomMenuItem(label: '安装根证书到本机', onPressed: () {}),
            ReqableCustomMenuItem(label: '安装根证书到Android设备', onPressed: () {}),
            ReqableCustomMenuItem(label: '安装根证书到iOS设备', onPressed: () {}),
            ReqableCustomMenuItem(label: '安装根证书到Firefox浏览器', onPressed: () {}),
            const ReqableCustomMenuItem.divider(),
            ReqableCustomMenuItem(label: '查看根证书', onPressed: () {}),
            ReqableCustomMenuItem(
              label: '根证书管理',
              subItems: [
                ReqableCustomMenuItem(label: '导入根证书(.p12)', onPressed: () {}),
                ReqableCustomMenuItem(label: '重新生成根证书', onPressed: () {}),
                const ReqableCustomMenuItem.divider(),
                ReqableCustomMenuItem(label: '导出根公钥证书(.crt)', onPressed: () {}),
                ReqableCustomMenuItem(label: '导出根公钥证书(.pem)', onPressed: () {}),
                ReqableCustomMenuItem(label: '导出根公钥证书(.0)', onPressed: () {}),
                ReqableCustomMenuItem(label: '导出根证书(.p12)', onPressed: () {}),
              ],
            ),
            ReqableCustomMenuItem(label: 'SSL证书', onPressed: () {}),
          ],
        ),
        _TopMenuButton(
          label: '帮助',
          items: [
            ReqableCustomMenuItem(label: '账号', onPressed: () {}),
            ReqableCustomMenuItem(label: '快捷键', onPressed: () {}),
            const ReqableCustomMenuItem.divider(),
            ReqableCustomMenuItem(label: '网站', onPressed: () {}),
            ReqableCustomMenuItem(label: '文档', onPressed: () {}),
            ReqableCustomMenuItem(label: 'Github', onPressed: () {}),
            const ReqableCustomMenuItem.divider(),
            ReqableCustomMenuItem(label: '数据恢复', onPressed: () {}),
            ReqableCustomMenuItem(label: '问题反馈', onPressed: () {}),
            ReqableCustomMenuItem(label: '服务条款', onPressed: () {}),
            const ReqableCustomMenuItem.divider(),
            ReqableCustomMenuItem(label: '更新日志', onPressed: () {}),
            ReqableCustomMenuItem(label: '检查更新...', onPressed: () {}),
          ],
        ),
      ],
    );
  }
}

class _TopMenuButton extends StatefulWidget {
  final String label;
  final List<ReqableCustomMenuItem> items;

  const _TopMenuButton({
    required this.label,
    required this.items,
  });

  @override
  State<_TopMenuButton> createState() => _TopMenuButtonState();
}

class _TopMenuButtonState extends State<_TopMenuButton> {
  OverlayEntry? _menuEntry;
  bool _isOpen = false;

  void _toggleMenu() {
    if (_isOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _closeMenu() {
    _menuEntry?.remove();
    _menuEntry = null;
    setState(() => _isOpen = false);
  }

  void _openMenu() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    _menuEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _closeMenu,
              onPanStart: (_) => _closeMenu(),
            ),
          ),
          Positioned(
            left: offset.dx,
            top: offset.dy + size.height,
            child: ReqableCustomMenu(
              items: widget.items,
              onMenuClosed: _closeMenu,
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_menuEntry!);
    setState(() => _isOpen = true);
  }

  @override
  void dispose() {
    _closeMenu();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _toggleMenu,
      style: TextButton.styleFrom(
        backgroundColor: _isOpen ? const Color(0xFF333333) : Colors.transparent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        minimumSize: const Size(0, 30),
      ),
      child: Text(widget.label),
    );
  }
}
