import 'package:flutter/material.dart';
import 'package:reqproxy/core/models/traffic_item.dart';

class TrafficDetailView extends StatefulWidget {
  final TrafficItem? item;

  const TrafficDetailView({super.key, this.item});

  @override
  State<TrafficDetailView> createState() => _TrafficDetailViewState();
}

class _TrafficDetailViewState extends State<TrafficDetailView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.item == null) {
      return const Center(
        child: Text('Select a request to see details'),
      );
    }

    return Column(
      children: [
        _buildTabBar(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewView(context, widget.item!),
              _buildRawView(context, widget.item!.requestHeaders, widget.item!.requestBody),
              _buildParamsView(context, widget.item!.uri.queryParameters),
              _buildHeadersView(context, widget.item!.requestHeaders),
              _buildBodyView(context, widget.item!.requestBody),
              _buildResponseView(context, widget.item!),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 35,
      child: Row(
        children: [
          Expanded(
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: const [
                Tab(text: '总览'),
                Tab(text: '原始'),
                Tab(text: '参数'),
                Tab(text: '请求头'),
                Tab(text: '请求体'),
                Tab(text: '响应体'),
              ],
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(color: Colors.orange),
              ),
            ),
          ),
          IconButton(icon: const Icon(Icons.search), iconSize: 18, onPressed: () {}),
          IconButton(icon: const Icon(Icons.copy), iconSize: 18, onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), iconSize: 18, onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildOverviewView(BuildContext context, TrafficItem item) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Value')),
        ],
        rows: [
          DataRow(cells: [const DataCell(Text('URL')), DataCell(Text(item.url))]),
          DataRow(cells: [const DataCell(Text('Method')), DataCell(Text(item.method.name))]),
          DataRow(cells: [const DataCell(Text('Status')), DataCell(Text('${item.statusCode} ${item.statusMessage}'))]),
          DataRow(cells: [const DataCell(Text('Protocol')), DataCell(Text(item.protocol))]),
          DataRow(cells: [const DataCell(Text('Client IP')), DataCell(Text(item.clientIp))]),
          DataRow(cells: [const DataCell(Text('Server IP')), DataCell(Text(item.serverIp))]),
          DataRow(cells: [const DataCell(Text('Duration')), DataCell(Text('${item.duration} ms'))]),
          DataRow(cells: [const DataCell(Text('Size')), DataCell(Text('${item.responseBodySize} bytes'))]),
        ],
      ),
    );
  }

  Widget _buildRawView(BuildContext context, Map<String, String> headers, dynamic body) {
    final raw = headers.entries.map((e) => '${e.key}: ${e.value}').join('\n') +
        '\n\n' +
        (body?.toString() ?? '');
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Text(raw),
    );
  }

  Widget _buildParamsView(BuildContext context, Map<String, String> params) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Key')),
          DataColumn(label: Text('Value')),
        ],
        rows: params.entries
            .map((e) => DataRow(cells: [DataCell(Text(e.key)), DataCell(Text(e.value))]))
            .toList(),
      ),
    );
  }

  Widget _buildHeadersView(BuildContext context, Map<String, String> headers) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Key')),
          DataColumn(label: Text('Value')),
        ],
        rows: headers.entries
            .map((e) => DataRow(cells: [DataCell(Text(e.key)), DataCell(Text(e.value))]))
            .toList(),
      ),
    );
  }

  Widget _buildBodyView(BuildContext context, dynamic body) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Text(body?.toString() ?? ''),
    );
  }

  Widget _buildResponseView(BuildContext context, TrafficItem item) {
    return _buildRawView(context, item.responseHeaders, item.responseBody);
  }
}
