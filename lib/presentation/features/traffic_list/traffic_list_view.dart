import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reqproxy/core/models/traffic_item.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

enum _ContextMenuAction {
  copyUrl,
  copyAsCurl,
  saveResponse,
  saveResponseBody,
  repeatRequest,
  repeatEditRequest,
  remove,
  clear
}

class TrafficListView extends StatefulWidget {
  const TrafficListView({super.key});

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _dataGridController.dispose();
    super.dispose();
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
          onCellSecondaryTap: (details) {
            if (details.rowColumnIndex.rowIndex > 0) {
              _showContextMenu(context, details.globalPosition, details.rowColumnIndex.rowIndex - 1);
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

  void _showContextMenu(BuildContext context, Offset position, int rowIndex) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final TrafficItem trafficItem = _trafficDataSource.trafficData[rowIndex];

    final result = await showMenu<_ContextMenuAction>(
      context: context,
      position: RelativeRect.fromRect(
        position & const Size(40, 40), // smaller rect, the touch area
        Offset.zero & overlay.size, // Bigger rect, the entire screen
      ),
      items: <PopupMenuEntry<_ContextMenuAction>>[
        const PopupMenuItem(value: _ContextMenuAction.copyUrl, child: Text('Copy URL')),
        const PopupMenuItem(value: _ContextMenuAction.copyAsCurl, child: Text('Copy as cURL')),
        const PopupMenuDivider(),
        const PopupMenuItem(value: _ContextMenuAction.saveResponse, child: Text('Save Response')),
        const PopupMenuItem(value: _ContextMenuAction.saveResponseBody, child: Text('Save Response Body')),
        const PopupMenuDivider(),
        const PopupMenuItem(value: _ContextMenuAction.repeatRequest, child: Text('Repeat Request')),
        const PopupMenuItem(value: _ContextMenuAction.repeatEditRequest, child: Text('Repeat & Edit Request')),
        const PopupMenuDivider(),
        const PopupMenuItem(value: _ContextMenuAction.remove, child: Text('Remove')),
        const PopupMenuItem(value: _ContextMenuAction.clear, child: Text('Clear')),
      ],
    );

    if (result == null) return;

    switch (result) {
      case _ContextMenuAction.copyUrl:
        await Clipboard.setData(ClipboardData(text: trafficItem.url));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('URL copied to clipboard'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        break;
      case _ContextMenuAction.copyAsCurl:
        final curlCommand = _buildCurlCommand(trafficItem);
        await Clipboard.setData(ClipboardData(text: curlCommand));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('cURL command copied to clipboard'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        break;
      default:
      // TODO: Implement other actions
    }
  }

  String _buildCurlCommand(TrafficItem item) {
    final buffer = StringBuffer();
    buffer.write('curl "${item.url}"');
    buffer.write(' -X ${item.method.name.toUpperCase()}');

    item.requestHeaders.forEach((key, value) {
      buffer.write(' -H "$key: $value"');
    });

    // TODO: Add request body when available in TrafficItem model
    // if (item.requestBody != null && item.requestBody.isNotEmpty) {
    //   buffer.write(' --data-binary @- <<EOF\n${item.requestBody}\nEOF');
    // }

    return buffer.toString();
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
