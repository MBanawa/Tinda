import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:tinda/service/category_service.dart';
import 'package:tinda/widgets/round_button.dart';

class NewCategory extends StatefulWidget {
  final double sizedBoxSize;
  final double fontSize;
  NewCategory({this.sizedBoxSize, this.fontSize});

  @override
  _NewCategoryState createState() => _NewCategoryState();
}

class _NewCategoryState extends State<NewCategory> {
  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();

  var _categoryService = CategoryService();

  var category;
  

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
      // resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          'New Category',
        ),
        actions: [
          IconButton(
            iconSize: 35,
            icon: Icon(Icons.save),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Container(
                // color: Colors.black,
                height: MediaQuery.of(context).size.height / 1.8,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 4),
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
                            elevation: 3.0,
                          ),
                        ),
                        Text(
                          'Change Color',
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 14.0),
                        ),
                      ],
                    ),
                    // SizedBox(height: 30),
                    Container(
                      height: MediaQuery.of(context).size.height / 3.5,
                      width: MediaQuery.of(context).size.width / 1.15,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: pickerColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade600,
                              blurRadius: 2.0,
                              spreadRadius: 0.5,
                              offset: Offset(0, 3),
                            ),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: TextField(
                                style: TextStyle(fontSize: widget.fontSize),
                                controller: _categoryNameController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: 'Category Name',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: widget.fontSize,
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
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: 'Category Description',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: widget.fontSize,
                                  ),
                                ),
                              ),
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
