import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reqproxy/core/models/traffic_item.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:reqproxy/presentation/widgets/traffic_context_menu.dart';

class TrafficListView extends StatefulWidget {
  final Function(TrafficItem) onItemTap;
  final Function(TrafficItem) onItemDoubleTap;

  const TrafficListView({
    super.key,
    required this.onItemTap,
    required this.onItemDoubleTap,
  });

  @override
  State<TrafficListView> createState() => _TrafficListViewState();
}

class _TrafficListViewState extends State<TrafficListView> {
  late TrafficDataSource _trafficDataSource;
  late DataGridController _dataGridController;
  final FocusNode _focusNode = FocusNode();
  bool _isCtrlPressed = false;
  bool _isShiftPressed = false;
  int _lastSelectedIndex = -1;

  final Map<String, double> _columnWidths = {
    'id': 60,
    'icon': 60,
    'method': 80,
    'url': 350,
    'status': 80,
    'serverIp': 120,
    'duration': 80,
    'size': 80,
  };

  final Map<String, double> _columnMinimumWidths = {
    'id': 40,
    'icon': 50,
    'method': 50,
    'url': 50,
    'status': 60,
    'serverIp': 80,
    'duration': 50,
    'size': 50,
  };

  @override
  void initState() {
    super.initState();
    _trafficDataSource = TrafficDataSource(trafficData: _getDummyData());
    _dataGridController = DataGridController();
    _dataGridController.addListener(_updateState);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _closeContextMenu();
    _focusNode.dispose();
    _dataGridController.removeListener(_updateState);
    _dataGridController.dispose();
    super.dispose();
  }

  void _updateState() {
    setState(() {});
  }

  void _deleteItems(List<TrafficItem> itemsToDelete) {
    setState(() {
      final currentData = _trafficDataSource.trafficData;
      currentData.removeWhere((item) => itemsToDelete.contains(item));
      _trafficDataSource = TrafficDataSource(trafficData: currentData);
      _dataGridController.selectedRows.clear();
    });
  }

  OverlayEntry? _contextMenuEntry;

  void _closeContextMenu() {
    _contextMenuEntry?.remove();
    _contextMenuEntry = null;
  }

