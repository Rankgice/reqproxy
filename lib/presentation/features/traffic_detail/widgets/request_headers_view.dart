import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reqproxy/core/models/traffic_item.dart';
import 'package:reqproxy/presentation/widgets/code_editor/code_editor.dart';

class RequestHeadersView extends StatefulWidget {
  final TrafficItem trafficItem;

  const RequestHeadersView({super.key, required this.trafficItem});

  @override
  State<RequestHeadersView> createState() => _RequestHeadersViewState();
}

class _RequestHeadersViewState extends State<RequestHeadersView> {
  bool _isTableMode = false;
  bool _isWrapEnabled = false;
  bool _sortAscending = true;
  late CodeEditorController _textController;
  late Map<String, String> _sortedHeaders;

  @override
  void initState() {
    super.initState();
    _sortHeaders();
    _textController = CodeEditorController(
      text: _formatHeadersText(),
      syntaxHighlighter: _highlightHeaders,
    );
  }

  @override
  void didUpdateWidget(RequestHeadersView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trafficItem != widget.trafficItem) {
      _sortHeaders();
      _textController.text = _formatHeadersText();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _sortHeaders() {
    var entries = widget.trafficItem.requestHeaders.entries.toList();
    if (_sortAscending) {
      entries.sort((a, b) => a.key.compareTo(b.key));
    } else {
      entries.sort((a, b) => b.key.compareTo(a.key));
    }
    _sortedHeaders = Map.fromEntries(entries);
  }

  String _formatHeadersText() {
    return _sortedHeaders.entries.map((e) => '${e.key}: ${e.value}').join('\n');
  }

  void _toggleSort() {
    setState(() {
      _sortAscending = !_sortAscending;
      _sortHeaders();
      _textController.text = _formatHeadersText();
    });
  }

  TextSpan _highlightHeaders(String text, TextStyle style) {
    final List<TextSpan> spans = [];
    final regex = RegExp(r'^([^:]+): (.*)$', multiLine: true);

    int start = 0;
    for (final match in regex.allMatches(text)) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start), style: style));
      }

      // Key
      spans.add(TextSpan(
        text: match.group(1),
        style: style.copyWith(color: const Color(0xFF9CDCFE)), // Light Blue
      ));
      
      // Separator
      spans.add(TextSpan(text: ': ', style: style));

      // Value
      spans.add(TextSpan(
        text: match.group(2),
        style: style.copyWith(color: const Color(0xFFCE9178)), // Orange/Red
      ));

      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: style));
    }

    return TextSpan(children: spans, style: style);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildToolbar(),
        Expanded(
          child: _isTableMode ? _buildTableView() : _buildTextView(),
        ),
      ],
    );
  }

  Widget _buildToolbar() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF3E3E3E))),
      ),
      child: Row(
        children: [
          Text(
            '请求头列表',
            style: TextStyle(color: Colors.grey[400], fontSize: 13),
          ),
          const Spacer(),
          if (!_isTableMode) ...[
            _buildIconButton(Icons.search, 'Search', () {}),
            _buildIconButton(Icons.unfold_more, 'Sort', _toggleSort),
            _buildIconButton(Icons.wrap_text, 'Wrap', () {
              setState(() => _isWrapEnabled = !_isWrapEnabled);
            }, isActive: _isWrapEnabled),
            _buildIconButton(Icons.grid_view, 'Table Mode', () {
              setState(() => _isTableMode = true);
            }),
          ] else ...[
            _buildIconButton(Icons.data_object, 'Copy as JSON', () {
               final jsonStr = const JsonEncoder.withIndent('  ').convert(_sortedHeaders);
               Clipboard.setData(ClipboardData(text: jsonStr));
            }),
            _buildIconButton(Icons.unfold_more, 'Sort', _toggleSort),
            _buildIconButton(Icons.copy, 'Copy', () {
               Clipboard.setData(ClipboardData(text: _formatHeadersText()));
            }),
            _buildIconButton(Icons.description_outlined, 'Text Mode', () {
              setState(() => _isTableMode = false);
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String tooltip, VoidCallback onPressed, {bool isActive = false}) {
    return IconButton(
      icon: Icon(icon, size: 18, color: isActive ? Colors.blue : Colors.grey),
      tooltip: tooltip,
      onPressed: onPressed,
      splashRadius: 20,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      padding: EdgeInsets.zero,
    );
  }

  Widget _buildTextView() {
    return CodeEditor(
      controller: _textController,
      readOnly: false,
      wrap: _isWrapEnabled,
      style: const TextStyle(
        fontFamily: 'Consolas',
        fontSize: 13,
        color: Color(0xFFD4D4D4),
        height: 1.5,
      ),
    );
  }

  Widget _buildTableView() {
    return Container(
      color: const Color(0xFF1E1E1E),
      child: SingleChildScrollView(
        child: Table(
          border: TableBorder.all(color: const Color(0xFF3E3E3E)),
          columnWidths: const {
            0: IntrinsicColumnWidth(),
            1: FlexColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: _sortedHeaders.entries.map((e) {
            return TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(e.key, style: const TextStyle(color: Color(0xFFD4D4D4), fontFamily: 'Consolas')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(e.value, style: const TextStyle(color: Color(0xFFD4D4D4), fontFamily: 'Consolas')),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
