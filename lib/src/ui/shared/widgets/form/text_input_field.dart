import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hintText;
  final dynamic validator;
  final TextInputType? keyboardType;
  final bool? isEnabled;
  final Color? borderColor;
  final double? borderRadius;
  final int? maxLines;
  final bool obscureText;
  final Widget? suffixIcon;

  TextInputField({
    required this.controller,
    this.label,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.isEnabled,
    this.borderColor,
    this.borderRadius,
    this.obscureText = false,
    this.maxLines = 1,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        filled: true,
        fillColor: Theme.of(context).secondaryHeaderColor,
        labelStyle: TextStyle(
          color: Theme.of(context).primaryColorDark,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
          borderSide: BorderSide(color: borderColor ?? Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
          borderSide: BorderSide(color: Theme.of(context).primaryColorDark),
        ),
        suffixIcon: suffixIcon,
      ),
      keyboardType: keyboardType,
      validator: validator,
      obscureText: obscureText,
    );
  }
}
