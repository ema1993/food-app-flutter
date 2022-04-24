import 'package:flutter/material.dart';
import 'package:food_app/src/helpers/screen_navigation.dart';
import 'package:food_app/src/providers/app.dart';
import 'package:food_app/src/providers/category.dart';
import 'package:food_app/src/providers/product.dart';
import 'package:food_app/src/providers/restaurant.dart';
import 'package:food_app/src/providers/user.dart';
import 'package:food_app/src/screens/cart.dart';
import 'package:food_app/src/screens/category.dart';
import 'package:food_app/src/screens/login.dart';
import 'package:food_app/src/screens/order.dart';
import 'package:food_app/src/screens/product_search.dart';
import 'package:food_app/src/screens/restaurant.dart';
import 'package:food_app/src/screens/restaurants_search.dart';
import 'package:food_app/src/widgets/categories.dart';
import 'package:food_app/src/widgets/loading.dart';
import 'package:food_app/src/widgets/maspedido.dart';
import 'package:food_app/src/widgets/restaurant.dart';

import 'package:food_app/src/widgets/title.dart';
import 'package:provider/provider.dart';
import '../commons.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final restaurantProvider = Provider.of<RestaurantProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final app = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        elevation: 0.5,
        backgroundColor: primary,
        title: CustomText(
          text: 'RestoApp',
          color: white,
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    changeScreen(context, CartScreen());
                  }),
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
                        color: primary,
                        border: Border.all(color: white),
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Text(
                        '${authProvider.userModel.cart.length}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: white, fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ),
              // Positioned(
              //   top: 12,
              //   right: 12,
              //   child: Container(
              //     height: 10,
              //     width: 10,
              //     decoration: BoxDecoration(
              //         color: green, borderRadius: BorderRadius.circular(20)),
              //   ),
              // )
            ],
          ),
          // Stack(
          //   children: [
          //     IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
          //     Positioned(
          //       top: 12,
          //       right: 12,
          //       child: Container(
          //         height: 10,
          //         width: 10,
          //         decoration: BoxDecoration(
          //             color: green, borderRadius: BorderRadius.circular(20)),
          //       ),
          //     )
          //   ],
          // )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: primary),
              accountName: CustomText(
                text: authProvider.userModel?.name,
                color: white,
                weight: FontWeight.bold,
              ),
              accountEmail: CustomText(
                text: authProvider.userModel?.email,
                color: white,
              ),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.fastfood),
              title: CustomText(text: 'Platos Favoritos'),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.restaurant),
              title: CustomText(text: 'Restaurantes favoritos'),
            ),
            ListTile(
              onTap: () async {
                await authProvider.getOrders();
                changeScreen(context, OrderScreen());
              },
              leading: Icon(Icons.bookmark_border),
              title: CustomText(text: 'Mis pedidos'),
            ),
            ListTile(
              onTap: () {
                changeScreen(context, CartScreen());
              },
              leading: Icon(Icons.shopping_cart),
              title: CustomText(text: 'Carrito'),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.settings),
              title: CustomText(text: 'Configuración'),
            ),
            ListTile(
              onTap: () {
                authProvider.signOut();
                changeScreenReplacement(context, LoginScreen());
              },
              leading: Icon(Icons.exit_to_app),
              title: CustomText(text: "Salir"),
            ),
          ],
        ),
      ),
      backgroundColor: white,
      body: app.isLoading
          ? Loading()
          : SafeArea(
              child: ListView(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8, right: 8, left: 8, bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                          leading: Icon(
                            Icons.search,
                            color: red,
                          ),
                          title: TextField(
                            textInputAction: TextInputAction.search,
                            onSubmitted: (pattern) async {
                              //app.changeLoading();
                              if (app.search == SearchBy.PLATOS) {
                                await productProvider.search(
                                    productName: pattern);
                                changeScreen(context, ProductSearch());
                              } else {
                                await restaurantProvider.search(
                                    restaurantName: pattern);
                                changeScreen(
                                  context,
                                  RestaurantSearch(),
                                );
                              }

                              //app.changeLoading();
                            },
                            decoration: InputDecoration(
                                hintText: 'Buscar comida o restaurantes',
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomText(
                        text: 'Buscar por:',
                        color: grey,
                        weight: FontWeight.w300,
                      ),
                      DropdownButton<String>(
                          value: app.filterBy,
                          style: TextStyle(
                              color: primary, fontWeight: FontWeight.w300),
                          icon: Icon(
                            Icons.filter_list,
                            color: primary,
                          ),
                          elevation: 0,
                          items: <String>['Platos', 'Restaurantes']
                              .map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value == 'Platos') {
                              app.changeSearchBy(searchBy: SearchBy.PLATOS);
                            } else {
                              app.changeSearchBy(
                                  searchBy: SearchBy.RESTAURANTES);
                            }
                          }),
                    ],
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: 100,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categoryProvider.categories.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                //app.changeLoading();
                                await productProvider.loadProductsByCategory(
                                    categoryName: categoryProvider
                                        .categories[index].name);
                                //app.changeLoading();
                                changeScreen(
                                    context,
                                    CategoryScreen(
                                      categoryModel:
                                          categoryProvider.categories[index],
                                    ));
                              },
                              child: CategoryWidget(
                                category: categoryProvider.categories[index],
                              ),
                            );
                          })),
                  SizedBox(
                    height: 5,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CustomText(
                          text: "Platos destacados",
                          size: 20,
                          color: grey,
                        ),
                        CustomText(
                          text: "Ver todos",
                          size: 14,
                          color: primary,
                        ),
                      ],
                    ),
                  ),
                  ////////////////////////////////////////////
                  Container(
                      height: 240,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: productProvider.products.length,
                          itemBuilder: (context, index) {
                            return FeaturedWidget(
                              product: productProvider.products[index],
                            );
                          })),
                  SizedBox(
                    height: 5,
                  ),

                  ////////////////////////////////////////////
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CustomText(
                          text: "Restaurantes populares",
                          size: 20,
                          color: grey,
                        ),
                        CustomText(
                          text: "Ver todos",
                          size: 14,
                          color: primary,
                        ),
                      ],
                    ),
                  ),
                  Column(
                      children: restaurantProvider.restaurants
                          .map((item) => GestureDetector(
                                onTap: () async {
                                  //app.changeLoading();
                                  await productProvider
                                      .loadProductsByRestaurant(
                                          restaurantId: item.id);
                                  //app.changeLoading();

                                  changeScreen(
                                      context,
                                      RestaurantScreen(
                                        restaurantModel: item,
                                      ));
                                },
                                child: RestaurantWidget(
                                  restaurant: item,
                                ),
                              ))
                          .toList())
                ],
              ),
            ),
    );
  }
}