  void _showContextMenu(BuildContext context, Offset position, List<TrafficItem> selectedItems) {
    _closeContextMenu(); // Close any existing menu

    final overlay = Overlay.of(context);
    final screenSize = MediaQuery.of(context).size;
    
    _contextMenuEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Full-screen mask
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _closeContextMenu,
              onSecondaryTap: _closeContextMenu,
              onPanStart: (_) => _closeContextMenu(),
            ),
          ),
          // Context Menu
          CustomSingleChildLayout(
            delegate: _ContextMenuLayoutDelegate(
              position: position,
              screenSize: screenSize,
            ),
            child: Material(
              color: Colors.transparent,
              child: TrafficContextMenu(
                selectedItems: selectedItems,
                onDelete: (items) {
                  _closeContextMenu();
                  _deleteItems(items);
                },
              ),
            ),
          ),
        ],
      ),
    );
    
    overlay.insert(_contextMenuEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: (event) {
        setState(() {
          _isCtrlPressed = event.isControlPressed;
          _isShiftPressed = event.isShiftPressed;
        });
      },
      child: SfDataGridTheme(
        data: SfDataGridThemeData(
          selectionColor: Colors.yellow.withOpacity(0.5),
        ),
        child: SfDataGrid(
          source: _trafficDataSource,
          controller: _dataGridController,
          selectionMode: SelectionMode.multiple,
          onCellTap: (details) {
            if (details.rowColumnIndex.rowIndex == 0) return; // Header tap
            final int tappedIndex = details.rowColumnIndex.rowIndex - 1;
            final tappedRow = _trafficDataSource.rows[tappedIndex];
            final tappedItem = _trafficDataSource.trafficData[tappedIndex];
            widget.onItemTap(tappedItem);

            if (_isShiftPressed) {
              if (_lastSelectedIndex != -1) {
                final int start = tappedIndex < _lastSelectedIndex ? tappedIndex : _lastSelectedIndex;
                final int end = tappedIndex > _lastSelectedIndex ? tappedIndex : _lastSelectedIndex;
                final List<DataGridRow> range = _trafficDataSource.rows.sublist(start, end + 1);
                _dataGridController.selectedRows = range;
              } else {
                _dataGridController.selectedRows = [tappedRow];
              }
            } else if (_isCtrlPressed) {
              if (_dataGridController.selectedRows.contains(tappedRow)) {
                _dataGridController.selectedRows.remove(tappedRow);
              } else {
                _dataGridController.selectedRows.add(tappedRow);
              }
            } else {
              _dataGridController.selectedRows = [tappedRow];
            }
            _lastSelectedIndex = tappedIndex;
          },
          onCellDoubleTap: (details) {
            if (details.rowColumnIndex.rowIndex > 0) {
              final int tappedIndex = details.rowColumnIndex.rowIndex - 1;
              final tappedItem = _trafficDataSource.trafficData[tappedIndex];
              widget.onItemDoubleTap(tappedItem);
            }
          },
          onCellSecondaryTap: (details) {
            if (details.rowColumnIndex.rowIndex > 0) {
              final int tappedIndex = details.rowColumnIndex.rowIndex - 1;
              final tappedRow = _trafficDataSource.rows[tappedIndex];

              if (!_dataGridController.selectedRows.contains(tappedRow)) {
                _dataGridController.selectedRows = [tappedRow];
                _lastSelectedIndex = tappedIndex;
              }

              final selectedItems = _dataGridController.selectedRows.map((dataGridRow) {
                final rowIndex = _trafficDataSource.rows.indexOf(dataGridRow);
                if (rowIndex != -1) {
                  return _trafficDataSource.trafficData[rowIndex];
                }
                return null;
              }).where((item) => item != null).cast<TrafficItem>().toList();

              _showContextMenu(
                context,
                details.globalPosition,
                selectedItems,
              );
            }
          },
          headerRowHeight: 45,
          rowHeight: 37,
          allowColumnsResizing: true,
          gridLinesVisibility: GridLinesVisibility.none,
          headerGridLinesVisibility: GridLinesVisibility.vertical,
          onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
            setState(() {
              var newWidth = details.width;
              final minWidth = _columnMinimumWidths[details.column.columnName]!;
              if (newWidth < minWidth) {
                newWidth = minWidth;
              }
              _columnWidths[details.column.columnName] = newWidth;
            });
            return true;
          },
          columnWidthMode: ColumnWidthMode.none,
          columns: <GridColumn>[
            GridColumn(
                columnName: 'id',
                width: _columnWidths['id']!,
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    alignment: Alignment.centerLeft,
                    child: const Text('ID', style: TextStyle(fontSize: 12)))),
            GridColumn(
                columnName: 'icon',
                width: _columnWidths['icon']!,
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    alignment: Alignment.centerLeft,
                    child: const Text('图标', style: TextStyle(fontSize: 12)))),
            GridColumn(
                columnName: 'method',
                width: _columnWidths['method']!,
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    alignment: Alignment.centerLeft,
                    child: const Text('方法', style: TextStyle(fontSize: 12)))),
            GridColumn(
                columnName: 'url',
                width: _columnWidths['url']!,
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    alignment: Alignment.centerLeft,
                    child: const Text('URL', style: TextStyle(fontSize: 12)))),
            GridColumn(
                columnName: 'status',
                width: _columnWidths['status']!,
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    alignment: Alignment.centerLeft,
                    child: const Text('状态码', style: TextStyle(fontSize: 12)))),
            GridColumn(
                columnName: 'serverIp',
                width: _columnWidths['serverIp']!,
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    alignment: Alignment.centerLeft,
                    child: const Text('服务器IP', style: TextStyle(fontSize: 12)))),
            GridColumn(
                columnName: 'duration',
                width: _columnWidths['duration']!,
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    alignment: Alignment.centerLeft,
                    child: const Text('时长', style: TextStyle(fontSize: 12)))),
            GridColumn(
                columnName: 'size',
                width: _columnWidths['size']!,
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    alignment: Alignment.centerLeft,
                    child: const Text('大小', style: TextStyle(fontSize: 12)))),
          ],
        ),
      ),
    );
  }

  List<TrafficItem> _getDummyData() {
    return List.generate(20, (index) {
      return TrafficItem(
        id: index + 1,
        method: HttpMethod.values[index % HttpMethod.values.length],
        url: 'https://example.com/path/to/resource/$index',
        uri: Uri.parse('https://example.com/path/$index'),
        statusCode: 200 + (index % 4 * 100),
        statusMessage: 'OK',
        protocol: 'HTTP/1.1',
        clientIp: '127.0.0.1',
        serverIp: '127.0.0.1',
        requestBodySize: 123 * index,
        responseBodySize: 456 * index,
        duration: 123 + index,
        startTime: DateTime.now(),
        status: index % 5 == 0 ? TrafficStatus.Failed : TrafficStatus.Success,
        requestHeaders: {},
        responseHeaders: {},
        contentType: index % 3 == 0 ? 'application/json' : 'text/html',
      );
    });
  }
}

