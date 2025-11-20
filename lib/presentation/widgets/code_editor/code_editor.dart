import 'package:flutter/material.dart';

class CodeEditor extends StatefulWidget {
  final CodeEditorController? controller;
  final String? initialText;
  final bool readOnly;
  final bool wrap;
  final TextStyle? style;
  final Color? backgroundColor;
  final Color? gutterColor;
  final TextStyle? gutterStyle;
  final Function(String)? onChanged;

  const CodeEditor({
    super.key,
    this.controller,
    this.initialText,
    this.readOnly = false,
    this.wrap = false,
    this.style,
    this.backgroundColor,
    this.gutterColor,
    this.gutterStyle,
    this.onChanged,
  });

  @override
  State<CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  late CodeEditorController _controller;
  final ScrollController _mainScrollController = ScrollController();
  final ScrollController _gutterScrollController = ScrollController();
  bool _isInternalController = false;
  int _currentLineIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = CodeEditorController(text: widget.initialText);
      _isInternalController = true;
    }
    _controller.addListener(_handleTextChange);
    
    // Sync scrolling
    _mainScrollController.addListener(() {
      if (_gutterScrollController.hasClients) {
        _gutterScrollController.jumpTo(_mainScrollController.offset);
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChange);
    if (_isInternalController) {
      _controller.dispose();
    }
    _mainScrollController.dispose();
    _gutterScrollController.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    // Calculate current line index based on selection
    final text = _controller.text;
    final selection = _controller.selection;
    
    int newIndex = 0;
    if (selection.baseOffset >= 0 && selection.baseOffset <= text.length) {
      newIndex = text.substring(0, selection.baseOffset).split('\n').length - 1;
    }

    if (newIndex != _currentLineIndex) {
      setState(() {
        _currentLineIndex = newIndex;
      });
    } else {
      // If line count changed but index didn't (e.g. added line below), we still need to rebuild gutter
      // But setState is expensive, so maybe check if line count changed?
      // For now, simple setState is safer for correctness.
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = widget.backgroundColor ?? const Color(0xFF1E1E1E);
    final gutterColor = widget.gutterColor ?? const Color(0xFF252526);
    final textStyle = widget.style ?? const TextStyle(
      fontFamily: 'Consolas',
      fontSize: 13,
      color: Color(0xFFD4D4D4),
      height: 1.5,
    );
    final gutterStyle = widget.gutterStyle ?? const TextStyle(
      fontFamily: 'Consolas',
      fontSize: 13,
      color: Colors.grey,
      height: 1.5,
    );

    int lineCount = _controller.text.split('\n').length;
    if (_controller.text.isEmpty) lineCount = 1;

    return Container(
      color: bgColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gutter (Line Numbers)
          Container(
            width: 50, // Fixed width for gutter
            color: gutterColor,
            child: ListView.builder(
              controller: _gutterScrollController,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: lineCount,
              physics: const NeverScrollableScrollPhysics(), // Scroll controlled by main
              itemBuilder: (context, index) {
                final isCurrentLine = index == _currentLineIndex;
                return Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 12),
                  height: textStyle.fontSize! * textStyle.height!, // Approximate line height
                  child: Text(
                    '${index + 1}',
                    style: isCurrentLine 
                        ? gutterStyle.copyWith(color: Colors.white) 
                        : gutterStyle,
                  ),
                );
              },
            ),
          ),
          // Editor Area
          Expanded(
            child: widget.wrap 
              ? _buildTextField(textStyle)
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 10000, // Large width to prevent wrapping
                    child: _buildTextField(textStyle),
                  ),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextStyle style) {
    return TextField(
      controller: _controller,
      readOnly: widget.readOnly,
      maxLines: null,
      scrollController: _mainScrollController,
      style: style,
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        isDense: true,
      ),
      onChanged: widget.onChanged,
      cursorColor: Colors.blue,
    );
  }
}

/// Controller that supports custom syntax highlighting
class CodeEditorController extends TextEditingController {
  final TextSpan Function(String text, TextStyle style)? syntaxHighlighter;

  CodeEditorController({super.text, this.syntaxHighlighter});

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    if (syntaxHighlighter != null && style != null) {
      return syntaxHighlighter!(value.text, style);
    }
    return super.buildTextSpan(context: context, style: style, withComposing: withComposing);
  }
}
