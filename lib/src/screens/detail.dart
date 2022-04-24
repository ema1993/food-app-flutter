import 'package:flutter/material.dart';
import 'package:food_app/src/helpers/screen_navigation.dart';
import 'package:food_app/src/models/products.dart';
import 'package:food_app/src/providers/app.dart';
import 'package:food_app/src/providers/user.dart';
import 'package:food_app/src/screens/cart.dart';
import 'package:food_app/src/widgets/loading.dart';
import 'package:food_app/src/widgets/title.dart';
import 'package:provider/provider.dart';
import '../commons.dart';

class Detail extends StatefulWidget {
  final ProductModel product;

  const Detail({@required this.product});

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  final _key = GlobalKey<ScaffoldState>();
  int quantity = 1;
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
        actions: <Widget>[
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  changeScreen(context, CartScreen());
                },
              ),
              Positioned(
                top: 2,
                right: 5,
                child: InkWell(
                  onTap: () {
                    changeScreen(context, CartScreen());
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        color: white,
                        border: Border.all(color: black),
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Text(
                        '${authProvider.userModel.cart.length}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: black, fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: app.isLoading
              ? Loading()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 120,
                      backgroundImage: NetworkImage(widget.product.image),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomText(
                        text: widget.product.name,
                        size: 26,
                        weight: FontWeight.bold),
                    CustomText(
                        text: "\$${widget.product.price / 100}",
                        size: 20,
                        weight: FontWeight.w400),
                    SizedBox(
                      height: 10,
                    ),
                    CustomText(
                        text: "Descripción", size: 18, weight: FontWeight.w400),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.product.description,
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: grey, fontWeight: FontWeight.w300),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                              icon: Icon(
                                Icons.remove,
                                size: 36,
                              ),
                              onPressed: () {
                                if (quantity != 1) {
                                  setState(() {
                                    quantity -= 1;
                                  });
                                }
                              }),
                        ),
                        GestureDetector(
                          onTap: () async {
                            //app.changeLoading();

                            bool value = await authProvider.addToCart(
                                product: widget.product, quantity: quantity);

                            if (value) {
                              _key.currentState.showSnackBar(SnackBar(
                                  content: Text('Agregado al carrito')));
                              authProvider.reloadUserModel();
                              //app.changeLoading();
                              return;
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: primary,
                                borderRadius: BorderRadius.circular(20)),
                            child: app.isLoading
                                ? Loading()
                                : Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        28, 12, 28, 12),
                                    child: CustomText(
                                      text: "Agregar $quantity",
                                      color: white,
                                      size: 22,
                                      weight: FontWeight.w300,
                                    ),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                              icon: Icon(
                                Icons.add,
                                size: 36,
                                color: red,
                              ),
                              onPressed: () {
                                setState(() {
                                  quantity += 1;
                                });
                              }),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
