class Item {
  int id;
  String createdDate;
  String barcode;
  String name;
  int quantity;
  String category;
  String buyDate;
  String supplier;
  double buyPrice;
  double sellPrice;
  String image;



  itemMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['createdDate'] = createdDate;
    mapping['barcode'] = barcode;
    mapping['name'] = name;
    mapping['quantity'] = quantity;
    mapping['category'] = category;
    mapping['buyDate'] = buyDate;
    mapping['supplier'] = supplier;
    mapping['buyPrice'] = buyPrice;
    mapping['sellPrice'] = sellPrice;
    mapping['image'] = image;
    
    return mapping;
  }
}