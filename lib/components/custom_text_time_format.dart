import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_4_events/components/custom_text_form.dart';

class CustomTextTimeForm extends StatefulWidget {
  final TextEditingController timeController;
  final String myLabelText;
  final String? Function(String? value) onValidator;
  final void Function(String? value) onChanged;
  final bool disableTap;

  const CustomTextTimeForm({
    required this.timeController,
    required this.myLabelText,
    required this.onValidator,
    required this.onChanged,
    this.disableTap = false,
  });

  @override
  State<CustomTextTimeForm> createState() => _CustomTextTimeFormState();
}

class _CustomTextTimeFormState extends State<CustomTextTimeForm> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dialOnly,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        var _hour = selectedTime.hour.toString();
        var _minute = selectedTime.minute.toString();
        var _time = _hour.padLeft(2, "0") + ':' + _minute.padLeft(2, "0");
        widget.timeController.text = _time;
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.disableTap == false) {
          _selectTime(context);
        }
      },
      child: TextFormField(
        enabled: false,
        controller: widget.timeController,
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
