import 'package:flutter/material.dart';
import 'package:food_app/src/commons.dart';
import 'package:food_app/src/helpers/screen_navigation.dart';
import 'package:food_app/src/providers/app.dart';
import 'package:food_app/src/providers/product.dart';
import 'package:food_app/src/providers/restaurant.dart';
import 'package:food_app/src/screens/restaurant.dart';
import 'package:food_app/src/widgets/loading.dart';
import 'package:food_app/src/widgets/restaurant.dart';
import 'package:food_app/src/widgets/title.dart';
import 'package:provider/provider.dart';

class RestaurantSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final restaurantProvider = Provider.of<RestaurantProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final app = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        title: CustomText(
          text: 'Restaurantes',
          size: 20,
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: white,
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [
          IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {})
        ],
      ),
      body: app.isLoading
          ? Loading()
          : restaurantProvider.restaurantsSearched.length < 1
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        color: grey,
                        size: 30,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomText(
                        text: 'No se encontraron restaurantes',
                        color: grey,
                        weight: FontWeight.w300,
                        size: 22,
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: restaurantProvider.restaurantsSearched.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        //app.changeLoading();
                        await productProvider.loadProductsByRestaurant(
                            restaurantId: restaurantProvider
                                .restaurantsSearched[index].id);
                        changeScreen(
                            context,
                            RestaurantScreen(
                              restaurantModel:
                                  restaurantProvider.restaurantsSearched[index],
                            ));
                        //app.changeLoading();
                      },
                      child: RestaurantWidget(
                        restaurant:
                            restaurantProvider.restaurantsSearched[index],
                      ),
                    );
                  }),
    );
  }
}
