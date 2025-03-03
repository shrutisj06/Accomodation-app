import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {
  final String dropdownName;
  final String collectionName;
  String selectedItem;
  final String keyname;
  final Function(String)? onStatusChanged;
  Dropdown({super.key, required this.collectionName, required this.selectedItem, required this.dropdownName, this.onStatusChanged, required this.keyname});

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 1.5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.grey, width: 1.5),
      ),
      child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection(widget.collectionName)
              // .where('isActive',isEqualTo: true)
              // .where('isVerified',isEqualTo: true)
              // .orderBy('name')
              .get(),
          builder: (context, snapshot) {
            List<DropdownMenuItem> listItems = [];
            if (!snapshot.hasData) {
              const CircularProgressIndicator();
            } else {
              listItems.add(DropdownMenuItem(
                  value: "0", child: Text("Select ${widget.dropdownName}")));
              final items = snapshot.data?.docs.toList();
              for (var item in items!) {
                listItems.add(DropdownMenuItem(
                    value: item.id, child: Text(item[widget.keyname])));
              }
            }
            return DropdownButtonHideUnderline(
              child: DropdownButton(
                dropdownColor: Colors.white,

                items: listItems,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                onChanged: (value) {
                  setState(() {
                    widget.selectedItem = value;
                    if(widget.onStatusChanged != null) {
                      widget.onStatusChanged!(value); // Call the callback function
                    }
                  });
                },
                isExpanded: true,
                value: widget.selectedItem,
              ),
            );
          }),
    );
  }
}