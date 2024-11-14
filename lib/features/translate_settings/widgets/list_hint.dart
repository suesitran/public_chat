import 'package:flutter/material.dart';
import '../../../_shared/dialog/loading_dialog.dart';
import 'hint_widget.dart';

//fetchListData noi bo trong class nay
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
  // @override
  // void didUpdateWidget(covariant ListStatusWidget<T> oldWidget) {//TODO to what?
  //   if ((widget.selectedIndex ?? 0) >= 0)
  //     selectedIndex = widget.selectedIndex ?? 0;
  //   super.didUpdateWidget(oldWidget);
  // }

  List<T>? _listData;
  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // if (_listData == null) {//vì history luôn đổi dù previous có empty hay ko thì cx phải fetch cái mới
      _listData = await widget.fetchListData();
      setState(() {});
      // }
    });
    // if ((widget.selectedIndex ?? 0) >= 0)
    //   selectedIndex = widget.selectedIndex ?? 0;
    super.initState();
  }

  List<int?> selectedIndex = [];
  @override
  Widget build(BuildContext context) {
    if (_listData == null) return const LoadingState();
    return Wrap(
      spacing: 4, //ngang
      runSpacing: 4, //doc
      children: _listData!
          .asMap()
          .entries
          .map((entry) => HintWidget(
                // width: widget.widthNull
                //     ? null
                //     : (widget.width ??
                //         MediaQuery.sizeOf(context).width / 2 - 25), //16+9
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
