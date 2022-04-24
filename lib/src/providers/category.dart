import 'package:flutter/material.dart';
import '../models/category.dart';
import '../helpers/category_helper.dart';

class CategoryProvider with ChangeNotifier{
  CategoryServices _categoryServices = CategoryServices();
  List<CategoryModel> categories = [];

  CategoryProvider.initialize(){
    _loadCategories();
  }

  _loadCategories() async{
    categories = await _categoryServices.getCategories();
    notifyListeners();
  }
}
