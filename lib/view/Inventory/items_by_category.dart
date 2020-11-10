import 'package:flutter/material.dart';
import 'package:tinda/model/items.dart';
import 'package:tinda/service/item_service.dart';
import 'package:tinda/view/Inventory/item_screen.dart';

class ItemsByCategory extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  ItemsByCategory({this.categoryId, this.categoryName});

  @override
  _ItemsByCategoryState createState() => _ItemsByCategoryState();
}

class _ItemsByCategoryState extends State<ItemsByCategory> {
  List<Item> _itemList = List<Item>();
  ItemService _itemService = ItemService();
  int itemId;
  String itemBarcode;
  String itemCategory;
  String itemName;

  @override
  void initState() {
    super.initState();
    getItemsByCategoryId();
  }

  getItemsByCategoryId() async {
    var items = await _itemService.readItemsById(widget.categoryId);
    items.forEach((item) {
      setState(() {
        var model = Item();
        model.id = item['id'];
        model.name = item['name'];
        model.barcode = item['barcode'];
        model.quantity = item['quantity'];
        model.sellPrice = item['sellPrice'];

        _itemList.add(model);
        itemId = model.id;
        itemName = model.name;
        itemBarcode = model.barcode;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.categoryName),
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
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ItemDetailsScreen(
                                      itemId: itemId,
                                      itemBarcode: itemBarcode,
                                      itemCategory: widget.categoryName,
                                      itemName: itemName,
                                    )));
                      },
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              '${_itemList[index].name != null ? _itemList[index].name : 'No Name'} '),
                        ],
                      ),
                      subtitle: Text(
                          '${_itemList[index].barcode != null ? _itemList[index].barcode : 'No Barcode'}'),
                      trailing:
                          Text('PHP ${_itemList[index].sellPrice.toString()}0'),
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
