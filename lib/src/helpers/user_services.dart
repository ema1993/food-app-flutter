import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app/src/models/cart_item.dart';
import 'package:food_app/src/models/user.dart';

class UserServices{
  String collection = 'users';
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void createUser(Map<String, dynamic> values){
    _firestore.collection(collection).doc(values['id']).set(values);
  }

  void updateUserData(Map<String, dynamic> values){
    _firestore.collection(collection).doc(values['id']).update(values);
  }

  Future<UserModel> getUserByID(String id) => _firestore.collection(collection).doc(id).get().then((doc){
    return UserModel.fromSnapshot(doc);
  });

  void addToCart({String userId, CartItemModel cartItem}){
    _firestore.collection(collection).doc(userId).update({
      'cart': FieldValue.arrayUnion([cartItem.toMap()])
    });
  }


  void removeFromCart({String userId, CartItemModel cartItem}){
    _firestore.collection(collection).doc(userId).update({
      'cart': FieldValue.arrayRemove([cartItem.toMap()])
    });
  }
}