import 'package:flutter/material.dart';

class MyFilterChipButton extends StatelessWidget {
  const MyFilterChipButton({
    super.key,
    required this.onSelected,
    required this.label,
    required this.selected,
  });
  final void Function(bool) onSelected;
  final String label;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    return FilterChip(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        label: Text(label),
        selected: selected, //t//bloc.hasLyric &&
        // selected: bloc.isHighLightMode,//f
        disabledColor: Colors.grey,
        selectedColor: Colors.black,
        onSelected: (bool value) {
          onSelected(value);
        });
  }
}
