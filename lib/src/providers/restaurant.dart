import 'package:flutter/material.dart';
import 'package:food_app/src/helpers/restaurant_helper.dart';
import 'package:food_app/src/models/restaurant.dart';

class RestaurantProvider with ChangeNotifier {
  RestaurantServices _restaurantServices = RestaurantServices();
  List<RestaurantModel> restaurants = [];
  RestaurantModel restaurant;
  List<RestaurantModel> restaurantsSearched = [];

  RestaurantProvider.initialize() {
    _loadRestaurants();
    
  }

  _loadRestaurants() async {
    restaurants = await _restaurantServices.getRestaurants();
    notifyListeners();
  }

  loadSingleRestaurant({String restaurantId}) async {
    restaurant = await _restaurantServices.getRestaurantByID(id: restaurantId);
    notifyListeners();
  }

  Future search({String restaurantName}) async {
    restaurantsSearched = await _restaurantServices.searchRestaurants(
        restaurantName: restaurantName);
    notifyListeners();
  }
}
