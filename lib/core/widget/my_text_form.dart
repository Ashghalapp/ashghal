import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final int lines;
  final String hint;
  final String? Function(String?)? validationFunc;
  const MyTextFormField({
    super.key,
    required this.controller,
    this.lines = 1,
    required this.hint,
    this.validationFunc, 
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: EdgeInsets.symmetric(
              vertical: lines == 1 ? 0 : 10, horizontal: 12),
          hintText: hint,
        ),
        validator: validationFunc,
        minLines: lines,
        maxLines: lines,
      ),
    );
  }
}
