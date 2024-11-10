import 'package:flutter/material.dart';

class MyCloseButton extends StatelessWidget {
  const MyCloseButton({super.key, required this.onPressed});
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey,
          ),
          child: const Icon(Icons.close, size: 20)), //24
      padding: EdgeInsets.zero, // Không có padding
      constraints: const BoxConstraints(), // Loại bỏ các ràng buộc mặc định
      onPressed: onPressed,
    );
  }
}
