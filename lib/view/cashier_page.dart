import 'package:flutter/material.dart';


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

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
           
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => ItemDetailsScreen()));
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
