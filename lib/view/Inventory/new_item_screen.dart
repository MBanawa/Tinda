import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:tinda/model/items.dart';
import 'package:tinda/service/item_service.dart';
import 'package:tinda/view/inventory_page.dart';

class ItemScreen extends StatefulWidget {
  final String category;
  final String barcode;

  ItemScreen({@required this.category, this.barcode});

  @override
  _ItemScreenState createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  ListCategories listCategories = ListCategories();
  var _itemNameController = TextEditingController();
  var _itemQuantityController = TextEditingController();
  var _itemBuyDateController = TextEditingController();
  var _itemSupplierController = TextEditingController();
  var _itemBuyPriceController = TextEditingController();
  var _itemSellPriceController = TextEditingController();

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
        actions: [
          IconButton(
              iconSize: 35,
              icon: Icon(Icons.save),
              onPressed: () async {
                var itemObject = Item();
                itemObject.createdDate = DateTime.now().toString();
                itemObject.barcode = widget.barcode;
                itemObject.name = _itemNameController.text;
                itemObject.category = widget.category;
                itemObject.quantity = int.parse(_itemQuantityController.text);
                itemObject.buyDate = _itemBuyDateController.text;
                itemObject.supplier = _itemSupplierController.text;
                itemObject.buyPrice =
                    double.parse(_itemBuyPriceController.text);
                itemObject.sellPrice =
                    double.parse(_itemSellPriceController.text);
                // itemObject.image = null;

                var _itemService = ItemService();
                var result = await _itemService.saveItem(itemObject);
                if (result > 0) {
                  Navigator.pop(context, 'itemsaved');
                }

                print(DateTime.now().toString());
                print(widget.barcode);
                print(_itemNameController.text);
                print(widget.category);
                print(int.parse(_itemQuantityController.text));
                print(_itemBuyDateController.text);
                print(_itemSupplierController.text);
                print(double.parse(_itemBuyPriceController.text));
                print(double.parse(_itemSellPriceController.text));
              }),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Category: ${widget.category}',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        Text(
                          widget.barcode != null
                              ? 'Barcode: ${widget.barcode}'
                              : 'Barcode: Empty',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: _itemNameController,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        labelText: 'Type item name here',
                        hintText: 'What\'s the name of this Item?',
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
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _itemBuyPriceController,
                      decoration: InputDecoration(
                        labelText: 'Buy Price',
                        hintText: 'How much did you buy the Item for?',
                      ),
                    ),
                    TextFormField(
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _itemSellPriceController,
                      decoration: InputDecoration(
                        labelText: 'Sell Price',
                        hintText: 'How much will you sell the Item for?',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
