import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../types/dtos/app_style.dart';

// Example provider for style (replace with your actual provider)
final styleProvider = Provider<AppStyle>((ref) => AppStyle.defaultStyle());

class CustomInputField extends ConsumerStatefulWidget {
  final String hintText;
  final bool isPassword;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const CustomInputField({
    Key? key,
    required this.hintText,
    this.isPassword = false,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends ConsumerState<CustomInputField> {
  @override
  Widget build(BuildContext context) {
    final style = ref.read(styleProvider);

    return TextFormField(
      obscureText: widget.isPassword,
      decoration: InputDecoration(
        hintText: widget.hintText,
        fillColor: style.backgroundColor,
        focusColor: style.themeBlack,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      validator: widget.validator,
      onChanged: widget.onChanged,
    );
  }
}
