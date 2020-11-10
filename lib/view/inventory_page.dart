import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:tinda/Service/category_service.dart';
import 'package:tinda/Widgets/Inventory.dart';
import 'package:tinda/model/categories.dart';
import 'package:tinda/view/Inventory/new_item_screen.dart';
import 'package:tinda/view/Inventory/items_by_category.dart';
import 'package:tinda/view/Inventory/new_category_screen.dart';
import 'package:tinda/widgets/menu_item.dart';

class ListCategories extends StatefulWidget {
  @override
  _ListCategoriesState createState() => _ListCategoriesState();
}

class _ListCategoriesState extends State<ListCategories> {
  var _categoryService = CategoryService();

  List<Category> _categoryList = List<Category>();

  var category;

  var _editCategoryNameController = TextEditingController();
  var _editCategoryDescriptionController = TextEditingController();
  String selectedItem;
  String _scanBarcode = '';

  double sizedBoxSize;
  double fontSize;

  //~~~~~~~~~~Colorpicker
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  int categcolor;

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
      int colorInt = pickerColor.value;
      categcolor = colorInt;
      print(colorInt);
    });
  }

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  //~~~~~~~~~~~~~~BARCODE~~~~~~~~~~~~~~~~~~
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if (barcodeScanRes.length < 3) {
        _scanBarcode = 'No Data';
      } else {
        _scanBarcode = barcodeScanRes;
      }
    });
  }
  //~~~~~~~~~~~~~~BARCODE~~~~~~~~~~~~~~~~~~

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllCategories() async {
    _categoryList = List<Category>();
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        var categoryModel = Category();
        categoryModel.name = category['name'];
        categoryModel.description = category['description'];
        categoryModel.id = category['id'];
        categoryModel.catcolor = category['catcolor'];
        _categoryList.add(categoryModel);
      });
    });
  }

  _editCategory(BuildContext context, categoryId) async {
    category = await _categoryService.readCategoryById(categoryId);
    setState(() {
      _editCategoryNameController.text = category[0]['name'] ?? 'No Name';
      _editCategoryDescriptionController.text =
          category[0]['description'] ?? 'No description';
    });
    _editCategoryDialog(context);
  }

  //Dropdown Menu
  String _selectedValue;
  DropDownList _dropDownList() => DropDownList(
        onChanged: (value) {
          _selectedValue = value;
        },
      );

  //pop-up dialog to select scan or new item:
  _scanDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            title: Text('Create New Item'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  RaisedButton(
                      child: Text('Scan Barcode Now'),
                      onPressed: () {
                        Navigator.pop(context);
                        scanBarcodeNormal()
                            .then((value) => _selectionDialog(context));
                      }),
                  SizedBox(height: 10.0),
                  Text(
                    'OR',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  RaisedButton(
                      child: Text('Create item without Barcode'),
                      onPressed: () {
                        Navigator.pop(context);
                        _selectionDialog(context);
                        _scanBarcode = null;
                      }),
                ],
              ),
            ),
          );
        });
  }

  //pop-up dialog to select category:
  _selectionDialog(BuildContext context) {
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
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              _scanBarcode == 'No Data'
                  ? FlatButton(
                      color: Colors.grey,
                      onPressed: () {},
                      child: Text(
                        'Continue',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : FlatButton(
                      color: Colors.blue,
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ItemScreen(
                                  category: _selectedValue,
                                  barcode: _scanBarcode,
                                )));
                      },
                      child: Text('Continue'),
                    ),
            ],
            title: Text(_scanBarcode == 'No Data'
                ? 'No Barcode Data Captured'
                : 'Please Select a Category ${_scanBarcode != null ? _scanBarcode : 'for this new item'}'),
            content: _scanBarcode == 'No Data'
                ? RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      scanBarcodeNormal()
                          .then((value) => _selectionDialog(context));
                    },
                    child: Text('Scan Again'),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        _dropDownList(),
                        SizedBox(height: 10.0),
                        Text(
                          'OR',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        RaisedButton(
                            child: Text('Create a new Category'),
                            onPressed: () {
                              _sizeAdjuster();
                              Navigator.pop(context, 'NewCategory');
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NewCategory(
                                                sizedBoxSize: sizedBoxSize,
                                                fontSize: fontSize,
                                                barcode: _scanBarcode,
                                              )))
                                  .then((value) => getAllCategories());
                            }),
                      ],
                    ),
                  ),
          );
        });
  }

  _sizeAdjuster() {
    var mediaQuery = MediaQuery.of(context).size.height *
        MediaQuery.of(context).devicePixelRatio;
    if (mediaQuery >= 2040) {
      sizedBoxSize = 20;
      fontSize = 25;
    } else if (mediaQuery >= 1794) {
      sizedBoxSize = 15;
      fontSize = 20;
    } else {
      sizedBoxSize = 10;
      fontSize = 15;
    }
    print(sizedBoxSize);
    print(fontSize);
  }

  _deleteCategoryDialog(BuildContext context, categoryId) {
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
                  var result =
                      await _categoryService.deleteCategory(categoryId);
                  if (result > 0) {
                    Navigator.pop(context, 'Delete');
                    getAllCategories();

                    _showDeleteSnackBar(
                      Text('Category Successfully Deleted.'),
                    );
                  }
                },
              ),
            ],
            title: Text('Are you sure you want to delete this Category?'),
            content: Stack(
              children: [
                Text('All items in this Category will lose their Category'),
              ],
            ),
          );
        });
  }

  //pop-up dialog to edit selected category:
  _editCategoryDialog(BuildContext context) {
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
                color: Colors.red,
                child: Text('Cancel'),
              ),
              FlatButton(
                color: Colors.green,
                child: Text('Update Category'),
                onPressed: () async {
                  // _category.id = category[0]['id'];
                  // _category.name = _editCategoryNameController.text;
                  // _category.description =
                  //     _editCategoryDescriptionController.text;

                  // var result = await _categoryService.updateCategory(_category);
                  // if (result > 0) {
                  //   Navigator.pop(context);
                  //   getAllCategories();
                  //   _showSuccessSnackBar(
                  //     Text('Category Successfully Updated!'),
                  //   );
                  // }
                },
              ),
            ],
            title: Text('Edit this Category'),
            content: SingleChildScrollView(
                child: Column(
              children: [
                TextField(
                  controller: _editCategoryNameController,
                  decoration: InputDecoration(
                    hintText: 'Write a Category',
                    labelText: 'Category',
                  ),
                ),
                TextField(
                  controller: _editCategoryDescriptionController,
                  decoration: InputDecoration(
                    hintText: 'Write a Description',
                    labelText: 'Description',
                  ),
                ),
              ],
            )),
          );
        });
  }

  // _showSuccessSnackBar(message) {
  //   var _snackBar = SnackBar(
  //     content: message,
  //     backgroundColor: Colors.green.shade700,
  //     duration: const Duration(milliseconds: 1000),
  //   );
  //   _globalKey.currentState.showSnackBar(_snackBar);
  // }

  _showDeleteSnackBar(message) {
    var _snackBar = SnackBar(
      content: message,
      backgroundColor: Colors.red.shade800,
      duration: const Duration(milliseconds: 1000),
    );
    _globalKey.currentState.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      key: _globalKey,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _scanDialog(context);
        },
      ),
      appBar: AppBar(
        leading: Icon(
          Icons.store,
          size: 30,
        ),
        title: Text('Inventory Manager'),
      ),
      body: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: _categoryList.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
              elevation: 3,
              child: InkWell(
                splashColor: Colors.teal.withAlpha(80),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ItemsByCategory(
                          categoryId: _categoryList[index].id,
                          categoryName: _categoryList[index].name)));
                },
                child: Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: 6,
                        height: 65,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              bottomLeft: Radius.circular(4)),
                          color: Color(_categoryList[index].catcolor == null
                              ? 0xff008080
                              : _categoryList[index].catcolor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 8, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _categoryList[index].name,
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      color: Colors.teal.shade800,
                                    ),
                                  ),
                                  Text(
                                    '${_categoryList[index].description}',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.orange.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuButton(onSelected: (MenuItem menuItem) {
                              if (menuItem.menuVal == "Edit") {
                                _editCategory(context, _categoryList[index].id);
                              } else if (menuItem.menuVal == "Delete") {
                                _deleteCategoryDialog(
                                    context, _categoryList[index].id);
                              }
                            }, itemBuilder: (BuildContext context) {
                              return menuitems.map((MenuItem menuItem) {
                                return PopupMenuItem(
                                  value: menuItem,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(menuItem.iconVal),
                                      Text(menuItem.menuVal),
                                    ],
                                  ),
                                );
                              }).toList();
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
