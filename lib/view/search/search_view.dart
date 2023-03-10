import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: false,
        title: Text(
          "Cerca",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Center(),
    );
  }
}
