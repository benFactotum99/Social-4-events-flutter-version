import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_4_events/components/custom_text_form.dart';

class CustomTextDateForm extends StatefulWidget {
  final TextEditingController dateController;
  final String myLabelText;
  final String? Function(String? value) onValidator;
  final void Function(String? value) onChanged;

  const CustomTextDateForm({
    required this.dateController,
    required this.myLabelText,
    required this.onValidator,
    required this.onChanged,
  });

  @override
  State<CustomTextDateForm> createState() => _CustomTextDateFormState();
}

class _CustomTextDateFormState extends State<CustomTextDateForm> {
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        widget.dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _selectDate(context);
      },
      child: TextFormField(
        enabled: false,
        controller: widget.dateController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: widget.onValidator,
        cursorColor: Colors.red,
        decoration: InputDecoration(
          labelText: widget.myLabelText,
          labelStyle: TextStyle(fontSize: 20, color: Colors.grey),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          //prefixIcon: Icon(Icons.account_circle, size: 30),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
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
        onChanged: widget.onChanged,
        /*onSaved: (val) {
          print(val);
        },*/
      ),
    );
  }
}
