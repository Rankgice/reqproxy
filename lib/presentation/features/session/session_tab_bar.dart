import 'package:flutter/material.dart';

class SessionTabBar extends StatefulWidget {
  const SessionTabBar({super.key});

  @override
  State<SessionTabBar> createState() => _SessionTabBarState();
}

class _SessionTabBarState extends State<SessionTabBar> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      child: Row(
        children: [
          Expanded(
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: [
                _buildTab('调试', 754, icon: Icons.wifi_tethering),
                _buildTab('127.0.0.1', null, dotColor: Colors.orange),
                _buildTab('127.0.0.1', null, dotColor: Colors.orange),
                _buildTab('localhost', null, icon: Icons.send),
                _buildTab('localhost', null, icon: Icons.send),
              ],
              indicatorSize: TabBarIndicatorSize.label,
              labelPadding: const EdgeInsets.symmetric(horizontal: 10.0),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(color: Colors.orange),
              ),
            ),
          ),
          IconButton(icon: const Icon(Icons.add), iconSize: 18, onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int? count, {IconData? icon, Color? dotColor}) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, size: 14),
          if (dotColor != null) ...[
            Icon(Icons.circle, color: dotColor, size: 8),
            const SizedBox(width: 4),
          ],
          if (icon != null && dotColor == null) const SizedBox(width: 4),
          Text(
            count != null ? '$title(${count > 999 ? '999+' : count})' : title,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
