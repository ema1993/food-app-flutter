import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app/src/models/restaurant.dart';

class RestaurantServices {
  String collection = 'restaurants';
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<RestaurantModel>> getRestaurants() async =>
      _firestore.collection(collection).get().then((result) {
        List<RestaurantModel> restaurants = [];
        for (DocumentSnapshot restaurant in result.docs) {
          restaurants.add(RestaurantModel.fromSnapshot(restaurant));
        }
        return restaurants;
      });

      Future<RestaurantModel> getRestaurantByID({String id}) => _firestore.collection(collection).doc(id).get().then((doc){
    return RestaurantModel.fromSnapshot(doc);
  });

  
  Future<List<RestaurantModel>> searchRestaurants({String restaurantName}) {
    String searchKey = restaurantName[0].toUpperCase() + restaurantName.substring(1);
    return _firestore
        .collection(collection)
        .orderBy('name')
        .startAt([searchKey])
        .endAt([searchKey + '\uf8ff'])
        .get()
        .then((result) {
          List<RestaurantModel> restaurants = [];
          for (DocumentSnapshot restaurant in result.docs) {
            restaurants.add(RestaurantModel.fromSnapshot(restaurant));
          }
          return restaurants;
        });
  }

      
}
