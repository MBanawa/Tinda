import 'package:flutter/material.dart';

class ListReports extends StatefulWidget {
  @override
  _ListReportsState createState() => _ListReportsState();
}

class _ListReportsState extends State<ListReports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {}),

      appBar: AppBar(
        leading: Icon(
          Icons.store,
          size: 30,
        ),
        title: Text('Business Manager'),
      ),
    );
  }
}