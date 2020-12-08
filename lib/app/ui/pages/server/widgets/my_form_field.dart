import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MyFormField extends StatelessWidget {
  final String text;
  final String hint;
  final String label;
  final TextInputType keyboardType;
  final Icon prefixIcon;
  final bool obscureText;
  final double topMargin;
  final double bottomMargin;
  final MaskTextInputFormatter mask;
  final Function(String text) onChanged;
  final Function(String text) validator;
  final int maxLines;
  final bool enabled;
  final TextCapitalization textCapitalization;
  final String initialValue;

  MyFormField({
    @required this.hint,
    this.text,
    this.label,
    this.keyboardType,
    this.prefixIcon,
    this.obscureText,
    this.topMargin,
    this.bottomMargin,
    this.mask,
    this.onChanged,
    this.validator,
    this.maxLines,
    this.enabled,
    this.textCapitalization,
    this.initialValue = "",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: topMargin ?? 8),
        this.text == null
            ? const SizedBox()
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    text,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
        TextFormField(
          initialValue: initialValue,
          enabled: enabled ?? true,
          obscureText: obscureText ?? false,
          maxLines: maxLines ?? 1,
          keyboardType: keyboardType ?? TextInputType.text,
          textInputAction: TextInputAction.done,
          textCapitalization:
              textCapitalization ?? TextCapitalization.sentences,
          inputFormatters: mask == null ? [] : [mask],
          style: TextStyle(height: 1.3),
          decoration: InputDecoration(
              labelText: label,
              prefixIcon: prefixIcon,
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(20),
                ),
              ),
              hintText: hint,
              labelStyle: TextStyle(color: Colors.white),
              fillColor: Colors.white70),
          onChanged: onChanged,
          validator: validator,
        ),
        SizedBox(height: bottomMargin ?? 8),
      ],
    );
  }
}
