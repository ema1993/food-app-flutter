import 'package:flutter/material.dart';
import 'package:food_app/src/helpers/order_services.dart';
import 'package:food_app/src/models/cart_item.dart';
import 'package:food_app/src/providers/app.dart';
import 'package:food_app/src/providers/user.dart';
import 'package:food_app/src/screens/home.dart';
import 'package:food_app/src/widgets/loading.dart';
import 'package:food_app/src/widgets/title.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../commons.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _key = GlobalKey<ScaffoldState>();
  OrderServices _orderServices = OrderServices();
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final app = Provider.of<AppProvider>(context);

    return Scaffold(
      key: _key,
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        backgroundColor: white,
        elevation: 0.0,
        title: CustomText(text: 'Carrito'),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                return Home();
              }), (route) => false);
            }),
      ),
      backgroundColor: white,
      body: app.isLoading
          ? Loading()
          : ListView.builder(
              itemCount: authProvider.userModel.cart.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.red[100],
                              offset: Offset(3, 5),
                              blurRadius: 30),
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                topLeft: Radius.circular(20),
                              ),
                              child: Image.network(
                                authProvider.userModel.cart[index].image,
                                height: 120,
                                width: 140,
                                fit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: authProvider
                                            .userModel.cart[index].name +
                                        '\n',
                                    style: TextStyle(
                                        color: black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text:
                                        '\$${authProvider.userModel.cart[index].price / 100}' +
                                            '\n\n',
                                    style: TextStyle(
                                        color: black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  TextSpan(
                                    text: 'Cantidad: ',
                                    style: TextStyle(
                                        color: grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  TextSpan(
                                    text: authProvider
                                        .userModel.cart[index].quantity
                                        .toString(),
                                    style: TextStyle(
                                        color: primary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: primary,
                            ),
                            onPressed: () async {
                              //app.changeLoading();
                              bool value = await authProvider.removeFromCart(
                                  cartItem: authProvider.userModel.cart[index]);
                              if (value) {
                                authProvider.reloadUserModel();
                                _key.currentState.showSnackBar(SnackBar(
                                    content: Text('Eliminado del carrito')));
                                //app.changeLoading();
                                return;
                              } else {
                                print('Error al remover el item');
                                //app.changeLoading();
                              }
                            })
                      ],
                    ),
                  ),
                );
              }),
      bottomNavigationBar: Container(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Total: ',
                      style: TextStyle(
                          color: grey,
                          fontSize: 22,
                          fontWeight: FontWeight.w400),
                    ),
                    TextSpan(
                      text: '\$${authProvider.userModel.totalCartPrice / 100}',
                      style: TextStyle(
                          color: primary,
                          fontSize: 22,
                          fontWeight: FontWeight.normal),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: primary),
                child: FlatButton(
                    onPressed: () {
                      if (authProvider.userModel.totalCartPrice == 0) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20.0)), //this right here
                                child: Container(
                                  height: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                            child: Text(
                                          'El carrito está vacío',
                                          textAlign: TextAlign.center,
                                        )),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        SizedBox(
                                          width: 320.0,
                                          child: RaisedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "CERRAR",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            color: red,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      } else {
                        showDialog(
                            context: _key.currentContext,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20.0)), //this right here
                                child: Container(
                                  height: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Text(
                                            'Se te cobrará \$${authProvider.userModel.totalCartPrice / 100}',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 320.0,
                                          child: RaisedButton(
                                            onPressed: () async {
                                              var uuid = Uuid();
                                              String id = uuid.v4();
                                              _orderServices.createOrder(
                                                  userId: authProvider.user.uid,
                                                  id: id,
                                                  description:
                                                      'random description',
                                                  status: 'complete',
                                                  totalPrice: authProvider
                                                      .userModel.totalCartPrice,
                                                  cart: authProvider
                                                      .userModel.cart);
                                              for (CartItemModel cartItem
                                                  in authProvider
                                                      .userModel.cart) {
                                                bool value = await authProvider
                                                    .removeFromCart(
                                                        cartItem: cartItem);
                                                if (value) {
                                                  authProvider
                                                      .reloadUserModel();
                                                  // _key.currentState
                                                  //     .showSnackBar(SnackBar(
                                                  //         content: Text(
                                                  //             'Eliminado del carrito')));
                                                } else {
                                                  print(
                                                      'Error al remover el item');
                                                }
                                              }
                                              Navigator.pop(
                                                  _key.currentContext);
                                              _key.currentState.showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          'Pedido realizado')));

                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 3000), () {
                                                // setState(() {
                                                //   print('HOLA');
                                                // });
                                                setState(() {
                                                  Navigator.pushAndRemoveUntil(
                                                      _key.currentContext,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return Home();
                                                  }), (route) => false);
                                                });
                                              });
                                            },
                                            child: Text(
                                              "Aceptar",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            color: const Color(0xFF1BC0C5),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 320.0,
                                          child: RaisedButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                  _key.currentContext);
                                            },
                                            child: Text(
                                              "Cancelar",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            color: red,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      }
                    },
                    child: CustomText(
                      text: 'Pagar',
                      size: 20,
                      color: white,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
