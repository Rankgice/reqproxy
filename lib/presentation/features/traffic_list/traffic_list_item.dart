import 'package:flutter/material.dart';
import 'package:reqproxy/core/models/traffic_item.dart';

class TrafficListItemWidget extends StatelessWidget {
  final TrafficItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const TrafficListItemWidget({
    super.key,
    required this.item,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.circle, color: _getStatusColor(item.status), size: 12),
      title: Text('${item.method.name} ${item.url}'),
      subtitle: Text('${item.statusCode} ${item.statusMessage}'),
      selected: isSelected,
      onTap: onTap,
    );
  }

  Color _getStatusColor(TrafficStatus status) {
    switch (status) {
      case TrafficStatus.Running:
        return Colors.blue;
      case TrafficStatus.Success:
        return Colors.green;
      case TrafficStatus.Failed:
        return Colors.red;
      case TrafficStatus.Pending:
        return Colors.grey;
    }
  }
}
