import 'package:flutter/material.dart';
import '../../_shared/widgets/my_textfield.dart';
import 'widgets/list_hint.dart';

class TranslatePopup extends StatelessWidget {
  TranslatePopup({
    super.key,
    required this.onSubmit,
    required this.fetchListHistoryLanguages,
  });
  final void Function(String value) onSubmit;
  final Future<List<String>> Function() fetchListHistoryLanguages;

  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        ListHintWidget<String>(
          fetchListData: fetchListHistoryLanguages,
          onSelect: (value) {
            _controller.text += '$value ';
          },
          onUnSelect: (value) {
            _controller.text = _controller.text.replaceAll('$value ', '');
          },
        ),
        const SizedBox(height: 10),
        Text(
          'ví dụ: vi en... (cách nhau bởi dấu cách)',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        TextFieldInput(
          autofocus: true,
          hintText: "Nhập 1 hoặc nhiều ngôn ngữ/ mã ngôn ngữ",
          controller: _controller,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (value) {
            onSubmit(value);
          },
        ),
      ],
    );
  }
}