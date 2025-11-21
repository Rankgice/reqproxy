import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reqproxy/core/models/traffic_item.dart';
import 'package:intl/intl.dart';

class RequestOverviewView extends StatelessWidget {
  final TrafficItem trafficItem;

  const RequestOverviewView({super.key, required this.trafficItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF2B2B2B),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUrlSection(),
            const SizedBox(height: 16),
            _buildGeneralInfo(),
            const SizedBox(height: 16),
            _buildCollapsibleSection(
              context,
              title: '应用程序',
              children: [
                _buildInfoRow('名称', 'WXWorkWeb'),
                _buildInfoRow('ID', 'WXWorkWeb.exe'),
                _buildInfoRow(
                  '路径',
                  r'D:\Program Files (x86)\WXWork\5.0.2.6008\updated_web\WXWorkWeb.exe',
                ),
              ],
            ),
            _buildCollapsibleSection(
              context,
              title: '连接',
              isExpanded: true,
              children: [
                _buildInfoRow('ID', '11'),
                _buildInfoRow(
                  '时间',
                  DateFormat(
                    'yyyy-MM-dd HH:mm:ss.SSSSSS',
                  ).format(trafficItem.startTime),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 4),
                  child: Text(
                    '前端',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
                _buildInfoRow(
                  ' - 客户端 地址',
                  trafficItem.clientIp.split(':').first,
                ),
                _buildInfoRow(' - 客户端 端口', '59063'), // Placeholder
                _buildInfoRow(' - 服务端 地址', '127.0.0.1'),
                _buildInfoRow(' - 服务端 端口', '9000'),
                const Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 4),
                  child: Text(
                    '后端',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
                _buildInfoRow(' - 客户端 地址', '127.0.0.1'),
                _buildInfoRow(' - 客户端 端口', '59064'), // Placeholder
                _buildInfoRow(
                  ' - 服务端 地址',
                  trafficItem.serverIp.split(':').first,
                ),
                _buildInfoRow(' - 服务端 端口', '7897'), // Placeholder
              ],
            ),
            _buildCollapsibleSection(context, title: 'TLS', children: []),
            _buildCollapsibleSection(context, title: '服务端证书', children: []),
            _buildCollapsibleSection(
              context,
              title: '时间',
              children: [
                _buildInfoRow(
                  '开始时间',
                  DateFormat('HH:mm:ss.SSS').format(trafficItem.startTime),
                ),
                _buildInfoRow('总耗时', '${trafficItem.duration} ms'),
              ],
            ),
            _buildCollapsibleSection(
              context,
              title: '大小',
              children: [
                _buildInfoRow('请求体', '${trafficItem.requestBodySize} bytes'),
                _buildInfoRow('响应体', '${trafficItem.responseBodySize} bytes'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUrlSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF464646),          // 下边框的颜色
            width: 0.7,                  // 下边框的厚度
            style: BorderStyle.solid,    // 下边框的样式 (通常是实线)
          ),
        ),
        // 如果需要，也可以设置圆角，但只对背景色和全边框可见
        // borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: SelectableText.rich(
              TextSpan(children: _highlightUrl(trafficItem.url)),
              style: const TextStyle(fontFamily: 'Consolas', fontSize: 13),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 14, color: Colors.grey),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: trafficItem.url));
            },
            tooltip: 'Copy URL',
          ),
        ],
      ),
    );
  }

  List<TextSpan> _highlightUrl(String url) {
    // Simple highlighting: Protocol (grey), Host (green), Path (blue), Query (yellow)
    final uri = Uri.parse(url);
    return [
      TextSpan(
        text: '${uri.scheme}://',
        style: const TextStyle(color: Colors.grey),
      ),
      TextSpan(
        text: uri.host,
        style: const TextStyle(color: Color(0xFF4EC9B0)),
      ), // Greenish
      if (uri.hasPort)
        TextSpan(
          text: ':${uri.port}',
          style: const TextStyle(color: Colors.grey),
        ),
      TextSpan(
        text: uri.path,
        style: const TextStyle(color: Color(0xFF569CD6)),
      ), // Blue
      if (uri.hasQuery)
        TextSpan(
          text: '?${uri.query}',
          style: const TextStyle(color: Color(0xFFDCDCAA)),
        ), // Yellowish
    ];
  }

  Widget _buildGeneralInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildInfoRow(
            '状态',
            trafficItem.statusMessage.isNotEmpty
                ? trafficItem.statusMessage
                : 'Completed',
          ),
          _buildInfoRow('方法', trafficItem.method.name),
          _buildInfoRow('协议', trafficItem.protocol),
          _buildInfoRow('Code', trafficItem.statusCode.toString()),
          _buildInfoRow('服务器地址', trafficItem.serverIp),
          _buildInfoRow('Keep Alive', 'true'), // Placeholder
          _buildInfoRow('流', '#1'), // Placeholder
          _buildInfoRow(
            'Content Type',
            trafficItem.contentType.isNotEmpty ? trafficItem.contentType : '-',
          ),
          _buildInfoRow('代理协议', 'https'), // Placeholder
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                  color: Color(0xFFD4D4D4),
                  fontSize: 13,
                  fontWeight: FontWeight.w500
              ),

            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFFD4D4D4),
                fontSize: 13,
                fontFamily: 'Consolas',
                  fontWeight: FontWeight.w500
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsibleSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
    bool isExpanded = false,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        color: const Color(0xFF252526),
        margin: const EdgeInsets.only(bottom: 1),
        child: ExpansionTile(
          title: Text(
            title,
            style: const TextStyle(
              color: Color(0xFFD4D4D4),
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          tilePadding: const EdgeInsets.symmetric(horizontal: 8),
          childrenPadding: const EdgeInsets.only(left: 12, bottom: 12),
          initiallyExpanded: isExpanded,
          collapsedIconColor: Colors.grey,
          iconColor: Colors.white,
          backgroundColor: const Color(0xFF252526),
          collapsedBackgroundColor: const Color(
            0xFF2D2D2D,
          ), // Slightly lighter for header
          shape: const Border(), // Remove borders
          children: children.isNotEmpty
              ? children
              : [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'No Data',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}
