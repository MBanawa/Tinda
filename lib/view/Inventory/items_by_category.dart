import 'package:flutter/material.dart';
import 'package:tinda/model/items.dart';
import 'package:tinda/service/item_service.dart';

class ItemsByCategory extends StatefulWidget {
  final String category;
  ItemsByCategory({this.category});

  @override
  _ItemsByCategoryState createState() => _ItemsByCategoryState();
}

class _ItemsByCategoryState extends State<ItemsByCategory> {
  List<Item> _itemList = List<Item>();
  ItemService _itemService = ItemService();

  @override
  void initState() {
    super.initState();
    getItemsByCategories();
  }

  getItemsByCategories() async {
    var items = await _itemService.readitemsByCategory(this.widget.category);
    items.forEach((item) {
      setState(() {
        var model = Item();
        model.name = item['name'];
        model.barcode = item['barcode'];
        model.quantity = item['quantity'];
        model.sellPrice = item['sellPrice'];

        _itemList.add(model);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.category),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _itemList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  child: Card(
                    elevation: 3,
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_itemList[index].name),
                        ],
                      ),
                      subtitle: Text(_itemList[index].barcode),
                      trailing: Text('PHP ${_itemList[index].sellPrice.toString()}0'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
