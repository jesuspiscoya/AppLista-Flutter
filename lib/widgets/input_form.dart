import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_input_formatter/money_input_formatter.dart';

class InputForm extends StatelessWidget {
  final String input;
  final TextEditingController inputController;

  const InputForm({
    super.key,
    required this.input,
    required this.inputController,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TextFormField(
        controller: inputController,
        keyboardType: identical(input, 'Precio')
            ? TextInputType.number
            : TextInputType.text,
        inputFormatters: identical(input, 'Precio')
            ? [
                MoneyInputFormatter(thousandSeparator: ''),
                LengthLimitingTextInputFormatter(6)
              ]
            : [],
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: const Color(0xFF12193C),
          hintText: input,
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 0.4, color: Colors.red)),
        ),
        validator: (value) =>
            value!.isEmpty ? 'Ingrese ${input.toLowerCase()}.' : null,
      ),
    );
  }
}
