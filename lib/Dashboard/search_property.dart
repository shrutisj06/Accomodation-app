import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchProperty extends StatefulWidget {
  const SearchProperty({super.key});

  @override
  State<SearchProperty> createState() => _SearchPropertyState();
}

class _SearchPropertyState extends State<SearchProperty> {
  String searchQuery = '';
  String selectedFilter = 'All';
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: "Search properties...",
        prefixIcon: Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        // **Adding Filter Icon**
        suffixIcon: IconButton(
          icon: Icon(Icons.filter_list, color: Colors.grey),
          onPressed: () {
            showFilterDropdown(context, (selected) {
              setState(() {
                selectedFilter = selected;
              });
            });
          },
        ),
      ),
    );

  }
void showFilterDropdown(){

}
}
