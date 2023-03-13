import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final TextEditingController textController;
  final String myLabelText;
  final String? Function(String? value) onValidator;
  final void Function(String? value) onChanged;
  final bool readOnly;
  final int maxLines;

  const CustomTextForm(
      {required this.textController,
      required this.myLabelText,
      required this.onValidator,
      required this.onChanged,
      this.readOnly = false,
      this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      readOnly: readOnly,
      controller: textController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: onValidator,
      cursorColor: Colors.red,
      decoration: InputDecoration(
        labelText: myLabelText,
        labelStyle: TextStyle(fontSize: 20, color: Colors.grey),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        //prefixIcon: Icon(Icons.account_circle, size: 30),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            width: 2,
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            width: 2,
            color: Colors.red,
          ),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
