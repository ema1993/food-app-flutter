import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app/src/models/cart_item.dart';

class UserModel{
  static const NAME = 'name';
  static const EMAIL = 'email';
  static const ID = 'id';
  static const STRIPE_ID = 'stripe_id';
  static const CART = 'cart';
  
  
  String _name;
  String _email;
  String _id;
  String _stripeId;
  int _priceSum = 0;
  int _quantitySum = 0;
  
  

  String get name => _name;
  String get email => _email;
  String get id => _id;
  String get stripeId => _stripeId;

  List<CartItemModel> cart;
  int totalCartPrice;
  
  
  

  UserModel.fromSnapshot(DocumentSnapshot snapshot){
    _name = snapshot.data()[NAME];
    _email = snapshot.data()[EMAIL];
    _id = snapshot.data()[ID];
    _stripeId = snapshot.data()[STRIPE_ID];
    cart = _convertCartItems(snapshot.data()[CART]) ?? [];
    totalCartPrice = getTotalPrice(cart: snapshot.data()[CART]);
    
  }

  int getTotalPrice({List cart}){
    for(Map cartItem in cart){
      _priceSum += cartItem['price'] * cartItem['quantity'];
    
    }

    
    return _priceSum;
  }

  List<CartItemModel> _convertCartItems(List cart){
    List<CartItemModel> convertedCart = [];
    for(Map cartItem in cart){
      convertedCart.add(CartItemModel.fromMap(cartItem));
    }
    return convertedCart; 
  }
}