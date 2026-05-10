import 'package:flutter/material.dart';
import 'package:bersih_in/app/core/constants/app_dimensions.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? errorText;
  final bool obscureText;
  final VoidCallback? onToggleObscure;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.errorText,
    this.obscureText = false,
    this.onToggleObscure,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXS),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            prefixIcon: prefixIcon,
            suffixIcon: onToggleObscure != null
                ? IconButton(
                    onPressed: onToggleObscure,
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      size: 20,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
