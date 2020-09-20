import 'package:flutter/material.dart';

class DropDownList extends StatefulWidget {

  @override
  _DropDownListState createState() => _DropDownListState();
}

class _DropDownListState extends State<DropDownList> {

  //value for Dropdown Button
  var _value = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButton(
        
        value: _value,
        // TODO: List Categories here
        //TODO: Guide: https://medium.com/@yashodgayashan/flutter-dropdown-button-widget-469794c886d0
        items: [
          DropdownMenuItem(child: Text("Snacks"), value: 1),
          DropdownMenuItem(child: Text("Drinks"), value: 2),
          DropdownMenuItem(child: Text("Medicine"), value: 3),
          DropdownMenuItem(child: Text("Liquor"), value: 4),
        ],
        onChanged: (value) {
          setState(() {
            _value = value;
            return value;
          });
        },
      ),
    );
  }
}
