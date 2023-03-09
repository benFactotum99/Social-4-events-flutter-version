import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final Color colorText;
  final double heightButton;
  final double widthButton;
  final Color colorButton;

  const CustomButton(
      {required this.onPressed,
      required this.text,
      required this.colorText,
      required this.heightButton,
      required this.widthButton,
      required this.colorButton,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heightButton,
      width: widthButton, //MediaQuery.of(context).size.width,
      //width: MediaQuery.of(context).size.width,
      child: MaterialButton(
        onPressed: onPressed,
        color: colorButton,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Text(
          text,
          style: TextStyle(color: colorText),
        ),
      ),
    );
  }
}
