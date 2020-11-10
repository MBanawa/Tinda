import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinda/model/items.dart';
import 'package:tinda/service/item_service.dart';

class ItemDetailsScreen extends StatefulWidget {
  final int itemId;
  final String itemName;
  final String itemCategory;
  final String itemBarcode;

  ItemDetailsScreen(
      {@required this.itemId,
      @required this.itemName,
      @required this.itemCategory,
      @required this.itemBarcode});
  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  var _itemService = ItemService();
  var item;

  var _editItemNameController = TextEditingController();
  var _editItemQuantityController = TextEditingController();
  var _editItemBuyDateController = TextEditingController();
  var _editItemSupplierController = TextEditingController();
  var _editItemBuyPriceController = TextEditingController();
  var _editItemSellPriceController = TextEditingController();
  List<Item> _itemList = List<Item>();

  @override
  void initState() {
    super.initState();
    _editItem(context, widget.itemId);
  }

  _editItem(BuildContext context, itemId) async {
    item = await _itemService.readItemsById(itemId);
    setState(() {
      _editItemNameController.text = item[0]['name'] ?? 'No Name';
      _editItemQuantityController.text = item[0]['quantity'].toString() ?? '0';
      _editItemBuyDateController.text = item[0]['buyDate'].toString();
      _editItemSupplierController.text =
          item[0]['supplier'].toString() ?? 'No Supplier Name';
      _editItemBuyPriceController.text = item[0]['buyPrice'].toString() ?? '0';
      _editItemSellPriceController.text =
          item[0]['sellPrice'].toString() ?? '0';
    });
  }

  _deleteItemDialog(BuildContext context, itemId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.blue,
                child: Text('Cancel'),
              ),
              FlatButton(
                color: Colors.red,
                child: Text('Delete'),
                onPressed: () async {
                  var result = await _itemService.deleteItem(itemId);
                  if (result > 0) {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
            title: Text('Delete Item'),
            content: Stack(
              children: [
                Text('Are you sure you want to delete this Item?'),
              ],
            ),
          );
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
        _editItemBuyDateController.text =
            DateFormat('dd-MMM-yyyy').format(_pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.itemName} Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          'Category: ${widget.itemCategory}',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        Text(
                          widget.itemBarcode ?? 'No Barcode',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: _editItemNameController,
                      decoration: InputDecoration(
                        labelText: 'Type item name here',
                        hintText: 'What\'s the name of this Item?',
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _editItemQuantityController,
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        hintText:
                            'How many ${_editItemNameController.text} will you stock?',
                      ),
                    ),
                    TextFormField(
                      onTap: () {
                        _selectedItemDate(context);
                      },
                      keyboardType: TextInputType.datetime,
                      controller: _editItemBuyDateController,
                      decoration: InputDecoration(
                        labelText: 'Purchase Date',
                        hintText:
                            'When did you buy ${_editItemNameController.text}?',
                        prefixIcon: InkWell(
                          onTap: () {
                            _selectedItemDate(context);
                          },
                          child: Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _editItemSupplierController,
                      decoration: InputDecoration(
                        labelText: 'Supplier',
                        hintText: 'Where did you buy the item?',
                      ),
                    ),
                    TextFormField(
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _editItemBuyPriceController,
                      decoration: InputDecoration(
                        labelText: 'Buy Price',
                        hintText: 'How much did you buy the Item for?',
                      ),
                    ),
                    TextFormField(
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _editItemSellPriceController,
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
          RaisedButton(
            onPressed: () {
              _deleteItemDialog(context, widget.itemId)
                  .then((_) => Navigator.pop(context));
            },
            child: Text('delete'),
          ),
        ],
      ),
    );
  }
}
