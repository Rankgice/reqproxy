import 'package:flutter/material.dart';
import 'package:reqproxy/core/models/traffic_item.dart';
import 'package:reqproxy/presentation/widgets/split_view.dart';
import 'package:reqproxy/presentation/features/traffic_detail/widgets/response_raw_view.dart';
import 'package:reqproxy/presentation/features/traffic_detail/widgets/request_raw_view.dart';
import 'package:reqproxy/presentation/features/traffic_detail/widgets/request_body_view.dart';
import 'package:reqproxy/presentation/features/traffic_detail/widgets/request_headers_view.dart';
import 'package:reqproxy/presentation/features/traffic_detail/widgets/request_overview_view.dart';

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
      child: _buildBody(),
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
          Container(
            height: 49,
            child: Row(
              children: [
                const Expanded(
                  child: TabBar(
                    tabs: [
                      Tab(text: '总览'),
                      Tab(text: '原始'),
                      Tab(text: '参数'),
                      Tab(text: '请求头'),
                      Tab(text: '请求体'),
                    ],
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    indicatorColor: Colors.yellow,
                    labelColor: Color(0xFFDFDFE0),
                    unselectedLabelColor: Colors.white70,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                  tooltip: 'Close',
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                RequestOverviewView(trafficItem: trafficItem),
                RequestRawView(trafficItem: trafficItem),
                Container(child: const Center(child: Text('Request Params'))),
                RequestHeadersView(trafficItem: trafficItem),
                RequestBodyView(trafficItem: trafficItem),
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
          Container(
            height: 49,
            child: const TabBar(
              tabs: [
                Tab(text: '原始'),
                Tab(text: '响应头'),
                Tab(text: '响应体'),
              ],
               isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: Colors.yellow,
              labelColor: Color(0xFFDFDFE0),
              unselectedLabelColor: Colors.white70,
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                ResponseRawView(trafficItem: trafficItem),
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
