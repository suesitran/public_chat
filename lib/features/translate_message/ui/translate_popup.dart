import 'package:flutter/material.dart';
import 'list_hint_widget.dart';
import 'my_textfield.dart';

class TranslatePopup extends StatelessWidget {
  const TranslatePopup({
    super.key,
    required this.onSubmit,
    required this.fetchListHistoryLanguages,
    // required this.controller,
  });
  final void Function(String value) onSubmit;
  final Future<List<String>> Function() fetchListHistoryLanguages;
  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        ListHintWidget<String>(
          fetchListData: fetchListHistoryLanguages,
          onSelect: (value) {
            controller.text += '$value,';
          },
          onUnSelect: (value) {
            controller.text = controller.text.replaceAll('$value,', '');
          },
        ),
        const SizedBox(height: 10),
        Text(
          'Example: vi, en... (separated by commas)',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        TextFieldInput(
          autofocus: true,
          hintText: "Enter languages/language codes...",
          controller: controller,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (value) {
            onSubmit(value);
          },
        ),
      ],
    );
  }
}
