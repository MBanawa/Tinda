import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:tinda/model/categories.dart';
import 'package:tinda/service/category_service.dart';
import 'package:tinda/view/Inventory/new_item_screen.dart';
import 'package:tinda/widgets/round_button.dart';

class NewCategory extends StatefulWidget {
  final double sizedBoxSize;
  final double fontSize;
  final String barcode;
  NewCategory({this.sizedBoxSize, this.fontSize, this.barcode});

  @override
  _NewCategoryState createState() => _NewCategoryState();
}

class _NewCategoryState extends State<NewCategory> {
  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();
  var _category = Category();
  var _categoryService = CategoryService();
  var category;
  List<Category> _categoryList = List<Category>();

  @override
  void initState() {
    super.initState();
  }

  //~~~~~~~~~~Colorpicker
  Color pickerColor = Color(0xff008080);
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

  static Widget layoutBuilder(
      BuildContext context, List<Color> colors, PickerItem child) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      height: MediaQuery.of(context).size.height / 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: orientation == Orientation.portrait ? 4 : 5,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
          children: colors.map((Color color) => child(color)).toList(),
        ),
      ),
    );
  }

  _colorDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            title: Text('Pick a Color'),
            content: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BlockPicker(
                      pickerColor: pickerColor,
                      onColorChanged: changeColor,
                      layoutBuilder: layoutBuilder,
                    ),
                    RaisedButton(
                      color: Colors.green,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Confirm',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Category',
        ),
        actions: [
          IconButton(
              iconSize: 35,
              icon: Icon(Icons.save),
              onPressed: () async {
                _category.name = _categoryNameController.text;
                _category.description = _categoryDescriptionController.text;
                _category.catcolor = categcolor;
                var result = await _categoryService.saveCategory(_category);
                if (result > 0) {
                  Navigator.pop(context, 'refresh');
                  _categoryNameController.clear();
                  _categoryDescriptionController.clear();

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ItemScreen(
                            category: _category.name,
                            barcode: widget.barcode,
                          )));
                }
              }),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                        child: Text(
                          'Preview:',
                          style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      elevation: 3,
                      child: InkWell(
                        splashColor: Colors.teal.withAlpha(80),
                        onTap: () {},
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
                                  color: pickerColor,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16.0, 12, 0, 0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Category Name',
                                            style: TextStyle(
                                              fontSize: 22.0,
                                              color: Colors.teal.shade800,
                                            ),
                                          ),
                                          Text(
                                            'Category short description',
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.orange.shade400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(Icons.more_vert),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 10.0, spreadRadius: 2)],
                          borderRadius: BorderRadius.all(
                              Radius.circular(20)),
                          color: Colors.white,
                        ),
                        height: MediaQuery.of(context).size.height / 1.4,
                        padding: const EdgeInsets.fromLTRB(15.0, 50, 15.0, 0),
                        child: Column(
                          
                          children: [
                            Container(
                              child: TextField(
                                style: TextStyle(fontSize: widget.fontSize),
                                controller: _categoryNameController,
                                decoration: InputDecoration(
                                  hintText: 'Enter category name',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    // fontSize: widget.fontSize,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: widget.sizedBoxSize,
                            ),
                            Container(
                              child: TextField(
                                style: TextStyle(fontSize: widget.fontSize),
                                controller: _categoryDescriptionController,
                                decoration: InputDecoration(
                                  hintText: 'Enter a short description..',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    // fontSize: widget.fontSize,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: widget.sizedBoxSize,
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 30, bottom: 4),
                                  child: RoundIconButton(
                                    onPressed: () {
                                      _colorDialog(context);
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    colour: pickerColor,
                                    elevation: 6.0,
                                  ),
                                ),
                                Text(
                                  'Change Color',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
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
