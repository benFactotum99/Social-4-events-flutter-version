import 'package:flutter/material.dart';

class HomeCartView extends StatefulWidget {
  const HomeCartView({super.key});

  @override
  State<HomeCartView> createState() => _HomeCartViewState();
}

class _HomeCartViewState extends State<HomeCartView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: false,
        title: Text(
          "Social4Events",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