class TrafficDataSource extends DataGridSource {
  TrafficDataSource({required this.trafficData}) {
    _dataGridRows = trafficData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'icon', value: e.contentType),
              DataGridCell<String>(columnName: 'method', value: e.method.name),
              DataGridCell<String>(columnName: 'url', value: e.url),
              DataGridCell<int>(columnName: 'status', value: e.statusCode),
              DataGridCell<String>(columnName: 'serverIp', value: e.serverIp),
              DataGridCell<int>(columnName: 'duration', value: e.duration),
              DataGridCell<int>(columnName: 'size', value: e.responseBodySize),
            ]))
        .toList();
  }

  final List<TrafficItem> trafficData;
  late List<DataGridRow> _dataGridRows;

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final int rowIndex = rows.indexOf(row);
    final Color backgroundColor =
        rowIndex % 2 == 0 ? const Color(0xFF2C2C2C) : const Color(0xFF212121);

    return DataGridRowAdapter(
        color: backgroundColor,
        cells: row.getCells().map<Widget>((e) {
      Alignment alignment;
      EdgeInsets padding;

      if (e.columnName == 'icon') {
        alignment = Alignment.center;
        padding = EdgeInsets.zero;
      } else {
        alignment = Alignment.centerLeft;
        padding = const EdgeInsets.symmetric(horizontal: 8.0);
      }

      return Container(
        padding: padding,
        alignment: alignment,
        child: (e.columnName == 'icon')
            ? _getContentIcon(e.value.toString())
            : Text(
                e.value.toString(),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
      );
    }).toList());
  }

  Icon _getContentIcon(String contentType) {
    if (contentType.contains('json')) {
      return const Icon(Icons.data_object, size: 16);
    }
    if (contentType.contains('image')) {
      return const Icon(Icons.image, size: 16);
    }
    return const Icon(Icons.description, size: 16);
  }
}

class _ContextMenuLayoutDelegate extends SingleChildLayoutDelegate {
  final Offset position;
  final Size screenSize;

  _ContextMenuLayoutDelegate({
    required this.position,
    required this.screenSize,
  });

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // Allow the child to be as large as it wants, up to screen size
    return BoxConstraints.loose(screenSize);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double dx = position.dx;
    double dy = position.dy;

    // Horizontal boundary check
    if (dx + childSize.width > screenSize.width) {
      dx = screenSize.width - childSize.width;
    }

    // Vertical boundary check
    if (dy + childSize.height > screenSize.height) {
      dy = screenSize.height - childSize.height;
    }

    // Ensure it doesn't go off-screen top/left (unlikely with mouse click, but good safety)
    if (dx < 0) dx = 0;
    if (dy < 0) dy = 0;

    return Offset(dx, dy);
  }

  @override
  bool shouldRelayout(_ContextMenuLayoutDelegate oldDelegate) {
    return position != oldDelegate.position || screenSize != oldDelegate.screenSize;
  }
}
