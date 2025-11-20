import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reqproxy/core/models/traffic_item.dart';

class ResponseRawView extends StatefulWidget {
  final TrafficItem trafficItem;

  const ResponseRawView({super.key, required this.trafficItem});

  @override
  State<ResponseRawView> createState() => _ResponseRawViewState();
}

class _ResponseRawViewState extends State<ResponseRawView> {
  bool _isTextTab = true;
  bool _isWrapEnabled = false;
  late String _rawContent;
  late TextSpan _formattedContent;

  @override
  void initState() {
    super.initState();
    _generateRawContent();
  }

  @override
  void didUpdateWidget(ResponseRawView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trafficItem != widget.trafficItem) {
      _generateRawContent();
    }
  }

  void _generateRawContent() {
    final item = widget.trafficItem;
    final buffer = StringBuffer();
    final List<TextSpan> spans = [];

    // Status Line
    // Example: HTTP/2 200
    final statusLine = '${item.protocol} ${item.statusCode}';
    buffer.writeln(statusLine);
    
    spans.add(TextSpan(
      text: item.protocol,
      style: const TextStyle(color: Color(0xFF569CD6), fontWeight: FontWeight.bold), // Blue
    ));
    spans.add(const TextSpan(text: ' '));
    spans.add(TextSpan(
      text: item.statusCode.toString(),
      style: const TextStyle(color: Color(0xFFB5CEA8), fontWeight: FontWeight.bold), // Light Green/Orange-ish
    ));
    spans.add(const TextSpan(text: '\n'));

    // Headers
    item.responseHeaders.forEach((key, value) {
      buffer.writeln('$key: $value');
      
      spans.add(TextSpan(
        text: key,
        style: const TextStyle(color: Color(0xFF9CDCFE)), // Light Blue
      ));
      spans.add(const TextSpan(
        text: ': ',
        style: TextStyle(color: Color(0xFFD4D4D4)),
      ));
      spans.add(TextSpan(
        text: value,
        style: const TextStyle(color: Color(0xFFCE9178)), // Orange/Red
      ));
      spans.add(const TextSpan(text: '\n'));
    });

    // Empty line
    buffer.writeln();
    spans.add(const TextSpan(text: '\n'));

    // Body
    if (item.responseBody != null) {
      final body = item.responseBody.toString();
      buffer.write(body);
      spans.add(TextSpan(
        text: body,
        style: const TextStyle(color: Color(0xFFD4D4D4)),
      ));
    }

    _rawContent = buffer.toString();
    _formattedContent = TextSpan(children: spans, style: const TextStyle(fontFamily: 'Consolas', fontSize: 13));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildToolbar(),
        Expanded(
          child: _isTextTab ? _buildTextContent() : _buildHexContent(),
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
          _buildTabButton('Text', true),
          const SizedBox(width: 8),
          _buildTabButton('Hex', false),
          const Spacer(),
          _buildIconButton(Icons.search, 'Search', () {}),
          _buildIconButton(Icons.wrap_text, 'Wrap', () {
            setState(() => _isWrapEnabled = !_isWrapEnabled);
          }, isActive: _isWrapEnabled),
          _buildIconButton(Icons.copy, 'Copy', () {
             Clipboard.setData(ClipboardData(text: _rawContent));
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
    final lines = _rawContent.split('\n');
    // If last line is empty (due to split), remove it for line count if it's just a trailing newline
    // But split gives empty string at end if ends with \n.
    final lineCount = lines.length;

    return Container(
      color: const Color(0xFF1E1E1E),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Line Numbers
          SingleChildScrollView(
            controller: ScrollController(), // Syncing would require linked controllers
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: const BoxDecoration(
                border: Border(right: BorderSide(color: Color(0xFF3E3E3E))),
                color: Color(0xFF252526),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(lineCount, (index) => Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.grey, fontSize: 13, fontFamily: 'Consolas', height: 1.5),
                )),
              ),
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  width: _isWrapEnabled ? MediaQuery.of(context).size.width * 0.6 : null, // Allow wrapping
                  child: SelectableText.rich(
                    _formattedContent,
                    style: const TextStyle(
                      color: Color(0xFFD4D4D4), 
                      fontSize: 13, 
                      fontFamily: 'Consolas',
                      height: 1.5, // Match line height
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHexContent() {
     return const Center(child: Text('Hex View Placeholder', style: TextStyle(color: Colors.grey)));
  }
}
