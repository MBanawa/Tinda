import 'package:flutter/material.dart';

import 'package:tinda/Model/Inventory_model/categories.dart';
import 'package:tinda/Service/category_service.dart';
import 'package:tinda/View/barcode.dart';
import 'package:tinda/Widgets/Inventory.dart';
import 'package:tinda/widgets/menu_item.dart';

class ListCategories extends StatefulWidget {
  @override
  _ListCategoriesState createState() => _ListCategoriesState();
}

class _ListCategoriesState extends State<ListCategories> {
  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();

  var _category = Category();
  var _categoryService = CategoryService();

  List<Category> _categoryList = List<Category>();

  var category;

  var _editCategoryNameController = TextEditingController();
  var _editCategoryDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    _categoryList = List<Category>();
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        var categoryModel = Category();
        categoryModel.name = category['name'];
        categoryModel.description = category['description'];
        categoryModel.id = category['id'];
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
  DropDownList _dropDownList() => DropDownList();

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
                      child: Text('Scan Now'),
                      onPressed: () {
                        Navigator.pop(context, 'Scan');
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Barcode()));
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
                        Navigator.pop(context, 'GetCategory');
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
                child: Text('Save'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
            title: Text('Please Select A Category'),
            content: SingleChildScrollView(
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
                        Navigator.pop(context, 'NewCategory');
                        _newCategoryDialog(context);
                      }),
                ],
              ),
            ),
          );
        });
  }

  //pop-up dialog to create new category:
  _newCategoryDialog(BuildContext context) {
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
                child: Text('Save'),
                onPressed: () async {
                  _category.name = _categoryNameController.text;
                  _category.description = _categoryDescriptionController.text;
                  var result = await _categoryService.saveCategory(_category);
                  if (result > 0) {
                    Navigator.pop(context, 'refresh');
                    getAllCategories();
                    _categoryNameController.clear();
                    _categoryDescriptionController.clear();
                  }
                },
              ),
            ],
            title: Text('Create New Category'),
            content: SingleChildScrollView(
                child: Column(
              children: [
                TextField(
                  controller: _categoryNameController,
                  decoration: InputDecoration(
                    hintText: 'Write a Category',
                    labelText: 'Category',
                  ),
                ),
                TextField(
                  controller: _categoryDescriptionController,
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

   _temporaryDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(

            title: Text('ARE YOU SURE YOU WANT TO DELETE?'),

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
                  _category.id = category[0]['id'];
                  _category.name = _editCategoryNameController.text;
                  _category.description =
                      _editCategoryDescriptionController.text;
                  var result = await _categoryService.updateCategory(_category);
                  if (result > 0) {
                    Navigator.pop(context, 'refresh');
                    getAllCategories();
                    // _categoryNameController.clear();
                    // _categoryDescriptionController.clear();
                  }
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


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _scanDialog(context).then((value) {
            if (value == 'GetCategory') {
              _selectionDialog(context);
            }
          });
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
            return Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                  height: 70.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(1.0, 2.0),
                        blurRadius: 4.0,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(80.0, 5.0, 5.0, 5.0),
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
                              // SizedBox(height: 5.0),
                              Text(
                                _categoryList[index].description,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.orange.shade200,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton(onSelected: (MenuItem menuItem) {
                          
                          if(menuItem.menuVal == "Edit"){
                            _editCategory(context, _categoryList[index].id);
                          } else if (menuItem.menuVal == "Delete") {
                            _temporaryDialog(context);
                          }
                          
                        }, 
                        itemBuilder: (BuildContext context) {
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
                ),
                Positioned(
                  left: 22,
                  top: 7.3,
                  bottom: 7,
                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                      child: Image(
                        width: 70.0,
                        image: NetworkImage(
                          'https://picsum.photos/250?image=$index',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
