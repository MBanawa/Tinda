import 'package:flutter/material.dart';
import 'package:tinda/view/Inventory/new_category_screen.dart';

class ShowCashier extends StatefulWidget {
  @override
  _ShowCashierState createState() => _ShowCashierState();
}

class _ShowCashierState extends State<ShowCashier> {
  double sizedBoxSize;
  double fontSize;

  @override
  void initState() {
    super.initState();
    
  }

  void sizeAdjuster() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            sizeAdjuster();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => NewCategory(sizedBoxSize: sizedBoxSize, fontSize: fontSize,)));
          }),
      appBar: AppBar(
        leading: Icon(
          Icons.store,
          size: 30,
        ),
        title: Text('Cashier'),
      ),
    );
  }
}
