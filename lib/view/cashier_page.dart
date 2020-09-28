import 'package:flutter/material.dart';
import 'package:tinda/view/Inventory/item_screen.dart';

class ShowCashier extends StatefulWidget {
  @override
  _ShowCashierState createState() => _ShowCashierState();
}

class _ShowCashierState extends State<ShowCashier> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){}
        //  =>  Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => ItemScreen()))
            
        ),

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