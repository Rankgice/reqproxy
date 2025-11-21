import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reqproxy/core/models/traffic_item.dart';
import 'package:reqproxy/presentation/widgets/code_editor/code_editor.dart';

class RequestRawView extends StatefulWidget {
  final TrafficItem trafficItem;

  const RequestRawView({super.key, required this.trafficItem});

  @override
  State<RequestRawView> createState() => _RequestRawViewState();
}

class _RequestRawViewState extends State<RequestRawView> {
  bool _isTextTab = true;
  bool _isWrapEnabled = false;
  late CodeEditorController _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = CodeEditorController(
      text: _generateRawContent(),
      syntaxHighlighter: _highlightSyntax,
    );
  }

  @override
  void didUpdateWidget(RequestRawView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trafficItem != widget.trafficItem) {
      _codeController.text = _generateRawContent();
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  String _generateRawContent() {
    final item = widget.trafficItem;
    final buffer = StringBuffer();

    // Request Line
    // Example: GET /path/to/resource HTTP/1.1
    buffer.writeln('${item.method.name} ${item.url} ${item.protocol}');

    // Headers
    item.requestHeaders.forEach((key, value) {
      buffer.writeln('$key: $value');
    });

    // Empty line
    buffer.writeln();

    // Body
    if (item.requestBody != null) {
      buffer.write(item.requestBody.toString());
    }

    return buffer.toString();
  }

  TextSpan _highlightSyntax(String text, TextStyle style) {
    final List<TextSpan> spans = [];
    final lines = text.split('\n');
    
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (i == 0) {
        // Request Line: GET /path HTTP/1.1
        final parts = line.split(' ');
        if (parts.isNotEmpty) {
          // Method (e.g., GET) - Pink/Red
          spans.add(TextSpan(text: parts[0], style: style.copyWith(color: const Color(0xFFFF4081), fontWeight: FontWeight.bold))); 
          
          if (parts.length > 1) {
             spans.add(TextSpan(text: ' '));
             // URL - Green
             spans.add(TextSpan(text: parts[1], style: style.copyWith(color: const Color(0xFF98C379)))); 
          }
          
          if (parts.length > 2) {
             spans.add(TextSpan(text: ' '));
             // Protocol - Blue
             spans.add(TextSpan(text: parts.sublist(2).join(' '), style: style.copyWith(color: const Color(0xFF61AFEF), fontWeight: FontWeight.bold))); 
          }
        }
      } else if (line.contains(':')) {
        // Header: Key: Value
        final parts = line.split(':');
        final key = parts[0];
        final value = parts.sublist(1).join(':');
        
        // Key - Light Green
        spans.add(TextSpan(text: key, style: style.copyWith(color: const Color(0xFF98C379)))); 
        // Separator - Grey
        spans.add(TextSpan(text: ':', style: style.copyWith(color: const Color(0xFFD4D4D4)))); 
        // Value - Default/White
        spans.add(TextSpan(text: value, style: style.copyWith(color: const Color(0xFFD4D4D4)))); 
      } else {
        // Body or other - Default
        spans.add(TextSpan(text: line, style: style.copyWith(color: const Color(0xFFD4D4D4))));
      }
      
      if (i < lines.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return TextSpan(children: spans, style: style);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
      child:Column(
        children: [
          _buildToolbar(),
          Expanded(
            child: _isTextTab ? _buildTextContent() : _buildHexContent(),
          ),
        ],
      )
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
          _buildTabButton('Text', true),
          const SizedBox(width: 8),
          _buildTabButton('Hex', false),
          const Spacer(),
          _buildIconButton(Icons.search, 'Search', () {}),
          _buildIconButton(Icons.wrap_text, 'Wrap', () {
            setState(() => _isWrapEnabled = !_isWrapEnabled);
          }, isActive: _isWrapEnabled),
          _buildIconButton(Icons.copy, 'Copy', () {
             Clipboard.setData(ClipboardData(text: _codeController.text));
          }),
          _buildIconButton(Icons.download, 'Download', () {}),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, bool isTextTab) {
    final isSelected = _isTextTab == isTextTab;
    return InkWell(
      onTap: () => setState(() => _isTextTab = isTextTab),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3E3E3E) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontSize: 13,
          ),
        ),
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

  Widget _buildTextContent() {
    return CodeEditor(
      controller: _codeController,
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
  
  Widget _buildHexContent() {
     return const Center(child: Text('Hex View Placeholder', style: TextStyle(color: Colors.grey)));
  }
}
