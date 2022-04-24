import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum SearchBy{PLATOS,RESTAURANTES}

class AppProvider with ChangeNotifier{
  bool isLoading = false;
  SearchBy search = SearchBy.PLATOS;
  String filterBy = 'Platos';
  int totalPrice = 0;
  int priceSum = 0;
  int quantitySum = 0;

  void changeLoading(){
    isLoading = !isLoading;
    notifyListeners();
  }

  void changeSearchBy({SearchBy searchBy}){
    search = searchBy;
    if(searchBy == SearchBy.PLATOS){
      filterBy = 'Platos';
    }else {
      filterBy = 'Restaurantes';
    }
    notifyListeners();
  }

  addPrice({int newPrice}){
    priceSum += newPrice;
    notifyListeners();
  }

  addQuantity({int newQuantity}){
    quantitySum += newQuantity;
    notifyListeners();
  }

  getTotalPrice(){
    totalPrice = priceSum * quantitySum;
    notifyListeners();
  }
}