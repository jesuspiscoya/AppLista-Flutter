import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputsForm extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  final TextEditingController inputController;
  final TextInputType inputType;
  final String hint;
  final String validator;
  final List<TextInputFormatter> inputFormatters;

  const InputsForm({
    super.key,
    required this.margin,
    required this.inputController,
    required this.inputType,
    required this.hint,
    required this.validator,
    required this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        margin: margin,
        child: TextFormField(
          controller: inputController,
          keyboardType: inputType,
          inputFormatters: inputFormatters,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF2B2A57),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            isDense: true,
          ),
          validator: (value) => value!.isEmpty ? validator : null,
        ),
      ),
    );
  }
}
