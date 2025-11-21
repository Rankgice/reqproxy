import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reqproxy/core/models/traffic_item.dart';
import 'package:reqproxy/presentation/widgets/code_editor/code_editor.dart';

class RequestBodyView extends StatefulWidget {
  final TrafficItem trafficItem;

  const RequestBodyView({super.key, required this.trafficItem});

  @override
  State<RequestBodyView> createState() => _RequestBodyViewState();
}

class _RequestBodyViewState extends State<RequestBodyView> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isWrapEnabled = false;
  late CodeEditorController _jsonController;
  late CodeEditorController _rawController;
  String _jsonContent = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _jsonContent = _formatJson(widget.trafficItem.requestBody);
    _jsonController = CodeEditorController(
      text: _jsonContent,
      syntaxHighlighter: _highlightJson,
    );
    _rawController = CodeEditorController(
      text: widget.trafficItem.requestBody?.toString() ?? '',
    );
  }

  @override
  void didUpdateWidget(RequestBodyView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trafficItem != widget.trafficItem) {
      _jsonContent = _formatJson(widget.trafficItem.requestBody);
      _jsonController.text = _jsonContent;
      _rawController.text = widget.trafficItem.requestBody?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _jsonController.dispose();
    _rawController.dispose();
    super.dispose();
  }

  String _formatJson(dynamic body) {
    if (body == null) return '';
    try {
      // If body is already a Map/List, encode it. If it's a string, try to decode then encode to pretty print.
      dynamic jsonObject;
      if (body is String) {
        if (body.trim().isEmpty) return '';
        jsonObject = json.decode(body);
      } else {
        jsonObject = body;
      }
      return const JsonEncoder.withIndent('  ').convert(jsonObject);
    } catch (e) {
      return body.toString(); // Fallback to raw string if not valid JSON
    }
  }

  TextSpan _highlightJson(String text, TextStyle style) {
    final List<TextSpan> spans = [];
    // Simple regex for JSON syntax highlighting
    // This is a basic implementation and might not cover all edge cases
    final regex = RegExp(
      r'(?<key>"[^"]+":)|(?<string>"[^"]*")|(?<number>\b-?(?:0|[1-9]\d*)(?:\.\d+)?(?:[eE][+-]?\d+)?\b)|(?<boolean>true|false)|(?<null>null)',
    );

    int start = 0;
    for (final match in regex.allMatches(text)) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start), style: style));
      }

      TextStyle? tokenStyle;
      if (match.namedGroup('key') != null) {
        tokenStyle = style.copyWith(color: const Color(0xFF9CDCFE)); // Key - Light Blue
      } else if (match.namedGroup('string') != null) {
        tokenStyle = style.copyWith(color: const Color(0xFFCE9178)); // String - Orange/Red
      } else if (match.namedGroup('number') != null) {
        tokenStyle = style.copyWith(color: const Color(0xFFB5CEA8)); // Number - Light Green
      } else if (match.namedGroup('boolean') != null) {
        tokenStyle = style.copyWith(color: const Color(0xFF569CD6)); // Boolean - Blue
      } else if (match.namedGroup('null') != null) {
        tokenStyle = style.copyWith(color: const Color(0xFF569CD6)); // Null - Blue
      }

      spans.add(TextSpan(text: match.group(0), style: tokenStyle ?? style));
      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: style));
    }

    return TextSpan(children: spans, style: style);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
        child: Column(
        children: [
          _buildToolbar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(), // Disable swipe to avoid conflict with editor scrolling
              children: [
                _buildJsonContent(),
                const Center(child: Text('Tree View Placeholder', style: TextStyle(color: Colors.grey))),
                _buildRawContent(),
                const Center(child: Text('Hex View Placeholder', style: TextStyle(color: Colors.grey))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      height: 40,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF3E3E3E))),
      ),
      child: Row(
        children: [
          _buildTabBar(),
          const Spacer(),
          _buildIconButton(Icons.search, 'Search', () {}),
          _buildIconButton(Icons.wrap_text, 'Wrap', () {
            setState(() => _isWrapEnabled = !_isWrapEnabled);
          }, isActive: _isWrapEnabled),
          _buildIconButton(Icons.copy, 'Copy', () {
             final text = _tabController.index == 0 ? _jsonController.text : _rawController.text;
             Clipboard.setData(ClipboardData(text: text));
          }),
          _buildIconButton(Icons.download, 'Download', () {}),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return SizedBox(
      width: 240, // Adjust width as needed
      child: TabBar(
        controller: _tabController,
        isScrollable: false,
        labelPadding: const EdgeInsets.symmetric(horizontal: 12),
        indicatorColor: Colors.orange,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'JSON'),
          Tab(text: 'Tree'),
          Tab(text: 'Raw'),
          Tab(text: 'Hex'),
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

  Widget _buildJsonContent() {
    return CodeEditor(
      controller: _jsonController,
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

  Widget _buildRawContent() {
    return CodeEditor(
      controller: _rawController,
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
}
