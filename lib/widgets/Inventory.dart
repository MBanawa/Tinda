import 'package:flutter/material.dart';
import 'package:tinda/Service/category_service.dart';

typedef OnChangeCallback = void Function(dynamic value);

class DropDownList extends StatefulWidget {
final OnChangeCallback onChanged;


  DropDownList({this.onChanged});
  @override
  _DropDownListState createState() => _DropDownListState();
}

class _DropDownListState extends State<DropDownList> {
  var _selectedValue;

  var _categories = List<DropdownMenuItem>();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  _loadCategories() async {
    var _categoryService = CategoryService();
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        _categories.add(
          DropdownMenuItem(
            child: Text(category['name']),
            value: category['name'],
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButtonFormField(
        value: _selectedValue,
        items: _categories,
        hint: Text('Category'),
        onChanged: (value) {
          setState(() {
            _selectedValue = value;
          });
          widget.onChanged(value);
        },
      ),
    );
  }
}
