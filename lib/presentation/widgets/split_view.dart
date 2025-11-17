import 'package:flutter/material.dart';

class SplitView extends StatefulWidget {
  final Widget top;
  final Widget bottom;
  final double initialRatio;

  const SplitView({
    super.key,
    required this.top,
    required this.bottom,
    this.initialRatio = 0.5,
  });

  @override
  State<SplitView> createState() => _SplitViewState();
}

class _SplitViewState extends State<SplitView> {
  late double _ratio;

  @override
  void initState() {
    super.initState();
    _ratio = widget.initialRatio;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            SizedBox(
              height: constraints.maxHeight * _ratio,
              child: widget.top,
            ),
            GestureDetector(
              onVerticalDragUpdate: (details) {
                setState(() {
                  _ratio += details.delta.dy / constraints.maxHeight;
                  if (_ratio < 0.1) _ratio = 0.1;
                  if (_ratio > 0.9) _ratio = 0.9;
                });
              },
              child: const MouseRegion(
                cursor: SystemMouseCursors.resizeUpDown,
                child: SizedBox(
                  height: 8,
                  child: Center(
                    child: Icon(Icons.drag_handle, size: 16),
                  ),
                ),
              ),
            ),
            Expanded(
              child: widget.bottom,
            ),
          ],
        );
      },
    );
  }
}
