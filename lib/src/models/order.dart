

import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel{
  static const ID = 'id';
  static const DESCRIPTION = 'description';
  static const CART = 'cart';
  static const TOTAL = 'total';
  static const STATUS = 'status';
  static const USER_ID = 'userId';
  static const CREATED_AT = 'createdAt';
  static const RESTAURANT_ID = 'restaurantId';

  String _id;
  String _description;
  int _total;
  String _status;
  String _userId;
  int _createdAt;
  String _restaurantId;

  String get id => _id;
  String get description => _description;
  int get total => _total;
  String get status => _status;
  String get userId => _userId;
  int get createdAt => _createdAt;
  String get restaurantId => _restaurantId;

  List cart;

  OrderModel.fromSnapshot(DocumentSnapshot snapshot){
    _id = snapshot.data()[ID];
    _description = snapshot.data()[DESCRIPTION];
    _total = snapshot.data()[TOTAL];
    _status = snapshot.data()[STATUS];
    _userId = snapshot.data()[USER_ID];
    _createdAt = snapshot.data()[CREATED_AT];
	_restaurantId = snapshot.data()[RESTAURANT_ID];
    cart = snapshot.data()[CART];
  }
  
}