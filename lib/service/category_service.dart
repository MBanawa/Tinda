import 'package:tinda/Model/Inventory_model/categories.dart';
import 'package:tinda/repositories/repository.dart';

class CategoryService {
  Repository _repository;

  CategoryService() {
    _repository = Repository();
  }

  // Create new Data
  saveCategory(Category category) async {
    return await _repository.inserData('categories', category.categoryMap());
  }

  // Read data from table
  readCategories() async {
    return await _repository.readData('categories');
  }

  // Read data from table by ID
  readCategoryById(categoryId) async {
    return await _repository.readDataById('categories', categoryId);
  }
  // Update data from table
  updateCategory(Category category) async {
    return await _repository.updateData('categories', category.categoryMap());
  }
}
