import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';

import 'package:tinda/model/items.dart';

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

  File _image;
  final _picker = ImagePicker();
  

  void getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);
    

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void getImageGallery() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Photo Library'),
                  onTap: () {
                    getImageGallery();
                    Navigator.pop(context, 'gallery');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text('Camera'),
                  onTap: () {
                    getImage();
                    Navigator.pop(context, 'camera');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a New Item'),
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            _showPicker(context);
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.teal,
                            radius: 70.0,
                            child: _image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(70.0),
                                    child: Image.file(_image,
                                    
                                        fit: BoxFit.contain),
                                  )
                                : Container(
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 50.0,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Category: $category',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        Text(
                          barcode != null
                              ? 'Barcode: $barcode'
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
