import 'package:flutter/material.dart';
import 'package:reqproxy/core/models/traffic_item.dart';
import 'package:reqproxy/presentation/widgets/split_view.dart';

class TrafficDetailView extends StatelessWidget {
  final TrafficItem trafficItem;
  final VoidCallback onClose;

  const TrafficDetailView({
    super.key,
    required this.trafficItem,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      color: const Color(0xFF2C2C2C),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black54, width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${trafficItem.method.name.toUpperCase()} ${trafficItem.url}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClose,
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SplitView(
      top: _buildRequestSection(),
      bottom: _buildResponseSection(),
      initialRatio: 0.4,
    );
  }

  Widget _buildRequestSection() {
    return DefaultTabController(
      length: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text('Request', style: TextStyle(color: Colors.grey[400])),
          ),
          const TabBar(
            tabs: [
              Tab(text: '总览'),
              Tab(text: '原始'),
              Tab(text: '参数'),
              Tab(text: '请求头'),
              Tab(text: '请求体'),
            ],
            isScrollable: true,
            indicatorColor: Colors.yellow,
            labelColor: Colors.yellow,
            unselectedLabelColor: Colors.white70,
          ),
          Expanded(
            child: TabBarView(
              children: [
                Container(child: const Center(child: Text('Request Overview'))),
                Container(child: const Center(child: Text('Request Raw'))),
                Container(child: const Center(child: Text('Request Params'))),
                Container(child: const Center(child: Text('Request Headers'))),
                Container(child: const Center(child: Text('Request Body'))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponseSection() {
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text('Response', style: TextStyle(color: Colors.grey[400])),
          ),
          const TabBar(
            tabs: [
              Tab(text: '原始'),
              Tab(text: '响应头'),
              Tab(text: '响应体'),
            ],
            isScrollable: true,
            indicatorColor: Colors.yellow,
            labelColor: Colors.yellow,
            unselectedLabelColor: Colors.white70,
          ),
          Expanded(
            child: TabBarView(
              children: [
                Container(child: const Center(child: Text('Response Raw'))),
                Container(child: const Center(child: Text('Response Headers'))),
                Container(child: const Center(child: Text('Response Body'))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
