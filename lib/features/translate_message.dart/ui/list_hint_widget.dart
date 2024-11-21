import 'package:flutter/material.dart';
import 'hint_widget.dart';
import 'loading_state.dart';

class ListHintWidget<T> extends StatefulWidget {
  const ListHintWidget({
    super.key,
    this.width,
    this.widthNull = false,
    required this.fetchListData,
    required this.onSelect,
    required this.onUnSelect,
  });
  final Future<List<T>> Function() fetchListData;
  final double? width;
  final bool widthNull;
  final void Function(T) onSelect;
  final void Function(T) onUnSelect;
  @override
  State<ListHintWidget<T>> createState() => _ListHintWidgetState<T>();
}

class _ListHintWidgetState<T> extends State<ListHintWidget<T>> {
  List<T>? _listData;
  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _listData = await widget.fetchListData();
      setState(() {});
    });
    super.initState();
  }

  List<int?> selectedIndex = [];
  @override
  Widget build(BuildContext context) {
    if (_listData == null) return const LoadingState();
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: _listData!
          .asMap()
          .entries
          .map((entry) => HintWidget(
                name: entry.value.toString(),
                isSelected: selectedIndex.contains(entry.key),
                onTap: () {
                  if (selectedIndex.contains(entry.key)) {
                    selectedIndex.remove(entry.key);
                    widget.onUnSelect.call(entry.value);
                  } else {
                    selectedIndex.add(entry.key);
                    widget.onSelect.call(entry.value);
                  }
                  setState(() {});
                },
              ))
          .toList(),
    );
  }
}
