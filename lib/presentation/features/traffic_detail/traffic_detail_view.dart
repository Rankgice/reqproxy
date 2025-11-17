import 'package:flutter/material.dart';
import 'package:reqproxy/core/models/traffic_item.dart';

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
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Request'),
              Tab(text: 'Response'),
            ],
            indicatorColor: Colors.yellow,
            labelColor: Colors.yellow,
            unselectedLabelColor: Colors.white70,
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildRequestSection(),
                _buildResponseSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestSection() {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Raw'),
              Tab(text: 'Headers'),
              Tab(text: 'Body'),
            ],
            isScrollable: true,
          ),
          Expanded(
            child: TabBarView(
              children: [
                Container(child: const Center(child: Text('Request Overview'))),
                Container(child: const Center(child: Text('Request Raw'))),
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
      length: 4,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Raw'),
              Tab(text: 'Headers'),
              Tab(text: 'Body'),
            ],
            isScrollable: true,
          ),
          Expanded(
            child: TabBarView(
              children: [
                Container(child: const Center(child: Text('Response Overview'))),
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
