import 'package:flutter/material.dart';
import 'widgets/option_row.dart';
import 'widgets/switch_button.dart';

// ignore: must_be_immutable
class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  bool autoTranslate = false;
  bool useDefaultLocale = true;
  bool useFavoriteLang = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(leading: const BackButton(), title: const Text('Cài đặt app')),
      body: Column(
        children: [
          buildRowOption(
              textLeft: 'Tắt dịch toàn bộ tin nhắn',
              right: MySwitchButton(
                onChange: (value) {
                  //TODO tat dich
                },
              )),
          StatefulBuilder(builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildRowOption(
                    textLeft: 'Tự động dịch mỗi lần vào app',
                    right: MySwitchButton(
                      toggle: autoTranslate,
                      onChange: (value) {
                        autoTranslate = value;
                        setState(() {});
                      },
                    )), //nếu hiện tại chưa dịch msg, thì kệ nó
                if (autoTranslate)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildRowOption(
                          level2: true,
                          textLeft: 'Sử dụng ngôn ngữ mặc định (locale)',
                          right: MySwitchButton(
                            toggle: useDefaultLocale,
                            onChange: (value) {
                              useDefaultLocale = value;
                              useFavoriteLang = !value;
                              setState(() {});
                            },
                          )),
                      buildRowOption(
                          level2: true,
                          textLeft: 'Sử dụng ngôn ngữ yêu thích',
                          right: MySwitchButton(
                            toggle: useFavoriteLang,
                            onChange: (value) {
                              useFavoriteLang = value;
                              useDefaultLocale = !value;
                              setState(() {});
                            },
                          )),
                    ],
                  ),
              ],
            );
          }),
          buildRowOption(
              textLeft:
                  'Dịch nhanh bằng cách bấm vào tin nhắn MỘT lần duy nhất',
              right: MySwitchButton(
                onChange: (value) {
                  //TODO one tap
                },
              )), //đối với msg chưa đc dịch
          buildRowOption(
              textLeft: 'Ngôn ngữ yêu thích',
              right: IconButton(
                onPressed: () {
                  //TODO favorite lang
                },
                icon: const Icon(Icons.add),
              )),
        ],
      ),
    );
  }
}
