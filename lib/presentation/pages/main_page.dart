import 'package:flutter/material.dart';
import 'package:reqproxy/presentation/features/sidebar/left_side_navbar.dart';
import 'package:reqproxy/presentation/features/status/proxy_status_bar.dart';
import 'package:reqproxy/presentation/features/session/session_tab_bar.dart';
import 'package:reqproxy/presentation/features/filter/filter_bar.dart';
import 'package:reqproxy/core/models/traffic_item.dart';
import 'package:reqproxy/presentation/features/traffic_list/traffic_list_view.dart';
import 'package:reqproxy/presentation/features/traffic_detail/traffic_detail_view.dart';
import 'package:reqproxy/presentation/features/status/bottom_status_bar.dart';
import 'package:reqproxy/presentation/widgets/custom_app_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TrafficItem? _detailedTrafficItem;
  double _detailViewWidth = 450;
  final double _minDetailViewWidth = 300;
  final double _maxDetailViewWidthFraction = 0.8;

  void _handleItemSelection(TrafficItem item) {
    if (_detailedTrafficItem != null) {
      setState(() {
        _detailedTrafficItem = item;
      });
    }
  }

  void _handleItemDoubleClick(TrafficItem item) {
    setState(() {
      if (_detailedTrafficItem == item) {
        _detailedTrafficItem = null;
      } else {
        _detailedTrafficItem = item;
      }
    });
  }

  void _closeDetailView() {
    setState(() {
      _detailedTrafficItem = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomAppBar(), // This is now the top menu/title bar
          Expanded(
            child: Row(
              children: [
                const LeftSideNavBar(),
                Expanded(
                  child: Column(
                    children: [
                      const ProxyStatusBar(),
                      const SessionTabBar(),
                      const FilterBar(),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Stack(
                              children: [
                                TrafficListView(
                                  onItemTap: _handleItemSelection,
                                  onItemDoubleTap: _handleItemDoubleClick,
                                ),
                                if (_detailedTrafficItem != null)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    bottom: 0,
                                    width: _detailViewWidth,
                                    child: TrafficDetailView(
                                      trafficItem: _detailedTrafficItem!,
                                      onClose: _closeDetailView,
                                    ),
                                  ),
                                if (_detailedTrafficItem != null)
                                  Positioned(
                                    right: _detailViewWidth - 4,
                                    top: 0,
                                    bottom: 0,
                                    width: 8,
                                    child: GestureDetector(
                                      onHorizontalDragUpdate: (details) {
                                        setState(() {
                                          final newWidth = _detailViewWidth - details.delta.dx;
                                          final maxWidth = constraints.maxWidth * _maxDetailViewWidthFraction;
                                          if (newWidth > _minDetailViewWidth && newWidth < maxWidth) {
                                            _detailViewWidth = newWidth;
                                          }
                                        });
                                      },
                                      child: const MouseRegion(
                                        cursor: SystemMouseCursors.resizeLeftRight,
                                        child: VerticalDivider(
                                          width: 8,
                                          thickness: 1,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomStatusBar(),
    );
  }
}
