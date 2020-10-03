import 'package:tinda/repositories/repository.dart';
import 'package:tinda/model/items.dart';



class ItemService {
  Repository _repository;

  ItemService() {
    _repository = Repository();
  }

  //create items
  saveItem(Item item) async {
    return await _repository.insertData('items', item.itemMap());
  }

  //read items
  readItems() async {
    return await _repository.readData('items');
  }

//Update data from table
  updateItems(Item item) async{
    return await _repository.updateData('items', item.itemMap());
  }

  //read items by category
  readitemsByCategory(category) async {
    return await _repository.readDataByColumnName('items', 'category', category);
  }
}
