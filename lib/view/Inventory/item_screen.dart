import 'package:flutter/material.dart';
import 'package:tinda/model/inventory_model/items.dart';

import 'package:intl/intl.dart';

class ItemScreen extends StatefulWidget {
  // final Item item;
  final String category;
  final String barcode;

  ItemScreen({@required this.category, this.barcode});

  @override
  _ItemScreenState createState() =>
      _ItemScreenState(barcode: barcode, category: category);
}

class _ItemScreenState extends State<ItemScreen> {
  String barcode;
  String category;
  _ItemScreenState({this.barcode, this.category});

  var _itemNameController = TextEditingController();
  var _itemQuantityController = TextEditingController();
  var _itemBuyDateController = TextEditingController();
  var _itemSupplierController = TextEditingController();
  var _itemBuyPriceController = TextEditingController();
  var _itemSellPriceController = TextEditingController();
  var _itemImageController = TextEditingController();

  FocusNode focusNode = FocusNode();
  String hintText = 'Enter item name here';

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        hintText = '';
      } else {
        hintText = 'Enter item name here';
      }
      setState(() {});
    });
  }

  DateTime _dateTime = DateTime.now();

  _selectedItemDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (_pickedDate != null) {
      setState(() {
        _dateTime = _pickedDate;
        _itemBuyDateController.text =
            DateFormat('dd-MMM-yyyy').format(_pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a New Item'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Category: $category'),
                      Text(barcode != null
                          ? 'Barcode: $barcode'
                          : 'Barcode: Empty'),
                    ],
                  ),
                ),
                TextFormField(
                  controller: _itemNameController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: 'Type item name here',
                    hintText: 'Where did you buy the item?',
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _itemQuantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    hintText:
                        'How many ${_itemNameController.text} will you stock?',
                  ),
                ),
                TextFormField(
                  onTap: () {
                    _selectedItemDate(context);
                  },
                  keyboardType: TextInputType.datetime,
                  controller: _itemBuyDateController,
                  decoration: InputDecoration(
                    labelText: 'Purchase Date',
                    hintText:
                        'When did you buy ${_itemNameController.text}?',
                    prefixIcon: InkWell(
                      onTap: () {
                        _selectedItemDate(context);
                      },
                      child: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _itemSupplierController,
                  decoration: InputDecoration(
                    labelText: 'Supplier',
                    hintText: 'Where did you buy the item?',
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: _itemBuyPriceController,
                  decoration: InputDecoration(
                    labelText: 'Buy Price',
                    hintText: 'How much did you buy the Item for?',
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: _itemSellPriceController,
                  decoration: InputDecoration(
                    labelText: 'Sell Price',
                    hintText: 'How much will you sell the Item for?',
                  ),
                ),
                TextFormField(
                  controller: _itemImageController,
                  decoration: InputDecoration(
                    labelText: 'Attach an Image',
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              color: Colors.teal,
              width: double.infinity,
              height: 70.0,
              child: Center(
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
