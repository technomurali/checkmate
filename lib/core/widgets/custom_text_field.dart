import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isRequired;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String)? validator;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.isRequired = false,
    this.validator,
    this.onChanged,
    this.suffixIcon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? errorText;
  bool isPasswordVisible = false;
  bool hasUserInteracted = false;
  void validate(String value) {
    final trimmed = value.trim();
    String? newError;
    if (!hasUserInteracted) return;
    if (widget.isRequired && trimmed.isEmpty) {
      newError = '${widget.label} is required';
    } else if (widget.validator != null) {
      newError = widget.validator!(trimmed);
    } else {
      newError = null;
    }

    if (newError != errorText) {
      if (mounted) {
        setState(() {
          errorText = newError;
        });
      }
    }
  }

  @override
  void initState() {
    isPasswordVisible = widget.obscureText;
    super.initState();

    widget.controller.addListener(() {
      validate(widget.controller.text);
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(() {
      validate(widget.controller.text);
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        setState(() {
          hasUserInteracted = true;
        });
        widget.onChanged?.call(value);
        validate(value);
      },
      controller: widget.controller,
      obscureText: isPasswordVisible,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        label: RichText(
          text: TextSpan(
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
            children: [
              TextSpan(text: widget.label),
              if (widget.isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppColors.accentError),
                ),
            ],
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: errorText == null
                ? AppColors.primary
                : AppColors.accentError,
          ),
        ),
        errorText: errorText,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              )
            : widget.suffixIcon,
      ),
    );
  }
}
