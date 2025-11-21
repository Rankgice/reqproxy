import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TopMenuBar extends StatelessWidget {
  const TopMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuBar(
      style: MenuStyle(
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        elevation: MaterialStateProperty.all(0),
        padding: MaterialStateProperty.all(EdgeInsets.zero),
      ),
      children: [
        _buildFileMenu(context),
        _buildToolsMenu(context),
        _buildViewMenu(context),
        _buildProxyMenu(context),
        _buildCertificateMenu(context),
        _buildHelpMenu(context),
      ],
    );
  }

  SubmenuButton _buildFileMenu(BuildContext context) {
    return SubmenuButton(
      menuChildren: [
        MenuItemButton(
          onPressed: () {},
          shortcut: const SingleActivator(LogicalKeyboardKey.keyT, control: true),
          child: const Text('新建HTTP'),
        ),
        MenuItemButton(
          onPressed: () {},
          child: const Text('新建WebSocket'),
        ),
        const Divider(),
        MenuItemButton(
          onPressed: () {},
          shortcut: const SingleActivator(LogicalKeyboardKey.keyO, control: true),
          child: const Text('打开文件'),
        ),
        MenuItemButton(
          onPressed: null, // Disabled
          child: const Text('打开最近'),
        ),
        MenuItemButton(
          onPressed: () {},
          shortcut: const SingleActivator(LogicalKeyboardKey.keyO, control: true, shift: true),
          child: const Text('从剪切板打开'),
        ),
        const Divider(),
        MenuItemButton(
          onPressed: () {},
          shortcut: const SingleActivator(LogicalKeyboardKey.keyW, control: true),
          child: const Text('关闭Tab'),
        ),
        MenuItemButton(
          onPressed: () {},
          shortcut: const SingleActivator(LogicalKeyboardKey.keyW, control: true, shift: true),
          child: const Text('关闭全部Tab'),
        ),
        const Divider(),
        MenuItemButton(
          onPressed: () {},
          child: const Text('退出Reqable'),
        ),
      ],
      child: const Text('文件'),
    );
  }

  SubmenuButton _buildToolsMenu(BuildContext context) {
    return SubmenuButton(
      menuChildren: [
        MenuItemButton(
          onPressed: () {},
          shortcut: const SingleActivator(LogicalKeyboardKey.keyP, control: true, alt: true),
          child: const Text('SSL代理'),
        ),
        const Divider(),
        MenuItemButton(
          onPressed: () {},
          shortcut: const SingleActivator(LogicalKeyboardKey.keyM, alt: true),
          child: const Text('镜像'),
        ),
        MenuItemButton(
          onPressed: () {},
          shortcut: const SingleActivator(LogicalKeyboardKey.keyG, alt: true),
          child: const Text('网关'),
        ),
        MenuItemButton(
          onPressed: () {},
          shortcut: const SingleActivator(LogicalKeyboardKey.keyK, alt: true),
          child: const Text('重写'),
        ),
        MenuItemButton(
          onPressed: () {},
          shortcut: const SingleActivator(LogicalKeyboardKey.keyB, alt: true),
          child: const Text('断点'),
        ),
        MenuItemButton(
          onPressed: () {},
          shortcut: const SingleActivator(LogicalKeyboardKey.keyP, alt: true),
          child: const Text('脚本'),
        ),
        const Divider(),
        MenuItemButton(
          onPressed: () {},
          child: const Text('脚本环境'),
        ),
        const Divider(),
        MenuItemButton(
          onPressed: () {},
          shortcut: const SingleActivator(LogicalKeyboardKey.keyJ, alt: true),
          child: const Text('网络限制'),
        ),
        MenuItemButton(
          onPressed: () {},
          child: const Text('报告服务器'),
        ),
        MenuItemButton(
          onPressed: () {},
          shortcut: const SingleActivator(LogicalKeyboardKey.keyT, alt: true),
          child: const Text('代理终端'),
        ),
        const Divider(),
        SubmenuButton(
          menuChildren: [
            MenuItemButton(onPressed: () {}, child: const Text('Base64')),
            MenuItemButton(onPressed: () {}, child: const Text('URL')),
            MenuItemButton(onPressed: () {}, child: const Text('JWT')),
          ],
          child: const Text('解码'),
        ),
        SubmenuButton(
          menuChildren: [
            MenuItemButton(onPressed: () {}, child: const Text('Base64')),
            MenuItemButton(onPressed: () {}, child: const Text('URL')),
          ],
          child: const Text('编码'),
        ),
        SubmenuButton(
          menuChildren: [
            MenuItemButton(onPressed: () {}, child: const Text('MD5')),
            MenuItemButton(onPressed: () {}, child: const Text('SHA-1')),
            MenuItemButton(onPressed: () {}, child: const Text('SHA-224')),
            MenuItemButton(onPressed: () {}, child: const Text('SHA-256')),
            MenuItemButton(onPressed: () {}, child: const Text('SHA-384')),
            MenuItemButton(onPressed: () {}, child: const Text('SHA-512')),
            MenuItemButton(onPressed: () {}, child: const Text('SHA-512/224')),
            MenuItemButton(onPressed: () {}, child: const Text('SHA-512/256')),
          ],
          child: const Text('消息摘要'),
        ),
        SubmenuButton(
          menuChildren: [
            MenuItemButton(onPressed: () {}, child: const Text('AES - CBC')),
            MenuItemButton(onPressed: () {}, child: const Text('AES - CFB')),
            MenuItemButton(onPressed: () {}, child: const Text('AES - CTR')),
            MenuItemButton(onPressed: () {}, child: const Text('AES - ECB')),
            MenuItemButton(onPressed: () {}, child: const Text('AES - OFB')),
            MenuItemButton(onPressed: () {}, child: const Text('AES - SIC')),
            MenuItemButton(onPressed: () {}, child: const Text('AES - GCM')),
          ],
          child: const Text('加密'),
        ),
        SubmenuButton(
          menuChildren: [
            MenuItemButton(onPressed: () {}, child: const Text('AES - CBC')),
            MenuItemButton(onPressed: () {}, child: const Text('AES - CFB')),
            MenuItemButton(onPressed: () {}, child: const Text('AES - CTR')),
            MenuItemButton(onPressed: () {}, child: const Text('AES - ECB')),
            MenuItemButton(onPressed: () {}, child: const Text('AES - OFB')),
            MenuItemButton(onPressed: () {}, child: const Text('AES - SIC')),
            MenuItemButton(onPressed: () {}, child: const Text('AES - GCM')),
          ],
          child: const Text('解密'),
        ),
        SubmenuButton(
          menuChildren: [
            MenuItemButton(onPressed: () {}, child: const Text('JSON')),
            MenuItemButton(onPressed: () {}, child: const Text('XML')),
            MenuItemButton(onPressed: () {}, child: const Text('Hex')),
            MenuItemButton(onPressed: () {}, child: const Text('图片')),
            MenuItemButton(onPressed: () {}, child: const Text('色彩')),
          ],
          child: const Text('视图'),
        ),
        const Divider(),
        SubmenuButton(
          menuChildren: [
            MenuItemButton(onPressed: () {}, child: const Text('时间戳')),
            MenuItemButton(onPressed: () {}, child: const Text('UUID')),
            MenuItemButton(onPressed: () {}, child: const Text('二维码')),
          ],
          child: const Text('更多'),
        ),
      ],
      child: const Text('工具'),
    );
  }

  SubmenuButton _buildViewMenu(BuildContext context) {
    return SubmenuButton(
      menuChildren: [
        MenuItemButton(
          onPressed: () {},
          shortcut: const SingleActivator(LogicalKeyboardKey.f1),
          child: const Text('工作台'),
        ),
        MenuItemButton(
          onPressed: () {},
          shortcut: const SingleActivator(LogicalKeyboardKey.f2),
          child: const Text('集合'),
        ),
        MenuItemButton(
          onPressed: () {},
          shortcut: const SingleActivator(LogicalKeyboardKey.f3),
          child: const Text('环境变量'),
        ),
        MenuItemButton(
          onPressed: () {},
          shortcut: const SingleActivator(LogicalKeyboardKey.f4),
          child: const Text('历史'),
        ),
        MenuItemButton(
          onPressed: () {},
          shortcut: const SingleActivator(LogicalKeyboardKey.f5),
          child: const Text('工具箱'),
        ),
        const Divider(),
        MenuItemButton(
          onPressed: () {},
          shortcut: const SingleActivator(LogicalKeyboardKey.bracketLeft, control: true, shift: true),
          child: const Text('展开侧边栏'),
        ),
        MenuItemButton(
          onPressed: () {},
          shortcut: const SingleActivator(LogicalKeyboardKey.bracketRight, control: true, shift: true),
          child: const Text('垂直布局'),
        ),
        MenuItemButton(
          onPressed: () {},
          shortcut: const SingleActivator(LogicalKeyboardKey.backslash, control: true, shift: true),
          child: const Text('禅模式'),
        ),
        const Divider(),
        MenuItemButton(
          onPressed: () {},
          shortcut: const SingleActivator(LogicalKeyboardKey.equal, control: true),
          child: const Text('放大'),
        ),
        MenuItemButton(
          onPressed: () {},
          shortcut: const SingleActivator(LogicalKeyboardKey.minus, control: true),
          child: const Text('缩小'),
        ),
        MenuItemButton(
          onPressed: () {},
          child: const Text('重置缩放'),
        ),
      ],
      child: const Text('视图'),
    );
  }

  SubmenuButton _buildProxyMenu(BuildContext context) {
    return SubmenuButton(
      menuChildren: [
        MenuItemButton(
          onPressed: () {},
          shortcut: const SingleActivator(LogicalKeyboardKey.f12),
          child: const Text('系统代理'),
        ),
        MenuItemButton(
          onPressed: () {},
          leadingIcon: const Icon(Icons.check, size: 16),
          child: const Text('自动启用'),
        ),
        const Divider(),
        MenuItemButton(
          onPressed: () {},
          leadingIcon: const Icon(Icons.check, size: 16),
          child: const Text('Web 代理'),
        ),
        MenuItemButton(
          onPressed: () {},
          child: const Text('Socks 代理'),
        ),
        const Divider(),
        SubmenuButton(
          menuChildren: [
            MenuItemButton(
              onPressed: () {},
              leadingIcon: const Icon(Icons.check, size: 16),
              child: const Text('ip:port'),
            ),
            MenuItemButton(
              onPressed: () {},
              child: const Text('http=http://ip:port;https=http://ip:p...'),
            ),
            MenuItemButton(
              onPressed: () {},
              child: const Text('http=ip:port;https=ip:port'),
            ),
          ],
          child: const Row(
            children: [
              Icon(Icons.check, size: 16),
              SizedBox(width: 8),
              Text('代理规则'),
            ],
          ),
        ),
        SubmenuButton(
          menuChildren: const [], // Empty as per screenshot/request not showing details
          child: const Row(
            children: [
              Icon(Icons.check, size: 16),
              SizedBox(width: 8),
              Text('配置回环'),
            ],
          ),
        ),
        const Divider(),
        SubmenuButton(
          menuChildren: [
            MenuItemButton(
              onPressed: () {},
              child: const Text('禁用'),
            ),
            MenuItemButton(
              onPressed: () {},
              leadingIcon: const Icon(Icons.check, size: 16),
              child: const Text('clash'),
            ),
            MenuItemButton(
              onPressed: () {},
              child: const Text('新建配置'),
            ),
            MenuItemButton(
              onPressed: () {},
              child: const Text('管理配置'),
            ),
          ],
          child: const Row(
            children: [
              Icon(Icons.check, size: 16),
              SizedBox(width: 8),
              Text('二级代理'),
            ],
          ),
        ),
        SubmenuButton(
          menuChildren: [
            MenuItemButton(onPressed: () {}, child: const Text('启用')),
            MenuItemButton(onPressed: () {}, child: const Text('新建配置')),
            MenuItemButton(onPressed: () {}, child: const Text('管理配置')),
          ],
          child: const Text('反向代理'),
        ),
        const Divider(),
        SubmenuButton(
          menuChildren: [
            MenuItemButton(onPressed: () {}, child: const Text('启用')),
            MenuItemButton(onPressed: () {}, child: const Text('新建')),
            MenuItemButton(onPressed: () {}, child: const Text('管理配置')),
          ],
          child: const Text('访问控制'),
        ),
      ],
      child: const Text('代理'),
    );
  }

  SubmenuButton _buildCertificateMenu(BuildContext context) {
    return SubmenuButton(
      menuChildren: [
        MenuItemButton(onPressed: () {}, child: const Text('安装根证书到本机')),
        MenuItemButton(onPressed: () {}, child: const Text('安装根证书到Android设备')),
        MenuItemButton(onPressed: () {}, child: const Text('安装根证书到iOS设备')),
        MenuItemButton(onPressed: () {}, child: const Text('安装根证书到Firefox浏览器')),
        const Divider(),
        MenuItemButton(onPressed: () {}, child: const Text('查看根证书')),
        SubmenuButton(
          menuChildren: [
            MenuItemButton(onPressed: () {}, child: const Text('导入根证书(.p12)')),
            MenuItemButton(onPressed: () {}, child: const Text('重新生成根证书')),
            const Divider(),
            MenuItemButton(onPressed: () {}, child: const Text('导出根公钥证书(.crt)')),
            MenuItemButton(onPressed: () {}, child: const Text('导出根公钥证书(.pem)')),
            MenuItemButton(onPressed: () {}, child: const Text('导出根公钥证书(.0)')),
            MenuItemButton(onPressed: () {}, child: const Text('导出根证书(.p12)')),
          ],
          child: const Text('根证书管理'),
        ),
        MenuItemButton(onPressed: () {}, child: const Text('SSL证书')),
      ],
      child: const Text('证书'),
    );
  }

  SubmenuButton _buildHelpMenu(BuildContext context) {
    return SubmenuButton(
      menuChildren: [
        MenuItemButton(onPressed: () {}, child: const Text('账号')),
        MenuItemButton(onPressed: () {}, child: const Text('快捷键')),
        const Divider(),
        MenuItemButton(onPressed: () {}, child: const Text('网站')),
        MenuItemButton(onPressed: () {}, child: const Text('文档')),
        MenuItemButton(onPressed: () {}, child: const Text('Github')),
        const Divider(),
        MenuItemButton(onPressed: () {}, child: const Text('数据恢复')),
        MenuItemButton(onPressed: () {}, child: const Text('问题反馈')),
        MenuItemButton(onPressed: () {}, child: const Text('服务条款')),
        const Divider(),
        MenuItemButton(onPressed: () {}, child: const Text('更新日志')),
        MenuItemButton(onPressed: () {}, child: const Text('检查更新...')),
      ],
      child: const Text('帮助'),
    );
  }
}
