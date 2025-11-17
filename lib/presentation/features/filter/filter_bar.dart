import 'package:flutter/material.dart';

class FilterBar extends StatefulWidget {
  const FilterBar({super.key});

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  int? _allIndex;
  int? _protocolTypeIndex;
  int? _protocolVersionIndex;
  final List<bool> _contentTypeSelection = List.generate(8, (_) => false);
  final List<bool> _statusCodeSelection = List.generate(5, (_) => false);
  bool _isSearchSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          _buildChipGroup(['All'], _allIndex, (index) {
            setState(() => _allIndex = (_allIndex == index) ? null : index);
          }),
          const VerticalDivider(),
          _buildChipGroup(['Http', 'Https', 'Websocket'], _protocolTypeIndex, (index) {
            setState(() => _protocolTypeIndex = (_protocolTypeIndex == index) ? null : index);
          }),
          const VerticalDivider(),
          _buildChipGroup(['HTTP1', 'HTTP2'], _protocolVersionIndex, (index) {
            setState(() => _protocolVersionIndex = (_protocolVersionIndex == index) ? null : index);
          }),
          const VerticalDivider(),
          _buildMultiSelectChipGroup(['JSON', 'XML', '文本', 'HTML', 'JS', '图片', '媒体', '二进制'], _contentTypeSelection),
          const VerticalDivider(),
          _buildMultiSelectChipGroup(['1xx', '2xx', '3xx', '4xx', '5xx'], _statusCodeSelection),
          const Spacer(),
          _buildSearchButton(),
        ],
      ),
    );
  }

  Widget _buildChipGroup(List<String> labels, int? selectedIndex, ValueChanged<int> onSelected) {
    return Wrap(
      spacing: 4.0,
      children: List.generate(labels.length, (index) {
        return _buildCustomChip(
          label: labels[index],
          isSelected: selectedIndex == index,
          onTap: () => onSelected(index),
        );
      }),
    );
  }

  Widget _buildMultiSelectChipGroup(List<String> labels, List<bool> selection) {
    return Wrap(
      spacing: 4.0,
      children: List.generate(labels.length, (index) {
        return _buildCustomChip(
          label: labels[index],
          isSelected: selection[index],
          onTap: () {
            setState(() => selection[index] = !selection[index]);
          },
        );
      }),
    );
  }

  Widget _buildCustomChip({required String label, required bool isSelected, required VoidCallback onTap}) {
    return Material(
      color: isSelected ? Colors.grey[700]! : Colors.transparent,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        hoverColor: Colors.grey[800],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: () {
          setState(() => _isSearchSelected = !_isSearchSelected);
        },
        borderRadius: BorderRadius.circular(4),
        hoverColor: Colors.grey[800],
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(
            Icons.search,
            size: 18,
            color: _isSearchSelected ? Colors.yellow : Colors.white,
          ),
        ),
      ),
    );
  }
}
