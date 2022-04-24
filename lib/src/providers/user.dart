import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/src/helpers/order_services.dart';
import 'package:food_app/src/helpers/user_services.dart';
import 'package:food_app/src/models/cart_item.dart';
import 'package:food_app/src/models/order.dart';
import 'package:food_app/src/models/products.dart';
import 'package:food_app/src/models/user.dart';
import 'package:uuid/uuid.dart';

enum Status { Uninitialized, Unauthenticated, Authtenticating, Authenticated }

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth;
  User _user;
  Status _status = Status.Uninitialized;
  UserServices _userServices = UserServices();
  OrderServices _orderServices = OrderServices();
  UserModel _userModel;

  Status get status => _status;
  UserModel get userModel => _userModel;
  User get user => _user;

  List<OrderModel> orders = [];

  final formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();

  AuthProvider.initialize() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onStateChanged);
  }

  Future<bool> signIn() async {
    try {
      _status = Status.Authtenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(
          email: email.text.trim(), password: password.text.trim());
      return true;
    } catch (e) {
      return _onError(e.toString());
    }
  }

  Future signOut() {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return null;
  }

  Future<bool> signUp() async {
    try {
      _status = Status.Authtenticating;
      notifyListeners();
      await _auth
          .createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((user) {
        Map<String, dynamic> values = {
          'name': name.text,
          'email': email.text,
          'id': user.user.uid,
          'likedFood': [],
          'likedRestaurants': []
        };
        _userServices.createUser(values);
      });
      return true;
    } catch (e) {
      return _onError(e);
    }
  }

  Future<void> _onStateChanged(User user) async {
    if (user == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = user;
      _status = Status.Authenticated;
      _userModel = await _userServices.getUserByID(user.uid);
    }
    notifyListeners();
  }

  bool _onError(String e) {
    _status = Status.Unauthenticated;
    notifyListeners();
    print('error' + e.toString());
    return false;
  }

  void cleanControllers() {
    email.text = '';
    name.text = '';
    password.text = '';
  }

  Future<bool> addToCart({ProductModel product, int quantity}) async {
    try {
      var uuid = Uuid();
      String cartItemId = uuid.v4();
      List cart = _userModel.cart;
      //bool itemExists = false;
      Map cartItem = {
        'id': cartItemId,
        'name': product.name,
        'image': product.image,
        'restaurantId': product.restaurantId,
        'totalRestaurantSale': product.price * quantity,
        'productId': product.id,
        'price': product.price,
        'quantity': quantity
      };

      CartItemModel item = CartItemModel.fromMap(cartItem);
      // if(!itemExists){
      _userServices.addToCart(userId: _userModel.id, cartItem: item);
      // }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> reloadUserModel() async {
    _userModel = await _userServices.getUserByID(user.uid);
    notifyListeners();
  }

  Future<bool> removeFromCart({CartItemModel cartItem}) async {
    try {
      _userServices.removeFromCart(userId: _userModel.id, cartItem: cartItem);

      return true;
    } catch (e) {
      return false;
    }
  }

  getOrders()async{
    orders= await _orderServices.getUserOrders(userId: _user.uid);
    notifyListeners();
  }
}
