import 'package:flutter/material.dart';
import 'package:food_app/src/helpers/product_helper.dart';
import 'package:food_app/src/models/products.dart';




class ProductProvider with ChangeNotifier{
  ProductServices _productServices = ProductServices();
  List<ProductModel> products = [];
  List<ProductModel> productsByCategory = [];
  List<ProductModel> productsByRestaurant = [];
  List<ProductModel> productsSearched = [];

  ProductProvider.initialize(){
    _loadProducts();
   
  }

  _loadProducts() async{
    products = await _productServices.getProducts();
    notifyListeners();
  }

  Future loadProductsByCategory({String categoryName})async{
    productsByCategory = await _productServices.getProductsOfCategory(category: categoryName);
    notifyListeners();
  }

  Future loadProductsByRestaurant({String restaurantId})async{
    productsByRestaurant = await _productServices.getProductsByRestaurant(id: restaurantId);
    notifyListeners();
  }

  Future search({String productName}) async{
    productsSearched = await _productServices.searchProducts(productName: productName);
    notifyListeners();
  }
}
