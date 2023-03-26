import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 60, 10, 0),
          child: Column(
            children: [
              Container(
                height: 41,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  onChanged: (String value) {
                    print(value);
                  },
                  controller: searchTextController,
                  decoration: InputDecoration(
                    hintText: 'Cerca',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
