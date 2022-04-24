import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel{
  static const ID = 'id';
  static const NAME = 'name';
  static const DESCRIPTION = 'description';
  static const RESTAURANT = 'restaurant';
  static const RESTAURANT_ID = 'restaurantId';
  static const CATEGORY = 'category';
  static const IMAGE = 'image';
  static const RATING = 'rating';
  static const PRICE = 'price';
  static const FEATURED = 'featured';
  static const RATES = 'rates';

  String _id;
  String _name;
  String _description;
  String _restaurant;
  String _restaurantId;
  String _category;
  String _image;
  double _rating;
  int _price;
  bool _featured;
  int _rates;
  

  String get id => _id;
  String get name => _name;
  String get description => _description;
  String get restaurant => _restaurant;
  String get restaurantId => _restaurantId;
  String get category => _category;
  String get image => _image;
  double get rating => _rating;
  int get price => _price;
  bool get featured => _featured;
  int get rates => _rates;

  ProductModel.fromSnapshot(DocumentSnapshot snapshot){
    _id = snapshot.data()[ID];
    _name = snapshot.data()[NAME];
    _description = snapshot.data()[DESCRIPTION];
    _restaurant = snapshot.data()[RESTAURANT];
    _restaurantId = snapshot.data()[RESTAURANT_ID];
    _category = snapshot.data()[CATEGORY];
    _image = snapshot.data()[IMAGE];
    _rating = snapshot.data()[RATING];
    _price = snapshot.data()[PRICE].floor();
    _featured = snapshot.data()[FEATURED];
    _rates = snapshot.data()[RATES];
    
  }
  
}

