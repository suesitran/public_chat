import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  const TextFieldInput({
    super.key,
    this.keyboardType,
    this.labelText,
    this.style,
    this.obscureText = false,
    this.autocorrect,
    this.onChanged,
    this.suffixIcon,
    this.suffix,
    this.suffixText,
    this.suffixStyle,
    this.suffixIconColor,
    this.suffixIconConstraints,
    this.filled,
    this.fillColor,
    this.readOnly = false,
    this.prefixIcon,
    this.controller,
    this.hintText,
    this.hintStyle,
    this.errorText,
    this.onFieldSubmitted,
    this.focusNode,
    this.minLines,
    this.maxLines,
    this.autofocus = false,
    this.textInputAction,
  });
  final TextInputType? keyboardType;
  final String? labelText, hintText;
  final bool obscureText;
  final bool? autocorrect;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? suffix;
  final String? suffixText;
  final TextStyle? suffixStyle;
  final Color? suffixIconColor;
  final BoxConstraints? suffixIconConstraints;
  final bool? filled;
  final Color? fillColor;
  final bool readOnly;
  final TextEditingController? controller;
  final TextStyle? hintStyle;
  final String? errorText;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final int? minLines;
  final int? maxLines;
  final TextStyle? style;
  final bool autofocus;
  final TextInputAction? textInputAction;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction,
      autofocus: autofocus,
      onChanged: onChanged,
      style: style ?? (readOnly ? const TextStyle(color: Colors.grey) : null),
      maxLines: maxLines,
      minLines: minLines,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      obscureText: obscureText,
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        errorText: errorText,
        hintText: hintText,
        counterStyle: const TextStyle(color: Colors.pink),
        labelStyle: const TextStyle(color: Colors.black),
        hintStyle: hintStyle ?? const TextStyle(color: Colors.grey),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        suffix: suffix,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        labelText: labelText,
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey)),
        focusColor: Colors.black,
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black)),
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey)),
        filled: filled ?? true,
        fillColor:
            readOnly ? (fillColor ?? Colors.grey) : fillColor ?? Colors.white,
      ),
    );
  }
}
