import 'package:flutter/material.dart';
import 'package:social_4_events/helpers/view_helpers/map_location.dart';
import 'package:social_4_events/view/add/add_event_location_view.dart';

class CustomTextLocationForm extends StatefulWidget {
  final TextEditingController textController;
  final String myLabelText;
  final String? Function(String? value) onValidator;
  final void Function(String? value) onChanged;
  final void Function() onTap;
  final bool readOnly;
  final int maxLines;

  const CustomTextLocationForm(
      {required this.textController,
      required this.myLabelText,
      required this.onValidator,
      required this.onChanged,
      required this.onTap,
      this.readOnly = false,
      this.maxLines = 1});

  @override
  State<CustomTextLocationForm> createState() => _CustomTextLocationFormState();
}

class _CustomTextLocationFormState extends State<CustomTextLocationForm> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: TextFormField(
        enabled: false,
        maxLines: widget.maxLines,
        readOnly: widget.readOnly,
        controller: widget.textController,
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
        onChanged: widget.onChanged,
      ),
    );
  }
}
