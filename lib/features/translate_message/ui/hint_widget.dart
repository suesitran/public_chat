import 'package:flutter/material.dart';

class HintWidget extends StatelessWidget {
  const HintWidget(
      {super.key,
      required this.name,
      this.width,
      this.isSelected = false,
      required this.onTap});
  final String name;
  final double? width;
  final bool isSelected;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), //20
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF121212)),
            borderRadius: BorderRadius.circular(30),
            color:
                isSelected ? const Color(0xFF121212) : const Color(0xFFFFFFFF)),
        child: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color:
                isSelected ? const Color(0xFFFFFFFF) : const Color(0xFF121212),
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
